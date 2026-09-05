import 'package:flutter_test/flutter_test.dart';
import 'package:smartspend_ui/demo_store.dart';

void main() {
  test('sample month has the displayed balance and category totals', () {
    final store = DemoStore(today: DateTime(2026, 9, 5));
    addTearDown(store.dispose);
    expect(store.spent, 184000);
    expect(store.remaining, 316000);
    expect(store.categoryTotal(ExpenseCategory.food), 92000);
    expect(store.categoryTotal(ExpenseCategory.travel), 46000);
    expect(store.categoryTotal(ExpenseCategory.books), 27600);
    expect(store.categoryTotal(ExpenseCategory.other), 18400);
  });

  test('add, edit and delete recalculate totals without duplicating an expense', () {
    final store = DemoStore(today: DateTime(2026, 9, 5));
    addTearDown(store.dispose);
    store.save(amount: 8050, category: ExpenseCategory.food, note: 'Tea and snack',
      date: DateTime(2026, 9, 5), payment: 'UPI');
    final added = store.expenses.first;
    expect(store.spent, 192050);
    expect(store.expenses.length, 8);
    store.save(id: added.id, amount: 10000, category: ExpenseCategory.travel,
      note: 'Ride', date: DateTime(2026, 9, 5), payment: 'Cash');
    expect(store.spent, 194000);
    expect(store.expenses.length, 8);
    expect(store.categoryTotal(ExpenseCategory.food), 92000);
    store.delete(added.id);
    expect(store.spent, 184000);
  });

  test('month changes isolate budgets and reports, including empty months', () {
    final store = DemoStore(today: DateTime(2026, 12, 1));
    addTearDown(store.dispose);
    expect(store.spent, 184000); // First-of-month seeds must stay in December.
    store.setBudget(200000);
    store.moveMonth(1);
    expect(store.month, DateTime(2027, 1));
    expect(store.spent, 0);
    expect(store.budget, 500000);
    store.save(amount: 600000, category: ExpenseCategory.bills, note: 'Fees',
      date: DateTime(2027, 1, 2), payment: 'Card');
    expect(store.remaining, -100000);
    store.moveMonth(-1);
    expect(store.budget, 200000);
    expect(store.spent, 184000);
    store.reset();
    expect(store.budget, 500000);
    expect(store.expenses.length, 7);
  });

  test('currency input rejects invalid amounts and preserves paise', () {
    expect(parseMoney('80.50'), 8050);
    expect(parseMoney('0.01'), 1);
    for (final input in ['', '0', '-5', '1.234', 'NaN', '1e3', '100000000']) {
      expect(parseMoney(input), isNull);
    }
    expect(money(8050), '₹80.50');
    expect(money(12345678), '₹1,23,456.78');
    expect(money(-10000), '−₹100');
  });
}
