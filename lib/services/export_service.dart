import 'dart:io';
import 'package:csv/csv.dart';
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
}
