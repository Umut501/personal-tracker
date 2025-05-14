import 'package:flutter/material.dart';
import '../models/activity_type.dart';
import '../utils/constants.dart';

class CalendarDay extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool isCurrentMonth;
  final List<ActivityType> activityTypes;
  final VoidCallback onTap;

  const CalendarDay({
    Key? key,
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.isCurrentMonth,
    required this.activityTypes,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.toString(),
              style: TextStyle(
                fontWeight: isToday || isSelected || activityTypes.isNotEmpty
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: _getTextColor(),
              ),
            ),
            const SizedBox(height: 4),
            if (activityTypes.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: activityTypes.map((type) {
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppColors.getColorForType(type),
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return AppColors.primary;
    } else if (isToday) {
      return AppColors.primary.withOpacity(0.3);
    } else {
      return isCurrentMonth ? Colors.white : Colors.grey.withOpacity(0.2);
    }
  }

  Color _getTextColor() {
    if (isSelected) {
      return Colors.white;
    } else if (!isCurrentMonth) {
      return Colors.grey;
    } else {
      return Colors.black;
    }
  }
}
