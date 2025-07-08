import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/category/category_dto.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/services/category_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/utils/color_utils.dart';
import 'package:uptodo/utils/format_time_utils.dart';
import 'package:uptodo/widgets/add_task/components/categories_dialog.dart';
import 'package:uptodo/widgets/add_task/components/date_dialog.dart';
import 'package:uptodo/widgets/add_task/components/priorities_dialog.dart';
import 'package:uptodo/widgets/add_task/components/task_input_form_files.dart';
import 'package:uptodo/widgets/task_detail/components/tasks_dialog.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskDTO task;
  final VoidCallback? onTaskUpdated;
  final VoidCallback? onTaskDeleted;

  const TaskDetailScreen({
    super.key,
    required this.task,
    this.onTaskUpdated,
    this.onTaskDeleted,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TaskDTO currentTask;
  late final AuthProvider authProvider;
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());
  CategoryDTO? currentCategory;

  String? _taskName;
  String? _taskDescription;
  String? _taskCategoryId;
  String? _taskPriority;
  DateTime? _taskDateTime;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    currentTask = widget.task;
    _initializeFields();
    _loadCategory();
  }

  void _initializeFields() {
    try {
      _taskName = currentTask.name;
      _taskDescription = currentTask.description;
      _taskCategoryId = currentTask.categoryId;
      _taskPriority = currentTask.priority;
      _taskDateTime = currentTask.date;
    } catch (e) {
      throw Exception('Failed to initialize fields: $e');
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.upToDoBgSecondary,
        title: Text(
          'Delete Task',
          style: AppTextStyles.displayMedium.copyWith(color: AppColor.upToDoWhile),
        ),
        content: Text(
          'Are you sure you want to delete this task?',
          style: AppTextStyles.displaySmall.copyWith(color: AppColor.upToDoWhile),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.displaySmall.copyWith(color: AppColor.upToDoKeyPrimary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              widget.onTaskDeleted?.call();
            },
            child: Text(
              'Delete',
              style: AppTextStyles.displaySmall.copyWith(color: AppColor.red),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTaskCompletion() {
    setState(() {
      currentTask = TaskDTO(
        id: currentTask.id,
        name: currentTask.name,
        description: currentTask.description,
        date: currentTask.date,
        categoryId: currentTask.categoryId,
        priority: currentTask.priority,
        isCompleted: !(currentTask.isCompleted ?? false),
      );
    });
    widget.onTaskUpdated?.call();
  }

  Future<void> _loadCategory() async {
    try {
      final userId = authProvider.currentUser?.id ?? '';
      if (userId.isNotEmpty && currentTask.categoryId.isNotEmpty) {
        final category = await _categoryRepository.getCategoryById(userId, _taskCategoryId!);
        setState(() {
          currentCategory = category;
        });
      }
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.upToDoBgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColor.upToDoWhile, size: 24),
                  ),
                  IconButton(
                    onPressed: _toggleTaskCompletion,
                    icon: Icon(
                      (currentTask.isCompleted ?? false) ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: (currentTask.isCompleted ?? false) ? AppColor.green : AppColor.upToDoWhile,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 12, top: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.upToDoWhile, width: 2),
                    ),
                    child:
                        (currentTask.isCompleted ?? false) ? Icon(Icons.check, color: AppColor.green, size: 16) : null,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _taskName ?? '',
                          style: AppTextStyles.displayLarge.copyWith(
                            color: AppColor.upToDoWhile,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            decoration:
                                (currentTask.isCompleted ?? false) ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _taskDescription ?? '',
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColor.upToDoWhile.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _showTaskInputFormFiles,
                    icon: Icon(Icons.edit, color: AppColor.upToDoWhile, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildDetailRow(
                icon: Icons.access_time,
                label: 'Task Time :',
                value: FormatTimeUtils.formatTaskTime(_taskDateTime!),
                backgroundColor: AppColor.upToDoBgSecondary,
                onTap: _showDateTimePicker,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.local_offer,
                label: 'Task Category :',
                value: currentCategory?.name ?? '',
                categoryImgUrl: currentCategory?.img,
                backgroundColor: ColorUtils.getColorFromKey(currentCategory?.color ?? 'yellow'),
                onTap: _showCategoryPicker,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.flag,
                label: 'Task Priority :',
                value: _taskPriority ?? 'Default',
                backgroundColor: AppColor.upToDoBgSecondary,
                onTap: _showPriorityPicker,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.account_tree,
                label: 'Sub - Task',
                value: 'Add Sub - Task',
                backgroundColor: AppColor.upToDoBgSecondary,
                onTap: () {},
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _showDeleteConfirmation,
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppColor.red, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Delete Task',
                      style: AppTextStyles.displaySmall.copyWith(
                        color: AppColor.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.upToDoPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    'Edit Task',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColor.upToDoWhile,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color backgroundColor,
    VoidCallback? onTap,
    String? categoryImgUrl,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColor.upToDoWhile, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColor.upToDoWhile,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                if (categoryImgUrl != null && categoryImgUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      categoryImgUrl,
                      width: 15,
                      height: 15,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/image_not_found.png',
                          width: 15,
                          height: 15,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                Text(
                  value,
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColor.upToDoWhile,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showTaskInputFormFiles() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      builder: (context) => SingleChildScrollView(
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
          child: TaskInputFormFiles(
            categoryId: _taskCategoryId,
            task: currentTask,
            onFormChanged: (name, description) {
              setState(() {
                _taskName = name;
                _taskDescription = description;
              });
            },
          ),
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _taskName = result['name'];
        _taskDescription = result['description'];
      });
      widget.onTaskUpdated?.call();
    }
  }

  Future<void> _showDateTimePicker() async {
    final selectedDateTime = await showDialog<DateTime>(
      context: context,
      builder: (context) => const DateDialog(),
    );

    if (selectedDateTime != null && selectedDateTime != _taskDateTime) {
      setState(() {
        _taskDateTime = selectedDateTime;
      });
    }
  }

  Future<void> _showCategoryPicker() async {
    final selectedCategoryId = await showDialog<String>(
      context: context,
      builder: (context) => const CategoriesDialog(),
    );

    if (selectedCategoryId != null && selectedCategoryId != _taskCategoryId) {
      setState(() {
        _taskCategoryId = selectedCategoryId;
      });
    }
  }

  Future<void> _showPriorityPicker() async {
    final selectedPriority = await showDialog<String>(
      context: context,
      builder: (context) => const PrioritiesDialog(),
    );
    if (selectedPriority != null && selectedPriority != _taskPriority) {
      setState(() {
        _taskPriority = selectedPriority;
      });
    }
  }

  Future<void> _showSubTaskPicker() async {
    final subTasks = await showDialog<List<TaskDTO>>(
      context: context,
      builder: (context) => const TasksDialog(),
    );

    if (subTasks != null && subTasks.isNotEmpty) {
      setState(() {
        currentTask = currentTask.copyWith(subtask: subTasks);
      });
      widget.onTaskUpdated?.call();
    }
  }
}
