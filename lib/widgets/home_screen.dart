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
import 'package:uptodo/widgets/add_task/add_task_bottom_sheet.dart';
import 'package:uptodo/widgets/shared/components/custom_bottom_navigation_bar.dart';
import 'package:uptodo/widgets/shared/components/header.dart';
import 'package:uptodo/widgets/shared/components/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  final List<TaskDTO> _items = [];
  late final AuthProvider authProvider;
  final TaskRepository _taskRepository = TaskRepository(TaskService());
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Index Page", style: TextStyle(color: Colors.white))),
    Center(child: Text("Calendar Page", style: TextStyle(color: Colors.white))),
    Center(child: Text("Focus Page", style: TextStyle(color: Colors.white))),
    Center(child: Text("Profile Page", style: TextStyle(color: Colors.white))),
  ];

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
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskBottomSheet(
        onTaskAdded: () {
          _fetchTasks(authProvider.currentUser?.id ?? '');
        },
      ),
    );
  }

  void _fetchTasks(String userId) {
    final userId = authProvider.currentUser?.id ?? '';
    if (userId.isEmpty) {
      return;
    }
    _taskRepository.getTasks(userId).then((tasks) {
      setState(() {
        _items.clear();
        _items.addAll(tasks);
      });
    }).catchError((e) {
      print("Error fetching tasks: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header(),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                  },
                ),
                SizedBox(height: 16),
                _items.isEmpty
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
                    : Container(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final task = _items[index];
                            final userId = authProvider.currentUser?.id ?? '';
                            return FutureBuilder(
                              future: _categoryRepository.getCategoryById(userId, task.categoryId),
                              builder: (context, snapshot) {
                                final category = snapshot.data;
                                return TaskItem(
                                  title: task.name,
                                  timeText: task.description ?? '',
                                  categoryLabel: category?.name ?? '',
                                  categoryIcon: category?.img,
                                  priorityLabel: task.priority,
                                );
                              },
                            );
                          },
                        ),
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
