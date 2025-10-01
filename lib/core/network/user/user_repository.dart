import 'dart:io';
import 'package:dio/dio.dart';
import '../apiClientHelper.dart';
import '../apiEndPoints.dart';

/// User Repository - Handles only HTTP requests for user functionality
/// Returns raw Response objects without business logic
class UserRepository {
  late final Dio _dio;

  UserRepository() {
    _dio = ApiClientHelper.createDioInstance();
  }

  Future<Response> getUserInfo() => _dio.get(ApiEndPoint.user);

  Future<Response> uploadImage(File file) async {
    final multipartFile = await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    );

    final formData = FormData.fromMap({
      'file': multipartFile,
    });

    return _dio.post(
      ApiEndPoint.profileImage,
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
  }

  Future<Response> updateAccountInfo(
    final String firstName,
    final String lastName,
  ) =>
      _dio.patch(
        ApiEndPoint.user,
        data: {
          'first_name': firstName,
          'last_name': lastName,
        },
      );
}
