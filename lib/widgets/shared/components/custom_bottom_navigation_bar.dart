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
      height: 122,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 90,
            child: Container(
              color: AppColor.upToDoBorder,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButtonItem(label: 'Index', index: 0),
                  _buildButtonItem(label: 'Calendar', index: 1),
                  const SizedBox(width: 64),
                  _buildButtonItem(label: 'Focus', index: 2),
                  _buildButtonItem(label: 'Profile', index: 3),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2 - 45,
            width: 90,
            height: 90,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: widget.onAddButtonPressed,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColor.upToDoPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColor.upToDoWhile,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonItem({
    required String label,
    required int index,
  }) {
    final isSelected = widget.currentIndex == index;
    return GestureDetector(
      onTap: () => widget.onTabSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/${label.toLowerCase()}${isSelected ? '_selected' : ''}.png',
              width: 24,
              height: 24,
              color: isSelected ? AppColor.upToDoPrimary : AppColor.upToDoWhile,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColor.upToDoPrimary : AppColor.upToDoWhile,
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
