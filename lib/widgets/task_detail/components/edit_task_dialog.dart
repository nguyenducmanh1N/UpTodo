import 'package:flutter/material.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/widgets/add_task/components/task_input_form_files.dart';

class EditTaskDialog extends StatefulWidget {
  final TaskDTO? task;
  final String? categoryId;
  const EditTaskDialog({super.key, this.task, this.categoryId});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  String? _taskName;
  String? _taskDescription;

  @override
  void initState() {
    super.initState();
    _taskName = widget.task?.name;
    _taskDescription = widget.task?.description;
  }

  void _handleSave() {
    Navigator.of(context).pop({
      'name': _taskName?.trim(),
      'description': _taskDescription?.trim(),
    });
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.upToDoBgPrimary,
      insetPadding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          decoration: BoxDecoration(
            color: AppColor.upToDoBgPrimary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Edit Task title',
                style: TextStyle(
                  color: AppColor.upToDoWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              TaskInputFormFiles(
                task: widget.task,
                categoryId: widget.categoryId,
                onFormChanged: (name, description) {
                  setState(() {
                    _taskName = name;
                    _taskDescription = description;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        _handleCancel();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColor.upToDoPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _handleSave();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.upToDoPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColor.upToDoWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
