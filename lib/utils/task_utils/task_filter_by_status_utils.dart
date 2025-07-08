import 'package:uptodo/models/task/task_dto.dart';

enum TaskStatus {
  completed,
  notCompleted,
}

class TaskStatusUtils {
  Future<List<TaskDTO>> filterTasksByStatus(List<TaskDTO> tasks, TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return filterTaskCompleted(tasks);
      case TaskStatus.notCompleted:
        return filterTaskNotCompleted(tasks);
    }
  }

  Future<List<TaskDTO>> filterTaskCompleted(List<TaskDTO> tasks) async {
    final tasksResult = List<TaskDTO>.from(tasks);
    try {
      if (tasksResult.isEmpty) return [];
      final completedTasks = tasksResult.where((task) => task.isCompleted == true).toList();
      return completedTasks;
    } catch (e) {
      return [];
    }
  }

  Future<List<TaskDTO>> filterTaskNotCompleted(List<TaskDTO> tasks) async {
    final tasksResult = List<TaskDTO>.from(tasks);
    try {
      if (tasksResult.isEmpty) return [];
      final now = DateTime.now();
      final uncompletedTasks =
          tasksResult.where((task) => task.isCompleted == false && task.date.isBefore(now)).toList();
      return uncompletedTasks;
    } catch (e) {
      return [];
    }
  }
}
