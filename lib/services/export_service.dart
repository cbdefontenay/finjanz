import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/expense.dart';

class ExportService {
  Future<void> exportExpensesToCsv(
    List<Expense> expenses, {
    String? fileName,
  }) async {
    List<List<dynamic>> rows = [];

    // Header
    rows.add(['Kategorie', 'Summe', 'Datum', 'Notiz']);

    for (var e in expenses) {
      rows.add([
        e.category,
        e.amount.toStringAsFixed(2),
        DateFormat('dd.MM.yyyy').format(e.date),
        e.note ?? '',
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${fileName ?? 'Finanzen_Export'}.csv');
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(file.path)], text: 'Mein Finanz-Export');
  }

  Future<List<Expense>?> importExpensesFromCsv() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) return null;

      final file = File(result.files.single.path!);
      final input = await file.readAsString();
      final List<List<dynamic>> rows = const CsvToListConverter().convert(
        input,
        shouldParseNumbers: false,
      );

      if (rows.length <= 1) return []; // Only header or empty

      final List<Expense> importedExpenses = [];
      // Skip header row
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.length < 3) continue;

        final category = row[0].toString();
        // Handle sum potential comma (though export uses dot via toStringAsFixed, user might edit)
        final amountStr = row[1].toString().replaceAll(',', '.');
        final amount = double.tryParse(amountStr) ?? 0.0;

        DateTime date;
        try {
          date = DateFormat('dd.MM.yyyy').parse(row[2].toString());
        } catch (_) {
          date = DateTime.now();
        }

        final note = row.length > 3 ? row[3].toString() : null;

        importedExpenses.add(
          Expense(
            category: category,
            amount: amount,
            date: date,
            note: note == '' ? null : note,
          ),
        );
      }

      return importedExpenses;
    } catch (e) {
      debugPrint('Import error: $e');
      return null;
    }
  }
}
