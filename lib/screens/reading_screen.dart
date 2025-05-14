import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_form.dart';
import '../widgets/empty_activity_message.dart';
import '../widgets/notification.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({Key? key}) : super(key: key);

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bookController = TextEditingController();
  final _timeController = TextEditingController();
  final _pagesController = TextEditingController();

  @override
  void dispose() {
    _bookController.dispose();
    _timeController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, provider, child) {
        final readingActivities =
            provider.getActivitiesByType(ActivityType.reading);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildForm(context, provider),
              const SizedBox(height: 16),
              _buildHistory(context, readingActivities, provider),
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
                'Kitap Okuma Takibi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ActivityFormField(
                label: 'Kitap Adı',
                controller: _bookController,
                hintText: 'Hangi kitabı okuyorsunuz?',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kitap adı girin';
                  }
                  return null;
                },
              ),
              ActivityFormField(
                label: 'Okuma Süresi (dk)',
                controller: _timeController,
                keyboardType: TextInputType.number,
                hintText: 'Kaç dakika okudunuz?',
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
                label: 'Okunan Sayfa Sayısı',
                controller: _pagesController,
                keyboardType: TextInputType.number,
                hintText: 'Kaç sayfa okudunuz?',
                minValue: 1,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null || int.parse(value) < 1) {
                      return 'Geçerli bir sayfa sayısı girin';
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
              'Okuma Geçmişi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            activities.isEmpty
                ? const EmptyActivityMessage(
                    message: 'Henüz okuma kaydı bulunmuyor.',
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
      final book = _bookController.text.trim();
      final duration = int.parse(_timeController.text);
      final pages = _pagesController.text.isNotEmpty
          ? int.parse(_pagesController.text)
          : null;

      final activity = ReadingActivity(
        date: DateTime.now(),
        book: book,
        duration: duration,
        pages: pages,
      );

      provider.addActivity(activity);

      _bookController.clear();
      _timeController.clear();
      _pagesController.clear();

      AppNotification.show(context, 'Okuma kaydedildi!');
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
