import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:dio/dio.dart';
import 'package:keytype/core/helper/extensions/app_extensions.dart';

import '../../init/dependency_injection.dart';
import '../../models/error_utils/error.dart';
import '../../models/template_model/parent_category_res_model.dart';
import '../../models/template_model/template_res_model.dart';
import '../network_error_handler.dart';
import 'templates_repository.dart';

/// Templates API Calls - Handles business logic and error handling for templates functionality
/// Returns Either<Failure, T> for functional error handling
class TemplatesApiCalls {
  final _repository = getIt<TemplatesRepository>();

  /// Handles DioExceptions and converts them to Either
  Either<Failure, T> _handleDioError<T>(DioException error) {
    final message = NetworkErrorHandler.handleDioError(error);
    return Left(Failure(message, error.response?.statusCode));
  }

  /// Handles general exceptions
  Either<Failure, T> _handleGeneralError<T>(Object error) {
    log('Unexpected error in TemplatesApiCalls: $error');
    return Left(Failure('An unexpected error occurred', null));
  }

  Future<Either<Failure, List<TemplateModel>>> publicTemplates({
    int? categoryId,
    String? query,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _repository.publicTemplates(
        categoryId: categoryId,
        query: query,
        limit: limit,
        offset: offset,
      );

      if (response.statusCode == 200) {
        if ((response.data as List<dynamic>).isNullOrEmpty) {
          return const Right([]);
        }

        final templates = (response.data as List<dynamic>)
            .map((json) => TemplateModel.fromJson(json))
            .toList();
        return Right(templates);
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

  Future<Either<Failure, List<ParentCategoryResModel>>> getCategories() async {
    try {
      final response = await _repository.getCategories();

      if (response.statusCode == 200) {
        if ((response.data as List<dynamic>).isNullOrEmpty) {
          return const Right([]);
        }

        final categories = (response.data as List<dynamic>)
            .map((json) => ParentCategoryResModel.fromJson(json))
            .toList();
        return Right(categories);
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
}