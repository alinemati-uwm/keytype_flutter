import 'package:flutter/services.dart';
import 'dart:developer' as developer;

class KeyboardService {
  static const MethodChannel _channel = MethodChannel('keyboard_channel');
  
  // Callback functions for AI actions
  static Function(String text, String action)? onAIActionRequest;
  static Function(String text)? onTextFromKeyboard;
  
  static void initialize() {
    _channel.setMethodCallHandler(_handleMethod);
    developer.log('🔤 KeyboardService initialized', name: 'KeyboardService');
  }
  
  static Future<dynamic> _handleMethod(MethodCall call) async {
    try {
      switch (call.method) {
        case 'textFromKeyboard':
          await _handleTextFromKeyboard(call);
          break;
        case 'aiActionRequest':
          await _handleAIActionRequest(call);
          break;
        case 'getKeyboardStatus':
          return await _handleGetKeyboardStatus(call);
        default:
          developer.log('⚠️ Unimplemented method: ${call.method}', name: 'KeyboardService');
          throw PlatformException(
            code: 'Unimplemented',
            details: 'Method ${call.method} not implemented',
          );
      }
    } catch (e) {
      developer.log('❌ Error handling method ${call.method}: $e', name: 'KeyboardService');
      rethrow;
    }
  }
  
  static Future<void> _handleTextFromKeyboard(MethodCall call) async {
    try {
      String text = call.arguments as String;
      _logReceivedText(text);
      
      // Call registered callback if available
      if (onTextFromKeyboard != null) {
        onTextFromKeyboard!(text);
      }
    } catch (e) {
      developer.log('❌ Error handling text from keyboard: $e', name: 'KeyboardService');
    }
  }
  
  static Future<void> _handleAIActionRequest(MethodCall call) async {
    try {
      final Map<String, dynamic> args = Map<String, dynamic>.from(call.arguments);
      final String text = args['text'] ?? '';
      final String action = args['action'] ?? '';
      
      developer.log('🤖 AI Action Request: $action for ${text.length} chars', name: 'KeyboardService');
      
      if (text.isEmpty) {
        await _sendAIErrorResponse(action, 'No text provided');
        return;
      }
      
      if (action.isEmpty) {
        await _sendAIErrorResponse('UNKNOWN', 'No action specified');
        return;
      }
      
      // Validate action type
      final validActions = ['REWRITE', 'SUMMARIZE', 'GENERATE'];
      if (!validActions.contains(action)) {
        await _sendAIErrorResponse(action, 'Invalid action type: $action');
        return;
      }
      
      // Call registered callback if available
      if (onAIActionRequest != null) {
        try {
          onAIActionRequest!(text, action);
        } catch (e) {
          developer.log('❌ Error in AI action callback: $e', name: 'KeyboardService');
          await _sendAIErrorResponse(action, 'Callback error: $e');
        }
      } else {
        developer.log('⚠️ No AI action callback registered', name: 'KeyboardService');
        await _sendAIErrorResponse(action, 'No AI handler available');
      }
      
    } catch (e) {
      developer.log('❌ Error handling AI action request: $e', name: 'KeyboardService');
      final action = (call.arguments as Map?)?['action'] ?? 'UNKNOWN';
      await _sendAIErrorResponse(action, 'Internal error: $e');
    }
  }
  
  static Future<Map<String, dynamic>> _handleGetKeyboardStatus(MethodCall call) async {
    try {
      final result = await _channel.invokeMethod('getKeyboardStatus');
      return Map<String, dynamic>.from(result);
    } catch (e) {
      developer.log('❌ Error getting keyboard status: $e', name: 'KeyboardService');
      return {
        'isServiceRunning': false,
        'error': e.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    }
  }
  
  static void _logReceivedText(String text) {
    developer.log('📝 Text Received: "${text.length > 100 ? '${text.substring(0, 100)}...' : text}"', name: 'KeyboardService');
    developer.log('📊 Text Length: ${text.length} characters', name: 'KeyboardService');
  }
  
  // Method to send text to keyboard
  static Future<bool> sendTextToKeyboard(String text) async {
    try {
      await _channel.invokeMethod('sendTextToKeyboard', text);
      developer.log('✅ Text sent to keyboard: ${text.length} chars', name: 'KeyboardService');
      return true;
    } on PlatformException catch (e) {
      developer.log('❌ Failed to send text to keyboard: ${e.message}', name: 'KeyboardService');
      return false;
    }
  }
  
  // Method to send AI success response
  static Future<bool> sendAISuccessResponse(String action, String result) async {
    try {
      final params = {
        'action': action,
        'success': true,
        'result': result,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      await _channel.invokeMethod('sendAIResponse', params);
      developer.log('✅ AI success response sent: $action', name: 'KeyboardService');
      return true;
    } on PlatformException catch (e) {
      developer.log('❌ Failed to send AI success response: ${e.message}', name: 'KeyboardService');
      return false;
    }
  }
  
  // Method to send AI error response
  static Future<bool> _sendAIErrorResponse(String action, String error) async {
    try {
      final params = {
        'action': action,
        'success': false,
        'error': error,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      await _channel.invokeMethod('sendAIResponse', params);
      developer.log('⚠️ AI error response sent: $action - $error', name: 'KeyboardService');
      return true;
    } on PlatformException catch (e) {
      developer.log('❌ Failed to send AI error response: ${e.message}', name: 'KeyboardService');
      return false;
    }
  }
  
  // Public method to send AI error response (for external use)
  static Future<bool> sendAIErrorResponse(String action, String error) async {
    return await _sendAIErrorResponse(action, error);
  }
  
  // Method to get keyboard service status
  static Future<Map<String, dynamic>> getKeyboardStatus() async {
    try {
      final result = await _channel.invokeMethod('getKeyboardStatus');
      return Map<String, dynamic>.from(result);
    } catch (e) {
      developer.log('❌ Error getting keyboard status: $e', name: 'KeyboardService');
      return {
        'isServiceRunning': false,
        'error': e.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    }
  }
  
  // Method to register AI action callback
  static void setAIActionCallback(Function(String text, String action) callback) {
    onAIActionRequest = callback;
    developer.log('🔗 AI action callback registered', name: 'KeyboardService');
  }
  
  // Method to register text callback
  static void setTextCallback(Function(String text) callback) {
    onTextFromKeyboard = callback;
    developer.log('🔗 Text callback registered', name: 'KeyboardService');
  }
  
  // Method to clear callbacks
  static void clearCallbacks() {
    onAIActionRequest = null;
    onTextFromKeyboard = null;
    developer.log('🧹 Callbacks cleared', name: 'KeyboardService');
  }
}