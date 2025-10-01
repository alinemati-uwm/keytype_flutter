import 'dart:convert';
import 'package:dio/dio.dart';
import '../apiClientHelper.dart';
import '../apiEndPoints.dart';
import '../../models/chat_bot_model/features_request_model.dart';

/// ChatBot Repository - Handles only HTTP requests for chat bot functionality
/// Returns raw Response objects without business logic
class ChatBotRepository {
  late final Dio _dio;
  // Cancel tokens for long-running requests
  CancelToken _chatBotCancelToken = CancelToken();

  ChatBotRepository() {
    _dio = ApiClientHelper.createDioInstance();
  }

  /// Cancels any ongoing chat bot conversation
  void cancelChatBotConversation() {
    if (!_chatBotCancelToken.isCancelled) {
      _chatBotCancelToken.cancel('Request cancelled by user');
    }
    _chatBotCancelToken = CancelToken();
  }

  /// Getter for backward compatibility
  CancelToken get ctApiChatBot => _chatBotCancelToken;

  Future<Response> chatBotConversation({
    required FeaturesRequestModel chatBotConversationReqModel,
    MultipartFile? file,
    String? uuid,
    int? chatId,
  }) async {
    // Reset cancel token if it was cancelled
    if (_chatBotCancelToken.isCancelled) {
      _chatBotCancelToken = CancelToken();
    }

    final String encodedJson = jsonEncode(chatBotConversationReqModel.toJson());

    // Build query parameters only if needed
    final Map<String, dynamic> queryParams = {};
    if (uuid?.isNotEmpty ?? false) {
      queryParams['conversation_uuid'] = uuid;
      if (chatId != null) {
        queryParams['chat_id'] = chatId;
      }
    }

    // Build form data
    final Map<String, dynamic> formDataMap = {'generate_data': encodedJson};
    if (file != null) {
      formDataMap['files'] = file;
    }

    return _dio.post(
      ApiEndPoint.chatBotConversation,
      cancelToken: _chatBotCancelToken,
      data: FormData.fromMap(formDataMap),
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      options: Options(
        headers: {
          'accept': '*/*',
          'Content-Type': 'multipart/form-data',
        },
        responseType: ResponseType.stream,
      ),
    );
  }

  Future<Response> historyAskAi() => _dio.get(ApiEndPoint.historyAskAi);

  Future<Response> chatBotHistoryOfConversation(String uuid) => _dio.get(
        ApiEndPoint.askAiHistoryOfConversation,
        queryParameters: {'conversation_uuid': uuid},
      );
}
