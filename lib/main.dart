import 'package:flutter/material.dart';
import 'home_page.dart';
import 'features/my_mood_tracker/lib/main.dart';
import 'features/to_do_list/lib/main.dart';
import 'features/sleep_tracker/lib/main.dart';
import 'features/journal/lib/main.dart';
import 'features/bmi/lib/main.dart';

void main() {
  runApp(const WelloraApp());
}

class WelloraApp extends StatelessWidget {
  const WelloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WELLORA',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/mood': (context) => MyMoodTrackerApp(),
        '/todo': (context) => MyPlannerApp(),
        '/sleep': (context) => SleepTrackerApp(),
        '/journal': (context) => MyJournalApp(),
        '/bmi': (context) => BodyMassIndexApp(),
      },
    );
  }
}
