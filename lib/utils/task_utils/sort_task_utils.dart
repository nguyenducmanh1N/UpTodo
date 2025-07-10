import 'package:uptodo/models/task/task_dto.dart';

enum TaskSortType {
  priority,
  date,
  name,
}

enum SortStatus {
  ascending,
  descending,
}

class TaskSortUtils {
  Future<List<TaskDTO>> sortTasks(List<TaskDTO> tasks, TaskSortType sortType, SortStatus? sortStatus) async {
    switch (sortType) {
      case TaskSortType.priority:
        return sortTasksByPriority(tasks, sortStatus);
      case TaskSortType.date:
        return sortTasksByDate(tasks, sortStatus);
      case TaskSortType.name:
        return sortTasksByName(tasks, sortStatus);
    }
  }

  Future<List<TaskDTO>> sortTasksByPriority(List<TaskDTO> tasks, SortStatus? sortStatus) async {
    final sortedTasks = List<TaskDTO>.from(tasks);
    try {
      sortedTasks.sort((a, b) {
        if (sortStatus == SortStatus.ascending) {
          return a.priority.compareTo(b.priority);
        }
        return b.priority.compareTo(a.priority);
      });
      return sortedTasks;
    } catch (e) {
      return [];
    }
  }

  Future<List<TaskDTO>> sortTasksByDate(List<TaskDTO> tasks, SortStatus? sortStatus) async {
    final sortedTasks = List<TaskDTO>.from(tasks);
    try {
      sortedTasks.sort((a, b) {
        if (sortStatus == SortStatus.ascending) {
          return a.date.compareTo(b.date);
        }
        return b.date.compareTo(a.date);
      });
      return sortedTasks;
    } catch (e) {
      return [];
    }
  }

  Future<List<TaskDTO>> sortTasksByName(List<TaskDTO> tasks, SortStatus? sortStatus) async {
    final sortedTasks = List<TaskDTO>.from(tasks);
    try {
      sortedTasks.sort((a, b) {
        if (sortStatus == SortStatus.ascending) {
          return a.name.compareTo(b.name);
        }
        return b.name.compareTo(a.name);
      });
      return sortedTasks;
    } catch (e) {
      return [];
    }
  }
}
