import 'dart:convert';
import 'activity_type.dart';

abstract class Activity {
  final DateTime date;
  final ActivityType type;

  Activity({required this.date, required this.type});

  Map<String, dynamic> toJson();

  String toString() {
    return '${type.name} - ${date.toString()}';
  }
}

class WalkingActivity extends Activity {
  final int duration;

  WalkingActivity({
    required DateTime date,
    required this.duration,
  }) : super(date: date, type: ActivityType.walking);

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'duration': duration,
      'type': 'walking',
    };
  }

  factory WalkingActivity.fromJson(Map<String, dynamic> json) {
    return WalkingActivity(
      date: DateTime.parse(json['date']),
      duration: json['duration'],
    );
  }
}

class FoodActivity extends Activity {
  final String name;
  final String amount;

  FoodActivity({
    required DateTime date,
    required this.name,
    required this.amount,
  }) : super(date: date, type: ActivityType.food);

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'name': name,
      'amount': amount,
      'type': 'food',
    };
  }

  factory FoodActivity.fromJson(Map<String, dynamic> json) {
    return FoodActivity(
      date: DateTime.parse(json['date']),
      name: json['name'],
      amount: json['amount'],
    );
  }
}

class WaterActivity extends Activity {
  final double amount;

  WaterActivity({
    required DateTime date,
    required this.amount,
  }) : super(date: date, type: ActivityType.water);

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'type': 'water',
    };
  }

  factory WaterActivity.fromJson(Map<String, dynamic> json) {
    return WaterActivity(
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(),
    );
  }
}

class ExpenseActivity extends Activity {
  final String description;
  final double amount;
  final String category;

  ExpenseActivity({
    required DateTime date,
    required this.description,
    required this.amount,
    required this.category,
  }) : super(date: date, type: ActivityType.expense);

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'description': description,
      'amount': amount,
      'category': category,
      'type': 'expense',
    };
  }

  factory ExpenseActivity.fromJson(Map<String, dynamic> json) {
    return ExpenseActivity(
      date: DateTime.parse(json['date']),
      description: json['description'],
      amount: json['amount'].toDouble(),
      category: json['category'],
    );
  }
}

class ReadingActivity extends Activity {
  final String book;
  final int duration;
  final int? pages;

  ReadingActivity({
    required DateTime date,
    required this.book,
    required this.duration,
    this.pages,
  }) : super(date: date, type: ActivityType.reading);

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'book': book,
      'duration': duration,
      'pages': pages,
      'type': 'reading',
    };
  }

  factory ReadingActivity.fromJson(Map<String, dynamic> json) {
    return ReadingActivity(
      date: DateTime.parse(json['date']),
      book: json['book'],
      duration: json['duration'],
      pages: json['pages'],
    );
  }
}

class WritingActivity extends Activity {
  final String project;
  final int duration;
  final int? words;

  WritingActivity({
    required DateTime date,
    required this.project,
    required this.duration,
    this.words,
  }) : super(date: date, type: ActivityType.writing);

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'project': project,
      'duration': duration,
      'words': words,
      'type': 'writing',
    };
  }

  factory WritingActivity.fromJson(Map<String, dynamic> json) {
    return WritingActivity(
      date: DateTime.parse(json['date']),
      project: json['project'],
      duration: json['duration'],
      words: json['words'],
    );
  }
}

class StudyingActivity extends Activity {
  final String subject;
  final int duration;

  StudyingActivity({
    required DateTime date,
    required this.subject,
    required this.duration,
  }) : super(date: date, type: ActivityType.studying);

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'subject': subject,
      'duration': duration,
      'type': 'studying',
    };
  }

  factory StudyingActivity.fromJson(Map<String, dynamic> json) {
    return StudyingActivity(
      date: DateTime.parse(json['date']),
      subject: json['subject'],
      duration: json['duration'],
    );
  }
}
