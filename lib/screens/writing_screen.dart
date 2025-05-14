import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_form.dart';
import '../widgets/empty_activity_message.dart';
import '../widgets/notification.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({Key? key}) : super(key: key);

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectController = TextEditingController();
  final _timeController = TextEditingController();
  final _wordsController = TextEditingController();

  @override
  void dispose() {
    _projectController.dispose();
    _timeController.dispose();
    _wordsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, provider, child) {
        final writingActivities =
            provider.getActivitiesByType(ActivityType.writing);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildForm(context, provider),
              const SizedBox(height: 16),
              _buildHistory(context, writingActivities, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, ActivityProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kitap Yazma Takibi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ActivityFormField(
                label: 'Proje Adı',
                controller: _projectController,
                hintText: 'Hangi projeyi yazıyorsunuz?',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen proje adı girin';
                  }
                  return null;
                },
              ),
              ActivityFormField(
                label: 'Yazma Süresi (dk)',
                controller: _timeController,
                keyboardType: TextInputType.number,
                hintText: 'Kaç dakika yazdınız?',
                minValue: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen süre girin';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Geçerli bir süre girin';
                  }
                  return null;
                },
              ),
              ActivityFormField(
                label: 'Yazılan Kelime Sayısı',
                controller: _wordsController,
                keyboardType: TextInputType.number,
                hintText: 'Kaç kelime yazdınız?',
                minValue: 1,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null || int.parse(value) < 1) {
                      return 'Geçerli bir kelime sayısı girin';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveActivity(context, provider),
                  child: const Text('Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistory(
    BuildContext context,
    List<Activity> activities,
    ActivityProvider provider,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yazma Geçmişi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            activities.isEmpty
                ? const EmptyActivityMessage(
                    message: 'Henüz yazma kaydı bulunmuyor.',
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return ActivityCard(
                        activity: activities[index],
                        onDelete: () => _deleteActivity(
                            context, activities[index], provider),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _saveActivity(BuildContext context, ActivityProvider provider) {
    if (_formKey.currentState!.validate()) {
      final project = _projectController.text.trim();
      final duration = int.parse(_timeController.text);
      final words = _wordsController.text.isNotEmpty
          ? int.parse(_wordsController.text)
          : null;

      final activity = WritingActivity(
        date: DateTime.now(),
        project: project,
        duration: duration,
        words: words,
      );

      provider.addActivity(activity);

      _projectController.clear();
      _timeController.clear();
      _wordsController.clear();

      AppNotification.show(context, 'Yazma kaydedildi!');
    }
  }

  void _deleteActivity(
    BuildContext context,
    Activity activity,
    ActivityProvider provider,
  ) {
    provider.deleteActivity(activity);
    AppNotification.show(context, 'Kayıt silindi!');
  }
}
