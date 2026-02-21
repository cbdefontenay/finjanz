import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class ComparisonBarChart extends StatelessWidget {
  final Map<String, Map<String, double>> data;
  final List<String> categories;
  final List<String> months;

  const ComparisonBarChart({
    super.key,
    required this.data,
    required this.categories,
    required this.months,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || categories.isEmpty) {
      return const Center(child: Text('Keine Daten zum Vergleichen'));
    }

    final provider = context.read<ExpenseProvider>();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY() * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${months[groupIndex]}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text:
                        '${categories[rodIndex]}: ${rod.toY.toStringAsFixed(2)} €',
                    style: TextStyle(
                      color: provider.getCategoryColor(categories[rodIndex]),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      months[value.toInt()],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withAlpha(50), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(months.length, (monthIndex) {
          final monthName = months[monthIndex];
          return BarChartGroupData(
            x: monthIndex,
            barRods: List.generate(categories.length, (catIndex) {
              final cat = categories[catIndex];
              final amount = data[monthName]?[cat] ?? 0.0;
              return BarChartRodData(
                toY: amount,
                color: provider.getCategoryColor(cat),
                width: 16,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  double _getMaxY() {
    double max = 0;
    for (var monthData in data.values) {
      for (var val in monthData.values) {
        if (val > max) max = val;
      }
    }
    return max == 0 ? 10 : max;
  }
}
