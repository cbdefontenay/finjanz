import 'package:flutter/material.dart';

/// A stylized input field for finance amounts.
/// Displays the current input in a large, readable format.
class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AmountInputField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '0,00',
            suffixText: ' €',
            labelText: 'Betrag',
            labelStyle: const TextStyle(fontSize: 16),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validator,
        ),
      ),
    );
  }
}
