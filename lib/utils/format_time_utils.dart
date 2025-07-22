import 'package:intl/intl.dart';

class FormatTimeUtils {
  static String formatTaskTime(DateTime taskDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDateOnly = DateTime(taskDate.year, taskDate.month, taskDate.day);
    final timeFormat = DateFormat('HH:mm');
    final timeString = timeFormat.format(taskDate);

    if (taskDateOnly == today) {
      return 'Today At $timeString';
    }

    if (taskDateOnly == today.add(Duration(days: 1))) {
      return 'Tomorrow At $timeString';
    }

    if (taskDateOnly == today.subtract(Duration(days: 1))) {
      return 'Yesterday At $timeString';
    }

    final dateFormat = DateFormat('MMM dd');
    return '${dateFormat.format(taskDate)} At $timeString';
  }
}
