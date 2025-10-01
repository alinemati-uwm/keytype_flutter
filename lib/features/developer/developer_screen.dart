import 'package:keytype/features/developer/developer_controller.dart';
import 'package:keytype/components/custom_button.dart';
import 'package:keytype/core/services/keyboard_debug_service.dart';
import 'package:keytype/core/services/keyboard_service.dart';

import '../../ui_imports.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DeveloperController(),
        builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Developer mode'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Original functionality
                Obx(() => Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.resultText.value.isEmpty 
                      ? 'No result yet...' 
                      : controller.resultText.value,
                    style: TextStyle(fontSize: 14),
                  ),
                )),
                
                CustomButton(
                  onTap: () {
                    controller.apiGenerateAiCreateText();
                  },
                  text: 'API Create Text',
                ),
                
                SizedBox(height: 20),
                
                // Keyboard testing section
                Text(
                  'Keyboard Service Testing',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
                SizedBox(height: 16),
                
                CustomButton(
                  onTap: () async {
                    final results = await KeyboardDebugService.testConnectivity();
                    controller.resultText.value = 'Connectivity Test Results:\n${results.toString()}';
                  },
                  text: 'Test Keyboard Connectivity',
                ),
                
                SizedBox(height: 8),
                
                CustomButton(
                  onTap: () {
                    KeyboardDebugService.logStatistics();
                    controller.resultText.value = 'Statistics logged to console. Check debug output.';
                  },
                  text: 'Log Keyboard Statistics',
                ),
                
                SizedBox(height: 8),
                
                CustomButton(
                  onTap: () async {
                    await KeyboardDebugService.testAIProcessing();
                    controller.resultText.value = 'AI processing test completed. Check debug output.';
                  },
                  text: 'Test AI Processing',
                ),
                
                SizedBox(height: 8),
                
                CustomButton(
                  onTap: () async {
                    final status = await KeyboardService.getKeyboardStatus();
                    controller.resultText.value = 'Keyboard Status:\n${status.toString()}';
                  },
                  text: 'Get Keyboard Status',
                ),
                
                SizedBox(height: 8),
                
                CustomButton(
                  onTap: () async {
                    final success = await KeyboardService.sendTextToKeyboard('Test message from developer screen');
                    controller.resultText.value = 'Send text result: ${success ? "Success" : "Failed"}';
                  },
                  text: 'Send Test Text to Keyboard',
                ),
                
                SizedBox(height: 8),
                
                CustomButton(
                  onTap: () async {
                    await KeyboardDebugService.simulateAIAction('REWRITE', 'This is a test message for rewriting functionality.');
                    controller.resultText.value = 'AI action simulation started. Check debug output.';
                  },
                  text: 'Simulate REWRITE Action',
                ),
                
                SizedBox(height: 8),
                
                CustomButton(
                  onTap: () async {
                    await KeyboardDebugService.simulateAIAction('SUMMARIZE', 'This is a longer test message that should be summarized. It contains multiple sentences and ideas that can be condensed into a shorter form for testing purposes.');
                    controller.resultText.value = 'AI action simulation started. Check debug output.';
                  },
                  text: 'Simulate SUMMARIZE Action',
                ),
                
                SizedBox(height: 8),
                
                CustomButton(
                  onTap: () async {
                    await KeyboardDebugService.simulateAIAction('GENERATE', 'Generate creative content based on this prompt for testing.');
                    controller.resultText.value = 'AI action simulation started. Check debug output.';
                  },
                  text: 'Simulate GENERATE Action',
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
