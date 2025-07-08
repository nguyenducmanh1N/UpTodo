import 'package:flutter/foundation.dart';
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
import 'package:uptodo/utils/task_utils/task_filter_by_status_utils.dart';
import 'package:uptodo/utils/task_utils/task_filter_utils.dart';
import 'package:uptodo/utils/task_utils/task_sort_utils.dart';
import 'package:uptodo/widgets/add_task/add_task_bottom_sheet.dart';
import 'package:uptodo/widgets/shared/components/custom_bottom_navigation_bar.dart';
import 'package:uptodo/widgets/shared/components/filter_dropdown.dart';
import 'package:uptodo/widgets/shared/components/header.dart';
import 'package:uptodo/widgets/shared/components/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  final List<TaskDTO> _resultTasks = [];
  final List<TaskDTO> _allTasks = [];
  final List<TaskDTO> _filteredTasksByStatus = [];
  late final AuthProvider authProvider;
  final TaskRepository _taskRepository = TaskRepository(TaskService());
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());
  int _currentIndex = 0;

  TaskFilter _selectedFilter = TaskFilter.all;
  TaskSortType _selectedSort = TaskSortType.priority;
  TaskStatus _selectedStatus = TaskStatus.completed;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _fetchTasks(authProvider.currentUser?.id ?? '');
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _fetchTasks(authProvider.currentUser?.id ?? '');
  }

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTaskBottomSheet(
        tasks: _resultTasks,
        onTaskAdded: () {
          _fetchTasks(authProvider.currentUser?.id ?? '');
        },
      ),
    );
  }

  void _fetchTasks(String userId) {
    if (userId.isEmpty) {
      return;
    }
    _taskRepository.getTasks(userId).then((tasks) {
      setState(() {
        _allTasks.clear();
        _allTasks.addAll(tasks);
        _applyFilter(_selectedFilter);
      });
    }).catchError((e) {
      throw Exception('Failed to load tasks: $e');
    });
  }

  Future<void> _applyFilter(TaskFilter? filterValue) async {
    final filteredTasks = await TaskFilterUtils().filterTasks(_allTasks, filterValue);
    final sortedTasks = await TaskSortUtils().sortTasksByPriority(filteredTasks);
    setState(() {
      _resultTasks.clear();
      _resultTasks.addAll(sortedTasks);
    });
    _filterByStatus(_selectedStatus);
  }

  Future<void> _sortTasks(TaskSortType sortValue) async {
    final sortedTasks = await TaskSortUtils().sortTasks(_resultTasks, sortValue);
    setState(() {
      _resultTasks.clear();
      _resultTasks.addAll(sortedTasks);
    });
  }

  Future<void> _filterByStatus(TaskStatus status) async {
    final filteredTasks = await TaskStatusUtils().filterTasksByStatus(_resultTasks, status);
    setState(() {
      _filteredTasksByStatus.clear();
      _filteredTasksByStatus.addAll(filteredTasks);
    });
  }

  void _onFilterChanged(TaskFilter? value) {
    setState(() {
      _selectedFilter = value!;
    });
    _applyFilter(value);
  }

  void _onSortChanged(TaskSortType? value) {
    setState(() {
      _selectedSort = value!;
    });
    _sortTasks(_selectedSort);
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

  void _setTaskCompleted(String userId, TaskDTO task) {
    final updatedTask = task.copyWith(isCompleted: !(task.isCompleted ?? false));
    _taskRepository.updateTask(userId, updatedTask).then((_) {
      _fetchTasks(authProvider.currentUser?.id ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.upToDoBlack,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header(),
                SizedBox(height: 16),
                _allTasks.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(image: AssetImage('assets/images/Checklist-rafiki_1.png')),
                            Text(
                              'What do you want to do today?',
                              style: AppTextStyles.displaySmall.copyWith(
                                color: AppColor.upToDoWhile,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Tap + to add your tasks",
                              style: AppTextStyles.displaySmall.copyWith(
                                color: AppColor.upToDoWhile,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          SearchBar(
                            hintText: 'Search tasks',
                            onChanged: _onSearchChanged,
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TaskFilterDropdown(
                                    type: Type.filter,
                                    selectedValue: _selectedFilter,
                                    onChanged: (value) => _onFilterChanged(value as TaskFilter?),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TaskFilterDropdown(
                                    type: Type.sort,
                                    selectedValue: _selectedSort,
                                    onChanged: (value) => _onSortChanged(value as TaskSortType?),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          if (_resultTasks.isEmpty)
                            Text(
                              'No tasks found',
                              style: AppTextStyles.displaySmall.copyWith(
                                color: AppColor.upToDoWhile,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          TaskList(
                            tasks: _resultTasks,
                            userId: authProvider.currentUser?.id ?? '',
                            categoryRepository: _categoryRepository,
                            onTaskCompleted: _setTaskCompleted,
                          ),
                          TaskFilterDropdown(
                              selectedValue: _selectedStatus,
                              onChanged: (value) => _onStatusChanged(value as TaskStatus?),
                              type: Type.status),
                          SizedBox(height: 16),
                          if (_resultTasks.isEmpty)
                            Text(
                              'No tasks found',
                              style: AppTextStyles.displaySmall.copyWith(
                                color: AppColor.upToDoWhile,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          TaskList(
                            tasks: _filteredTasksByStatus,
                            userId: authProvider.currentUser?.id ?? '',
                            categoryRepository: _categoryRepository,
                            onTaskCompleted: _setTaskCompleted,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: _onNavTapped,
        onAddButtonPressed: _onAddPressed,
      ),
    );
  }
}
