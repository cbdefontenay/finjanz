import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../components/comparison_bar_chart.dart';
import '../components/total_spending_card.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final List<DateTime> _selectedMonths = [
    DateTime(DateTime.now().year, DateTime.now().month),
    DateTime(DateTime.now().year, DateTime.now().month - 1),
  ];
  Set<String> _selectedCategories = {};
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final categories = context.read<ExpenseProvider>().categories;
      _selectedCategories = Set.from(categories);
      _isInitialized = true;
    }
  }

  void _toggleMonth(DateTime month) {
    setState(() {
      final normalized = DateTime(month.year, month.month);
      if (_selectedMonths.any(
        (m) => m.year == normalized.year && m.month == normalized.month,
      )) {
        if (_selectedMonths.length > 1) {
          _selectedMonths.removeWhere(
            (m) => m.year == normalized.year && m.month == normalized.month,
          );
        }
      } else {
        _selectedMonths.add(normalized);
        _selectedMonths.sort((a, b) => b.compareTo(a));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final comparisonData = expenseProvider.getComparisonData(
      _selectedMonths,
      _selectedCategories.toList(),
    );

    double totalAmount = 0;
    for (var monthData in comparisonData.values) {
      totalAmount += monthData.values.fold(0.0, (sum, val) => sum + val);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: BackButton(color: Theme.of(context).colorScheme.onTertiary),
        title: Text(
          'Vergleichs-Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMonthPickerHeader(),
            const SizedBox(height: 16),
            _buildCategoryFilter(expenseProvider.categories),
            TotalSpendingCard(total: totalAmount),
            _buildChartSection(comparisonData),
            _buildRankingSection(comparisonData),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPickerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Text(
            'MONATE VERGLEICHEN',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 12, // Last 12 months
              itemBuilder: (context, index) {
                final date = DateTime(
                  DateTime.now().year,
                  DateTime.now().month - index,
                );
                final isSelected = _selectedMonths.any(
                  (m) => m.year == date.year && m.month == date.month,
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(DateFormat('MMM yy', 'de_DE').format(date)),
                    selected: isSelected,
                    selectedColor: Colors.white,
                    checkmarkColor: Theme.of(context).colorScheme.tertiary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.tertiary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    backgroundColor: Colors.white12,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected ? Colors.white : Colors.white24,
                      ),
                    ),
                    onSelected: (_) => _toggleMonth(date),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(List<String> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            'KATEGORIEN WÄHLEN',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategories.contains(cat);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) => setState(() {
                    selected
                        ? _selectedCategories.add(cat)
                        : _isMonthCategorySelected(cat)
                        ? _selectedCategories.remove(cat)
                        : null;

                    // Don't allow 0 categories
                    if (_selectedCategories.isEmpty) {
                      _selectedCategories.add(cat);
                    }
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isMonthCategorySelected(String cat) {
    return _selectedCategories.length > 1;
  }

  Widget _buildChartSection(Map<String, Map<String, double>> comparisonData) {
    final monthKeys = comparisonData.keys.toList().reversed.toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vergleichsanalyse',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                child: ComparisonBarChart(
                  data: comparisonData,
                  categories: _selectedCategories.toList(),
                  months: monthKeys,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingSection(Map<String, Map<String, double>> comparisonData) {
    // Show a summary of totals per category across all selected periods
    final aggregateTotals = <String, double>{};
    for (var monthData in comparisonData.values) {
      monthData.forEach((cat, amount) {
        aggregateTotals[cat] = (aggregateTotals[cat] ?? 0) + amount;
      });
    }

    final sortedEntries = aggregateTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalValue = aggregateTotals.values.fold(
      0.0,
      (sum, val) => sum + val,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Text(
              'Gesamtübersicht (Gewählter Zeitraum)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ...sortedEntries.map((entry) {
            final percentage = totalValue > 0 ? entry.value / totalValue : 0.0;
            final color = context.read<ExpenseProvider>().getCategoryColor(
              entry.key,
            );

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: LinearProgressIndicator(
                  value: percentage,
                  color: color,
                  backgroundColor: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                trailing: Text(
                  '${entry.value.toStringAsFixed(2)} €',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
