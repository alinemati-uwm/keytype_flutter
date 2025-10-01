import 'package:dio/dio.dart';
import 'package:keytype/core/models/task_model/task_model.dart';
import 'package:keytype/core/network/tasks/taskEndPoints.dart';
import 'package:keytype/core/network/apiClientHelper.dart';

class TaskRepository {
  late final Dio _dio;

  TaskRepository() {
    _dio = ApiClientHelper.createDioInstance(useBasicCredintials: true);
  }

  Future<Response> getAllTasks() => _dio.get(TaskEndPoints.getAllTasks);

  Future<Response> getTaskById({required String taskId}) =>
      _dio.get("${TaskEndPoints.getTask}$taskId/");

  Future<Response> createTask({required TaskModel task}) =>
      _dio.post(TaskEndPoints.createTask, data: task.convertToApiPost());

  Future<Response> updateTask({required TaskModel task}) => _dio.put(
    '${TaskEndPoints.updateTask}${task.id}/',
    data: task.convertToApiPost(),
  );

  Future<Response> updateTaskPartially({required TaskModel task}) => _dio.patch(
    '${TaskEndPoints.updateTask}${task.id}/',
    data: task.convertToApiPost(),
  );

  Future<Response> deleteTask({required String taskID}) =>
      _dio.delete('${TaskEndPoints.deleteTask}$taskID/');
}
