import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

/// An expandable tile for a specific category containing individual expense items.
/// Supports long-press for editing/deleting.
class CategoryExpansionTile extends StatelessWidget {
  final String category;
  final double total;
  final List<Expense> expenses;
  final Function(Expense) onEdit;
  final Function(int) onDelete;

  const CategoryExpansionTile({
    super.key,
    required this.category,
    required this.total,
    required this.expenses,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            category[0].toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          '${total.toStringAsFixed(2)} €',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        children: expenses
            .map(
              (e) => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                title: Row(
                  children: [
                    Text(
                      DateFormat('dd. MMMM yyyy', 'de_DE').format(e.date),
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (e.isRecurring) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.repeat,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ],
                ),
                subtitle: e.note != null
                    ? Text(
                        e.note!,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      )
                    : null,
                trailing: Text(
                  '${e.amount.toStringAsFixed(2)} €',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onLongPress: () => _handleLongPress(context, e),
              ),
            )
            .toList(),
      ),
    );
  }

  void _handleLongPress(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eintrag verwalten'),
        content: const Text('Was möchten Sie mit diesem Eintrag tun?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onEdit(expense);
            },
            child: const Text('Bearbeiten'),
          ),
          TextButton(
            onPressed: () {
              onDelete(expense.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }
}
