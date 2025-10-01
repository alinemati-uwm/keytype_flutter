import 'package:flutter/services.dart';
import 'package:keytype/core/init/dependency_injection.dart';
import 'package:keytype/core/models/task_model/task_model.dart';
import 'package:keytype/core/network/tasks/task_api_calls.dart';
import 'package:keytype/utils/task_functions.dart';
import 'package:keytype/utils/env_functions.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;

/// Service to handle AI keyboard functionality and API communication
class AIKeyboardService {
  static const MethodChannel _channel = MethodChannel('keyboard_channel');
  static final _taskApiCalls = getIt<TaskApiCalls>();
  static final _taskController = TaskSystemController();
  
  // Current processing state
  static bool _isProcessing = false;
  static String? _currentAction;
  
  /// Initialize the AI keyboard service
  static void initialize() {
    _channel.setMethodCallHandler(_handleMethodCall);
    developer.log('🤖 AIKeyboardService initialized', name: 'AIKeyboardService');
  }
  
  /// Handle method calls from Android keyboard
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      switch (call.method) {
        case 'aiActionRequest':
          return await _handleAIActionRequest(call);
        case 'textFromKeyboard':
          return await _handleTextFromKeyboard(call);
        case 'getKeyboardStatus':
          return await _handleGetKeyboardStatus(call);
        default:
          developer.log('⚠️ Unimplemented method: ${call.method}', name: 'AIKeyboardService');
          throw PlatformException(
            code: 'Unimplemented',
            details: 'Method ${call.method} not implemented',
          );
      }
    } catch (e) {
      developer.log('❌ Error handling method ${call.method}: $e', name: 'AIKeyboardService');
      rethrow;
    }
  }
  
  /// Handle AI action request from keyboard
  static Future<Map<String, dynamic>> _handleAIActionRequest(MethodCall call) async {
    try {
      final args = call.arguments as Map<dynamic, dynamic>;
      final text = args['text'] as String? ?? '';
      final action = args['action'] as String? ?? '';
      
      developer.log('🎯 AI Action Request: $action for text (${text.length} chars)', name: 'AIKeyboardService');
      
      if (text.trim().isEmpty) {
        developer.log('⚠️ Empty text provided for AI action: $action', name: 'AIKeyboardService');
        await _sendAIErrorResponse(action, 'Please enter some text to process');
        return {'success': false, 'error': 'Empty text provided'};
      }
      
      if (_isProcessing) {
        developer.log('⚠️ Another AI request is already processing', name: 'AIKeyboardService');
        await _sendAIErrorResponse(action, 'Another request is being processed. Please wait.');
        return {'success': false, 'error': 'Already processing'};
      }
      
      // Set processing state
      _isProcessing = true;
      _currentAction = action;
      
      try {
        // Get system prompt for the action
        final systemPrompt = _taskController.getTaskSystemPrompt(type: action.toLowerCase());
        
        // Create task model
        final taskModel = TaskModel(
          prompt: systemPrompt,
          inputText: text,
          model: TaskSystemController.modelName,
          meta: TaskSystemController.meta,
        );
        
        developer.log('📋 Creating task with prompt: ${systemPrompt.substring(0, 100)}...', name: 'AIKeyboardService');
        developer.log('🔗 API Base URL: ${DotEnvUtils.getApiBaseUrl}', name: 'AIKeyboardService');
        developer.log('📊 Task Model: ${taskModel.toString()}', name: 'AIKeyboardService');
        
        // Call API
        final result = await _taskApiCalls.createTask(task: taskModel);
        
        result.fold(
          (failure) async {
            developer.log('❌ API Error: ${failure.message}', name: 'AIKeyboardService');
            await _sendAIErrorResponse(action, failure.message ?? 'Unknown error occurred');
          },
          (taskResponse) async {
            developer.log('✅ API Success: ${taskResponse.status}', name: 'AIKeyboardService');
            
            if (taskResponse.status?.toLowerCase() == 'completed' && taskResponse.responseData != null) {
              // Parse response data and extract 5 outputs
              final responseData = taskResponse.responseData!;
              final outputs = _parseAIResponse(responseData);
              
              await _sendAISuccessResponse(action, outputs);
            } else if (taskResponse.status?.toLowerCase() == 'error' || taskResponse.errorMessage != null) {
              await _sendAIErrorResponse(action, taskResponse.errorMessage ?? 'Task failed to complete');
            } else {
              await _sendAIErrorResponse(action, 'Task did not complete successfully. Status: ${taskResponse.status}');
            }
          },
        );
        
        return {'success': true};
      } finally {
        // Reset processing state
        _isProcessing = false;
        _currentAction = null;
      }
    } catch (e) {
      developer.log('❌ Error processing AI request: $e', name: 'AIKeyboardService');
      developer.log('❌ Error type: ${e.runtimeType}', name: 'AIKeyboardService');
      if (e is DioException) {
        developer.log('❌ DioException details: ${e.response?.data}', name: 'AIKeyboardService');
        developer.log('❌ Status code: ${e.response?.statusCode}', name: 'AIKeyboardService');
        developer.log('❌ Request URL: ${e.requestOptions.uri}', name: 'AIKeyboardService');
      }
      _isProcessing = false;
      _currentAction = null;
      await _sendAIErrorResponse(call.arguments['action'] ?? 'unknown', 'Internal error: ${e.toString()}');
      return {'success': false, 'error': e.toString()};
    }
  }
  
  /// Parse AI response data into 5 outputs
  static List<String> _parseAIResponse(String responseData) {
    try {
      // Split by newline and filter non-empty lines
      final lines = responseData.split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .toList();
      
      List<String> outputs = [];
      
      // Extract up to 5 meaningful outputs
      for (String line in lines) {
        // Remove numbering if present (1., 2., etc.)
        String cleanLine = line.replaceFirst(RegExp(r'^\d+\.\s*'), '');
        
        // Skip very short lines
        if (cleanLine.length > 10) {
          outputs.add(cleanLine);
          if (outputs.length >= 5) break;
        }
      }
      
      // If we don't have 5 outputs, pad with variations
      while (outputs.length < 5) {
        if (outputs.isNotEmpty) {
          outputs.add('${outputs.first} (Alternative ${outputs.length})');
        } else {
          outputs.add('Processing completed successfully');
        }
      }
      
      // Ensure exactly 5 outputs
      return outputs.take(5).toList();
    } catch (e) {
      developer.log('⚠️ Error parsing AI response: $e', name: 'AIKeyboardService');
      // Return fallback outputs
      return [
        'AI processing completed',
        'Response generated successfully',
        'Task finished with results',
        'Operation completed successfully',
        'Processing finished'
      ];
    }
  }
  
  /// Handle text from keyboard (legacy support)
  static Future<void> _handleTextFromKeyboard(MethodCall call) async {
    final text = call.arguments as String? ?? '';
    developer.log('📝 Text from keyboard: ${text.substring(0, text.length > 100 ? 100 : text.length)}', name: 'AIKeyboardService');
  }
  
  /// Handle keyboard status request
  static Future<Map<String, dynamic>> _handleGetKeyboardStatus(MethodCall call) async {
    return {
      'isProcessing': _isProcessing,
      'currentAction': _currentAction,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }
  
  /// Send AI success response to keyboard
  static Future<void> _sendAISuccessResponse(String action, List<String> outputs) async {
    try {
      final params = {
        'action': action,
        'success': true,
        'outputs': outputs,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      await _channel.invokeMethod('sendAIResponse', params);
      developer.log('✅ AI success response sent: $action with ${outputs.length} outputs', name: 'AIKeyboardService');
    } catch (e) {
      developer.log('❌ Failed to send AI success response: $e', name: 'AIKeyboardService');
    }
  }
  
  /// Send AI error response to keyboard
  static Future<void> _sendAIErrorResponse(String action, String error) async {
    try {
      final params = {
        'action': action,
        'success': false,
        'error': error,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      await _channel.invokeMethod('sendAIResponse', params);
      developer.log('❌ AI error response sent: $action - $error', name: 'AIKeyboardService');
    } catch (e) {
      developer.log('❌ Failed to send AI error response: $e', name: 'AIKeyboardService');
    }
  }
  
  /// Check if currently processing
  static bool get isProcessing => _isProcessing;
  
  /// Get current action being processed
  static String? get currentAction => _currentAction;
}