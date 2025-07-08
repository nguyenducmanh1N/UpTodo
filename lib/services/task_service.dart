import 'package:shared_preferences/shared_preferences.dart';
import 'package:uptodo/constants/shared_preferences.dart';
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
      throw Exception('Failed to save task: $e');
    }
  }

  Future<void> updateTask(String userId, TaskDTO task) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final List<TaskDTO> tasks = await getTasks(userId);
      final int index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
        final String tasksJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
        await sharedPreferences.setString(_userTasksKey(userId), tasksJson);
      }
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<bool> checkTaskNameExistsInCategory(String userId, String categoryId, String taskName) async {
    try {
      final tasks = await getTasks(userId);
      return tasks.any(
          (task) => task.categoryId == categoryId && task.name.trim().toLowerCase() == taskName.trim().toLowerCase());
    } catch (e) {
      return false;
    }
  }
}
