import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../services/export_service.dart';
import '../components/total_spending_card.dart';
import '../components/category_expansion_tile.dart';

enum OverviewViewType { monthly, weekly }

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  DateTime _currentDate = DateTime.now();
  OverviewViewType _viewType = OverviewViewType.monthly;
  final ExportService _exportService = ExportService();

  void _next() {
    setState(() {
      if (_viewType == OverviewViewType.monthly) {
        _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
      } else {
        _currentDate = _currentDate.add(const Duration(days: 7));
      }
    });
  }

  void _previous() {
    setState(() {
      if (_viewType == OverviewViewType.monthly) {
        _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
      } else {
        _currentDate = _currentDate.subtract(const Duration(days: 7));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final List<Expense> filteredExpenses = _viewType == OverviewViewType.monthly
        ? expenseProvider.getMonthlyExpenses(_currentDate)
        : expenseProvider.getWeeklyExpenses(_currentDate);

    final categoryTotals = expenseProvider.getCategoryTotals(filteredExpenses);
    final totalAmount = categoryTotals.values.fold(
      0.0,
      (sum, item) => sum + item,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Übersicht',
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () => _showExportDialogChoice(context, filteredExpenses),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          TotalSpendingCard(total: totalAmount),
          Expanded(
            child: ListView.builder(
              itemCount: categoryTotals.length,
              itemBuilder: (context, index) {
                final category = categoryTotals.keys.elementAt(index);
                final total = categoryTotals[category]!;
                final categoryExpenses = filteredExpenses
                    .where((e) => e.category == category)
                    .toList();

                return CategoryExpansionTile(
                  category: category,
                  total: total,
                  expenses: categoryExpenses,
                  onEdit: (e) => _showEditDialog(context, e),
                  onDelete: (id) =>
                      context.read<ExpenseProvider>().deleteExpense(id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Expense expense) {
    final amountController = TextEditingController(
      text: expense.amount.toString(),
    );
    final noteController = TextEditingController(text: expense.note ?? '');
    String selectedCategory = expense.category;
    DateTime selectedDate = expense.date;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Eintrag bearbeiten'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Betrag (€)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  items: context
                      .read<ExpenseProvider>()
                      .categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedCategory = value!),
                  decoration: const InputDecoration(labelText: 'Kategorie'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Datum'),
                  subtitle: Text(DateFormat('dd.MM.yyyy').format(selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                ),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Notiz'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                final updated = Expense(
                  id: expense.id,
                  amount: double.parse(amountController.text),
                  category: selectedCategory,
                  date: selectedDate,
                  note: noteController.text.isEmpty
                      ? null
                      : noteController.text,
                );
                context.read<ExpenseProvider>().updateExpense(updated);
                Navigator.pop(ctx);
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialogChoice(
    BuildContext context,
    List<Expense> currentViewExpenses,
  ) {
    final expenseProvider = context.read<ExpenseProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exportieren'),
        content: const Text('Welchen Zeitraum möchten Sie exportieren?'),
        actions: [
          TextButton(
            onPressed: () {
              _exportService.exportExpensesToCsv(
                currentViewExpenses,
                fileName:
                    'Finanzen_${DateFormat('yyyy_MM_dd').format(_currentDate)}',
              );
              Navigator.pop(ctx);
            },
            child: const Text('Aktuelle Ansicht'),
          ),
          TextButton(
            onPressed: () {
              final now = DateTime.now();
              final data = expenseProvider.expenses
                  .where((e) => e.date.year == now.year)
                  .toList();
              _exportService.exportExpensesToCsv(
                data,
                fileName: 'Finanzen_Jahr_${now.year}',
              );
              Navigator.pop(ctx);
            },
            child: const Text('Dieses Jahr'),
          ),
          TextButton(
            onPressed: () {
              _exportService.exportExpensesToCsv(
                expenseProvider.expenses,
                fileName: 'Finanzen_Alle',
              );
              Navigator.pop(ctx);
            },
            child: const Text('Alle'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    String dateLabel = _viewType == OverviewViewType.monthly
        ? DateFormat('MMMM yyyy', 'de_DE').format(_currentDate)
        : 'KW ${DateFormat('w').format(_currentDate)}, ${DateFormat('yyyy').format(_currentDate)}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          SegmentedButton<OverviewViewType>(
            segments: const [
              ButtonSegment(
                value: OverviewViewType.monthly,
                label: Text('Monat'),
              ),
              ButtonSegment(
                value: OverviewViewType.weekly,
                label: Text('Woche'),
              ),
            ],
            selected: {_viewType},
            onSelectionChanged: (Set<OverviewViewType> newSelection) {
              setState(() {
                _viewType = newSelection.first;
                // If switching to weekly, ensure we start at a normalized date
                if (_viewType == OverviewViewType.weekly) {
                  _currentDate = DateTime.now();
                }
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previous,
              ),
              Text(dateLabel, style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _next,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
