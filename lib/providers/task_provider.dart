import 'package:flutter/material.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;
  List<TaskDTO> tasks = [];

  TaskProvider(this._repository);

  Future<void> loadTasks(String userId) async {
    tasks = await _repository.getTasks(userId);
    notifyListeners();
  }

  Future<void> addTask(String userId, TaskDTO task) async {
    await _repository.saveTask(userId, task);
    tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(String userId, TaskDTO updatedTask) async {
    await _repository.updateTask(userId, updatedTask);
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> setTaskCompleted(String userId, TaskDTO task) async {
    final updatedTask = task.copyWith(isCompleted: !(task.isCompleted ?? false));
    await updateTask(userId, updatedTask);
  }

  Future<void> updateTaskById(String userId, String taskId) async {
    final updatedTask = await _repository.getTaskById(userId, taskId);
    if (updatedTask == null) return;
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> deleteTaskById(String taskId) async {
    tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}
