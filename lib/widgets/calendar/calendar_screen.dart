import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/providers/task_provider.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/repositories/task_repository.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/task_utils/task_filter_utils.dart';
import 'package:uptodo/widgets/auth/components/custom_button.dart';
import 'package:uptodo/widgets/calendar/component/calendar_header.dart';
import 'package:uptodo/widgets/shared/components/notification.dart';
import 'package:uptodo/widgets/shared/components/task_list.dart';

class CalendarScreen extends StatefulWidget {
  final String userId;
  final TaskRepository taskRepository;
  final CategoryRepository categoryRepository;
  final void Function(DateTime)? onDateSelected;
  const CalendarScreen(
      {super.key,
      required this.taskRepository,
      required this.userId,
      required this.categoryRepository,
      this.onDateSelected});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  late List<DateTime> daysOfMonth;
  final List<TaskDTO> tasks = [];
  late final String _userId;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _generateDaysOfMonth();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDate());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<TaskProvider>(context, listen: false).loadTasks(_userId);
    _fetchTasksByDate();
  }

  void _scrollToSelectedDate() {
    final index = daysOfMonth
        .indexWhere((d) => d.year == selectedDate.year && d.month == selectedDate.month && d.day == selectedDate.day);
    if (index != -1 && _scrollController.hasClients) {
      final itemWidth = 56.0 + 12.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
      _scrollController.animateTo(
        offset.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _generateDaysOfMonth() {
    final daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    daysOfMonth = List.generate(
      daysInMonth,
      (index) => DateTime(selectedDate.year, selectedDate.month, index + 1),
    );
  }

  void _fetchTasksByDate() {
    try {
      final allTasks = Provider.of<TaskProvider>(context, listen: false).tasks;
      final filteredTasks = allTasks.where((task) {
        return task.date.year == selectedDate.year &&
            task.date.month == selectedDate.month &&
            task.date.day == selectedDate.day;
      }).toList();
      setState(() {
        tasks.clear();
        tasks.addAll(filteredTasks);
      });
    } catch (error) {
      TopNotification.showError(context, 'Error fetching tasks: $error');
    }
  }

  void _fetchCompletedTasks() {
    final completedTasks = TaskFilterUtils().filterTasksByStatus(
      tasks,
      TaskStatus.completed,
    );
    setState(() {
      tasks.clear();
      tasks.addAll(completedTasks);
    });
  }

  void _changeMonth(int delta) {
    final newMonth = DateTime(
      selectedDate.year,
      selectedDate.month + delta,
      1,
    );
    setState(() {
      selectedDate = DateTime(
        newMonth.year,
        newMonth.month,
        selectedDate.day.clamp(1, DateTime(newMonth.year, newMonth.month + 1, 0).day),
      );
      _generateDaysOfMonth();
    });
  }

  void _setTaskCompleted(TaskDTO task) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).setTaskCompleted(_userId, task);
      TopNotification.showSuccess(
        context,
        (task.isCompleted == false) ? 'Task marked as completed' : 'Task marked as uncompleted',
      );
    } catch (e) {
      TopNotification.showError(context, 'Error updating task: $e');
    }
  }

  void _updateTaskById(String taskId) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).updateTaskById(_userId, taskId);
    } catch (e) {
      TopNotification.showError(context, 'Error updating task: $e');
    }
  }

  void _deleteTaskById(String taskId) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).deleteTaskById(taskId);
    } catch (e) {
      TopNotification.showError(context, 'Error deleting task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.upToDoBlack,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.upToDoBlack,
        centerTitle: true,
        title: Text(
          'Calendar',
          style: AppTextStyles.displayLarge.copyWith(
            color: AppColor.upToDoWhite,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CalendarHeader(
              selectedDate: selectedDate,
              daysOfMonth: daysOfMonth,
              scrollController: _scrollController,
              onMonthChange: (delta) {
                _changeMonth(delta);
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDate());
              },
              onDateSelected: (date) {
                setState(() => selectedDate = date);
                _fetchTasksByDate();
                if (widget.onDateSelected != null) widget.onDateSelected!(date);
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.upToDoBgSecondary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Today',
                      onPressed: () {
                        setState(() {
                          selectedDate = DateTime.now();
                          _generateDaysOfMonth();
                          _fetchTasksByDate();
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDate());
                      },
                      isEnabled: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      label: 'Completed',
                      onPressed: _fetchCompletedTasks,
                      isEnabled: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
                padding: const EdgeInsets.all(16),
                child: TaskList(
                  tasks: tasks,
                  userId: _userId,
                  categoryRepository: widget.categoryRepository,
                  onTaskCompleted: (userId, task) => _setTaskCompleted(task),
                  onTaskDeleted: _deleteTaskById,
                  onTaskUpdated: _updateTaskById,
                )),
          ],
        ),
      ),
    );
  }
}
