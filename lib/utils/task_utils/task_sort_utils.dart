import 'package:uptodo/models/task/task_dto.dart';

enum TaskSortType {
  priority,
  date,
  name,
}

class TaskSortUtils {
  Future<List<TaskDTO>> sortTasks(List<TaskDTO> tasks, TaskSortType sortType) {
    switch (sortType) {
      case TaskSortType.priority:
        return sortTasksByPriority(tasks);
      case TaskSortType.date:
        return sortTasksByDate(tasks);
      case TaskSortType.name:
        return sortTasksByName(tasks);
    }
  }

  Future<List<TaskDTO>> sortTasksByPriority(List<TaskDTO> tasks) async {
    final sortedTasks = List<TaskDTO>.from(tasks);
    sortedTasks.sort((a, b) {
      final priorityA = int.tryParse(a.priority) ?? 0;
      final priorityB = int.tryParse(b.priority) ?? 0;
      return priorityA.compareTo(priorityB);
    });
    return sortedTasks;
  }

  Future<List<TaskDTO>> sortTasksByDate(List<TaskDTO> tasks) async {
    final sortedTasks = List<TaskDTO>.from(tasks);
    sortedTasks.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    return sortedTasks;
  }

  Future<List<TaskDTO>> sortTasksByName(List<TaskDTO> tasks) async {
    final sortedTasks = List<TaskDTO>.from(tasks);
    sortedTasks.sort((a, b) {
      return a.name.compareTo(b.name);
    });
    return sortedTasks;
  }
}
