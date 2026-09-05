import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartspend_ui/main.dart';

void main() {
  testWidgets('expense form saves and navigation shows the updated report', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SmartSpendApp());
    expect(find.text('₹3,160'), findsOneWidget);
    await tester.tap(find.byKey(const Key('addExpense')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('expenseAmount')), '80');
    await tester.enterText(find.byKey(const Key('expenseNote')), 'Demo snack');
    await tester.ensureVisible(find.byKey(const Key('saveExpense')));
    await tester.tap(find.byKey(const Key('saveExpense')));
    await tester.pumpAndSettle();
    expect(find.text('₹3,080'), findsOneWidget);
    await tester.tap(find.widgetWithText(NavigationDestination, 'Reports'));
    await tester.pumpAndSettle();
    expect(find.text('₹1,920'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.widgetWithText(NavigationDestination, 'History'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('searchExpenses')), 'Demo snack');
    await tester.pumpAndSettle();
    expect(find.text('Demo snack'), findsOneWidget);
  });
}
