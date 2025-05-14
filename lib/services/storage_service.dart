// services/storage_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';

class StorageService {
  static const String _walkingKey = 'walking_activities';
  static const String _foodKey = 'food_activities';
  static const String _waterKey = 'water_activities';
  static const String _expenseKey = 'expense_activities';
  static const String _readingKey = 'reading_activities';
  static const String _writingKey = 'writing_activities';
  static const String _studyingKey = 'studying_activities';

  // Save activities
  Future<void> saveActivities(List<Activity> activities) async {
    final prefs = await SharedPreferences.getInstance();

    final walkingActivities = activities
        .where((activity) => activity.type == ActivityType.walking)
        .map((activity) => jsonEncode((activity as WalkingActivity).toJson()))
        .toList();

    final foodActivities = activities
        .where((activity) => activity.type == ActivityType.food)
        .map((activity) => jsonEncode((activity as FoodActivity).toJson()))
        .toList();

    final waterActivities = activities
        .where((activity) => activity.type == ActivityType.water)
        .map((activity) => jsonEncode((activity as WaterActivity).toJson()))
        .toList();

    final expenseActivities = activities
        .where((activity) => activity.type == ActivityType.expense)
        .map((activity) => jsonEncode((activity as ExpenseActivity).toJson()))
        .toList();

    final readingActivities = activities
        .where((activity) => activity.type == ActivityType.reading)
        .map((activity) => jsonEncode((activity as ReadingActivity).toJson()))
        .toList();

    final writingActivities = activities
        .where((activity) => activity.type == ActivityType.writing)
        .map((activity) => jsonEncode((activity as WritingActivity).toJson()))
        .toList();

    final studyingActivities = activities
        .where((activity) => activity.type == ActivityType.studying)
        .map((activity) => jsonEncode((activity as StudyingActivity).toJson()))
        .toList();

    await prefs.setStringList(_walkingKey, walkingActivities);
    await prefs.setStringList(_foodKey, foodActivities);
    await prefs.setStringList(_waterKey, waterActivities);
    await prefs.setStringList(_expenseKey, expenseActivities);
    await prefs.setStringList(_readingKey, readingActivities);
    await prefs.setStringList(_writingKey, writingActivities);
    await prefs.setStringList(_studyingKey, studyingActivities);
  }

  // Load activities
  Future<List<Activity>> loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    List<Activity> activities = [];

    // Load walking activities
    final walkingJson = prefs.getStringList(_walkingKey) ?? [];
    for (var json in walkingJson) {
      try {
        activities.add(WalkingActivity.fromJson(jsonDecode(json)));
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing walking activity: $e');
        }
      }
    }

    // Load food activities
    final foodJson = prefs.getStringList(_foodKey) ?? [];
    for (var json in foodJson) {
      try {
        activities.add(FoodActivity.fromJson(jsonDecode(json)));
      } catch (e) {
        print('Error parsing food activity: $e');
      }
    }

    // Load water activities
    final waterJson = prefs.getStringList(_waterKey) ?? [];
    for (var json in waterJson) {
      try {
        activities.add(WaterActivity.fromJson(jsonDecode(json)));
      } catch (e) {
        print('Error parsing water activity: $e');
      }
    }

    // Load expense activities
    final expenseJson = prefs.getStringList(_expenseKey) ?? [];
    for (var json in expenseJson) {
      try {
        activities.add(ExpenseActivity.fromJson(jsonDecode(json)));
      } catch (e) {
        print('Error parsing expense activity: $e');
      }
    }

    // Load reading activities
    final readingJson = prefs.getStringList(_readingKey) ?? [];
    for (var json in readingJson) {
      try {
        activities.add(ReadingActivity.fromJson(jsonDecode(json)));
      } catch (e) {
        print('Error parsing reading activity: $e');
      }
    }

    // Load writing activities
    final writingJson = prefs.getStringList(_writingKey) ?? [];
    for (var json in writingJson) {
      try {
        activities.add(WritingActivity.fromJson(jsonDecode(json)));
      } catch (e) {
        print('Error parsing writing activity: $e');
      }
    }

    // Load studying activities
    final studyingJson = prefs.getStringList(_studyingKey) ?? [];
    for (var json in studyingJson) {
      try {
        activities.add(StudyingActivity.fromJson(jsonDecode(json)));
      } catch (e) {
        print('Error parsing studying activity: $e');
      }
    }

    return activities;
  }

  // Export all data as JSON
  Future<String> exportData() async {
    final activities = await loadActivities();

    // Group activities by type
    Map<String, List<Map<String, dynamic>>> groupedActivities = {
      'walking': [],
      'food': [],
      'water': [],
      'expense': [],
      'reading': [],
      'writing': [],
      'studying': [],
    };

    for (var activity in activities) {
      switch (activity.type) {
        case ActivityType.walking:
          groupedActivities['walking']!
              .add((activity as WalkingActivity).toJson());
          break;
        case ActivityType.food:
          groupedActivities['food']!.add((activity as FoodActivity).toJson());
          break;
        case ActivityType.water:
          groupedActivities['water']!.add((activity as WaterActivity).toJson());
          break;
        case ActivityType.expense:
          groupedActivities['expense']!
              .add((activity as ExpenseActivity).toJson());
          break;
        case ActivityType.reading:
          groupedActivities['reading']!
              .add((activity as ReadingActivity).toJson());
          break;
        case ActivityType.writing:
          groupedActivities['writing']!
              .add((activity as WritingActivity).toJson());
          break;
        case ActivityType.studying:
          groupedActivities['studying']!
              .add((activity as StudyingActivity).toJson());
          break;
      }
    }

    return jsonEncode(groupedActivities);
  }
}
