import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final VoidCallback onAddButtonPressed;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAddButtonPressed,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: AppColor.upToDoBorder,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButtonItem(
                  image: Image.asset('assets/images/index.png'),
                  label: 'Index',
                  index: 0,
                  isSelected: widget.currentIndex == 0,
                ),
                _buildButtonItem(
                  image: Image.asset('assets/images/calendar.png'),
                  label: 'Calendar',
                  index: 1,
                  isSelected: widget.currentIndex == 1,
                ),
                SizedBox(width: 64),
                _buildButtonItem(
                  image: Image.asset('assets/images/focus.png'),
                  label: 'Focus',
                  index: 2,
                  isSelected: widget.currentIndex == 2,
                ),
                _buildButtonItem(
                  image: Image.asset('assets/images/profile.png'),
                  label: 'Profile',
                  index: 3,
                  isSelected: widget.currentIndex == 3,
                ),
              ],
            ),
          ),
          Positioned(
            top: -32,
            left: MediaQuery.of(context).size.width / 2 - 32,
            child: GestureDetector(
              onTap: widget.onAddButtonPressed,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColor.upToDoPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.upToDoPrimary,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonItem({
    required Image image,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => widget.onTabSelected(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: isSelected
                  ? AssetImage('assets/images/${label.toLowerCase()}_selected.png')
                  : AssetImage('assets/images/${label.toLowerCase()}.png'),
              width: 24,
              height: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColor.upToDoPrimary : Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
