import 'dart:developer' as developer;
import 'keyboard_service.dart';

/// Debug service for keyboard communication troubleshooting
class KeyboardDebugService {
  static const String _logName = 'KeyboardDebug';
  
  /// Test keyboard service connectivity
  static Future<Map<String, dynamic>> testConnectivity() async {
    final results = <String, dynamic>{};
    
    try {
      // Test 1: Check keyboard status
      developer.log('🔍 Testing keyboard status...', name: _logName);
      final status = await KeyboardService.getKeyboardStatus();
      results['keyboardStatus'] = status;
      
      // Test 2: Test text sending
      developer.log('🔍 Testing text sending...', name: _logName);
      final textSent = await KeyboardService.sendTextToKeyboard('Test message from Flutter');
      results['textSendTest'] = textSent;
      
      // Test 3: Test AI response sending
      developer.log('🔍 Testing AI response sending...', name: _logName);
      final aiResponseSent = await KeyboardService.sendAISuccessResponse('TEST', 'Test AI response');
      results['aiResponseTest'] = aiResponseSent;
      
      results['overallStatus'] = 'success';
      results['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      
      developer.log('✅ Connectivity test completed successfully', name: _logName);
      
    } catch (e) {
      results['overallStatus'] = 'error';
      results['error'] = e.toString();
      results['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      
      developer.log('❌ Connectivity test failed: $e', name: _logName);
    }
    
    return results;
  }
  
  /// Log keyboard service statistics
  static void logStatistics() {
    developer.log('📊 Keyboard Service Statistics:', name: _logName);
    developer.log('  - AI Action Callback: ${KeyboardService.onAIActionRequest != null ? "Registered" : "Not Registered"}', name: _logName);
    developer.log('  - Text Callback: ${KeyboardService.onTextFromKeyboard != null ? "Registered" : "Not Registered"}', name: _logName);
    developer.log('  - Timestamp: ${DateTime.now().toIso8601String()}', name: _logName);
  }
  
  /// Simulate AI action for testing
  static Future<void> simulateAIAction(String action, String text) async {
    developer.log('🎭 Simulating AI action: $action', name: _logName);
    
    try {
      if (KeyboardService.onAIActionRequest != null) {
        KeyboardService.onAIActionRequest!(text, action);
        developer.log('✅ AI action simulation completed', name: _logName);
      } else {
        developer.log('❌ No AI action callback registered', name: _logName);
      }
    } catch (e) {
      developer.log('❌ AI action simulation failed: $e', name: _logName);
    }
  }
  
  /// Log detailed debug information
  static void logDebugInfo() {
    final info = {
      'timestamp': DateTime.now().toIso8601String(),
      'hasAICallback': KeyboardService.onAIActionRequest != null,
      'hasTextCallback': KeyboardService.onTextFromKeyboard != null,
      'platform': 'Flutter',
    };
    
    developer.log('🔧 Debug Info: $info', name: _logName);
  }
  
  /// Test AI processing with sample data
  static Future<void> testAIProcessing() async {
    developer.log('🧪 Testing AI processing...', name: _logName);
    
    final testCases = [
      {'action': 'REWRITE', 'text': 'This is a test message for rewriting.'},
      {'action': 'SUMMARIZE', 'text': 'This is a longer test message that should be summarized. It contains multiple sentences and ideas that can be condensed into a shorter form.'},
      {'action': 'GENERATE', 'text': 'Generate content based on this prompt.'},
    ];
    
    for (final testCase in testCases) {
      try {
        await simulateAIAction(testCase['action']!, testCase['text']!);
        await Future.delayed(Duration(milliseconds: 500)); // Small delay between tests
      } catch (e) {
        developer.log('❌ Test case failed: ${testCase['action']} - $e', name: _logName);
      }
    }
    
    developer.log('🧪 AI processing test completed', name: _logName);
  }
}