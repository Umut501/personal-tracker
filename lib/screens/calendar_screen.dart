import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../widgets/calendar_day.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_activity_message.dart';
import '../utils/constants.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCalendarHeader(context, provider),
              const SizedBox(height: 16),
              _buildCalendarGrid(context, provider),
              const SizedBox(height: 16),
              _buildSelectedDayActivities(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendarHeader(BuildContext context, ActivityProvider provider) {
    final currentMonth = provider.currentMonth;
    final monthName = DateFormat('MMMM yyyy', 'tr_TR').format(currentMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            final previousMonth = DateTime(
              currentMonth.year,
              currentMonth.month - 1,
              1,
            );
            provider.setCurrentMonth(previousMonth);
          },
        ),
        Text(
          monthName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            final nextMonth = DateTime(
              currentMonth.year,
              currentMonth.month + 1,
              1,
            );
            provider.setCurrentMonth(nextMonth);
          },
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(BuildContext context, ActivityProvider provider) {
    final currentMonth = provider.currentMonth;
    final today = DateTime.now();
    final selectedDate = provider.selectedDate;

    // Pazartesi gününden başlayarak gün adlarını yazdır
    final dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    // Ayın ilk günü
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);

    // Ayın ilk günü haftanın hangi günü
    // Pazartesi: 1, Salı: 2, ..., Pazar: 7 olarak alıyoruz
    int dayOffset = firstDayOfMonth.weekday;

    // Ayın son günü
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Önceki ayın son günleri
    final daysInPrevMonth =
        DateTime(currentMonth.year, currentMonth.month, 0).day;

    List<Widget> calendarDays = [];

    // Gün adlarını ekle
    for (var dayName in dayNames) {
      calendarDays.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: Text(
            dayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // Önceki ayın günlerini ekle
    for (var i = 0; i < dayOffset - 1; i++) {
      final day = daysInPrevMonth - (dayOffset - 2) + i;
      final date = DateTime(
        currentMonth.year,
        currentMonth.month - 1,
        day,
      );

      calendarDays.add(
        CalendarDay(
          day: day,
          isToday: false,
          isSelected: false,
          isCurrentMonth: false,
          activityTypes: provider.getDayActivityTypes(date),
          onTap: () {
            provider.setSelectedDate(date);
          },
        ),
      );
    }

    // Mevcut ayın günlerini ekle
    for (var i = 1; i <= daysInMonth; i++) {
      final date = DateTime(currentMonth.year, currentMonth.month, i);

      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;

      final isSelected = date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;

      calendarDays.add(
        CalendarDay(
          day: i,
          isToday: isToday,
          isSelected: isSelected,
          isCurrentMonth: true,
          activityTypes: provider.getDayActivityTypes(date),
          onTap: () {
            provider.setSelectedDate(date);
          },
        ),
      );
    }

    // Sonraki ayın günlerini ekle
    final remainingDays = 7 - (calendarDays.length % 7);
    if (remainingDays < 7) {
      for (var i = 1; i <= remainingDays; i++) {
        final date = DateTime(
          currentMonth.year,
          currentMonth.month + 1,
          i,
        );

        calendarDays.add(
          CalendarDay(
            day: i,
            isToday: false,
            isSelected: false,
            isCurrentMonth: false,
            activityTypes: provider.getDayActivityTypes(date),
            onTap: () {
              provider.setSelectedDate(date);
            },
          ),
        );
      }
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: calendarDays,
    );
  }

  Widget _buildSelectedDayActivities(
      BuildContext context, ActivityProvider provider) {
    final selectedDate = provider.selectedDate;
    final selectedActivities = provider.selectedDateActivities;
    final formattedDate =
        DateFormat('d MMMM yyyy', 'tr_TR').format(selectedDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seçili Gün Aktiviteleri - $formattedDate',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            selectedActivities.isEmpty
                ? const EmptyActivityMessage(
                    message: 'Bu günde aktivite kaydı bulunmuyor.',
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedActivities.length,
                    itemBuilder: (context, index) {
                      return ActivityCard(
                        activity: selectedActivities[index],
                        showDate: false,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
