enum ActivityType {
  walking,
  food,
  water,
  expense,
  reading,
  writing,
  studying,
}

extension ActivityTypeExtension on ActivityType {
  String get name {
    switch (this) {
      case ActivityType.walking:
        return 'Yürüyüş';
      case ActivityType.food:
        return 'Beslenme';
      case ActivityType.water:
        return 'Su';
      case ActivityType.expense:
        return 'Harcama';
      case ActivityType.reading:
        return 'Okuma';
      case ActivityType.writing:
        return 'Yazma';
      case ActivityType.studying:
        return 'Ders';
    }
  }

  String get icon {
    switch (this) {
      case ActivityType.walking:
        return 'Y';
      case ActivityType.food:
        return 'B';
      case ActivityType.water:
        return 'S';
      case ActivityType.expense:
        return 'H';
      case ActivityType.reading:
        return 'O';
      case ActivityType.writing:
        return 'K';
      case ActivityType.studying:
        return 'D';
    }
  }

  String get unit {
    switch (this) {
      case ActivityType.walking:
        return 'dk';
      case ActivityType.food:
        return '';
      case ActivityType.water:
        return 'lt';
      case ActivityType.expense:
        return '₺';
      case ActivityType.reading:
        return 'dk';
      case ActivityType.writing:
        return 'dk';
      case ActivityType.studying:
        return 'dk';
    }
  }
}
