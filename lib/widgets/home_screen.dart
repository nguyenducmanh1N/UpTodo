import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/widgets/shared/components/CustomBottomnavigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required void Function() onLogout});

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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                            style: AppTextStyles.uptododisplaysmall.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Tap + to add your tasks",
                            style: AppTextStyles.uptododisplaysmall.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Custombottomnavigationbar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        onAddPressed: _onAddPressed,
      ),
    );
  }
}
