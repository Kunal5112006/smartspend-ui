import 'package:flutter/foundation.dart';

enum ExpenseCategory { food, travel, books, shopping, bills, other }

extension CategoryLabel on ExpenseCategory {
  String get label => name[0].toUpperCase() + name.substring(1);
}

class Expense {
  const Expense({required this.id, required this.amount, required this.category,
    required this.note, required this.date, required this.payment});
  final String id;
  // Integer paise avoid floating-point rounding errors.
  final int amount;
  final ExpenseCategory category;
  final String note;
  final DateTime date;
  final String payment;
}

/// UI-only state. Replace this layer with a repository after project approval.
/// There is no disk storage, database, account, or network connection.
class DemoStore extends ChangeNotifier {
  DemoStore({DateTime? today}) : today = today ?? DateTime.now() {
    reset(notify: false);
  }

  final DateTime today;
  late DateTime month;
  String name = 'Kunal';
  final List<Expense> _expenses = [];
  final Map<String, int> _budgets = {};
  int _serial = 0;

  String get monthKey => '${month.year}-${month.month}';
  int get budget => _budgets[monthKey] ?? 500000;
  List<Expense> get expenses => List.unmodifiable(_expenses);
  List<Expense> get monthlyExpenses {
    final result = _expenses.where((e) =>
      e.date.year == month.year && e.date.month == month.month).toList();
    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }
  int get spent => monthlyExpenses.fold(0, (sum, e) => sum + e.amount);
  int get remaining => budget - spent;
  double get used => spent / budget;
  int categoryTotal(ExpenseCategory category) => monthlyExpenses
      .where((e) => e.category == category).fold(0, (sum, e) => sum + e.amount);

  void moveMonth(int delta) {
    month = DateTime(month.year, month.month + delta);
    notifyListeners();
  }

  void setBudget(int value) {
    if (value <= 0) throw ArgumentError('Budget must be positive.');
    _budgets[monthKey] = value;
    notifyListeners();
  }

  void setName(String value) {
    if (value.trim().isEmpty) return;
    name = value.trim();
    notifyListeners();
  }

  void save({String? id, required int amount, required ExpenseCategory category,
      required String note, required DateTime date, required String payment}) {
    if (amount <= 0) throw ArgumentError('Amount must be positive.');
    final item = Expense(id: id ?? 'expense-${_serial++}', amount: amount,
      category: category, note: note.trim().isEmpty ? category.label : note.trim(),
      date: date, payment: payment);
    final index = _expenses.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      _expenses.insert(0, item);
    } else {
      _expenses[index] = item;
    }
    // Follow the saved expense so users immediately see it in the dashboard.
    month = DateTime(date.year, date.month);
    notifyListeners();
  }

  void delete(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void reset({bool notify = true}) {
    month = DateTime(today.year, today.month);
    name = 'Kunal';
    _budgets.clear();
    _expenses.clear();
    _serial = 0;
    void seed(int amount, ExpenseCategory category, String note, int days,
        String payment) {
      final day = (today.day - days).clamp(1, 31).toInt();
      _expenses.add(Expense(id: 'expense-${_serial++}', amount: amount,
        category: category, note: note,
        date: DateTime(today.year, today.month, day, 12 - days), payment: payment));
    }
    seed(8000, ExpenseCategory.food, 'Lunch', 0, 'UPI');
    seed(4000, ExpenseCategory.travel, 'Bus fare', 0, 'Cash');
    seed(12000, ExpenseCategory.books, 'Notebook', 1, 'UPI');
    seed(84000, ExpenseCategory.food, 'Canteen & groceries', 2, 'UPI');
    seed(42000, ExpenseCategory.travel, 'Travel pass', 3, 'Cash');
    seed(15600, ExpenseCategory.books, 'Study supplies', 4, 'Card');
    seed(18400, ExpenseCategory.other, 'Mobile accessories', 5, 'UPI');
    if (notify) notifyListeners();
  }
}

int? parseMoney(String input) {
  final value = input.trim();
  if (!RegExp(r'^\d{1,8}(\.\d{1,2})?$').hasMatch(value)) return null;
  final parts = value.split('.');
  final paise = int.parse(parts[0]) * 100 +
      (parts.length == 2 ? int.parse(parts[1].padRight(2, '0')) : 0);
  return paise > 0 ? paise : null;
}

String amountInput(int paise) => (paise / 100).toStringAsFixed(paise % 100 == 0 ? 0 : 2);

String money(int paise) {
  final absolute = paise.abs();
  final digits = (absolute ~/ 100).toString();
  String whole = digits;
  if (digits.length > 3) {
    final prefix = digits.substring(0, digits.length - 3);
    final groups = <String>[];
    for (int end = prefix.length; end > 0; end -= 2) {
      groups.insert(0, prefix.substring(end >= 2 ? end - 2 : 0, end));
    }
    whole = '${groups.join(',')},${digits.substring(digits.length - 3)}';
  }
  final fraction = absolute % 100 == 0 ? '' : '.${(absolute % 100).toString().padLeft(2, '0')}';
  return '${paise < 0 ? '−' : ''}₹$whole$fraction';
}

const months = ['January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'];
String monthText(DateTime date) => '${months[date.month - 1]} ${date.year}';
String dateText(DateTime date) => '${date.day.toString().padLeft(2, '0')} '
    '${months[date.month - 1].substring(0, 3)} ${date.year}';
