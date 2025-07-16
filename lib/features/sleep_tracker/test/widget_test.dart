//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_tracker/main.dart';

void main() {
  testWidgets('Sleep Tracker UI Test', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(SleepTrackerApp());

    // Verify that the "Sleep Tracker" title is displayed
    expect(find.text('Sleep Tracker'), findsOneWidget);

    // Verify the "Select Sleep Time" button exists
    expect(find.text('Select Sleep Time'), findsOneWidget);

    // Verify the "Select Wake Time" button exists
    expect(find.text('Select Wake Time'), findsOneWidget);

    // Verify the "Log Sleep" button exists
    expect(find.text('Log Sleep'), findsOneWidget);
  });
}
