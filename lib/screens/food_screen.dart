import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_form.dart';
import '../widgets/empty_activity_message.dart';
import '../widgets/notification.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, provider, child) {
        final foodActivities = provider.getActivitiesByType(ActivityType.food);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildForm(context, provider),
              const SizedBox(height: 16),
              _buildHistory(context, foodActivities, provider),
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
                'Beslenme Takibi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ActivityFormField(
                label: 'Yiyecek/İçecek',
                controller: _nameController,
                hintText: 'Ne yediniz/içtiniz?',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir şeyler girin';
                  }
                  return null;
                },
              ),
              ActivityFormField(
                label: 'Miktar',
                controller: _amountController,
                hintText: 'Miktar (ör: 1 porsiyon, 200gr)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen miktar girin';
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
              'Beslenme Geçmişi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            activities.isEmpty
                ? const EmptyActivityMessage(
                    message: 'Henüz beslenme kaydı bulunmuyor.',
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
      final activity = FoodActivity(
        date: DateTime.now(),
        name: _nameController.text.trim(),
        amount: _amountController.text.trim(),
      );

      provider.addActivity(activity);

      _nameController.clear();
      _amountController.clear();

      AppNotification.show(context, 'Beslenme kaydedildi!');
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
