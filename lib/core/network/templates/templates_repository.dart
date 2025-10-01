import 'package:dio/dio.dart';
import '../apiClientHelper.dart';
import '../apiEndPoints.dart';

/// Templates Repository - Handles only HTTP requests for templates functionality
/// Returns raw Response objects without business logic
class TemplatesRepository {
  late final Dio _dio;

  TemplatesRepository() {
    _dio = ApiClientHelper.createDioInstance();
  }

  Future<Response> publicTemplates({
    int? categoryId,
    String? query,
    int limit = 10,
    int offset = 0,
  }) {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };

    if (categoryId != null && categoryId != 0) {
      queryParams['category_id'] = categoryId;
    }

    if (query?.isNotEmpty ?? false) {
      queryParams['search'] = query;
    }

    return _dio.get(
      ApiEndPoint.allTemplates,
      queryParameters: queryParams,
    );
  }

  Future<Response> getCategories() => _dio.get(ApiEndPoint.categories);
}