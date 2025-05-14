# Personal Tracker - Flutter Application

Personal Tracker is a comprehensive Flutter application that helps you monitor your daily activities and develop healthy habits.

## Features

### 📊 Multiple Activity Tracking
- **Walking**: Record your daily walks in minutes.
- **Nutrition**: Track the food and beverages you consume.
- **Water**: Measure your daily water intake.
- **Expenses**: Record your expenses by categories.
- **Reading**: Track which books you read and for how long.
- **Writing**: Document your writing sessions.
- **Studying**: Monitor your study hours.

### 📱 User-Friendly Interface
- Intuitive and modern design
- Easy data entry
- Bottom menu and drawer navigation for quick access
- Turkish language support

### 📆 Calendar View
- Monthly activity overview
- Daily activity summary
- Visual distinction between activity types

### 🔍 Analytics and Statistics
- Total and category-based activity statistics
- Daily, weekly, and all-time views
- Activity distribution
- Most active days and streaks

### 💾 Data Management
- Local storage on the device
- View data in JSON format
- Ability to delete activities

## Installation

### Requirements
- Flutter SDK 3.7.0 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code / IntelliJ IDEA

### Steps

1. Install Flutter SDK (https://flutter.dev/docs/get-started/install)
2. Clone the repository:
   ```
   git clone https://github.com/Umut501/personal_tracker.git
   ```
3. Navigate to the project directory:
   ```
   cd personal_tracker
   ```
4. Install dependencies:
   ```
   flutter pub get
   ```
5. Run the application:
   ```
   flutter run
   ```

## Project Structure

```
lib/
├── models/                # Data models
│   ├── activity.dart      # Activity classes
│   └── activity_type.dart # Activity types
├── screens/               # Application screens
│   ├── dashboard_screen.dart   # Home page
│   ├── movement_screen.dart    # Walking tracking
│   ├── food_screen.dart        # Nutrition tracking
│   ├── water_screen.dart       # Water tracking
│   ├── expense_screen.dart     # Expense tracking
│   ├── reading_screen.dart     # Reading tracking
│   ├── writing_screen.dart     # Writing tracking
│   ├── studying_screen.dart    # Studying tracking
│   ├── calendar_screen.dart    # Calendar view
│   └── analytics_screen.dart   # Analytics screen
├── widgets/               # Reusable components
│   ├── activity_card.dart      # Activity card
│   ├── stat_card.dart          # Statistics card
│   └── ...
├── providers/             # State management
│   └── activity_provider.dart  # Activity data manager
├── services/              # Services
│   └── storage_service.dart    # Data storage service
├── utils/                 # Helper classes
│   └── constants.dart         # Constants, colors, themes
└── main.dart              # Application entry point
```

## Technologies Used

- **Flutter**: UI framework
- **Provider**: State management
- **Shared Preferences**: Local data storage
- **Intl**: Localization and date formatting

## Contributing

1. Fork the repository
2. Create a feature or bug-fix branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push your branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License

This project is licensed under the [MIT License](LICENSE).

