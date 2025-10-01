import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keytype/core/helper/extensions/app_extensions.dart';
import 'package:keytype/core/helper/stream/json_stream.dart';
import 'package:keytype/core/models/template_model/template_res_model.dart';
import '../../core/init/dependency_injection.dart';
import '../../core/models/chat_bot_model/chat_bot_conversation_res_model.dart';
import '../../core/network/chatbot/chatbot_api_calls.dart';

class AskAiController extends GetxController {
  final chatBotApiCalls = getIt<ChatBotApiCalls>();

  final textEditController = TextEditingController();
  final scrollController = ScrollController();
  final jsonStream = JsonStream();

  /// obs
  final hasMessage = false.obs;
  final listMessages = <ChatBotConversationResModel>[].obs;
  final isGenerated = false.obs;
  final isLoadingHistory = false.obs;
  String lastConversationUuid = '';
  int? lastChatId;

  final promptModel = TemplateModel().obs;
  bool _userScrolledUp = false;

  @override
  void onInit() {
    final arg = Get.arguments;
    if (arg != null) {
      if (arg['dataPrompt'] != null) {
        final data = arg['dataPrompt'];
        promptModel.value = data as TemplateModel;
        onChange('value');
      }
      if (arg['uuId'] != null) {
        final String uuId = arg['uuId'];
        _callApiChatHistory(uuId);
      }
    }

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;

      if (maxScroll - currentScroll > 100) {
        _userScrolledUp = true;
      } else {
        _userScrolledUp = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    onStopGenerate();
    super.onClose();
  }

  /// func
  void onChange(String value) {
    if (value.isEmpty) {
      hasMessage.value = false;
    } else {
      hasMessage.value = true;
    }
  }

  void onStopGenerate() {
    chatBotApiCalls.cancelChatBotConversation();
  }

  void sendMessage() {
    if (isGenerated.value) {
      onStopGenerate();
      return;
    }
    if (!hasMessage.value) {
      return;
    }
    _userScrolledUp = false;
    if (promptModel.value.prompt != null) {
      textEditController.text =
          '${promptModel.value.prompt ?? ''} ${textEditController.text}';
    }
    _addItemToList(isUser: true, message: textEditController.text);
    _callApiChatConversation();
    _animateEndPosition();
    _clearInput();
  }

  String _idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  void _addItemToList(
      {required bool isUser,
      required String message,
      String? id,
      String? uuId,
      String? createdAt}) {
    listMessages.add(ChatBotConversationResModel(
        createdAt: createdAt ?? DateTime.now().toString(),
        content: message,
        id: id,
        uuId: uuId,
        role: isUser ? 'user' : 'assistant'));
  }

  void _removeItemFromList({required String id}) {
    listMessages.removeWhere(
      (element) => element.id == id,
    );
  }

  void _animateEndPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userScrolledUp) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _callApiChatConversation() async {
    isGenerated.value = true;
    final id = _idGenerator();
    _addItemToList(isUser: false, message: '', id: id);
    final result = await chatBotApiCalls.callChatBotConversation(
        chatId: lastChatId,
        uuid: lastConversationUuid,
        gptModel: 'gpt-4o-mini',
        content: textEditController.text);

    result.fold(
      (left) {
        debugPrint(left.message);
        _removeItemFromList(id: id);
        isGenerated.value = false;
      },
      (right) {
        _handleStream(right, id);
      },
    );
  }

  void _handleStream(Stream<Uint8List> stream, String id) {
    String buffer = '';
    String completeMsg = '';
    final itemMessage = listMessages.firstWhere(
      (element) => element.id == id,
      orElse: () => ChatBotConversationResModel(),
    );

    jsonStream
        .jsonDecodeHandler(
      stream: stream,
      startWith: 'data: ',
    )
        .listen(
      (json) {
        final data = ChatBotConversationResModel.fromJson(json);
        print("Data : ${jsonEncode(data)}");
        if (data.content?.isNotEmpty ?? false) {
          if (data.content != null) {
            buffer += data.content!;
            completeMsg += buffer;
            buffer = '';
            itemMessage.content = completeMsg;
            _animateEndPosition();
            log(completeMsg);
            update();
          }
        }
        if (data.conversationUuid?.isNotEmpty ?? false) {
          lastConversationUuid = data.conversationUuid!;
        }
        if (!data.chats.isNullOrEmpty) {
          lastChatId = data.chats!.last;
        }
      },
      onError: (error) {
        // _removeItemFromList(id: id);
      },
      onDone: () {
        isGenerated.value = false;
      },
    );
  }

  void _callApiChatHistory(String uuId) async {
    isLoadingHistory.value = true;
    final result = await chatBotApiCalls.chatBotHistoryOfConversation(uuId);
    result.fold(
      (left) {
        debugPrint(left.message);
      },
      (right) {
        for (var element in right) {
          _addItemToList(
            isUser: element.role == 'user',
            message: element.text ?? '',
            createdAt: element.createdAt,
          );
          element.answer?.forEach(
            (element) {
              _addItemToList(
                isUser: element.role == 'user',
                message: element.text ?? '',
                createdAt: element.createdAt,
              );
            },
          );
        }
      },
    );
    isLoadingHistory.value = false;
  }

  void newChat() {
    _userScrolledUp = false;
    listMessages.clear();
    textEditController.clear();
    onChange('');
    deletePrompt();
  }

  void deletePrompt() {
    promptModel.value = TemplateModel();
    if (textEditController.text.isEmpty) {
      onChange('');
    }
  }

  void editPrompt() {
    textEditController.text = promptModel.value.prompt ?? '';
    deletePrompt();
  }

  void _clearInput() {
    textEditController.clear();
    deletePrompt();
    onChange('');
  }
}
