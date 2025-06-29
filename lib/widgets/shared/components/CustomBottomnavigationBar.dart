import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';

class Custombottomnavigationbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddPressed;

  const Custombottomnavigationbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  State<Custombottomnavigationbar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<Custombottomnavigationbar> {
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
              color: AppColor.uptodoBoder,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBtItem(
                  image: Image.asset('assets/images/index.png'),
                  label: 'Index',
                  index: 0,
                  isSelected: widget.currentIndex == 0,
                ),
                _buildBtItem(
                  image: Image.asset('assets/images/calendar.png'),
                  label: 'Calendar',
                  index: 1,
                  isSelected: widget.currentIndex == 1,
                ),
                SizedBox(width: 64),
                _buildBtItem(
                  image: Image.asset('assets/images/focus.png'),
                  label: 'Focus',
                  index: 2,
                  isSelected: widget.currentIndex == 2,
                ),
                _buildBtItem(
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
              onTap: widget.onAddPressed,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFF8875FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF8875FF).withOpacity(0.3),
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

  Widget _buildBtItem({
    required Image image,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => widget.onTap(index),
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
                color: isSelected ? Color(0xFF8875FF) : Colors.white,
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
