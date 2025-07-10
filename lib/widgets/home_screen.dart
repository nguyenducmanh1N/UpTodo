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
import 'package:uptodo/utils/task_utils/sort_task_utils.dart';
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
  final List<TaskDTO> _allTasks = [];
  final List<TaskDTO> _resultTasks = [];
  final List<TaskDTO> _filteredTasksByStatus = [];
  late final AuthProvider authProvider;
  int _currentIndex = 0;
  final TaskRepository _taskRepository = TaskRepository(TaskService());
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());

  TaskFilter _selectedFilter = TaskFilter.all;
  TaskSortType _selectedSort = TaskSortType.priority;
  TaskStatus _selectedStatus = TaskStatus.completed;
  SortStatus _sortStatus = SortStatus.ascending;

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

  void _onAddBtnPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTaskBottomSheet(
        tasks: _allTasks,
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
        _filterTasks(_selectedFilter);
      });
    }).catchError((e) {
      throw Exception('Failed to load tasks: $e');
    });
  }

  Future<void> _filterTasks(TaskFilter? filterValue) async {
    final filteredTasks = await TaskFilterUtils().filterTasks(_allTasks, filterValue);
    setState(() {
      _resultTasks.clear();
      _resultTasks.addAll(filteredTasks);
    });
    await _sortTasks(_selectedSort, _sortStatus);
  }

  Future<void> _sortTasks(TaskSortType sortType, SortStatus sortStatus) async {
    final sortedTasks = await TaskSortUtils().sortTasks(_resultTasks, sortType, sortStatus);
    setState(() {
      _resultTasks.clear();
      _resultTasks.addAll(sortedTasks);
    });

    _filterByStatus(_selectedStatus);
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
                SizedBox(height: 16),
                Header(
                  onSortSelected: (type, status) {
                    setState(() {
                      _selectedSort = type;
                      _sortStatus = status;
                    });
                    _sortTasks(_selectedSort, _sortStatus);
                  },
                ),
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
                                    style: const TextStyle(color: AppColor.upToDoWhile),
                                    cursorColor: AppColor.upToDoWhile,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search for your task...',
                                      hintStyle: TextStyle(color: AppColor.upToDoWhile),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
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
                          SizedBox(height: 16),
                          TaskList(
                            tasks: _resultTasks,
                            userId: authProvider.currentUser?.id ?? '',
                            categoryRepository: _categoryRepository,
                            onTaskCompleted: _setTaskCompleted,
                            text: "No tasks yet,add some tasks or enjoy your day!",
                          ),
                          SizedBox(height: 16),
                          TaskFilterDropdown(
                              selectedValue: _selectedStatus,
                              onChanged: (value) => _onStatusChanged(value as TaskStatus?),
                              type: Type.status),
                          SizedBox(height: 16),
                          TaskList(
                            tasks: _filteredTasksByStatus,
                            userId: authProvider.currentUser?.id ?? '',
                            categoryRepository: _categoryRepository,
                            onTaskCompleted: _setTaskCompleted,
                            text: _selectedStatus == TaskStatus.completed
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
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: _onNavTapped,
        onAddButtonPressed: _onAddBtnPressed,
      ),
    );
  }
}
