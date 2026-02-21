import 'package:flutter/material.dart';

enum SortCriteria { amountHighToLow, amountLowToHigh, dateLastUsed, nameAZ }

class SortSelector extends StatelessWidget {
  final SortCriteria selectedCriteria;
  final Function(SortCriteria) onCriteriaChanged;

  const SortSelector({
    super.key,
    required this.selectedCriteria,
    required this.onCriteriaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(
            Icons.sort,
            size: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          const Text(
            'Sortierung:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: SortCriteria.values.map((criteria) {
                  final isSelected = selectedCriteria == criteria;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        _getCriteriaLabel(criteria),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onTertiary
                              : null,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Theme.of(context).colorScheme.tertiary,
                      onSelected: (selected) {
                        if (selected) {
                          onCriteriaChanged(criteria);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCriteriaLabel(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.amountHighToLow:
        return 'Betrag (Hoch → Tief)';
      case SortCriteria.amountLowToHigh:
        return 'Betrag (Tief → Hoch)';
      case SortCriteria.dateLastUsed:
        return 'Datum (Neu → Alt)';
      case SortCriteria.nameAZ:
        return 'Name (A → Z)';
    }
  }
}
