import 'package:flutter/material.dart';
import '../models/activity_type.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);

  // Activity colors
  static const Color walking = Color(0xFF4CAF50);
  static const Color food = Color(0xFFFF9800);
  static const Color water = Color(0xFF2196F3);
  static const Color expense = Color(0xFF9C27B0);
  static const Color reading = Color(0xFF9C27B0);
  static const Color writing = Color(0xFFE91E63);
  static const Color studying = Color(0xFF00BCD4);

  static Color getColorForType(ActivityType type) {
    switch (type) {
      case ActivityType.walking:
        return walking;
      case ActivityType.food:
        return food;
      case ActivityType.water:
        return water;
      case ActivityType.expense:
        return expense;
      case ActivityType.reading:
        return reading;
      case ActivityType.writing:
        return writing;
      case ActivityType.studying:
        return studying;
    }
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        error: Colors.red,
        background: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Güncellenmiş CardTheme yapısı
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      // Güncellenmiş TextTheme adları
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ExpenseCategories {
  static const List<Map<String, dynamic>> categories = [
    {'id': 'food', 'name': 'Yiyecek'},
    {'id': 'transportation', 'name': 'Ulaşım'},
    {'id': 'entertainment', 'name': 'Eğlence'},
    {'id': 'health', 'name': 'Sağlık'},
    {'id': 'other', 'name': 'Diğer'},
  ];

  static String getNameById(String id) {
    final category = categories.firstWhere(
      (cat) => cat['id'] == id,
      orElse: () => {'id': id, 'name': id},
    );
    return category['name'];
  }
}
