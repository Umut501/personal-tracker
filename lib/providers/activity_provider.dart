import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../services/storage_service.dart';

class ActivityProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Activity> _activities = [];
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  // Getters
  List<Activity> get activities => _activities;
  DateTime get selectedDate => _selectedDate;
  DateTime get currentMonth => _currentMonth;

  // Constructor: Load data on initialization
  ActivityProvider() {
    _loadActivities();
  }

  // Filter activities by today
  List<Activity> get todayActivities {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _activities.where((activity) {
      final activityDate = DateTime(
        activity.date.year,
        activity.date.month,
        activity.date.day,
      );
      return activityDate.isAtSameMomentAs(today);
    }).toList();
  }

  // Filter activities by selected date
  List<Activity> get selectedDateActivities {
    final selectedDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    return _activities.where((activity) {
      final activityDate = DateTime(
        activity.date.year,
        activity.date.month,
        activity.date.day,
      );
      return activityDate.isAtSameMomentAs(selectedDay);
    }).toList();
  }

  // Filter activities by type
  List<Activity> getActivitiesByType(ActivityType type) {
    return _activities.where((activity) => activity.type == type).toList();
  }

  // Filter activities by type and day
  List<Activity> getActivitiesByTypeAndDay(ActivityType type, DateTime day) {
    final targetDay = DateTime(day.year, day.month, day.day);

    return _activities.where((activity) {
      final activityDate = DateTime(
        activity.date.year,
        activity.date.month,
        activity.date.day,
      );
      return activity.type == type && activityDate.isAtSameMomentAs(targetDay);
    }).toList();
  }

  // Add a new activity
  Future<void> addActivity(Activity activity) async {
    _activities.add(activity);
    await _saveActivities();
    notifyListeners();
  }

  // Delete an activity
  Future<void> deleteActivity(Activity activity) async {
    _activities.removeWhere((a) =>
        a.date.isAtSameMomentAs(activity.date) &&
        a.type == activity.type &&
        a.toString() == activity.toString());
    await _saveActivities();
    notifyListeners();
  }

  // Set the selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Set current month for calendar
  void setCurrentMonth(DateTime date) {
    _currentMonth = date;
    notifyListeners();
  }

  // Check if a day has any activities
  bool hasDayActivities(DateTime day) {
    final targetDay = DateTime(day.year, day.month, day.day);

    return _activities.any((activity) {
      final activityDate = DateTime(
        activity.date.year,
        activity.date.month,
        activity.date.day,
      );
      return activityDate.isAtSameMomentAs(targetDay);
    });
  }

  // Get activity types for a specific day
  List<ActivityType> getDayActivityTypes(DateTime day) {
    final targetDay = DateTime(day.year, day.month, day.day);
    Set<ActivityType> types = {};

    for (var activity in _activities) {
      final activityDate = DateTime(
        activity.date.year,
        activity.date.month,
        activity.date.day,
      );
      if (activityDate.isAtSameMomentAs(targetDay)) {
        types.add(activity.type);
      }
    }

    return types.toList();
  }

  // Get total walking duration
  int get totalWalkingDuration {
    int total = 0;
    for (var activity in getActivitiesByType(ActivityType.walking)) {
      total += (activity as WalkingActivity).duration;
    }
    return total;
  }

  // Get total water amount
  double get totalWaterAmount {
    double total = 0;
    for (var activity in getActivitiesByType(ActivityType.water)) {
      total += (activity as WaterActivity).amount;
    }
    return total;
  }

  // Get total expense amount
  double get totalExpenseAmount {
    double total = 0;
    for (var activity in getActivitiesByType(ActivityType.expense)) {
      total += (activity as ExpenseActivity).amount;
    }
    return total;
  }

  // Get total reading duration
  int get totalReadingDuration {
    int total = 0;
    for (var activity in getActivitiesByType(ActivityType.reading)) {
      total += (activity as ReadingActivity).duration;
    }
    return total;
  }

  // Get total writing duration
  int get totalWritingDuration {
    int total = 0;
    for (var activity in getActivitiesByType(ActivityType.writing)) {
      total += (activity as WritingActivity).duration;
    }
    return total;
  }

  // Get total studying duration
  int get totalStudyingDuration {
    int total = 0;
    for (var activity in getActivitiesByType(ActivityType.studying)) {
      total += (activity as StudyingActivity).duration;
    }
    return total;
  }

  // Get current streak days
  int get streakDays {
    int streak = 0;
    final today = DateTime.now();
    DateTime currentDate = DateTime(today.year, today.month, today.day);

    while (true) {
      if (hasDayActivities(currentDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  // Export data as JSON
  Future<String> exportData() async {
    return await _storageService.exportData();
  }

  // Private methods
  Future<void> _loadActivities() async {
    _activities = await _storageService.loadActivities();
    notifyListeners();
  }

  Future<void> _saveActivities() async {
    await _storageService.saveActivities(_activities);
  }
}
