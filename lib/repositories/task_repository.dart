import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/services/task_service.dart';

class TaskRepository {
  final TaskService _taskService;
  TaskRepository(this._taskService);

  Future<List<TaskDTO>> getTasks(String userId) async {
    return await _taskService.getTasks(userId);
  }

  Future<void> saveTask(String userId, TaskDTO task) async {
    await _taskService.saveTask(userId, task);
  }

  Future<void> deleteTask(String userId, String task) async {
    await _taskService.deleteTask(userId, task);
  }

  Future<void> updateTask(String userId, TaskDTO oldTask, TaskDTO newTask) async {
    await _taskService.updateTask(userId, oldTask, newTask);
  }

  Future<TaskDTO?> getTaskById(String userId, String taskId) async {
    return await _taskService.getTaskById(userId, taskId);
  }

  Future<void> clearTasks(String userId) async {
    await _taskService.clearTasks(userId);
  }

  Future<List<TaskDTO>> getTaskByDate(String userId, DateTime date) async {
    return await _taskService.getTaskByDate(userId, date);
  }
}
