import 'package:flutter/material.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';

const List<String> kWeekDays = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

typedef OnMonthChange = void Function(int delta);
typedef OnDateSelected = void Function(DateTime date);

class CalendarHeader extends StatelessWidget {
  final DateTime selectedDate;
  final List<DateTime> daysOfMonth;
  final ScrollController scrollController;
  final OnMonthChange onMonthChange;
  final OnDateSelected onDateSelected;

  const CalendarHeader({
    super.key,
    required this.selectedDate,
    required this.daysOfMonth,
    required this.scrollController,
    required this.onMonthChange,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.upToDoBorder,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: AppColor.upToDoWhite),
                onPressed: () => onMonthChange(-1),
              ),
              Text(
                '${selectedDate.month}/${selectedDate.year}',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColor.upToDoWhite,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right, color: AppColor.upToDoWhite),
                onPressed: () => onMonthChange(1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70,
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: daysOfMonth.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final date = daysOfMonth[index];
                final isSelected = date.day == selectedDate.day;
                return GestureDetector(
                  onTap: () => onDateSelected(date),
                  child: Container(
                    width: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.upToDoPrimary : AppColor.upToDoBgSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          kWeekDays[date.weekday % 7],
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColor.upToDoWhite,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          date.day.toString(),
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColor.upToDoWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
