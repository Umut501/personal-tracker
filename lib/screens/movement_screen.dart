import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_form.dart';
import '../widgets/empty_activity_message.dart';
import '../widgets/notification.dart';

class MovementScreen extends StatefulWidget {
  const MovementScreen({Key? key}) : super(key: key);

  @override
  State<MovementScreen> createState() => _MovementScreenState();
}

class _MovementScreenState extends State<MovementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, provider, child) {
        final walkingActivities =
            provider.getActivitiesByType(ActivityType.walking);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildForm(context, provider),
              const SizedBox(height: 16),
              _buildHistory(context, walkingActivities, provider),
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
                'Hareket Takibi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ActivityFormField(
                label: 'Yürüme Süresi (dk)',
                controller: _durationController,
                keyboardType: TextInputType.number,
                hintText: 'Kaç dakika yürüdünüz?',
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
              'Yürüyüş Geçmişi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            activities.isEmpty
                ? const EmptyActivityMessage(
                    message: 'Henüz yürüyüş kaydı bulunmuyor.',
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
      final duration = int.parse(_durationController.text);

      final activity = WalkingActivity(
        date: DateTime.now(),
        duration: duration,
      );

      provider.addActivity(activity);

      _durationController.clear();

      AppNotification.show(context, 'Yürüyüş kaydedildi!');
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
