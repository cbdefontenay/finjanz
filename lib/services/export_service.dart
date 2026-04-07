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
    rows.add(['Kategorie', 'Summe', 'Datum', 'Notiz', 'Wiederholend']);

    for (var e in expenses) {
      rows.add([
        e.category,
        e.amount.toStringAsFixed(2),
        DateFormat('dd.MM.yyyy').format(e.date),
        e.note ?? '',
        e.isRecurring ? 1 : 0,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${fileName ?? 'Finanzen_Export'}.csv');
    await file.writeAsString(csv);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Mein Finanz-Export',
      ),
    );
  }

  Future<List<Expense>?> importExpensesFromCsv() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) return null;

      final file = File(result.files.single.path!);
      final input = await file.readAsString();

      // Auto-detect delimiter (comma vs semicolon)
      String delimiter = ',';
      if (input.isNotEmpty) {
        final firstLine = input.split('\n').first;
        if (firstLine.split(';').length > firstLine.split(',').length) {
          delimiter = ';';
        }
      }

      final List<List<dynamic>> rows = CsvToListConverter(
        fieldDelimiter: delimiter,
        shouldParseNumbers: false,
      ).convert(input);

      if (rows.length <= 1) return []; // Only header or empty

      final List<Expense> importedExpenses = [];
      // Skip header row
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.length < 3) continue;

        final category = row[0].toString().trim();

        // Handle sum potential comma and thousands separators
        String amountStr = row[1].toString().replaceAll(' ', '');
        // If it format like 1.000,50
        if (amountStr.contains('.') && amountStr.contains(',')) {
          amountStr = amountStr.replaceAll('.', '').replaceAll(',', '.');
        } else {
          amountStr = amountStr.replaceAll(',', '.');
        }

        final amount = double.tryParse(amountStr) ?? 0.0;

        DateTime date;
        final dateStr = row[2].toString().trim();
        try {
          date = DateFormat('dd.MM.yyyy').parseStrict(dateStr);
        } catch (_) {
          try {
            date = DateFormat('yyyy-MM-dd').parse(dateStr);
          } catch (_) {
            try {
              date = DateFormat('dd/MM/yyyy').parse(dateStr);
            } catch (_) {
              date = DateTime.now(); // Fallback
            }
          }
        }

        final note = row.length > 3 ? row[3].toString() : null;
        final isRecurring = row.length > 4 ? row[4].toString() == '1' : false;

        importedExpenses.add(
          Expense(
            category: category,
            amount: amount,
            date: date,
            note: note == '' ? null : note,
            isRecurring: isRecurring,
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
