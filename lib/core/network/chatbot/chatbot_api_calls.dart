import 'dart:typed_data';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:dio/dio.dart';

import '../../init/dependency_injection.dart';
import '../../helper/base_brain.dart';
import '../../models/error_utils/error.dart';
import '../../models/chat_bot_model/features_request_model.dart';
import '../../models/chat_bot_model/user_chat_res_model.dart';
import '../../models/history/history_model.dart';
import '../network_error_handler.dart';
import 'chatbot_repository.dart';

/// ChatBot API Calls - Handles business logic and error handling for chat bot functionality
/// Returns Either<Failure, T> for functional error handling
class ChatBotApiCalls {
  final _repository = getIt<ChatBotRepository>();

  /// Handles DioExceptions and converts them to Either
  Either<Failure, T> _handleDioError<T>(DioException error) {
    final message = NetworkErrorHandler.handleDioError(error);
    return Left(Failure(message, error.response?.statusCode));
  }

  /// Handles general exceptions
  Either<Failure, T> _handleGeneralError<T>(Object error) {
    log('Unexpected error in ChatBotApiCalls: $error');
    return Left(Failure('An unexpected error occurred', null));
  }

  /// Creates a MultipartFile from file path if provided
  Future<MultipartFile?> _createMultipartFile(String? filePath) async {
    if (filePath?.isEmpty ?? true) return null;
    try {
      return await MultipartFile.fromFile(filePath!);
    } catch (e) {
      log('Error creating multipart file: $e');
      return null;
    }
  }

  /// Cancels any ongoing chat bot conversation
  void cancelChatBotConversation() {
    _repository.cancelChatBotConversation();
  }

  /// Getter for backward compatibility with cancel token
  CancelToken get ctApiChatBot => _repository.ctApiChatBot;

  Future<Either<Failure, Stream<Uint8List>>> callChatBotConversation({
    required String gptModel,
    required String content,
    String? filePath,
    String? uuid,
    int? chatId,
  }) async {
    try {
      final multipartFile = await _createMultipartFile(filePath);

      final response = await _repository.chatBotConversation(
        chatBotConversationReqModel: FeaturesRequestModel(
          message: content,
          setting: BaseBrain.settingAi,
          model: gptModel,
        ),
        file: multipartFile,
        uuid: uuid,
        chatId: chatId,
      );

      if (response.statusCode == 200) {
        return Right(response.data.stream);
      } else {
        return Left(Failure(
          NetworkErrorHandler.handleDioError(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
            ),
          ),
          response.statusCode,
        ));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, List<GeneratedHistoryItemModel>>>
      historyAskAi() async {
    try {
      final response = await _repository.historyAskAi();
      if (response.statusCode == 200) {
        final List<dynamic> dynamicList = response.data['histories'];
        final historyList = dynamicList
            .map((json) => GeneratedHistoryItemModel.fromJson(json))
            .toList();
        return Right(historyList);
      }
      return Left(Failure(
        NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
          ),
        ),
        response.statusCode,
      ));
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, List<UserChatResModel>>> chatBotHistoryOfConversation(
      String uuid) async {
    try {
      final response = await _repository.chatBotHistoryOfConversation(uuid);
      if (response.statusCode == 200) {
        final historyTree = (response.data as List)
            .map((json) => UserChatResModel.fromJson(json))
            .toList();
        return Right(historyTree);
      }
      return Left(Failure(
        NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
          ),
        ),
        response.statusCode,
      ));
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }
}
