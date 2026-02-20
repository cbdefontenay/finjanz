import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../components/create_hero_header.dart';
import '../components/create_entry_form.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _categoryController = TextEditingController();
  final _categoryFocusNode = FocusNode();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  bool _isAddingNewCategory = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _categoryController.dispose();
    _categoryFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final category = _isAddingNewCategory
          ? _categoryController.text
          : _selectedCategory;
      if (category == null || category.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte wählen Sie eine Kategorie')),
        );
        return;
      }

      final expense = Expense(
        amount: double.parse(_amountController.text),
        category: category,
        date: _selectedDate,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );

      context.read<ExpenseProvider>().addExpense(expense);

      _amountController.clear();
      _noteController.clear();
      _categoryController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _isAddingNewCategory = false;
        _selectedCategory = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Eintrag gespeichert')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<ExpenseProvider>().categories;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Neuer Eintrag',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CreateHeroHeader(amountController: _amountController),
              CreateEntryForm(
                categories: categories,
                selectedCategory: _selectedCategory,
                isAddingNewCategory: _isAddingNewCategory,
                categoryController: _categoryController,
                noteController: _noteController,
                categoryFocusNode: _categoryFocusNode,
                selectedDate: _selectedDate,
                onSelectDate: _selectDate,
                onCategoryChanged: (value) {
                  if (value == 'NEW_CATEGORY') {
                    setState(() => _isAddingNewCategory = true);
                    _categoryFocusNode.requestFocus();
                  } else {
                    setState(() => _selectedCategory = value);
                  }
                },
                onToggleAddMode: () => setState(
                  () => _isAddingNewCategory = !_isAddingNewCategory,
                ),
                onSubmit: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
