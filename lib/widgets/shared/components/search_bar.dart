import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  const SearchBar({super.key, this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText ?? 'Search...',
          icon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}
