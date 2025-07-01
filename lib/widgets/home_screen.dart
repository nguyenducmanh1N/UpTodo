import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';

import 'package:uptodo/widgets/shared/components/custom_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  final List<String> _items = [];

  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Index Page", style: TextStyle(color: Colors.white))),
    Center(child: Text("Calendar Page", style: TextStyle(color: Colors.white))),
    Center(child: Text("Focus Page", style: TextStyle(color: Colors.white))),
    Center(child: Text("Profile Page", style: TextStyle(color: Colors.white))),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddPressed() {
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => const AddTaskBottomSheet(),
    // );
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
                SizedBox(height: 16),
                _items.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.logout, color: Colors.white),
                              onPressed: () {
                                Provider.of<AuthProvider>(context, listen: false).logout();
                              },
                            ),
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
                        child: Column(
                          children: [
                            SearchBar(
                              hintText: "Search tasks",
                              onChanged: (value) {},
                            ),
                            SizedBox(height: 16),
                          ],
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
