import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/theme_provider.dart';
import '../providers/expense_provider.dart';
import '../services/export_service.dart';
import 'statistics_page.dart';
import 'manage_categories_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Einstellungen',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
              trailing: const Icon(Icons.palette_outlined),
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
                  leading: const Icon(Icons.bar_chart_outlined),
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
                  leading: const Icon(Icons.category_outlined),
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
            child: ListTile(
              leading: const Icon(Icons.file_download_outlined),
              title: const Text('Daten exportieren'),
              subtitle: const Text('Als CSV-Datei speichern'),
              onTap: () => _showExportDialog(context),
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
          color: Theme.of(context).colorScheme.primary,
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
            child: const Text('Alle'),
          ),
        ],
      ),
    );
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
        title: const Text('Thema auswählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System-Standard'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (mode) {
                themeProvider.setThemeMode(mode!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Hell'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (mode) {
                themeProvider.setThemeMode(mode!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dunkel'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
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
}
