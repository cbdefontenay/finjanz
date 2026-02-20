import 'package:flutter/material.dart';

/// A premium-looking card to display the total amount spent.
/// Features a gradient background and subtle shadows.
class TotalSpendingCard extends StatelessWidget {
  final double total;

  const TotalSpendingCard({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.tertiary.withAlpha(1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
              'Gesamtausgaben',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(1),
                fontSize: 16,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${total.toStringAsFixed(2)} €',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
