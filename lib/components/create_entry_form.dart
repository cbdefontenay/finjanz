import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'category_selector_field.dart';

class CreateEntryForm extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final bool isAddingNewCategory;
  final TextEditingController categoryController;
  final TextEditingController noteController;
  final FocusNode categoryFocusNode;
  final DateTime selectedDate;
  final VoidCallback onSelectDate;
  final Function(String?) onCategoryChanged;
  final VoidCallback onToggleAddMode;
  final VoidCallback onSubmit;

  const CreateEntryForm({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.isAddingNewCategory,
    required this.categoryController,
    required this.noteController,
    required this.categoryFocusNode,
    required this.selectedDate,
    required this.onSelectDate,
    required this.onCategoryChanged,
    required this.onToggleAddMode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CategorySelectorField(
            categories: categories,
            selectedCategory: selectedCategory,
            isAddingNew: isAddingNewCategory,
            controller: categoryController,
            focusNode: categoryFocusNode,
            onCategoryChanged: onCategoryChanged,
            onToggleAddMode: onToggleAddMode,
          ),
          const SizedBox(height: 20),
          _buildDatePicker(context),
          const SizedBox(height: 20),
          TextFormField(
            controller: noteController,
            decoration: InputDecoration(
              labelText: 'Beschreibung',
              prefixIcon: const Icon(Icons.notes),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: onSubmit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Eintrag Speichern',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: onSelectDate,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Datum',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  DateFormat('dd. MMMM yyyy', 'de_DE').format(selectedDate),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
