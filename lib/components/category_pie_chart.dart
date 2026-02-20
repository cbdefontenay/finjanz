import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

/// A professional pie chart to visualize expense distribution by category.
class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryTotals;

  const CategoryPieChart({super.key, required this.categoryTotals});

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return const Center(
        child: Text('Keine Daten für diesen Zeitraum verfügbar.'),
      );
    }

    final provider = context.read<ExpenseProvider>();
    final total = categoryTotals.values.fold(0.0, (sum, val) => sum + val);
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              sections: sortedEntries.asMap().entries.map((entry) {
                final category = entry.value.key;
                final value = entry.value.value;
                final percentage = (value / total * 100).toStringAsFixed(1);
                final color = provider.getCategoryColor(category);

                return PieChartSectionData(
                  color: color,
                  value: value,
                  title: '$percentage%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  badgeWidget: _Badge(
                    category[0].toUpperCase(),
                    size: 30,
                    borderColor: color,
                  ),
                  badgePositionPercentageOffset: 0.98,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: sortedEntries.map((entry) {
            final category = entry.key;
            final value = entry.value;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: provider.getCategoryColor(category),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$category: ${value.toStringAsFixed(2)} €',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final double size;
  final Color borderColor;

  const _Badge(this.text, {required this.size, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 3),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: size * .5,
            fontWeight: FontWeight.bold,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}
