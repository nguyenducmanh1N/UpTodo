import 'package:shared_preferences/shared_preferences.dart';
import 'package:uptodo/constants/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'dart:convert';

class TaskService {
  final String key = SharedPreferencesKeys.tasksKey;
  String _userTasksKey(String userId) => '${key}_$userId';

  Future<List<TaskDTO>> getTasks(String userId) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final String? tasksJson = sharedPreferences.getString(_userTasksKey(userId));
      if (tasksJson == null || tasksJson.isEmpty) {
        return [];
      }
      final List<dynamic> decoded = jsonDecode(tasksJson);
      return decoded.map((e) => TaskDTO.fromJson(e)).toList();
    } catch (e) {
      print('Error retrieving tasks: $e');
      return [];
    }
  }

  Future<void> saveTask(String userId, TaskDTO task) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final List<TaskDTO> tasks = await getTasks(userId);
      tasks.add(task);
      final String tasksJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
      await sharedPreferences.setString(_userTasksKey(userId), tasksJson);
    } catch (e) {
      print('Error saving task: $e');
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final List<TaskDTO> tasks = await getTasks(userId);
      tasks.removeWhere((task) => task.id == taskId);
      final String tasksJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
      await sharedPreferences.setString(_userTasksKey(userId), tasksJson);
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> updateTask(String userId, TaskDTO oldTask, TaskDTO newTask) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final List<TaskDTO> tasks = await getTasks(userId);
      final int index = tasks.indexWhere((t) => t.id == oldTask.id);
      if (index != -1) {
        tasks[index] = newTask;
        final String tasksJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
        await sharedPreferences.setString(_userTasksKey(userId), tasksJson);
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<TaskDTO?> getTaskById(String userId, String taskId) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final String? tasksJson = sharedPreferences.getString(_userTasksKey(userId));
      if (tasksJson == null || tasksJson.isEmpty) {
        return null;
      }
      final List<dynamic> decoded = jsonDecode(tasksJson);
      final List<TaskDTO> tasks = decoded.map((e) => TaskDTO.fromJson(e)).toList();
      return tasks.firstWhereOrNull((task) => task.id == taskId);
    } catch (e) {
      print('Error retrieving task by ID: $e');
      return null;
    }
  }

  Future<void> clearTasks(String userId) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.remove(_userTasksKey(userId));
    } catch (e) {
      print('Error clearing tasks: $e');
    }
  }

  Future<List<TaskDTO>> getTaskByDate(String userId, DateTime date) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final String? tasksJson = sharedPreferences.getString(_userTasksKey(userId));
      if (tasksJson == null || tasksJson.isEmpty) {
        return [];
      }
      final List<dynamic> decoded = jsonDecode(tasksJson);
      final List<TaskDTO> tasks = decoded.map((e) => TaskDTO.fromJson(e)).toList();
      return _filterTasksByDate(tasks, date);
    } catch (e) {
      print('Error retrieving tasks by date: $e');
      return [];
    }
  }

  List<TaskDTO> _filterTasksByDate(List<TaskDTO> tasks, DateTime date) {
    return tasks.where((task) {
      final taskDate = task.date;
      return taskDate.year == date.year && taskDate.month == date.month && taskDate.day == date.day;
    }).toList();
  }
}
