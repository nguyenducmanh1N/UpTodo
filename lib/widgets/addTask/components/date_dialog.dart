import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/widgets/addTask/components/time_dialog.dart';

class DateDialog extends StatefulWidget {
  const DateDialog({super.key});

  @override
  State<DateDialog> createState() => _TimerDialogState();
}

class _TimerDialogState extends State<DateDialog> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _showTimeDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => TimeDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.upToDoBgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                        _focusedDay.day,
                      );
                    });
                  },
                ),
                Column(
                  children: [
                    Text(
                      "${_focusedDay.month} ${_focusedDay.year}",
                      style: AppTextStyles.displayLarge.copyWith(
                        color: AppColor.upToDoWhile,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                        _focusedDay.day,
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: AppColor.upToDoKeyPrimary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColor.upToDoBorder,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: AppTextStyles.displaySmall.copyWith(
                  color: AppColor.upToDoWhile,
                ),
                weekendTextStyle: AppTextStyles.displaySmall.copyWith(
                  color: Colors.red,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: AppTextStyles.displayLarge.copyWith(
                  color: AppColor.upToDoWhile,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoKeyPrimary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showTimeDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.upToDoKeyPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Choose Time",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoWhile,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
