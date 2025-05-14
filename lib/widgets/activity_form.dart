import 'package:flutter/material.dart';
import '../models/activity_type.dart';
import '../utils/constants.dart';

class ActivityFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? hintText;
  final double? minValue;
  final double? step;

  const ActivityFormField({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.hintText,
    this.minValue,
    this.step,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (minValue != null && value.isNotEmpty) {
            final numValue = double.tryParse(value);
            if (numValue != null && numValue < minValue!) {
              controller.text = minValue.toString();
            }
          }
        },
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final String label;
  final String value;
  final Function(String?) onChanged;
  final List<Map<String, dynamic>> items;

  const CategoryDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item['id'],
            child: Text(item['name']),
          );
        }).toList(),
      ),
    );
  }
}
