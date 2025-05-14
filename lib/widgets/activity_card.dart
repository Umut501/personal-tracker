import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../utils/constants.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onDelete;
  final bool showDate;

  const ActivityCard({
    Key? key,
    required this.activity,
    this.onDelete,
    this.showDate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 4,
              color: AppColors.getColorForType(activity.type),
            ),
          ),
          color: _getBackgroundColor(activity.type),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: CircleAvatar(
            backgroundColor: AppColors.getColorForType(activity.type),
            child: Text(
              activity.type.icon,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(_getActivityTitle()),
          subtitle: showDate 
              ? Text(DateFormat('dd/MM/yyyy HH:mm').format(activity.date)) 
              : null,
          trailing: onDelete != null 
              ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                )
              : null,
        ),
      ),
    );
  }

  Color _getBackgroundColor(ActivityType type) {
    final color = AppColors.getColorForType(type);
    return color.withOpacity(0.1);
  }

  String _getActivityTitle() {
    switch (activity.type) {
      case ActivityType.walking:
        final walkingActivity = activity as WalkingActivity;
        return '${walkingActivity.duration} dakika yürüyüş';
        
      case ActivityType.food:
        final foodActivity = activity as FoodActivity;
        return '${foodActivity.name} - ${foodActivity.amount}';
        
      case ActivityType.water:
        final waterActivity = activity as WaterActivity;
        return '${waterActivity.amount} litre su';
        
      case ActivityType.expense:
        final expenseActivity = activity as ExpenseActivity;
        return '${expenseActivity.description} - ${expenseActivity.amount}₺ (${ExpenseCategories.getNameById(expenseActivity.category)})';
        
      case ActivityType.reading:
        final readingActivity = activity as ReadingActivity;
        final pagesText = readingActivity.pages != null ? ' (${readingActivity.pages} sayfa)' : '';
        return '${readingActivity.book} - ${readingActivity.duration} dakika$pagesText';
        
      case ActivityType.writing:
        final writingActivity = activity as WritingActivity;
        final wordsText = writingActivity.words != null ? ' (${writingActivity.words} kelime)' : '';
        return '${writingActivity.project} - ${writingActivity.duration} dakika$wordsText';
        
      case ActivityType.studying:
        final studyingActivity = activity as StudyingActivity;
        return '${studyingActivity.subject} - ${studyingActivity.duration} dakika';
    }
  }
}