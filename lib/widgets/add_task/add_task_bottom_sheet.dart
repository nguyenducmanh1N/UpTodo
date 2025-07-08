import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/task_repository.dart';
import 'package:uptodo/services/task_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/widgets/add_task/components/categories_dialog.dart';
import 'package:uptodo/widgets/add_task/components/date_dialog.dart';
import 'package:uptodo/widgets/add_task/components/priorities_dialog.dart';
import 'package:uptodo/widgets/add_task/components/task_input_form_files.dart';
import 'package:uuid/uuid.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final VoidCallback? onTaskAdded;
  final List<TaskDTO> tasks;
  const AddTaskBottomSheet({super.key, this.onTaskAdded, required this.tasks});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TaskRepository _taskRepository = TaskRepository(TaskService());
  late final AuthProvider authProvider;
  String _name = '';
  String _description = '';
  DateTime? _selectedDate;
  String? _selectedCategoryId;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  bool _validateFields() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date')),
      );
      return false;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
      return false;
    }

    if (_selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a priority')),
      );
      return false;
    }
    return true;
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _updateSelectedPriority(String priority) {
    setState(() {
      _selectedPriority = priority;
    });
  }

  void _updateSelectedCategoryId(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  void _handleSaveTask() async {
    if (!_validateFields()) {
      return;
    }

    final uuid = Uuid();
    final task = TaskDTO(
      id: uuid.v4(),
      name: _name,
      description: _description,
      date: _selectedDate!,
      categoryId: _selectedCategoryId!,
      priority: _selectedPriority!,
      isCompleted: false,
    );
    final userId = authProvider.currentUser?.id ?? '';

    try {
      await _taskRepository.saveTask(userId, task);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task saved successfully')),
      );
      Navigator.pop(context);
      widget.onTaskAdded?.call();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving task: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColor.upToDoBgSecondary,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskInputFormFiles(
                categoryId: _selectedCategoryId,
                onFormChanged: (name, description) {
                  setState(() {
                    _name = name;
                    _description = description;
                  });
                }),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showDateDialog(context),
                      child: SizedBox(
                        child: Image.asset('assets/images/timer_icon.png', width: 34, height: 34),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _showCategoriesDialog(context),
                      child: SizedBox(
                        child: Image.asset('assets/images/tag_icon.png', width: 34, height: 34),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _showPrioritiesDialog(context),
                      child: SizedBox(
                        child: Image.asset('assets/images/flag_icon.png', width: 34, height: 34),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _handleSaveTask,
                  child: SizedBox(
                    child: Image.asset('assets/images/send_icon.png', width: 34, height: 34),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDateDialog(BuildContext context) async {
    final dateResult = await showDialog<DateTime>(
      context: context,
      builder: (context) => DateDialog(),
    );
    if (dateResult != null) {
      _updateSelectedDate(dateResult);
    }
  }

  void _showPrioritiesDialog(BuildContext context) async {
    final priorityResult = await showDialog<String>(
      context: context,
      builder: (context) => PrioritiesDialog(),
    );
    if (priorityResult != null) {
      _updateSelectedPriority(priorityResult);
    }
  }

  void _showCategoriesDialog(BuildContext context) async {
    final categoryId = await showDialog<String>(
      context: context,
      builder: (context) => CategoriesDialog(),
    );
    if (categoryId != null) {
      _updateSelectedCategoryId(categoryId);
    }
  }
}
