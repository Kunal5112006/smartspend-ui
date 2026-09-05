import 'package:flutter/material.dart';
import 'demo_store.dart';
import 'ui.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.store, required this.onAdd,
    required this.onEdit, required this.onHistory});
  final DemoStore store;
  final VoidCallback onAdd;
  final ValueChanged<Expense> onEdit;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final over = store.remaining < 0;
    final recent = store.monthlyExpenses.take(3).toList();
    return PageBody(children: [
      Text('Hi, ${store.name}', style: const TextStyle(fontSize: 29,
        fontWeight: FontWeight.w800, color: ink)),
      const SizedBox(height: 5),
      const Text('Track your expenses, build a better tomorrow.',
        style: TextStyle(color: muted, height: 1.4)),
      MonthPicker(store: store),
      Container(padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF08745B), Color(0xFF064E40)])),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Expanded(child: Text('Monthly budget',
            style: TextStyle(color: Colors.white, fontSize: 15))),
            IconButton(tooltip: 'Edit monthly budget', onPressed: () => editBudget(context, store),
              icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20))]),
          Text(money(store.budget), style: const TextStyle(color: Colors.white,
            fontSize: 34, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _BalanceValue(label: 'Spent', value: money(store.spent))),
            const SizedBox(width: 16),
            Expanded(child: _BalanceValue(label: over ? 'Over budget' : 'Remaining',
              value: money(store.remaining.abs()))),
          ]),
          const SizedBox(height: 20),
          ClipRRect(borderRadius: BorderRadius.circular(12), child: LinearProgressIndicator(
            value: store.used.clamp(0.0, 1.0).toDouble(), minHeight: 9,
            backgroundColor: Colors.white.withAlpha(50),
            valueColor: AlwaysStoppedAnimation<Color>(over ? const Color(0xFFFFCE88) : const Color(0xFFA4F2C6)))),
          const SizedBox(height: 9),
          Text('${(store.used * 100).round()}% of budget used',
            style: const TextStyle(color: Colors.white, fontSize: 12)),
        ])),
      const SizedBox(height: 14),
      FilledButton.icon(key: const Key('addExpense'), onPressed: onAdd,
        icon: const Icon(Icons.add_rounded), label: const Text('Add expense')),
      SectionTitle('Recent transactions', action: TextButton(
        onPressed: onHistory, child: const Text('See all'))),
      if (recent.isEmpty)
        const EmptyState(title: 'A fresh start', message: 'Add an expense to start tracking this month.')
      else Surface(padding: EdgeInsets.zero, child: Column(children: [
        for (int i = 0; i < recent.length; i++) ...[
          ExpenseTile(expense: recent[i], onTap: () => onEdit(recent[i])),
          if (i < recent.length - 1) const Divider(height: 1, color: line, indent: 16, endIndent: 16),
        ],
      ])),
      const SizedBox(height: 18),
      InfoCard(warning: store.used >= 0.8,
        icon: store.used >= 0.8 ? Icons.warning_amber_rounded : Icons.celebration_outlined,
        title: over ? 'Budget exceeded' : store.used >= 0.8 ? 'Getting close' : 'Nice work!',
        message: over ? 'You are ${money(store.remaining.abs())} over your monthly budget.'
          : store.used >= 0.8 ? 'You have ${money(store.remaining)} left for this month.'
          : "You're within your monthly budget."),
    ]);
  }
}

