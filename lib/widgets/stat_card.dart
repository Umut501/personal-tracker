import 'package:flutter/material.dart';
import '../models/activity_type.dart';
import '../utils/constants.dart';

class StatCard extends StatelessWidget {
  final String value;
  final ActivityType type;

  const StatCard({
    Key? key,
    required this.value,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.getColorForType(type),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${type.name} ${type.unit}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
