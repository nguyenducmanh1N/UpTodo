import 'package:flutter/material.dart';

class PriorityUtils {
  static final List<Map<String, dynamic>> priorities = [
    {'key': '1', 'label': '1', 'icon': 'assets/images/flag_icon.png'},
    {'key': '2', 'label': '2', 'icon': 'assets/images/flag_icon.png'},
    {'key': '3', 'label': '3', 'icon': 'assets/images/flag_icon.png'},
    {'key': '4', 'label': '4', 'icon': 'assets/images/flag_icon.png'},
    {'key': '5', 'label': '5', 'icon': 'assets/images/flag_icon.png'},
    {'key': '6', 'label': '6', 'icon': 'assets/images/flag_icon.png'},
    {'key': '7', 'label': '7', 'icon': 'assets/images/flag_icon.png'},
    {'key': '8', 'label': '8', 'icon': 'assets/images/flag_icon.png'},
    {'key': '9', 'label': '9', 'icon': 'assets/images/flag_icon.png'},
    {'key': '10', 'label': '10', 'icon': 'assets/images/flag_icon.png'},
  ];

  static Map<String, dynamic> getPriorityByKey(String key) {
    return priorities.firstWhere(
      (element) => element['key'] == key,
      orElse: () => priorities[0],
    );
  }

  static String getLabelFromKey(String key) {
    return getPriorityByKey(key)['label'];
  }

  static String getIconFromKey(String key) {
    return getPriorityByKey(key)['icon'];
  }
}
