import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/repositories/task_repository.dart';
import 'package:uptodo/services/category_service.dart';
import 'package:uptodo/services/task_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/widgets/shared/components/notification.dart';
import 'package:uptodo/widgets/shared/components/task_list.dart';

class TasksDialog extends StatefulWidget {
  List<TaskDTO>? initialTasks = [];
  final String? currentTaskId;
  TasksDialog({super.key, this.initialTasks, this.currentTaskId});

  @override
  State<TasksDialog> createState() => _TasksDialogState();
}

class _TasksDialogState extends State<TasksDialog> {
  late final AuthProvider _authProvider;
  final List<TaskDTO> _allTasks = [];
  final List<TaskDTO> _resultTasks = [];
  final List<TaskDTO> _selectedTasks = [];

  final TaskRepository _taskRepository = TaskRepository(TaskService());
  final _categoryRepository = CategoryRepository(CategoryService());

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    _fetchTasks(_authProvider.currentUser?.id ?? '');
    if (widget.initialTasks != null && widget.initialTasks!.isNotEmpty) {
      _selectedTasks.addAll(widget.initialTasks!);
    }
  }

  Future<void> _fetchTasks(String userId) async {
    if (userId.isEmpty) return;
    try {
      final tasks = await _taskRepository.getTasks(userId);
      setState(() {
        _allTasks.clear();
        _allTasks.addAll(widget.currentTaskId != null ? tasks.where((task) => task.id != widget.currentTaskId) : tasks);
      });
      _onSearchChanged('');
    } catch (error) {
      TopNotification.showError(context, 'Error fetching tasks: $error');
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _resultTasks.clear();
      _resultTasks.addAll(
        _allTasks.where((task) => task.name.toLowerCase().contains(value.toLowerCase())),
      );
    });
  }

  void _onTaskSelected(TaskDTO task) {
    setState(() {
      if (_selectedTasks.contains(task)) {
        _selectedTasks.remove(task);
      } else {
        _selectedTasks.add(task);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.upToDoBlack,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: double.infinity,
        height: 600,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Add Sub - Task',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColor.upToDoWhite,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: Icon(Icons.search, color: AppColor.upToDoWhite),
                  filled: true,
                  fillColor: AppColor.upToDoBgPrimary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: AppColor.upToDoWhite.withOpacity(0.6)),
                ),
                style: TextStyle(color: AppColor.upToDoWhite),
                onChanged: (value) => _onSearchChanged(value),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _resultTasks.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks found',
                        style: TextStyle(
                          color: AppColor.upToDoWhite.withOpacity(0.6),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: TaskList(
                          tasks: _resultTasks,
                          onTaskSelected: _onTaskSelected,
                          userId: _authProvider.currentUser?.id ?? '',
                          categoryRepository: _categoryRepository,
                          onTaskCompleted: (taskId, task) {},
                          selectedTasks: _selectedTasks,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Close',
                      style: TextStyle(color: AppColor.upToDoPrimary),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(_selectedTasks),
                    child: Text(
                      'Save',
                      style: TextStyle(color: AppColor.upToDoPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
