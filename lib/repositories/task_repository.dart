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

  Future<void> updateTask(String userId, TaskDTO task) async {
    await _taskService.updateTask(userId, task);
  }

  Future<bool> checkTaskNameExistsInCategory(String userId, String categoryId, String taskName) async {
    return await _taskService.checkTaskNameExistsInCategory(userId, categoryId, taskName);
  }
}
