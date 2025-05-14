import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../utils/constants.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'week';

  @override
  Widget build(BuildContext context) {
    // MediaQuery.boldTextOverride yerine MediaQuery.boldTextOf kullanımı
    final bool isBoldText = MediaQuery.boldTextOf(context);

    return Consumer<ActivityProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodFilter(),
              const SizedBox(height: 16),
              _buildStatsCards(context, provider),
              const SizedBox(height: 16),
              _buildActivityDistribution(context, provider),
              const SizedBox(height: 16),
              _buildDailyActivitySummary(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: _buildFilterButton('Bu Hafta', 'week'),
            ),
            Expanded(
              child: _buildFilterButton('Bu Ay', 'month'),
            ),
            Expanded(
              child: _buildFilterButton('Tümü', 'all'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, String period) {
    final isActive = _selectedPeriod == period;

    return TextButton(
      onPressed: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: isActive ? AppColors.primary : Colors.transparent,
        foregroundColor: isActive ? Colors.white : AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text(label),
    );
  }

  Widget _buildStatsCards(BuildContext context, ActivityProvider provider) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          'Toplam Etkinlik (dk)',
          (provider.totalWalkingDuration +
                  provider.totalReadingDuration +
                  provider.totalWritingDuration +
                  provider.totalStudyingDuration)
              .toString(),
        ),
        _buildStatCard(
          context,
          'Günlük Ort. Etkinlik',
          _calculateDailyAverage(provider).toString(),
        ),
        _buildStatCard(
          context,
          'En Aktif Gün',
          _findMostActiveDay(provider),
        ),
        _buildStatCard(
          context,
          'Aktif Gün Serisi',
          provider.streakDays.toString(),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityDistribution(
      BuildContext context, ActivityProvider provider) {
    // ActivityType bazında dağılımı gösteren liste
    final Map<ActivityType, int> activityCounts = {
      ActivityType.walking:
          provider.getActivitiesByType(ActivityType.walking).length,
      ActivityType.food: provider.getActivitiesByType(ActivityType.food).length,
      ActivityType.water:
          provider.getActivitiesByType(ActivityType.water).length,
      ActivityType.expense:
          provider.getActivitiesByType(ActivityType.expense).length,
      ActivityType.reading:
          provider.getActivitiesByType(ActivityType.reading).length,
      ActivityType.writing:
          provider.getActivitiesByType(ActivityType.writing).length,
      ActivityType.studying:
          provider.getActivitiesByType(ActivityType.studying).length,
    };

    // Sadece sayısı 0'dan büyük olan aktiviteleri al
    final filteredActivities =
        activityCounts.entries.where((entry) => entry.value > 0).toList();

    // Toplam aktivite sayısı
    final totalActivities =
        filteredActivities.fold(0, (sum, entry) => sum + entry.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aktivite Dağılımı',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            filteredActivities.isEmpty
                ? const Center(
                    child: Text('Henüz yeterli veri yok.'),
                  )
                : Column(
                    children: filteredActivities.map((entry) {
                      final percent = (entry.value / totalActivities * 100)
                          .toStringAsFixed(1);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.getColorForType(entry.key),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${entry.key.name}: ${entry.value} aktivite ($percent%)',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyActivitySummary(
      BuildContext context, ActivityProvider provider) {
    // Son 7 gün için aktivite verilerini hazırla
    final now = DateTime.now();
    final startDate = _getStartDateByPeriod(now);

    // Her gün için aktivitelerin süre toplamlarını hesapla
    final Map<String, Map<ActivityType, int>> dailyActivityDurations = {};

    // Tarih formatı
    final dateFormat = DateFormat('dd/MM');

    // Tarih aralığındaki her günü döngü ile oluştur
    for (int i = 0; i <= _getDayCount(); i++) {
      final date = startDate.add(Duration(days: i));
      final dateStr = dateFormat.format(date);

      dailyActivityDurations[dateStr] = {
        ActivityType.walking: 0,
        ActivityType.reading: 0,
        ActivityType.writing: 0,
        ActivityType.studying: 0,
      };
    }

    // Aktivite sürelerini topla
    for (var activity in provider.activities) {
      final activityDate = activity.date;
      // Sadece başlangıç tarihinden sonraki aktiviteleri al
      if (activityDate.isAfter(startDate) ||
          activityDate.isAtSameMomentAs(startDate)) {
        final dateStr = dateFormat.format(activityDate);

        // Süresi olan aktivite tiplerini kontrol et
        if (activity is WalkingActivity) {
          dailyActivityDurations[dateStr]![ActivityType.walking] =
              (dailyActivityDurations[dateStr]![ActivityType.walking] ?? 0) +
                  activity.duration;
        } else if (activity is ReadingActivity) {
          dailyActivityDurations[dateStr]![ActivityType.reading] =
              (dailyActivityDurations[dateStr]![ActivityType.reading] ?? 0) +
                  activity.duration;
        } else if (activity is WritingActivity) {
          dailyActivityDurations[dateStr]![ActivityType.writing] =
              (dailyActivityDurations[dateStr]![ActivityType.writing] ?? 0) +
                  activity.duration;
        } else if (activity is StudyingActivity) {
          dailyActivityDurations[dateStr]![ActivityType.studying] =
              (dailyActivityDurations[dateStr]![ActivityType.studying] ?? 0) +
                  activity.duration;
        }
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Günlük Aktivite Süresi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Column(
              children: dailyActivityDurations.entries.map((entry) {
                final date = entry.key;
                final durations = entry.value;

                final totalDuration =
                    durations.values.fold(0, (sum, duration) => sum + duration);

                if (totalDuration == 0) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: 1.0,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                              minHeight: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$totalDuration dk',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: durations.entries
                            .where((e) => e.value > 0)
                            .map((e) {
                          return Chip(
                            backgroundColor: AppColors.getColorForType(e.key)
                                .withOpacity(0.2),
                            label: Text(
                              '${e.key.name}: ${e.value} dk',
                              style: TextStyle(
                                color: AppColors.getColorForType(e.key),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            avatar: CircleAvatar(
                              backgroundColor: AppColors.getColorForType(e.key),
                              child: Text(
                                e.key.icon,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  int _calculateDailyAverage(ActivityProvider provider) {
    // Seçilen periyoda göre günlük ortalama aktivite sayısı
    final activities = provider.activities;
    if (activities.isEmpty) return 0;

    // Aktivite olan günleri bul
    final Set<String> activityDays = {};
    for (var activity in activities) {
      final date = activity.date;
      activityDays.add(DateFormat('yyyy-MM-dd').format(date));
    }

    if (activityDays.isEmpty) return 0;
    return (activities.length / activityDays.length).round();
  }

  String _findMostActiveDay(ActivityProvider provider) {
    // En çok aktivite olan günü bul
    final activities = provider.activities;
    if (activities.isEmpty) return '-';

    // Günlere göre aktivite sayısını say
    final Map<String, int> activityCounts = {};
    for (var activity in activities) {
      final dateStr = DateFormat('dd/MM').format(activity.date);
      activityCounts[dateStr] = (activityCounts[dateStr] ?? 0) + 1;
    }

    // En çok aktivite olan günü bul
    String mostActiveDay = '-';
    int maxCount = 0;

    activityCounts.forEach((date, count) {
      if (count > maxCount) {
        maxCount = count;
        mostActiveDay = date;
      }
    });

    return mostActiveDay;
  }

  DateTime _getStartDateByPeriod(DateTime now) {
    switch (_selectedPeriod) {
      case 'week':
        // Pazartesi gününü bul
        final weekday = now.weekday;
        return now.subtract(Duration(days: weekday - 1));
      case 'month':
        // Ayın ilk günü
        return DateTime(now.year, now.month, 1);
      case 'all':
      default:
        // Son 30 gün
        return now.subtract(const Duration(days: 30));
    }
  }

  int _getDayCount() {
    switch (_selectedPeriod) {
      case 'week':
        return 6; // Pazartesi-Pazar: 7 gün
      case 'month':
        // Mevcut ayın gün sayısı
        final now = DateTime.now();
        return DateTime(now.year, now.month + 1, 0).day - 1;
      case 'all':
      default:
        return 30;
    }
  }
}