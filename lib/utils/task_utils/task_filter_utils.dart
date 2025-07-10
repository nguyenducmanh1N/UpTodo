import 'package:uptodo/models/task/task_dto.dart';

enum TaskFilter {
  all,
  today,
  tomorrow,
}

class TaskFilterUtils {
  List<TaskDTO> filterTasks(List<TaskDTO> allTasks, TaskFilter? filterValue) {
    if (filterValue == null || filterValue == TaskFilter.all) {
      return allTasks;
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

  List<TaskDTO> _filterTodayTasks(List<TaskDTO> tasks) {
    try {
      final today = DateTime.now();
      return tasks.where((task) {
        final taskDate = task.date;
        return taskDate.year == today.year && taskDate.month == today.month && taskDate.day == today.day;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  List<TaskDTO> _filterTomorrowTasks(List<TaskDTO> tasks) {
    try {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      return tasks.where((task) {
        final taskDate = task.date;
        return taskDate.year == tomorrow.year && taskDate.month == tomorrow.month && taskDate.day == tomorrow.day;
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
