import 'package:flutter/material.dart';
import 'demo_store.dart';
import 'screens.dart';
import 'ui.dart';

void main() => runApp(const SmartSpendApp());

class SmartSpendApp extends StatelessWidget {
  const SmartSpendApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SmartSpend',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: green,
        primary: green, surface: Colors.white),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(backgroundColor: background,
        foregroundColor: ink, elevation: 0, scrolledUnderElevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: line)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: line)),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
        backgroundColor: green, foregroundColor: Colors.white,
        minimumSize: const Size(0, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
    ),
    home: const AppShell(),
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final store = DemoStore();
  int tab = 0;
  @override
  void dispose() { store.dispose(); super.dispose(); }

  Future<void> openExpense([Expense? expense]) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => ExpenseFormScreen(store: store, expense: expense)));
    if (!mounted || saved != true) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(expense == null ? 'Expense added' : 'Expense updated')));
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: Text(['SmartSpend', 'Expense history', 'Reports', 'Profile'][tab],
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 23)),
        actions: [
          if (tab == 0) Padding(padding: const EdgeInsets.only(right: 16),
            child: IconButton(tooltip: 'Open profile',
              onPressed: () => setState(() => tab = 3),
              icon: CircleAvatar(backgroundColor: mint,
                child: Text(store.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: green, fontWeight: FontWeight.bold))))),
          if (tab == 1) IconButton(tooltip: 'Add expense',
            onPressed: () => openExpense(), icon: const Icon(Icons.add_rounded)),
        ],
      ),
      body: SafeArea(top: false, child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: IndexedStack(index: tab, children: [
          DashboardScreen(store: store, onAdd: () => openExpense(),
            onEdit: openExpense, onHistory: () => setState(() => tab = 1)),
          HistoryScreen(store: store, onEdit: openExpense),
          ReportsScreen(store: store),
          ProfileScreen(store: store),
        ]),
      ))),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        backgroundColor: Colors.white, indicatorColor: mint,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: green), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history_rounded, color: green), label: 'History'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded),
            selectedIcon: Icon(Icons.bar_chart_rounded, color: green), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: green), label: 'Profile'),
        ],
      ),
    ),
  );
}
