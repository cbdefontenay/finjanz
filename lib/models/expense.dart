class Expense {
  final int? id;
  final String category;
  final double amount;
  final DateTime date;
  final String? note;
  final bool isRecurring;

  Expense({
    this.id,
    required this.category,
    required this.amount,
    required this.date,
    this.note,
    this.isRecurring = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'isRecurring': isRecurring ? 1 : 0,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      note: map['note'],
      isRecurring: map['isRecurring'] == 1,
    );
  }
}
