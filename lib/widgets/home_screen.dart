import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/repositories/task_repository.dart';
import 'package:uptodo/services/category_service.dart';
import 'package:uptodo/services/task_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/widgets/add_task/add_task_bottom_sheet.dart';
import 'package:uptodo/widgets/index/index_screen.dart';
import 'package:uptodo/widgets/shared/components/custom_bottom_navigation_bar.dart';
import 'package:uptodo/widgets/calendar/calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeScreen> {
  late final AuthProvider authProvider;
  int _currentIndex = 0;
  late final List<Widget> _screens;
  DateTime? _calendarSelectedDate;

  final TaskRepository _taskRepository = TaskRepository(TaskService());
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _initScreens();
  }

  void _initScreens() {
    _screens = [
      IndexScreen(
        userId: authProvider.currentUser?.id ?? '',
        taskRepository: _taskRepository,
        categoryRepository: _categoryRepository,
      ),
      CalendarScreen(
        userId: authProvider.currentUser?.id ?? '',
        taskRepository: _taskRepository,
        categoryRepository: _categoryRepository,
        onDateSelected: (date) {
          setState(() {
            _calendarSelectedDate = date;
          });
        },
      ),
      Container(
          color: AppColor.upToDoBlack,
          child: const Center(child: Text('Focus Screen', style: TextStyle(color: AppColor.upToDoWhite)))),
      Container(
          color: AppColor.upToDoBlack,
          child: const Center(child: Text('Profile Screen', style: TextStyle(color: AppColor.upToDoWhite)))),
    ];
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
        tasks: [],
        initialDate: _currentIndex == 1 ? _calendarSelectedDate : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.upToDoBlack,
      body: SafeArea(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: _onNavTapped,
        onAddButtonPressed: _onAddBtnPressed,
      ),
    );
  }
}
