import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_do_list/main.dart';

void main() {
  testWidgets('Add task test', (WidgetTester tester) async {
    // Load the app
    await tester.pumpWidget(MyPlannerApp());

    // Verify app bar title exists
    expect(find.text('To-Do List'), findsOneWidget);

    // Enter a task in the TextField
    await tester.enterText(find.byType(TextField), 'Buy groceries');

    // Tap the '+' icon to add task
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // Rebuild UI

    // Verify the task appears in the list
    expect(find.text('Buy groceries'), findsOneWidget);
  });
}
