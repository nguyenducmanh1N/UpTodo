import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:table_calendar/table_calendar.dart';

class DateDialog extends StatefulWidget {
  final DateTime? initialDate;
  const DateDialog({super.key, this.initialDate});

  @override
  State<DateDialog> createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isPickingTime = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
      _selectedTime = TimeOfDay.fromDateTime(widget.initialDate!);
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  void _onTimeSelected(TimeOfDay selectedTime) {
    setState(() {
      _selectedTime = selectedTime;
    });
  }

  void _handleDateTimeSelection() {
    final combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    Navigator.pop(context, combinedDateTime);
  }

  Widget _buildCalendar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableCalendar(
          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          focusedDay: _selectedDate,
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: _onDaySelected,
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: AppColor.upToDoPrimary,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: AppTextStyles.displayMedium.copyWith(
              color: AppColor.upToDoWhile,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: AppColor.upToDoWhile),
            rightChevronIcon: Icon(Icons.chevron_right, color: AppColor.upToDoWhile),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColor.upToDoKeyPrimary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isPickingTime = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.upToDoPrimary,
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
    );
  }

  Widget _buildTimePicker() {
    TimeOfDay tempTime = _selectedTime;

    return StatefulBuilder(
      builder: (context, setStateSB) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose Time",
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColor.upToDoWhile,
              ),
            ),
            const Divider(height: 24, color: AppColor.upToDoBgSecondary),
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                backgroundColor: AppColor.upToDoBgSecondary,
                initialDateTime: DateTime(2024, 1, 1, _selectedTime.hour, _selectedTime.minute),
                onDateTimeChanged: (DateTime newDateTime) {
                  setStateSB(() {
                    tempTime = TimeOfDay(
                      hour: newDateTime.hour,
                      minute: newDateTime.minute,
                    );
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoKeyPrimary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _onTimeSelected(tempTime);
                    _handleDateTimeSelection();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.upToDoPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoWhile,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
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
        child: _isPickingTime ? _buildTimePicker() : _buildCalendar(),
      ),
    );
  }
}
