import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/database_service.dart';

class ExpenseProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Expense> _expenses = [];
  List<String> _categories = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;

  ExpenseProvider() {
    loadExpenses();
    loadCategories();
  }
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();
    _expenses = await _dbService.getExpenses();

    bool addedNew = false;
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    final recurringExpenses = _expenses.where((e) => e.isRecurring).toList();
    for (var expense in recurringExpenses) {
      var d = DateTime(expense.date.year, expense.date.month + 1);
      while (d.isBefore(currentMonth) || d.isAtSameMomentAs(currentMonth)) {
        final exists = _expenses.any((e) =>
            e.category == expense.category &&
            e.amount == expense.amount &&
            e.isRecurring == true &&
            e.date.year == d.year &&
            e.date.month == d.month);

        if (!exists) {
          // Create for this month
          // Adjust day if month doesn't have that day (e.g. Feb 30 -> Feb 28)
          int day = expense.date.day;
          final lastDayOfMonth = DateTime(d.year, d.month + 1, 0).day;
          if (day > lastDayOfMonth) {
            day = lastDayOfMonth;
          }

          final newExpense = Expense(
            category: expense.category,
            amount: expense.amount,
            date: DateTime(d.year, d.month, day),
            note: expense.note,
            isRecurring: true,
          );
          await _dbService.insertExpense(newExpense);
          addedNew = true;
        }

        d = DateTime(d.year, d.month + 1);
      }
    }

    if (addedNew) {
      _expenses = await _dbService.getExpenses();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _categories = await _dbService.getCategories();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _dbService.insertExpense(expense);
    await loadExpenses();
    await loadCategories();
  }

  Future<void> deleteExpense(int id) async {
    await _dbService.deleteExpense(id);
    await loadExpenses();
    await loadCategories();
  }

  Future<void> updateExpense(Expense expense) async {
    await _dbService.updateExpense(expense);
    await loadExpenses();
    await loadCategories();
  }

  List<Expense> getMonthlyExpenses(DateTime month) {
    return _expenses
        .where((e) => e.date.year == month.year && e.date.month == month.month)
        .toList();
  }

  List<Expense> getWeeklyExpenses(DateTime date) {
    // Normalize to the start of the week (Monday) at 00:00:00
    final startOfWeek = DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return _expenses.where((e) {
      final expenseDate = DateTime(e.date.year, e.date.month, e.date.day);
      return (expenseDate.isAtSameMomentAs(startOfWeek) ||
              expenseDate.isAfter(startOfWeek)) &&
          expenseDate.isBefore(endOfWeek);
    }).toList();
  }

  Map<String, double> getCategoryTotals(List<Expense> expenses) {
    final totals = <String, double>{};
    for (var e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  Color getCategoryColor(String category) {
    final List<Color> palette = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.indigo,
      Colors.lime,
      Colors.brown,
    ];

    // Hash the string to get a consistent index
    int hash = 0;
    for (int i = 0; i < category.length; i++) {
      hash = category.codeUnitAt(i) + ((hash << 5) - hash);
    }

    return palette[hash.abs() % palette.length];
  }

  Future<void> renameCategory(String oldName, String newName) async {
    await _dbService.renameCategory(oldName, newName);
    await loadExpenses();
    await loadCategories();
  }

  Future<void> deleteCategory(String category) async {
    await _dbService.deleteCategory(category);
    await loadExpenses();
    await loadCategories();
  }

  Map<String, Map<String, double>> getComparisonData(
    List<DateTime> months,
    List<String> selectedCategories,
  ) {
    final comparisonData = <String, Map<String, double>>{};

    for (var month in months) {
      final monthKey = DateFormat('MMM yy', 'de_DE').format(month);
      final monthlyExpenses = getMonthlyExpenses(month);
      final totals = <String, double>{};

      for (var category in selectedCategories) {
        totals[category] = monthlyExpenses
            .where((e) => e.category == category)
            .fold(0.0, (sum, e) => sum + e.amount);
      }
      comparisonData[monthKey] = totals;
    }

    return comparisonData;
  }

  Future<int> importExpenses(List<Expense> expenses) async {
    final newExpenses = <Expense>[];

    for (var exp in expenses) {
      final exists = _expenses.any(
        (existing) =>
            existing.category == exp.category &&
            existing.amount == exp.amount &&
            existing.date.year == exp.date.year &&
            existing.date.month == exp.date.month &&
            existing.date.day == exp.date.day &&
            existing.note == exp.note,
      );

      if (!exists) {
        newExpenses.add(exp);
      }
    }

    if (newExpenses.isNotEmpty) {
      await _dbService.insertExpensesBatch(newExpenses);
      await loadExpenses();
      await loadCategories();
    }

    return newExpenses.length;
  }
}
