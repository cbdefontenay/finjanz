import 'package:flutter/material.dart';
import 'amount_input_field.dart';

class CreateHeroHeader extends StatelessWidget {
  final TextEditingController amountController;

  const CreateHeroHeader({super.key, required this.amountController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Increased top padding to ensure text is below the AppBar
      padding: const EdgeInsets.only(top: 120, bottom: 40, left: 24, right: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Text(
            'Wie viel hast du ausgegeben?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            child: AmountInputField(
              controller: amountController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pflichtfeld';
                }
                if (double.tryParse(value) == null) {
                  return 'Ungültige Zahl';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
