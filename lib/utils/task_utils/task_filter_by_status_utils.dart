import 'package:uptodo/models/task/task_dto.dart';

enum TaskStatus {
  completed,
  uncompleted,
}

class TaskStatusUtils {
  Future<List<TaskDTO>> filterTasksByStatus(List<TaskDTO> tasks, TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return filterCompletedTask(tasks);
      case TaskStatus.uncompleted:
        return filterUncompletedTask(tasks);
    }
  }

  Future<List<TaskDTO>> filterCompletedTask(List<TaskDTO> tasks) async {
    final tasksResult = List<TaskDTO>.from(tasks);
    try {
      return tasksResult.where((task) => task.isCompleted == true).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<TaskDTO>> filterUncompletedTask(List<TaskDTO> tasks) async {
    final tasksResult = List<TaskDTO>.from(tasks);
    try {
      final now = DateTime.now();
      return tasksResult.where((task) => task.isCompleted == false && task.date.isBefore(now)).toList();
    } catch (e) {
      return [];
    }
  }
}
