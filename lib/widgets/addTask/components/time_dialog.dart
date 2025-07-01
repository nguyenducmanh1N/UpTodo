import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';

class TimeDialog extends StatefulWidget {
  const TimeDialog({super.key});

  @override
  State<TimeDialog> createState() => _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog> {
  int _selectedHour = 8;
  int _selectedMinute = 20;
  String _selectedPeriod = "AM";

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose Time",
              style: AppTextStyles.displayLarge.copyWith(
                color: AppColor.upToDoWhile,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour Picker
                _buildPicker(
                  currentValue: _selectedHour,
                  values: List.generate(12, (index) => index + 1),
                  onChanged: (value) {
                    setState(() {
                      _selectedHour = value;
                    });
                  },
                ),
                const Text(
                  ":",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                _buildPicker(
                  currentValue: _selectedMinute,
                  values: List.generate(60, (index) => index),
                  onChanged: (value) {
                    setState(() {
                      _selectedMinute = value;
                    });
                  },
                ),
                const SizedBox(width: 16),
                _buildPicker(
                  currentValue: _selectedPeriod == "AM" ? 0 : 1,
                  values: ["AM", "PM"],
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriod = value == 0 ? "AM" : "PM";
                    });
                  },
                ),
              ],
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
                    print("Selected Time: $_selectedHour:$_selectedMinute $_selectedPeriod");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.upToDoKeyPrimary,
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
        ),
      ),
    );
  }

  Widget _buildPicker({
    required dynamic currentValue,
    required List<dynamic> values,
    required Function(dynamic) onChanged,
  }) {
    return SizedBox(
      height: 100,
      width: 60,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Center(
              child: Text(
                values[index].toString(),
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColor.upToDoWhile,
                ),
              ),
            );
          },
          childCount: values.length,
        ),
      ),
    );
  }
}
