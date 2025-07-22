import 'package:uptodo/models/task/task_dto.dart';

enum TaskSortType {
  priority,
  date,
  name,
}

enum SortOrder {
  ascending,
  descending,
}

class TaskSortUtils {
  List<TaskDTO> sortTasks(List<TaskDTO> tasks, TaskSortType sortType, SortOrder? sortOrder) {
    switch (sortType) {
      case TaskSortType.priority:
        return sortTasksByPriority(tasks, sortOrder);
      case TaskSortType.date:
        return sortTasksByDate(tasks, sortOrder);
      case TaskSortType.name:
        return sortTasksByName(tasks, sortOrder);
    }
  }

  List<TaskDTO> sortTasksByPriority(List<TaskDTO> tasks, SortOrder? sortOrder) {
    if (tasks.isEmpty) return [];
    if (sortOrder == null) return List<TaskDTO>.from(tasks);

    final sortedTasks = List<TaskDTO>.from(tasks);
    sortedTasks.sort((a, b) {
      final priorityA = a?.priority ?? '';
      final priorityB = b?.priority ?? '';
      if (sortOrder == SortOrder.ascending) {
        return priorityA.compareTo(priorityB);
      } else {
        return priorityB.compareTo(priorityA);
      }
    });
    return sortedTasks;
  }

  List<TaskDTO> sortTasksByDate(List<TaskDTO> tasks, SortOrder? sortOrder) {
    if (tasks.isEmpty) return [];
    if (sortOrder == null) return List<TaskDTO>.from(tasks);

    final sortedTasks = List<TaskDTO>.from(tasks);
    sortedTasks.sort((a, b) {
      final dateA = a?.date?.toUtc() ?? DateTime.now();
      final dateB = b?.date?.toUtc() ?? DateTime.now();
      if (sortOrder == SortOrder.ascending) {
        return dateA.compareTo(dateB);
      } else {
        return dateB.compareTo(dateA);
      }
    });
    return sortedTasks;
  }

  List<TaskDTO> sortTasksByName(List<TaskDTO> tasks, SortOrder? sortOrder) {
    if (tasks.isEmpty) return [];
    if (sortOrder == null) return List<TaskDTO>.from(tasks);

    final sortedTasks = List<TaskDTO>.from(tasks);
    sortedTasks.sort((a, b) {
      final nameA = a?.name?.toLowerCase() ?? '';
      final nameB = b?.name?.toLowerCase() ?? '';
      if (sortOrder == SortOrder.ascending) {
        return nameA.compareTo(nameB);
      } else {
        return nameB.compareTo(nameA);
      }
    });
    return sortedTasks;
  }
}
