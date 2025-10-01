import 'dart:convert';
import 'package:keytype/core/models/task_model/task_model.dart';
import 'package:keytype/core/network/tasks/task_api_calls.dart';
import 'package:keytype/components/modals/credits_error_modal.dart';
import 'package:keytype/utils/task_functions.dart';
import '../../core/helper/stream/json_stream.dart';
import '../../core/init/dependency_injection.dart';
import '../../core/network/ai_writer/ai_writer_api_calls.dart';
import '../../ui_imports.dart';
import '../../core/helper/utils.dart';

enum TaskType {
  generate,
  rewrite,
  translate,
  summarize,
  fixGrammar,
  makeFormal,
  makeInformal
}

enum ToneType {
  normal,
  casual,
  professional,
  friendly,
  confident,
  empathetic
}

enum FormalityType {
  formal,
  informal
}

class TaskOption {
  final TaskType type;
  final String title;
  final String description;
  final String icon;
  final List<Color> gradientColors;

  TaskOption({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}

class TaskResult {
  final String content;
  final bool isSelected;

  TaskResult({
    required this.content,
    this.isSelected = false,
  });
}

class CreateController extends GetxController {
  final aiWriterApiCalls = getIt<AIWriterApiCalls>();
  final taskApiCalls = getIt<TaskApiCalls>();
  final jsonStream = JsonStream();

  // Text input controller
  final textController = TextEditingController();

  // Task options
  final taskOptions = <TaskOption>[
    TaskOption(
      type: TaskType.generate,
      title: 'Continue Writing',
      description: 'Generate continuation of your text',
      icon: '✨',
      gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
    TaskOption(
      type: TaskType.rewrite,
      title: 'Rewrite',
      description: 'Rewrite text in different ways',
      icon: '🔄',
      gradientColors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    ),
    TaskOption(
      type: TaskType.translate,
      title: 'Translate',
      description: 'Translate to different languages',
      icon: '🌍',
      gradientColors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    ),
    TaskOption(
      type: TaskType.summarize,
      title: 'Summarize',
      description: 'Create concise summaries',
      icon: '📝',
      gradientColors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
    ),
    TaskOption(
      type: TaskType.fixGrammar,
      title: 'Fix Grammar',
      description: 'Correct grammar and spelling',
      icon: '✏️',
      gradientColors: [Color(0xFFfa709a), Color(0xFFfee140)],
    ),
    TaskOption(
      type: TaskType.makeFormal,
      title: 'Make Formal',
      description: 'Transform to formal language',
      icon: '🎩',
      gradientColors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
    ),
    TaskOption(
      type: TaskType.makeInformal,
      title: 'Make Casual',
      description: 'Transform to casual language',
      icon: '😎',
      gradientColors: [Color(0xFFffecd2), Color(0xFFfcb69f)],
    ),
  ].obs;

  // Selected options
  final selectedTask = TaskOption(
    type: TaskType.generate,
    title: 'Continue Writing',
    description: 'Generate continuation of your text',
    icon: '✨',
    gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
  ).obs;

  final selectedTone = ToneType.normal.obs;
  final selectedFormality = FormalityType.formal.obs;

  // Results
  final taskResults = <TaskResult>[].obs;
  final isLoading = false.obs;
  final isGenerating = false.obs;

  // Animation controllers
  final animationDuration = Duration(milliseconds: 300);
  final shimmerAnimation = true.obs;


  // Task selection
  void selectTask(TaskOption task) {
    selectedTask.value = task;
    // Ensure the UI updates immediately
    update();
  }

  // Tone selection
  void selectTone(ToneType tone) {
    selectedTone.value = tone;
    selectedTone.refresh();
  }

  // Formality selection
  void selectFormality(FormalityType formality) {
    selectedFormality.value = formality;
    selectedFormality.refresh();
  }

  // Get tone display name
  String getToneDisplayName(ToneType tone) {
    switch (tone) {
      case ToneType.normal:
        return 'Normal';
      case ToneType.casual:
        return 'Casual';
      case ToneType.professional:
        return 'Professional';
      case ToneType.friendly:
        return 'Friendly';
      case ToneType.confident:
        return 'Confident';
      case ToneType.empathetic:
        return 'Empathetic';
    }
  }

  // Get formality display name
  String getFormalityDisplayName(FormalityType formality) {
    switch (formality) {
      case FormalityType.formal:
        return 'Formal';
      case FormalityType.informal:
        return 'Informal';
    }
  }

  // Get task type string for API
  String getTaskTypeString(TaskType type) {
    switch (type) {
      case TaskType.generate:
        return 'generate';
      case TaskType.rewrite:
        return 'rewrite';
      case TaskType.translate:
        return 'translate';
      case TaskType.summarize:
        return 'summarize';
      case TaskType.fixGrammar:
        return 'fix_grammar';
      case TaskType.makeFormal:
        return 'make_formal';
      case TaskType.makeInformal:
        return 'make_informal';
    }
  }

  void _clearResults() {
    taskResults.clear();
  }

  // Generate task results
  Future<void> generateTask() async {
    if (textController.text.trim().isEmpty) {
      ToastDialogs.showErrorIconNotification(
        message: 'Please enter some text to process',
      );
      return;
    }

    _clearResults();
    isLoading.value = true;
    isGenerating.value = true;

    try {
      // Get the system prompt for the selected task
      final taskSystem = TaskSystemController();
      final taskTypeString = getTaskTypeString(selectedTask.value.type);
      final systemPrompt = taskSystem.getTaskSystemPrompt(type: taskTypeString);

      // Create the meta data with tone and formality
      final meta = {
        'Tone': getToneDisplayName(selectedTone.value),
        'formality': getFormalityDisplayName(selectedFormality.value).toLowerCase(),
      };

      // Create the task model for API call
      final taskModel = TaskModel(
        inputText: textController.text.trim(),
        prompt: systemPrompt,
        action: 'text', // hardcoded as requested
        model: 'openai/gpt-4o-mini', // hardcoded as requested
        meta: meta,
      );

      // Make the real API call
      await _createTaskWithApi(taskModel);

    } catch (e) {
      ToastDialogs.showErrorIconNotification(
        message: 'Failed to generate results: $e',
      );
    } finally {
      isLoading.value = false;
      isGenerating.value = false;
    }
  }

  // Real API call to create task
  Future<void> _createTaskWithApi(TaskModel taskModel) async {
    print('[DEBUG] Making API call to create task');
    
    final result = await taskApiCalls.createTask(task: taskModel);
    
    result.fold(
      (failure) {
        print('[DEBUG] API call failed:');
        print('[DEBUG] Failure code: ${failure.code}');
        print('[DEBUG] Failure message: ${failure.message}');
        
        // Check if it's a credits error (status code 402)
        if (failure.code == 402) {
          print('[DEBUG] Detected 402 error, calling _handleCreditsError');
          _handleCreditsError(failure.message);
        } else {
          // Handle other API errors
          ToastDialogs.showErrorIconNotification(
            message: failure.message ?? 'Failed to create task',
          );
        }
      },
      (createdTask) {
        print('[DEBUG] Task created successfully: ${createdTask.id}');
        // Task created successfully, now poll for completion
        if (createdTask.id != null) {
          _pollTaskForCompletion(createdTask.id!);
        } else {
          ToastDialogs.showErrorIconNotification(
            message: 'Task created but no ID returned',
          );
        }
      },
    );
  }

  // Handle credits error by parsing the response and showing modal
  void _handleCreditsError(String? errorMessage) {
    print('[DEBUG] Credits error received: $errorMessage');
    
    try {
      if (errorMessage != null) {
        // Try to parse the JSON error response
        final errorData = jsonDecode(errorMessage);
        print('[DEBUG] Parsed error data: $errorData');
        
        // Show the credits error modal
        CreditsErrorModal.show(
          context: Get.context!,
          errorData: errorData,
        );
        print('[DEBUG] Credits modal should be showing now');
      } else {
        print('[DEBUG] Error message is null, showing fallback toast');
        // Fallback for when we can't parse the error
        ToastDialogs.showErrorIconNotification(
          message: 'Insufficient credits. Please add credits to continue.',
        );
      }
    } catch (e) {
      print('[DEBUG] JSON parsing failed: $e');
      // If JSON parsing fails, show a generic message
      ToastDialogs.showErrorIconNotification(
        message: 'Insufficient credits. Please add credits to continue.',
      );
    }
  }

  // Poll task status until completion
  Future<void> _pollTaskForCompletion(String taskId) async {
    const maxPollingAttempts = 30; // 30 attempts = ~60 seconds max
    const pollingInterval = Duration(seconds: 2);
    
    for (int attempt = 0; attempt < maxPollingAttempts; attempt++) {
      await Future.delayed(pollingInterval);
      
      final result = await taskApiCalls.getTask(taskId: taskId);
      
      result.fold(
        (failure) {
          ToastDialogs.showErrorIconNotification(
            message: 'Failed to get task status: ${failure.message}',
          );
          return;
        },
        (task) {
          if (task.isCompleted && task.responseData != null) {
            // Task completed successfully
            _parseTaskResults(task.responseData!);
            return;
          } else if (task.hasError) {
            // Task failed
            ToastDialogs.showErrorIconNotification(
              message: task.errorMessage ?? 'Task failed',
            );
            return;
          }
          // Task still in progress, continue polling
        },
      );
    }
    
    // If we get here, polling timed out
    ToastDialogs.showErrorIconNotification(
      message: 'Task took too long to complete. Please try again.',
    );
  }

  // Parse the response_data into individual results
  void _parseTaskResults(String responseData) {
    final lines = responseData.split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    taskResults.clear();
    
    for (int i = 0; i < lines.length && i < 5; i++) {
      String content = lines[i].trim();
      // Remove numbering if present (1., 2., etc.)
      content = content.replaceFirst(RegExp(r'^\d+\.\s*'), '');
      
      if (content.isNotEmpty) {
        taskResults.add(TaskResult(content: content));
      }
    }
  }

  // Copy result to clipboard
  void copyResult(String content) {
    Utils.copyText(content);
    ToastDialogs.showErrorIconNotification(
      message: 'Copied to clipboard! ✅',
    );
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
// void _handleStream(Stream<Uint8List> stream) {
//   String buffer = '';
//   String completeMsg = '';
//
//   jsonStream
//       .jsonDecodeHandler(
//     stream: stream,
//     startWith: 'data: ',
//   )
//       .listen(
//         (json) {
//       final data = ChatBotConversationResModel.fromJson(json);
//       if (data.content != null) {
//         if (data.content?.isNotEmpty ?? false) {
//           buffer += data.content!;
//           completeMsg += buffer;
//           buffer = '';
//           resultText.value = completeMsg;
//         }
//       }
//     },
//     onError: (error) {
//       // _removeItemFromList(id: id);
//     },
//     onDone: () {},
//   );
// }
