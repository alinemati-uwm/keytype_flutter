import 'package:dio/dio.dart';
import '../apiClientHelper.dart';
import '../apiEndPoints.dart';
import '../../models/chat_bot_model/features_request_model.dart';

/// AI Writer Repository - Handles only HTTP requests for AI writer functionality
/// Returns raw Response objects without business logic
class AIWriterRepository {
  late final Dio _dio;

  AIWriterRepository() {
    _dio = ApiClientHelper.createDioInstance();
  }

  Future<Response> historyAIWriter({String? type}) {
    final queryParams = <String, dynamic>{};
    if (type?.isNotEmpty ?? false) {
      queryParams['app_type'] = type;
    }

    return _dio.get(
      ApiEndPoint.history,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  Future<Response> languages() => _dio.get(ApiEndPoint.translate);

  Future<Response> getWritingStyles() => _dio.get(ApiEndPoint.writingStyles);

  Future<Response> generateAIWriter({
    required FeaturesRequestModel data,
  }) =>
      _dio.post(
        ApiEndPoint.generateAIWriter,
        data: data.toJson(),
        options: Options(responseType: ResponseType.stream),
      );
}
