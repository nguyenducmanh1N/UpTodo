import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/category/category_dto.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/repositories/task_repository.dart';
import 'package:uptodo/services/category_service.dart';
import 'package:uptodo/services/task_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/utils/color_utils.dart';
import 'package:uptodo/utils/format_time_utils.dart';
import 'package:uptodo/widgets/add_task/components/categories_dialog.dart';
import 'package:uptodo/widgets/add_task/components/date_dialog.dart';
import 'package:uptodo/widgets/add_task/components/priorities_dialog.dart';
import 'package:uptodo/widgets/auth/components/custom_button.dart';
import 'package:uptodo/widgets/shared/components/notification.dart';
import 'package:uptodo/widgets/shared/components/task_list.dart';
import 'package:uptodo/widgets/task_detail/components/edit_task_dialog.dart';
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
  late TaskDTO _currentTask;
  late final AuthProvider authProvider;
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());
  final TaskRepository _taskRepository = TaskRepository(TaskService());
  CategoryDTO? _currentCategory;
  List<TaskDTO> _subTasks = [];
  String? _taskName;
  String? _taskDescription;
  String? _taskCategoryId;
  String? _taskPriority;
  DateTime? _taskDateTime;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _currentTask = widget.task;
    _initializeFields();
    _loadCategory();
  }

  void _initializeFields() {
    try {
      _taskName = _currentTask.name;
      _taskDescription = _currentTask.description;
      _taskCategoryId = _currentTask.categoryId;
      _taskPriority = _currentTask.priority;
      _taskDateTime = _currentTask.date;
      _subTasks = _currentTask.subtask;
    } catch (e) {
      throw Exception('Failed to initialize fields: $e');
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        onDeleteConfirmed: () async {
          await _handleDeleteTask();
        },
      ),
    );
  }

  void _toggleTaskCompletion() {
    setState(() {
      _currentTask = TaskDTO(
        id: _currentTask.id,
        name: _currentTask.name,
        description: _currentTask.description,
        date: _currentTask.date,
        categoryId: _currentTask.categoryId,
        priority: _currentTask.priority,
        isCompleted: !(_currentTask.isCompleted ?? false),
      );
    });
    widget.onTaskUpdated?.call();
  }

  Future<void> _loadCategory() async {
    try {
      final userId = authProvider.currentUser?.id ?? '';
      if (userId.isNotEmpty && _currentTask.categoryId.isNotEmpty) {
        final category = await _categoryRepository.getCategoryById(userId, _taskCategoryId!);
        setState(() {
          _currentCategory = category;
        });
      }
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }

  Future<void> _handleUpdateTask() async {
    try {
      final updatedTask = _currentTask.copyWith(
          name: _taskName ?? '',
          description: _taskDescription,
          categoryId: _taskCategoryId ?? '',
          priority: _taskPriority ?? 'Default',
          date: _taskDateTime ?? DateTime.now(),
          subtask: _subTasks);
      await _taskRepository.updateTask(authProvider.currentUser?.id ?? '', updatedTask);
      widget.onTaskUpdated?.call();
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> _handleDeleteTask() async {
    try {
      await _taskRepository.deleteTaskById(authProvider.currentUser?.id ?? '', _currentTask.id);
      widget.onTaskDeleted?.call();
      Navigator.pop(context);
      TopNotification.showSuccess(
        context,
        'Task deleted successfully',
      );
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  void _onTaskSelected(TaskDTO task) {}

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
                    icon: Icon(Icons.close, color: AppColor.upToDoWhite, size: 24),
                  ),
                  IconButton(
                    onPressed: _toggleTaskCompletion,
                    icon: Icon(
                      (_currentTask.isCompleted ?? false) ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: (_currentTask.isCompleted ?? false) ? AppColor.green : AppColor.upToDoWhite,
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
                      border: Border.all(color: AppColor.upToDoWhite, width: 2),
                    ),
                    child:
                        (_currentTask.isCompleted ?? false) ? Icon(Icons.check, color: AppColor.green, size: 16) : null,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _taskName ?? '',
                          style: AppTextStyles.displayLarge.copyWith(
                            color: AppColor.upToDoWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            decoration:
                                (_currentTask.isCompleted ?? false) ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _taskDescription ?? '',
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColor.upToDoWhite.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _showTaskInputFormFiles,
                    icon: Icon(Icons.edit, color: AppColor.upToDoWhite, size: 20),
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
                value: _currentCategory?.name ?? '',
                categoryImgUrl: _currentCategory?.img,
                backgroundColor: ColorUtils.getColorFromKey(_currentCategory?.color ?? 'yellow'),
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
                onTap: _showSubTaskPicker,
              ),
              const SizedBox(height: 16),
              if (_subTasks.isNotEmpty)
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppColor.upToDoBgPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: TaskList(
                      tasks: _subTasks,
                      onTaskSelected: _onTaskSelected,
                      userId: authProvider.currentUser?.id ?? '',
                      categoryRepository: _categoryRepository,
                      onTaskCompleted: (taskId, task) {},
                    ),
                  ),
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
              CustomButton(
                isEnabled: true,
                onPressed: () async {
                  await _handleUpdateTask();
                  Navigator.pop(context);
                },
                label: 'Update Task ',
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
        Icon(icon, color: AppColor.upToDoWhite, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColor.upToDoWhite,
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
                    color: AppColor.upToDoWhite,
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
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) => EditTaskDialog(
        task: _currentTask,
        categoryId: _taskCategoryId,
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
      builder: (context) => DateDialog(
        initialDate: _taskDateTime,
      ),
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
      builder: (context) => CategoriesDialog(
        initialCategoryId: _taskCategoryId,
      ),
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
      builder: (context) => PrioritiesDialog(
        initialPriority: _taskPriority,
      ),
    );
    if (selectedPriority != null && selectedPriority != _taskPriority) {
      setState(() {
        _taskPriority = selectedPriority;
      });
    }
  }

  Future<void> _showSubTaskPicker() async {
    final selectedSubTasks = await showDialog<List<TaskDTO>>(
      context: context,
      builder: (context) => TasksDialog(
        initialTasks: _subTasks,
        currentTaskId: _currentTask.id,
      ),
    );

    if (selectedSubTasks != null && selectedSubTasks.isNotEmpty) {
      setState(() {
        _subTasks = selectedSubTasks;
      });
      widget.onTaskUpdated?.call();
    }
  }
}
