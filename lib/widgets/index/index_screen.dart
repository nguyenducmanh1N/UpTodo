import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/providers/task_provider.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/repositories/task_repository.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/utils/task_utils/task_filter_by_status_utils.dart';
import 'package:uptodo/utils/task_utils/task_filter_utils.dart';
import 'package:uptodo/utils/task_utils/sort_task_utils.dart';
import 'package:uptodo/widgets/shared/components/filter_dropdown.dart';
import 'package:uptodo/widgets/shared/header.dart';
import 'package:uptodo/widgets/shared/components/notification.dart';
import 'package:uptodo/widgets/shared/components/task_list.dart';
import 'package:uptodo/widgets/shared/empty_task_widget.dart';

class IndexScreen extends StatefulWidget {
  final String userId;
  final TaskRepository taskRepository;
  final CategoryRepository categoryRepository;

  const IndexScreen({
    super.key,
    required this.userId,
    required this.taskRepository,
    required this.categoryRepository,
  });

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final List<TaskDTO> _allTasks = [];
  final List<TaskDTO> _resultTasks = [];
  final List<TaskDTO> _filteredTasksByStatus = [];
  late String _userId;

  TaskFilter _selectedFilter = TaskFilter.all;
  TaskSortType _selectedSort = TaskSortType.priority;
  TaskStatus _selectedStatus = TaskStatus.completed;
  SortStatus _sortStatus = SortStatus.ascending;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _fetchTasks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<TaskProvider>(context, listen: false).loadTasks(_userId);
    _fetchTasks();
  }

  void _fetchTasks() {
    try {
      final tasks = Provider.of<TaskProvider>(context, listen: false).tasks;
      setState(() {
        _allTasks.clear();
        _allTasks.addAll(tasks);
        _filterTasks(_selectedFilter);
      });
    } catch (e) {
      TopNotification.showError(context, 'Error fetching tasks: $e');
    }
  }

  void _filterTasks(TaskFilter? filterValue) {
    final filteredTasks = TaskFilterUtils().filterTasks(_allTasks, filterValue);
    setState(() {
      _resultTasks.clear();
      _resultTasks.addAll(filteredTasks);
    });
    _sortTasks(_selectedSort, _sortStatus);
  }

  void _sortTasks(TaskSortType sortType, SortStatus sortStatus) {
    final sortedTasks = TaskSortUtils().sortTasks(_resultTasks, sortType, sortStatus);
    setState(() {
      _resultTasks.clear();
      _resultTasks.addAll(sortedTasks);
    });
    _filterByStatus(_selectedStatus);
  }

  void _filterByStatus(TaskStatus status) {
    final filteredTasks = TaskStatusUtils().filterTasksByStatus(_resultTasks, status);
    setState(() {
      _filteredTasksByStatus.clear();
      _filteredTasksByStatus.addAll(filteredTasks);
    });
  }

  void _onFilterChanged(TaskFilter? value) {
    setState(() {
      _selectedFilter = value!;
    });
    _filterTasks(value);
  }

  void _onStatusChanged(TaskStatus? value) {
    setState(() {
      _selectedStatus = value!;
    });
    _filterByStatus(_selectedStatus);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _resultTasks.clear();
      _resultTasks.addAll(
        _allTasks.where((task) => task.name.toLowerCase().contains(value.toLowerCase())),
      );
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

  Future<void> _updateTaskById(String taskId) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).updateTaskById(_userId, taskId);
    } catch (e) {
      TopNotification.showError(context, 'Error updating task: $e');
    }
  }

  Future<void> _deleteTaskById(String taskId) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).deleteTaskById(taskId);
    } catch (e) {
      TopNotification.showError(context, 'Error deleting task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = context.watch<TaskProvider>().tasks;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Header(
              onSortSelected: (type, status) {
                setState(() {
                  _selectedSort = type;
                  _sortStatus = status;
                });
                _sortTasks(_selectedSort, _sortStatus);
              },
            ),
            const SizedBox(height: 16),
            allTasks.isEmpty
                ? const EmptyTasksWidget()
                : Column(
                    children: [
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.upToDoBorder),
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.upToDoBgSecondary,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColor.upToDoBorder),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                onChanged: _onSearchChanged,
                                style: const TextStyle(color: AppColor.upToDoWhite),
                                cursorColor: AppColor.upToDoWhite,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search your task...',
                                  hintStyle: TextStyle(color: AppColor.upToDoWhite),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TaskFilterDropdown(
                            selectedValue: _selectedFilter,
                            onChanged: (value) => _onFilterChanged(value as TaskFilter?),
                            type: Type.filter,
                            items: [
                              TaskFilter.all,
                              TaskFilter.today,
                              TaskFilter.tomorrow,
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TaskList(
                        tasks: _resultTasks,
                        userId: _userId,
                        categoryRepository: widget.categoryRepository,
                        onTaskCompleted: (userId, task) => _setTaskCompleted(task),
                        onTaskUpdated: (taskId) => _updateTaskById(taskId),
                        onTaskDeleted: (taskId) => _deleteTaskById(taskId),
                        notificationText: "No tasks yet, add some tasks or enjoy your day!",
                      ),
                      const SizedBox(height: 16),
                      TaskFilterDropdown(
                          selectedValue: _selectedStatus,
                          onChanged: (value) => _onStatusChanged(value as TaskStatus?),
                          type: Type.status,
                          items: [
                            TaskStatus.completed,
                            TaskStatus.uncompleted,
                          ]),
                      const SizedBox(height: 16),
                      TaskList(
                        tasks: _filteredTasksByStatus,
                        userId: _userId,
                        categoryRepository: widget.categoryRepository,
                        onTaskCompleted: (userId, task) => _setTaskCompleted(task),
                        notificationText: _selectedStatus == TaskStatus.completed
                            ? "No completed tasks yet!"
                            : _selectedStatus == TaskStatus.uncompleted
                                ? "No not completed tasks yet!"
                                : "No tasks available for this status!",
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
