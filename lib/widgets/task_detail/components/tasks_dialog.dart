import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/repositories/task_repository.dart';
import 'package:uptodo/services/category_service.dart';
import 'package:uptodo/services/task_service.dart';
import 'package:uptodo/widgets/shared/components/task_list.dart';

class TasksDialog extends StatefulWidget {
  const TasksDialog({super.key});

  @override
  State<TasksDialog> createState() => _TasksDialogState();
}

class _TasksDialogState extends State<TasksDialog> {
  late final AuthProvider authProvider;
  final List<TaskDTO> _tasks = [];
  final TaskRepository _taskRepository = TaskRepository(TaskService());
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _fetchTasks(authProvider.currentUser?.id ?? '');
  }

  void _fetchTasks(String userId) {
    if (userId.isEmpty) return;
    _taskRepository.getTasks(userId).then((tasks) {
      setState(() {
        _tasks.clear();
        _tasks.addAll(tasks);
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch tasks: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: TaskList(
        tasks: _tasks,
        userId: authProvider.currentUser?.id ?? '',
        categoryRepository: _categoryRepository,
        onTaskCompleted: (String, TaskDTO) {},
      ),
    );
  }
}
