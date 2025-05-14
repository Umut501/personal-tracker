import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_activity_message.dart';
import '../widgets/notification.dart';
import '../utils/constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStats(context, provider),
              const SizedBox(height: 16),
              _buildTodayActivities(context, provider),
              const SizedBox(height: 16),
              _buildExportButton(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStats(BuildContext context, ActivityProvider provider) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          value: provider.totalWalkingDuration.toString(),
          type: ActivityType.walking,
        ),
        StatCard(
          value: provider.totalWaterAmount.toStringAsFixed(1),
          type: ActivityType.water,
        ),
        StatCard(
          value: provider.totalExpenseAmount.toStringAsFixed(0),
          type: ActivityType.expense,
        ),
        StatCard(
          value: provider.totalReadingDuration.toString(),
          type: ActivityType.reading,
        ),
        StatCard(
          value: provider.totalWritingDuration.toString(),
          type: ActivityType.writing,
        ),
        StatCard(
          value: provider.totalStudyingDuration.toString(),
          type: ActivityType.studying,
        ),
      ],
    );
  }

  Widget _buildTodayActivities(
      BuildContext context, ActivityProvider provider) {
    final todayActivities = provider.todayActivities;
    final now = DateTime.now();
    final today = DateFormat('EEEE, d MMMM yyyy', 'tr_TR').format(now);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Günlük Özet - $today',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            _buildActivityGroup(
              context,
              'Yürüyüş',
              ActivityType.walking,
              provider.getActivitiesByTypeAndDay(ActivityType.walking, now),
            ),
            _buildActivityGroup(
              context,
              'Beslenme',
              ActivityType.food,
              provider.getActivitiesByTypeAndDay(ActivityType.food, now),
            ),
            _buildActivityGroup(
              context,
              'Su',
              ActivityType.water,
              provider.getActivitiesByTypeAndDay(ActivityType.water, now),
            ),
            _buildActivityGroup(
              context,
              'Harcama',
              ActivityType.expense,
              provider.getActivitiesByTypeAndDay(ActivityType.expense, now),
            ),
            _buildActivityGroup(
              context,
              'Okuma',
              ActivityType.reading,
              provider.getActivitiesByTypeAndDay(ActivityType.reading, now),
            ),
            _buildActivityGroup(
              context,
              'Kitap Yazma',
              ActivityType.writing,
              provider.getActivitiesByTypeAndDay(ActivityType.writing, now),
            ),
            _buildActivityGroup(
              context,
              'Ders Çalışma',
              ActivityType.studying,
              provider.getActivitiesByTypeAndDay(ActivityType.studying, now),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityGroup(
    BuildContext context,
    String title,
    ActivityType type,
    List<Activity> activities,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.getColorForType(type),
                radius: 12,
                child: Text(
                  type.icon,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        if (activities.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 16),
            child: Text(
              'Bugün için kayıt yok',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          )
        else
          ...activities.map((activity) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: ActivityCard(
                  activity: activity,
                  showDate: false,
                ),
              )),
        const Divider(),
      ],
    );
  }

  Widget _buildExportButton(BuildContext context, ActivityProvider provider) {
    return ElevatedButton.icon(
      onPressed: () => _exportData(context, provider),
      icon: const Icon(Icons.download),
      label: const Text('Verileri Görüntüle (JSON)'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  Future<void> _exportData(
      BuildContext context, ActivityProvider provider) async {
    try {
      final jsonData = await provider.exportData();

      // Dosyaya kaydetmek ve paylaşmak yerine dialog ile gösteriyoruz
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Veriler (JSON)'),
            content: SingleChildScrollView(
              child: SelectableText(
                jsonData,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Kapat'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      AppNotification.show(context, 'Veriler görüntülenirken hata oluştu: $e',
          isError: true);
    }
  }
}
