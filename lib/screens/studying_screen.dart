import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_form.dart';
import '../widgets/empty_activity_message.dart';
import '../widgets/notification.dart';

class StudyingScreen extends StatefulWidget {
  const StudyingScreen({Key? key}) : super(key: key);

  @override
  State<StudyingScreen> createState() => _StudyingScreenState();
}

class _StudyingScreenState extends State<StudyingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, provider, child) {
        final studyingActivities =
            provider.getActivitiesByType(ActivityType.studying);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildForm(context, provider),
              const SizedBox(height: 16),
              _buildHistory(context, studyingActivities, provider),
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
                'Ders Çalışma Takibi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ActivityFormField(
                label: 'Ders Konusu',
                controller: _subjectController,
                hintText: 'Hangi konuyu çalışıyorsunuz?',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen konu girin';
                  }
                  return null;
                },
              ),
              ActivityFormField(
                label: 'Çalışma Süresi (dk)',
                controller: _timeController,
                keyboardType: TextInputType.number,
                hintText: 'Kaç dakika çalıştınız?',
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
              'Ders Çalışma Geçmişi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            activities.isEmpty
                ? const EmptyActivityMessage(
                    message: 'Henüz ders çalışma kaydı bulunmuyor.',
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
      final subject = _subjectController.text.trim();
      final duration = int.parse(_timeController.text);

      final activity = StudyingActivity(
        date: DateTime.now(),
        subject: subject,
        duration: duration,
      );

      provider.addActivity(activity);

      _subjectController.clear();
      _timeController.clear();

      AppNotification.show(context, 'Ders çalışma kaydedildi!');
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
