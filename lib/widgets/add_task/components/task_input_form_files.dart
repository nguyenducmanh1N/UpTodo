import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/task_repository.dart';
import 'package:uptodo/services/task_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/validator/text_input_validator.dart';
import 'package:uptodo/widgets/auth/components/custom_text_field.dart';

class TaskInputFormFiles extends StatefulWidget {
  final String? categoryId;
  final TaskDTO? task;
  final Function(String, String)? onFormChanged;
  const TaskInputFormFiles({
    super.key,
    this.categoryId,
    this.task,
    this.onFormChanged,
  });

  @override
  State<TaskInputFormFiles> createState() => _TaskInputFormFilesState();
}

class _TaskInputFormFilesState extends State<TaskInputFormFiles> {
  String description = '';
  String name = '';
  String? _nameError;
  String? _descriptionError;
  late final AuthProvider authProvider;
  final TaskRepository _taskRepository = TaskRepository(TaskService());

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (widget.task != null) {
      name = widget.task!.name;
      description = widget.task!.description!;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(TaskInputFormFiles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNameChanged(name);
      });
    }
  }

  void _onNameChanged(String value) async {
    final trimmedValue = value.trim();

    setState(() {
      if (trimmedValue.isEmpty) {
        _nameError = TextInput.dirty(value).error?.errorMessage;
        name = '';
        return;
      }
      name = trimmedValue;
      _nameError = null;
    });

    if (widget.categoryId != null && trimmedValue.isNotEmpty) {
      final userId = authProvider.currentUser?.id ?? '';
      final exists = await _taskRepository.checkTaskNameExistsInCategory(userId, widget.categoryId!, trimmedValue);
      if (mounted) {
        setState(() {
          if (exists == true) {
            _nameError = 'task name already exists in this category';
          }
        });
      }
    }
    widget.onFormChanged?.call(name, description);
  }

  void _onDescriptionChanged(String value) {
    setState(() {
      description = value.trim();
      _descriptionError = TextInput.dirty(value).error?.errorMessage;
    });
    widget.onFormChanged?.call(name, description);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}
