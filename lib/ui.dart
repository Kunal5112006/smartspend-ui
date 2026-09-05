import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'demo_store.dart';

const green = Color(0xFF086650);
const mint = Color(0xFFDDF5EA);
const background = Color(0xFFF5FAF8);
const ink = Color(0xFF172338);
const muted = Color(0xFF657285);
const line = Color(0xFFE2EBE7);

Color categoryColor(ExpenseCategory category) => const [
  Color(0xFF16A06E), Color(0xFF4B9FFA), Color(0xFFEAB044),
  Color(0xFFE47999), Color(0xFFFF9340), Color(0xFFA789EB),
][category.index];
IconData categoryIcon(ExpenseCategory category) => const [
  Icons.restaurant_rounded, Icons.directions_bus_rounded, Icons.menu_book_rounded,
  Icons.shopping_bag_outlined, Icons.receipt_long_outlined, Icons.more_horiz_rounded,
][category.index];

class Surface extends StatelessWidget {
  const Surface({super.key, required this.child, this.color = Colors.white,
    this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: line)), child: child);
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: children);
}

class MonthPicker extends StatelessWidget {
  const MonthPicker({super.key, required this.store});
  final DemoStore store;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Surface(padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(children: [
        IconButton(tooltip: 'Previous month', onPressed: () => store.moveMonth(-1),
          icon: const Icon(Icons.chevron_left_rounded)),
        const Icon(Icons.calendar_month_outlined, size: 19, color: green),
        const SizedBox(width: 8),
        Expanded(child: Text(monthText(store.month), textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600, color: ink))),
        IconButton(tooltip: 'Next month', onPressed: () => store.moveMonth(1),
          icon: const Icon(Icons.chevron_right_rounded)),
      ])),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.action});
  final String text;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 12),
    child: Row(children: [Expanded(child: Text(text, style: const TextStyle(
      fontSize: 19, fontWeight: FontWeight.w800, color: ink))),
      if (action != null) action!,
    ]),
  );
}

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense, required this.onTap});
  final Expense expense;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    leading: CircleAvatar(backgroundColor: categoryColor(expense.category).withAlpha(32),
      child: Icon(categoryIcon(expense.category), color: categoryColor(expense.category))),
    title: Text(expense.note, maxLines: 1, overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w700, color: ink)),
    subtitle: Text('${expense.category.label} · ${dateText(expense.date)}',
      style: const TextStyle(fontSize: 12, color: muted)),
    trailing: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 105),
      child: Text('−${money(expense.amount)}', maxLines: 2, textAlign: TextAlign.right,
        style: const TextStyle(fontWeight: FontWeight.w700, color: ink))),
  );
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.message,
    this.icon = Icons.tips_and_updates_outlined, this.warning = false});
  final String title;
  final String message;
  final IconData icon;
  final bool warning;
  @override
  Widget build(BuildContext context) => Surface(
    color: warning ? const Color(0xFFFFF0D8) : mint,
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: warning ? const Color(0xFF9C5B00) : green),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)),
        const SizedBox(height: 4),
        Text(message, style: const TextStyle(color: muted, height: 1.4)),
      ])),
    ]),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message});
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => Surface(child: Column(children: [
    const SizedBox(height: 16),
    const Icon(Icons.receipt_long_outlined, size: 44, color: green),
    const SizedBox(height: 12),
    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
    const SizedBox(height: 8),
    Text(message, textAlign: TextAlign.center, style: const TextStyle(color: muted)),
    const SizedBox(height: 16),
  ]));
}

class SpendingDonut extends StatelessWidget {
  const SpendingDonut({super.key, required this.totals});
  final List<int> totals;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Spending by category. Values are listed below the chart.',
    child: SizedBox(height: 230, child: Center(child: SizedBox(
      width: 220, height: 220,
      child: CustomPaint(painter: DonutPainter(totals), child: const Center(
        child: Text('This\nmonth', textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 18, height: 1.4)))),
    ))),
  );
}

class DonutPainter extends CustomPainter {
  DonutPainter(this.totals);
  final List<int> totals;
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * 0.20;
    final rect = Rect.fromCircle(center: size.center(Offset.zero),
      radius: (size.shortestSide - stroke) / 2);
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = stroke;
    final total = totals.fold<int>(0, (sum, value) => sum + value);
    if (total == 0) {
      paint.color = line;
      canvas.drawArc(rect, 0, math.pi * 2, false, paint);
      return;
    }
    double start = -math.pi / 2;
    for (int i = 0; i < totals.length; i++) {
      if (totals[i] == 0) continue;
      final sweep = totals[i] / total * math.pi * 2;
      paint.color = categoryColor(ExpenseCategory.values[i]);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }
  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) => true;
}

Future<void> editBudget(BuildContext context, DemoStore store) async {
  final result = await showDialog<int>(context: context,
    builder: (_) => _BudgetDialog(budget: store.budget, month: store.month));
  if (result != null) store.setBudget(result);
}

class _BudgetDialog extends StatefulWidget {
  const _BudgetDialog({required this.budget, required this.month});
  final int budget;
  final DateTime month;
  @override
  State<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<_BudgetDialog> {
  late final controller = TextEditingController(text: amountInput(widget.budget));
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Monthly budget'),
    content: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(monthText(widget.month), style: const TextStyle(color: muted)),
      const SizedBox(height: 16),
      TextFormField(controller: controller, autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: 'Budget', prefixText: '₹ '),
        validator: (value) => parseMoney(value ?? '') == null
          ? 'Enter a positive amount (up to 2 decimals)' : null),
    ])),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(onPressed: () {
        if (formKey.currentState!.validate()) Navigator.pop(context, parseMoney(controller.text));
      }, child: const Text('Save budget'))],
  );
}
