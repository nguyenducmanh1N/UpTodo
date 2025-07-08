import 'package:uptodo/models/task/task_dto.dart';

enum TaskFilter {
  all,
  today,
  tomorrow,
}

enum TaskStatus {
  completed,
  uncompleted,
}

class TaskFilterUtils {
  List<TaskDTO> filterTasks(List<TaskDTO> allTasks, TaskFilter? filterValue) {
    if (filterValue == null) {
      return allTasks;
    }
    if (allTasks.isEmpty) {
      return [];
    }
    switch (filterValue) {
      case TaskFilter.today:
        return _filterTodayTasks(allTasks);
      case TaskFilter.tomorrow:
        return _filterTomorrowTasks(allTasks);
      default:
        return allTasks;
    }
  }

  List<TaskDTO> filterTasksByStatus(List<TaskDTO> tasks, TaskStatus? status) {
    if (tasks.isEmpty) {
      return [];
    }
    if (status == null) {
      return tasks;
    }
    switch (status) {
      case TaskStatus.completed:
        return filterCompletedTask(tasks);
      case TaskStatus.uncompleted:
        return filterUncompletedTask(tasks);
    }
  }

  List<TaskDTO> _filterTodayTasks(List<TaskDTO> tasks) {
    final today = DateTime.now();
    return tasks.where((task) {
      final taskDate = task.date;
      return taskDate.year == today.year && taskDate.month == today.month && taskDate.day == today.day;
    }).toList();
  }

  List<TaskDTO> _filterTomorrowTasks(List<TaskDTO> tasks) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tasks.where((task) {
      final taskDate = task.date;
      return taskDate.year == tomorrow.year && taskDate.month == tomorrow.month && taskDate.day == tomorrow.day;
    }).toList();
  }

  List<TaskDTO> filterCompletedTask(List<TaskDTO> tasks) {
    return tasks.where((task) => task.isCompleted == true).toList();
  }

  List<TaskDTO> filterUncompletedTask(List<TaskDTO> tasks) {
    return tasks.where((task) => task.isCompleted == false).toList();
  }
}
