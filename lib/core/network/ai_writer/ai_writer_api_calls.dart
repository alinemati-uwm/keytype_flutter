import 'dart:typed_data';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:dio/dio.dart';

import '../../init/dependency_injection.dart';
import '../../models/error_utils/error.dart';
import '../../models/chat_bot_model/features_request_model.dart';
import '../../models/history/history_model.dart';
import '../../models/language_model/language_model.dart';
import '../../models/writing_style_model/writing_style_model.dart';
import '../network_error_handler.dart';
import 'ai_writer_repository.dart';

/// AI Writer API Calls - Handles business logic and error handling for AI writer functionality
/// Returns Either<Failure, T> for functional error handling
class AIWriterApiCalls {
  final _repository = getIt<AIWriterRepository>();

  /// Handles DioExceptions and converts them to Either
  Either<Failure, T> _handleDioError<T>(DioException error) {
    final message = NetworkErrorHandler.handleDioError(error);
    return Left(Failure(message, error.response?.statusCode));
  }

  /// Handles general exceptions
  Either<Failure, T> _handleGeneralError<T>(Object error) {
    log('Unexpected error in AIWriterApiCalls: $error');
    return Left(Failure('An unexpected error occurred', null));
  }

  Future<Either<Failure, List<GeneratedHistoryItemModel>>> historyAIWriter({
    String? type,
  }) async {
    try {
      final result = await _repository.historyAIWriter(type: type);
      if (result.statusCode == 200) {
        final List<dynamic> dynamicList = result.data['histories'];
        final historyList = dynamicList
            .map((json) => GeneratedHistoryItemModel.fromJson(json))
            .toList();
        return Right(historyList);
      } else {
        return Left(Failure(
          NetworkErrorHandler.handleDioError(
            DioException(
              requestOptions: result.requestOptions,
              response: result,
            ),
          ),
          result.statusCode,
        ));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, List<LanguageModel>>> languages() async {
    try {
      final result = await _repository.languages();
      if (result.statusCode == 200) {
        final List<dynamic> dynamicList = result.data;
        final languageList =
            dynamicList.map((json) => LanguageModel.fromJson(json)).toList();
        return Right(languageList);
      } else {
        return Left(Failure(
          NetworkErrorHandler.handleDioError(
            DioException(
              requestOptions: result.requestOptions,
              response: result,
            ),
          ),
          result.statusCode,
        ));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, WritingStyleModel>> getWritingStyles() async {
    try {
      final result = await _repository.getWritingStyles();
      if (result.statusCode == 200) {
        return Right(WritingStyleModel.fromJson(result.data));
      } else {
        return Left(Failure(
          NetworkErrorHandler.handleDioError(
            DioException(
              requestOptions: result.requestOptions,
              response: result,
            ),
          ),
          result.statusCode,
        ));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, Stream<Uint8List>>> generateAIWriter({
    required FeaturesRequestModel data,
  }) async {
    try {
      final result = await _repository.generateAIWriter(data: data);
      if (result.statusCode == 200) {
        return Right(result.data.stream);
      } else {
        return Left(Failure(
          NetworkErrorHandler.handleDioError(
            DioException(
              requestOptions: result.requestOptions,
              response: result,
            ),
          ),
          result.statusCode,
        ));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }
}
