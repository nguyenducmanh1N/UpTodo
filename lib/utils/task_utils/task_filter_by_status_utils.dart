import 'package:uptodo/models/task/task_dto.dart';

enum TaskStatus {
  completed,
  uncompleted,
}

class TaskStatusUtils {
  List<TaskDTO> filterTasksByStatus(List<TaskDTO> tasks, TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return filterCompletedTask(tasks);
      case TaskStatus.uncompleted:
        return filterUncompletedTask(tasks);
    }
  }

  List<TaskDTO> filterCompletedTask(List<TaskDTO> tasks) {
    final tasksResult = List<TaskDTO>.from(tasks);
    try {
      return tasksResult.where((task) => task.isCompleted == true).toList();
    } catch (e) {
      return [];
    }
  }

  List<TaskDTO> filterUncompletedTask(List<TaskDTO> tasks) {
    final tasksResult = List<TaskDTO>.from(tasks);
    try {
      final now = DateTime.now();
      return tasksResult.where((task) => task.isCompleted == false && task.date.isBefore(now)).toList();
    } catch (e) {
      return [];
    }
  }
}
