import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../components/category_pie_chart.dart';
import '../components/category_bar_chart.dart';
import '../components/total_spending_card.dart';

enum ChartType { pie, bar }

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime _selectedDate = DateTime.now();
  bool _isMonthly = true;
  ChartType _chartType = ChartType.pie;
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

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final allExpenses = _isMonthly
        ? expenseProvider.getMonthlyExpenses(_selectedDate)
        : expenseProvider.expenses
              .where((e) => e.date.year == _selectedDate.year)
              .toList();

    final filteredExpenses = allExpenses
        .where((e) => _selectedCategories.contains(e.category))
        .toList();
    final categoryTotals = expenseProvider.getCategoryTotals(filteredExpenses);
    final totalAmount = categoryTotals.values.fold(
      0.0,
      (sum, val) => sum + val,
    );

    final String dateLabel = _isMonthly
        ? DateFormat('MMMM yyyy', 'de_DE').format(_selectedDate)
        : _selectedDate.year.toString();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Expert Analysen',
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onTertiary),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCustomHeader(dateLabel),
            const SizedBox(height: 16),
            _buildCategoryFilter(expenseProvider.categories),
            TotalSpendingCard(total: totalAmount),
            _buildChartSection(categoryTotals),
            _buildRankingSection(categoryTotals, totalAmount),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(String dateLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => setState(() {
                  if (_isMonthly) {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month - 1,
                    );
                  } else {
                    _selectedDate = DateTime(_selectedDate.year - 1);
                  }
                }),
              ),
              Text(
                dateLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () => setState(() {
                  if (_isMonthly) {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month + 1,
                    );
                  } else {
                    _selectedDate = DateTime(_selectedDate.year + 1);
                  }
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SegmentedButton<bool>(
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: Theme.of(context).colorScheme.tertiary,
                selectedForegroundColor: Theme.of(context).colorScheme.onTertiary,
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white24),
              ),
              segments: const [
                ButtonSegment(value: true, label: Text('Monat')),
                ButtonSegment(value: false, label: Text('Jahr')),
              ],
              selected: {_isMonthly},
              onSelectionChanged: (val) =>
                  setState(() => _isMonthly = val.first),
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
            'KATEGORIEN FILTERN',
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
                        : _selectedCategories.remove(cat);
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(Map<String, double> categoryTotals) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Visualisierung',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(12),
                    constraints: const BoxConstraints(
                      minHeight: 32,
                      minWidth: 48,
                    ),
                    isSelected: [
                      _chartType == ChartType.pie,
                      _chartType == ChartType.bar,
                    ],
                    onPressed: (index) => setState(
                      () => _chartType = index == 0
                          ? ChartType.pie
                          : ChartType.bar,
                    ),
                    children: const [
                      Icon(Icons.pie_chart_outline, size: 20),
                      Icon(Icons.bar_chart_outlined, size: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _chartType == ChartType.pie
                    ? CategoryPieChart(categoryTotals: categoryTotals)
                    : SizedBox(
                        height: 300,
                        child: CategoryBarChart(categoryTotals: categoryTotals),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingSection(Map<String, double> totals, double totalAmount) {
    if (totals.isEmpty) return const SizedBox();

    final sortedEntries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Text(
              'Kategorie-Ranking',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ...sortedEntries.map((entry) {
            final percentage = entry.value / totalAmount;
            final color = context.read<ExpenseProvider>().getCategoryColor(
              entry.key,
            );

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${entry.value.toStringAsFixed(2)} €',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: color.withValues(
                          alpha: 32,),
                        color: color,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
