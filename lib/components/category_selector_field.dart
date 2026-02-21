import 'package:flutter/material.dart';

/// A field that allows selecting an existing category or adding a new one.
class CategorySelectorField extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final bool isAddingNew;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String?) onCategoryChanged;
  final Function() onToggleAddMode;

  const CategorySelectorField({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.isAddingNew,
    required this.controller,
    required this.focusNode,
    required this.onCategoryChanged,
    required this.onToggleAddMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isAddingNew
            ? TextFormField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Neue Kategorie',
                  prefixIcon: const Icon(Icons.add_box_outlined),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onToggleAddMode,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (isAddingNew && (value == null || value.isEmpty)) {
                    return 'Pflichtfeld';
                  }
                  return null;
                },
              )
            : DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategorie',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  ...categories.map(
                    (c) => DropdownMenuItem(value: c, child: Text(c)),
                  ),
                  const DropdownMenuItem(
                    value: 'NEW_CATEGORY',
                    child: Text(
                      '+ Neue Kategorie hinzufügen',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
                onChanged: onCategoryChanged,
              ),
      ),
    );
  }
}
