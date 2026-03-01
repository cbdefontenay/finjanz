import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/theme_provider.dart';
import '../providers/expense_provider.dart';
import '../services/export_service.dart';
import 'statistics_page.dart';
import 'manage_categories_page.dart';
import '../components/qr_export_dialog.dart';
import 'qr_scanner_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Einstellungen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Erscheinungsbild'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: ListTile(
              title: const Text('Design-Thema'),
              subtitle: Text(_getThemeModeName(themeProvider.themeMode)),
              trailing: Icon(
                Icons.palette_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              onTap: () => _showThemeDialog(context, themeProvider),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(context, 'Analysen'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.bar_chart_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  title: const Text('Statistiken'),
                  subtitle: const Text('Ausgaben visuell auswerten'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StatisticsPage(),
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(
                    Icons.category_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  title: const Text('Kategorien verwalten'),
                  subtitle: const Text('Namen bearbeiten oder löschen'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageCategoriesPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(context, 'Daten & Export'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.file_download_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  title: const Text('Daten exportieren'),
                  subtitle: const Text('Als CSV-Datei speichern'),
                  onTap: () => _showExportDialog(context),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(
                    Icons.file_upload_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  title: const Text('Daten importieren'),
                  subtitle: const Text('Aus CSV-Datei hinzufügen'),
                  onTap: () => _handleImport(context),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(
                    Icons.qr_code_scanner,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  title: const Text('QR-Code scannen'),
                  subtitle: const Text('Daten von anderem Gerät empfangen'),
                  onTap: () => _scanQrCode(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Finjanz v1.0.1',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final expenseProvider = context.read<ExpenseProvider>();
    final exportService = ExportService();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exportieren'),
        content: const Text('Welchen Zeitraum möchten Sie exportieren?'),
        actions: [
          TextButton(
            onPressed: () {
              final now = DateTime.now();
              final data = expenseProvider.getMonthlyExpenses(now);
              exportService.exportExpensesToCsv(
                data,
                fileName: 'Finanzen_Monat_${DateFormat('MM_yyyy').format(now)}',
              );
              Navigator.pop(ctx);
            },
            child: const Text('Diesen Monat'),
          ),
          TextButton(
            onPressed: () {
              final now = DateTime.now();
              final data = expenseProvider.expenses
                  .where((e) => e.date.year == now.year)
                  .toList();
              exportService.exportExpensesToCsv(
                data,
                fileName: 'Finanzen_Jahr_${now.year}',
              );
              Navigator.pop(ctx);
            },
            child: const Text('Dieses Jahr'),
          ),
          TextButton(
            onPressed: () {
              exportService.exportExpensesToCsv(
                expenseProvider.expenses,
                fileName: 'Finanzen_Alle',
              );
              Navigator.pop(ctx);
            },
            child: const Text('Alle (CSV)'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              final now = DateTime.now();
              final data = expenseProvider.getMonthlyExpenses(now);
              final qrData = exportService.generateQrData(data);
              showDialog(
                context: context,
                builder: (context) => QrExportDialog(qrData: qrData),
              );
            },
            child: const Text('QR-Code (Diesen Monat)'),
          ),
        ],
      ),
    );
  }

  Future<void> _scanQrCode(BuildContext context) async {
    final scannedData = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerPage()),
    );

    if (scannedData != null && scannedData.isNotEmpty) {
      if (context.mounted) {
        final exportService = ExportService();
        final expenses = exportService.parseQrData(scannedData);
        if (expenses != null && expenses.isNotEmpty) {
          final importedCount = await context
              .read<ExpenseProvider>()
              .importExpenses(expenses);
          if (context.mounted) {
            if (importedCount > 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$importedCount neue Einträge per QR-Code importiert',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Keine neuen Einträge gefunden (Duplikate übersprungen)',
                  ),
                ),
              );
            }
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ungültiger oder leerer QR-Code'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System-Standard';
      case ThemeMode.light:
        return 'Hell';
      case ThemeMode.dark:
        return 'Dunkel';
    }
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modus auswählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ignore: deprecated_member_use
            RadioListTile<ThemeMode>(
              title: const Text('System-Standard'),
              value: ThemeMode.system,
              // ignore: deprecated_member_use
              groupValue: themeProvider.themeMode,
              // ignore: deprecated_member_use
              onChanged: (mode) {
                themeProvider.setThemeMode(mode!);
                Navigator.pop(context);
              },
            ),
            // ignore: deprecated_member_use
            RadioListTile<ThemeMode>(
              title: const Text('Hell'),
              value: ThemeMode.light,
              // ignore: deprecated_member_use
              groupValue: themeProvider.themeMode,
              // ignore: deprecated_member_use
              onChanged: (mode) {
                themeProvider.setThemeMode(mode!);
                Navigator.pop(context);
              },
            ),
            // ignore: deprecated_member_use
            RadioListTile<ThemeMode>(
              title: const Text('Dunkel'),
              value: ThemeMode.dark,
              // ignore: deprecated_member_use
              groupValue: themeProvider.themeMode,
              // ignore: deprecated_member_use
              onChanged: (mode) {
                themeProvider.setThemeMode(mode!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImport(BuildContext context) async {
    final exportService = ExportService();
    final expenses = await exportService.importExpensesFromCsv();

    if (expenses == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Import abgebrochen oder fehlgeschlagen'),
          ),
        );
      }
      return;
    }

    if (expenses.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Keine Daten zum Importieren gefunden')),
        );
      }
      return;
    }

    if (context.mounted) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final importedCount = await context
            .read<ExpenseProvider>()
            .importExpenses(expenses);
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          if (importedCount > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '$importedCount neue Einträge erfolgreich importiert',
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Keine neuen Einträge zum Importieren gefunden (Duplikate übersprungen)',
                ),
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Fehler beim Importieren in die Datenbank'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}
