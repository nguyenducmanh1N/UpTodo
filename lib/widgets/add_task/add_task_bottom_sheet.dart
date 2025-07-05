import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/task_repository.dart';
import 'package:uptodo/services/task_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/widgets/add_task/components/categories_dialog.dart';
import 'package:uptodo/widgets/add_task/components/date_dialog.dart';
import 'package:uptodo/widgets/add_task/components/priorities_dialog.dart';
import 'package:uptodo/widgets/auth/components/custom_text_field.dart';
import 'package:uuid/uuid.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final VoidCallback? onTaskAdded;
  const AddTaskBottomSheet({super.key, this.onTaskAdded});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TaskRepository _taskRepository = TaskRepository(TaskService());
  late final AuthProvider authProvider;
  String description = '';
  String name = '';
  String? _nameError;
  String? _descriptionError;
  DateTime? selectedDate;
  String? selectedCategory;
  String? selectedPriority;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  void _onNameChanged(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _nameError = 'Task name cannot be empty';
        return;
      }
      _nameError = null;
      name = value;
    });
  }

  void _onDescriptionChanged(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _descriptionError = 'Task description cannot be empty';
        return;
      }
      _descriptionError = null;
      description = value;
    });
  }

  bool _validateFields() {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date')),
      );
      return false;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
      return false;
    }

    if (selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a priority')),
      );
      return false;
    }
    return true;
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _updateSelectedPriority(String priority) {
    setState(() {
      selectedPriority = priority;
    });
  }

  void _updateSelectedCategory(String categoryId) {
    setState(() {
      selectedCategory = categoryId;
    });
  }

  void _handleSaveTask() async {
    if (!_validateFields()) {
      return;
    }

    final uuid = Uuid();
    final task = TaskDTO(
      id: uuid.v4(),
      name: name,
      description: description,
      date: selectedDate!,
      categoryId: selectedCategory!,
      priority: selectedPriority!,
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
            Text(
              "Add Task",
              style: AppTextStyles.displayLarge.copyWith(
                color: AppColor.upToDoWhile,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Task Name",
              style: AppTextStyles.displaySmall.copyWith(
                color: AppColor.upToDoKeyPrimary,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              onChanged: _onNameChanged,
              hintText: "Task name",
              obscureText: false,
              errorText: _nameError,
            ),
            const SizedBox(height: 16),
            Text(
              "Task Description",
              style: AppTextStyles.displaySmall.copyWith(
                color: AppColor.upToDoKeyPrimary,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              onChanged: _onDescriptionChanged,
              hintText: "Task description",
              obscureText: false,
              errorText: _descriptionError,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showDateDialog(context),
                      child: SizedBox(
                        child: Image(image: AssetImage('assets/images/timer_icon.png'), width: 34, height: 34),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _showCategoriesDialog(context),
                      child: SizedBox(
                        child: Image(image: AssetImage('assets/images/tag_icon.png'), width: 34, height: 34),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _showPrioritiesDialog(context),
                      child: SizedBox(
                        child: Image(image: AssetImage('assets/images/flag_icon.png'), width: 34, height: 34),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _handleSaveTask,
                  child: SizedBox(
                    child: Image(image: AssetImage('assets/images/send_icon.png'), width: 34, height: 34),
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
      _updateSelectedCategory(categoryId);
    }
  }
}
