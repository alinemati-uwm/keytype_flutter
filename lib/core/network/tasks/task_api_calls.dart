import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:keytype/core/init/dependency_injection.dart';
import 'package:keytype/core/models/error_utils/error.dart';
import 'package:keytype/core/models/task_model/task_model.dart';
import 'package:keytype/core/models/task_model/task_response_model.dart';
import 'package:keytype/core/network/network_error_handler.dart';
import 'package:keytype/core/network/tasks/task_repository.dart';

class TaskApiCalls {
  final _repository = getIt<TaskRepository>();

  /// Handles DioExceptions and converts them to Either
  Either<Failure, T> _handleDioError<T>(DioException error) {
    final message = NetworkErrorHandler.handleDioError(error);
    return Left(Failure(message, error.response?.statusCode));
  }

  /// Handles general exceptions
  Either<Failure, T> _handleGeneralError<T>(Object error) {
    log('Unexpected error in AuthApiCalls: $error');
    return Left(Failure('An unexpected error occurred', null));
  }

  Future<Either<Failure, TaskResponseModel>> getAllTasks() async {
    try {
      final result = await _repository.getAllTasks();
      if (result.statusCode == 200) {
        return Right(TaskResponseModel.fromJson(result.data));
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(requestOptions: result.requestOptions, response: result),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, TaskModel>> createTask({
    required TaskModel task,
  }) async {
    try {
      final result = await _repository.createTask(task: task);
      if (result.statusCode == 200 || result.statusCode == 201 || result.statusCode == 202) {
        return Right(TaskModel.fromJson(result.data));
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(requestOptions: result.requestOptions, response: result),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, TaskModel>> getTask({required String taskId}) async {
    try {
      final result = await _repository.getTaskById(taskId: taskId);
      if (result.statusCode == 200) {
        return Right(TaskModel.fromJson(result.data));
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(requestOptions: result.requestOptions, response: result),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, TaskModel>> editTask({required TaskModel task}) async {
    try {
      final result = await _repository.updateTask(task: task);
      if (result.statusCode == 200) {
        return Right(TaskModel.fromJson(result.data));
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(requestOptions: result.requestOptions, response: result),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, TaskModel>> editTaskPartially({
    required TaskModel task,
  }) async {
    try {
      final result = await _repository.updateTask(task: task);
      if (result.statusCode == 200) {
        return Right(TaskModel.fromJson(result.data));
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(requestOptions: result.requestOptions, response: result),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> deleteTask({required String taskID}) async {
    try {
      final result = await _repository.deleteTask(taskID: taskID);
      if (result.statusCode == 200) {
        return Right("Task deleted successfully!");
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(requestOptions: result.requestOptions, response: result),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }
}