class _BalanceValue extends StatelessWidget {
  const _BalanceValue({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [Text(label, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 5),
      Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: Colors.white))]);
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.store, required this.onEdit});
  final DemoStore store;
  final ValueChanged<Expense> onEdit;
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String query = '';
  ExpenseCategory? category;
  final searchController = TextEditingController();
  @override
  void dispose() { searchController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final items = widget.store.monthlyExpenses.where((e) =>
      (category == null || category == e.category) &&
      '${e.note} ${e.category.label} ${e.payment} ${dateText(e.date)}'
        .toLowerCase().contains(query.toLowerCase().trim())).toList();
    final total = items.fold<int>(0, (sum, e) => sum + e.amount);
    return PageBody(children: [
      const Text('Every little expense, in one place.', style: TextStyle(color: muted)),
      MonthPicker(store: widget.store),
      TextField(key: const Key('searchExpenses'), controller: searchController,
        onChanged: (value) => setState(() => query = value),
        decoration: InputDecoration(hintText: 'Search note, date or payment',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: query.isEmpty ? null : IconButton(tooltip: 'Clear search',
            onPressed: () { searchController.clear(); setState(() => query = ''); },
            icon: const Icon(Icons.close_rounded)))),
      const SizedBox(height: 12),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
        ChoiceChip(label: const Text('All'), selected: category == null,
          onSelected: (_) => setState(() => category = null)),
        for (final value in ExpenseCategory.values) Padding(
          padding: const EdgeInsets.only(left: 8), child: ChoiceChip(
            label: Text(value.label), selected: category == value,
            onSelected: (_) => setState(() => category = value))),
      ])),
      SectionTitle('${items.length} expenses', action: Text(money(total),
        style: const TextStyle(color: green, fontWeight: FontWeight.w800, fontSize: 18))),
      if (items.isEmpty)
        const EmptyState(title: 'No expenses found',
          message: 'Try another month or filter, or add your first expense.')
      else ...[
        const Padding(padding: EdgeInsets.only(bottom: 10),
          child: Text('Tap an expense to edit or delete it.', style: TextStyle(color: muted, fontSize: 12))),
        Surface(padding: EdgeInsets.zero, child: Column(children: [
          for (int i = 0; i < items.length; i++) ...[
            ExpenseTile(expense: items[i], onTap: () => widget.onEdit(items[i])),
            if (i < items.length - 1) const Divider(height: 1, indent: 16, endIndent: 16, color: line),
          ],
        ])),
      ],
    ]);
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key, required this.store});
  final DemoStore store;
  @override
  Widget build(BuildContext context) {
    final totals = ExpenseCategory.values.map(store.categoryTotal).toList();
    final total = store.spent;
    int largest = 0;
    for (int i = 1; i < totals.length; i++) {
      if (totals[i] > totals[largest]) largest = i;
    }
    return PageBody(children: [
      MonthPicker(store: store),
      const SizedBox(height: 8),
      const Center(child: Text('Total spent', style: TextStyle(color: muted, fontSize: 16))),
      const SizedBox(height: 6),
      Center(child: Text(money(total), style: const TextStyle(color: ink,
        fontSize: 38, fontWeight: FontWeight.w800))),
      const SizedBox(height: 12),
      SpendingDonut(totals: totals),
      const SizedBox(height: 16),
      if (total == 0)
        const EmptyState(title: 'Your report starts here',
          message: 'Add an expense in this month to see a spending breakdown.')
      else ...[
        Surface(child: Column(children: [
          for (int i = 0; i < totals.length; i++)
            if (totals[i] > 0) Padding(padding: const EdgeInsets.symmetric(vertical: 11),
              child: Row(children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(
                  color: categoryColor(ExpenseCategory.values[i]), shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Expanded(child: Text(ExpenseCategory.values[i].label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
                Text(money(totals[i]), style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(width: 12),
                SizedBox(width: 43, child: Text('${(totals[i] / total * 100).round()}%',
                  textAlign: TextAlign.right, style: const TextStyle(color: muted))),
              ])),
        ])),
        const SizedBox(height: 18),
        InfoCard(title: 'Top category', icon: Icons.bar_chart_rounded,
          message: '${ExpenseCategory.values[largest].label} accounts for '
            '${(totals[largest] / total * 100).round()}% of your spending this month.'),
      ],
    ]);
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.store});
  final DemoStore store;
  @override
  Widget build(BuildContext context) => PageBody(children: [
    const SizedBox(height: 16),
    Center(child: CircleAvatar(radius: 42, backgroundColor: mint,
      child: Text(store.name.substring(0, 1).toUpperCase(),
        style: const TextStyle(fontSize: 34, color: green, fontWeight: FontWeight.w800)))),
    const SizedBox(height: 14),
    Center(child: Text(store.name, style: const TextStyle(fontSize: 26,
      color: ink, fontWeight: FontWeight.w800))),
    const SizedBox(height: 5),
    const Center(child: Text('Student · SmartSpend', style: TextStyle(color: muted))),
    const SizedBox(height: 24),
    Surface(padding: EdgeInsets.zero, child: Column(children: [
      ListTile(leading: const Icon(Icons.person_outline_rounded, color: green),
        title: const Text('Edit display name'), trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () async {
          final name = await showDialog<String>(context: context,
            builder: (_) => _NameDialog(initialName: store.name));
          if (name != null) store.setName(name);
        }),
      const Divider(height: 1, color: line),
      ListTile(leading: const Icon(Icons.account_balance_wallet_outlined, color: green),
        title: const Text('Monthly budget'), subtitle: Text('${monthText(store.month)} · ${money(store.budget)}'),
        trailing: const Icon(Icons.chevron_right_rounded), onTap: () => editBudget(context, store)),
      const Divider(height: 1, color: line),
      ListTile(leading: const Icon(Icons.info_outline_rounded, color: green),
        title: const Text('About SmartSpend'), trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => showAboutDialog(context: context, applicationName: 'SmartSpend',
          applicationVersion: '1.0 · UI demo',
          children: [const Text('A student expense tracker with budgets, transaction history '
            'and spending reports. This preview uses temporary sample data.')])),
    ])),
    const SizedBox(height: 22),
    const InfoCard(title: 'Preview version', icon: Icons.science_outlined,
      message: 'Changes last for this app session. Restarting the app restores the sample data.'),
    const SizedBox(height: 18),
    OutlinedButton.icon(icon: const Icon(Icons.restart_alt_rounded),
      label: const Text('Reset demo data'), onPressed: () async {
        final confirmed = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
          title: const Text('Reset demo data?'),
          content: const Text('This replaces your session changes with the original sample expenses, budget and name.'),
          actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Reset'))]));
        if (confirmed == true) store.reset();
      }),
  ]);
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initialName});
  final String initialName;
  @override
  State<_NameDialog> createState() => _NameDialogState();
}
class _NameDialogState extends State<_NameDialog> {
  late final controller = TextEditingController(text: widget.initialName);
  final form = GlobalKey<FormState>();
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AlertDialog(title: const Text('Display name'),
    content: Form(key: form, child: TextFormField(controller: controller, autofocus: true,
      maxLength: 24, textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Your name'),
      validator: (value) => (value ?? '').trim().isEmpty ? 'Enter your name' : null)),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(onPressed: () {
        if (form.currentState!.validate()) Navigator.pop(context, controller.text.trim());
      }, child: const Text('Save'))]);
}

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key, required this.store, this.expense});
  final DemoStore store;
  final Expense? expense;
  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final form = GlobalKey<FormState>();
  late final TextEditingController amount;
  late final TextEditingController note;
  late ExpenseCategory category;
  late DateTime date;
  late String payment;

  @override
  void initState() {
    super.initState();
    final item = widget.expense;
    amount = TextEditingController(text: item == null ? '' : amountInput(item.amount));
    note = TextEditingController(text: item?.note ?? '');
    category = item?.category ?? ExpenseCategory.food;
    payment = item?.payment ?? 'UPI';
    final selected = widget.store.month;
    final now = widget.store.today;
    date = item?.date ?? (selected.year == now.year && selected.month == now.month
      ? now : DateTime(selected.year, selected.month));
  }
  @override
  void dispose() { amount.dispose(); note.dispose(); super.dispose(); }

  void save() {
    if (!form.currentState!.validate()) return;
    widget.store.save(id: widget.expense?.id, amount: parseMoney(amount.text)!,
      category: category, note: note.text, date: date, payment: payment);
    Navigator.pop(context, true);
  }

  Future<void> delete() async {
    final result = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Delete expense?'),
      content: const Text('This expense will be removed from your history and reports.'),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete'))]));
    if (!mounted || result != true) return;
    widget.store.delete(widget.expense!.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.expense == null ? 'Add expense' : 'Edit expense',
      style: const TextStyle(fontWeight: FontWeight.w800)),
      actions: [if (widget.expense != null) IconButton(tooltip: 'Delete expense',
        onPressed: delete, icon: const Icon(Icons.delete_outline_rounded))]),
    body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 620),
      child: Form(key: form, child: PageBody(children: [
        const SizedBox(height: 10),
        Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Amount', style: TextStyle(color: ink, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          TextFormField(key: const Key('expenseAmount'), controller: amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: ink),
            decoration: const InputDecoration(prefixText: '₹ ', hintText: '0', fillColor: mint),
            validator: (value) => parseMoney(value ?? '') == null
              ? 'Enter a positive amount (up to 2 decimals)' : null),
        ])),
        const SectionTitle('Category'),
        LayoutBuilder(builder: (context, constraints) => Wrap(spacing: 10, runSpacing: 10,
          children: [for (final value in ExpenseCategory.values)
            SizedBox(width: (constraints.maxWidth - 20) / 3,
              child: Semantics(selected: category == value, button: true,
                child: Material(color: category == value ? green : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: line)),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(onTap: () => setState(() => category = value),
                    child: Padding(padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                      child: Column(children: [
                        Icon(categoryIcon(value), size: 29,
                          color: category == value ? Colors.white : categoryColor(value)),
                        const SizedBox(height: 9),
                        Text(value.label, style: TextStyle(fontWeight: FontWeight.w600,
                          color: category == value ? Colors.white : ink)),
                      ]))))))])),
        const SectionTitle('Note'),
        TextFormField(key: const Key('expenseNote'), controller: note, maxLength: 60,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: 'e.g. Lunch at the canteen', counterText: ''),
          textInputAction: TextInputAction.done),
        const SectionTitle('Date'),
        OutlinedButton.icon(style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 54), alignment: Alignment.centerLeft,
          backgroundColor: Colors.white, side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          icon: const Icon(Icons.calendar_month_outlined), label: Text(dateText(date)),
          onPressed: () async {
            final selected = await showDatePicker(context: context, initialDate: date,
              firstDate: DateTime(date.year < 2020 ? date.year : 2020),
              lastDate: DateTime(date.year > 2100 ? date.year : 2100, 12, 31));
            if (selected != null && mounted) setState(() => date = selected);
          }),
        const SectionTitle('Paid via'),
        Wrap(spacing: 12, runSpacing: 8, children: [
          for (final method in ['Cash', 'UPI', 'Card']) ChoiceChip(
            label: Text(method), selected: payment == method,
            avatar: Icon(method == 'Cash' ? Icons.payments_outlined
              : method == 'UPI' ? Icons.send_outlined : Icons.credit_card_rounded, size: 18),
            onSelected: (_) => setState(() => payment = method)),
        ]),
        const SizedBox(height: 28),
        FilledButton(key: const Key('saveExpense'), onPressed: save,
          child: Text(widget.expense == null ? 'Save expense' : 'Save changes')),
      ])),
    ))),
  );
}
