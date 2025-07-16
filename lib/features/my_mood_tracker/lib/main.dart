import 'dart:math'; // For random positions
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyMoodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Enables Material 3 UI which uses proper icons
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: MoodTrackerHomePage(),
    );
  }
}

class MoodTrackerHomePage extends StatefulWidget {
  @override
  _MoodTrackerHomePageState createState() => _MoodTrackerHomePageState();
}

class _MoodTrackerHomePageState extends State<MoodTrackerHomePage> {
  String? selectedMood;
  String? selectedReason;
  String? sleepQuality;
  DateTime selectedDate = DateTime.now();
  List<String> moodHistory = [];
  final Random random = Random();

  void logMood(BuildContext context) {
    String formattedDate = selectedDate.toLocal().toString().split(' ')[0];
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 240, 247),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Text(
            'Mood logged for $formattedDate!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        );
      },
    );
    setState(() {
      selectedMood = null;
      selectedReason = null;
      sleepQuality = null;
      selectedDate = DateTime.now();
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MOOD TRACKER',
          style: GoogleFonts.dynaPuff(
            textStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 2,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 214, 234),
      ),
      body: Stack(
        children: [
          // Background image
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'lib/features/my_mood_tracker/assets/pinkbg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                color: Colors.white.withOpacity(0.2),
              ),
            ],
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Select Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _selectDate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 214, 234),
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Select Date',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Highlighted selected date
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                            255, 255, 214, 234), // Highlight color
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 180, 220),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Text(
                  'How are you feeling today?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: [
                    {
                      'name': 'Happy',
                      'asset':
                          'lib/features/my_mood_tracker/assets/emotions/happy.png'
                    },
                    {
                      'name': 'Excited',
                      'asset':
                          'lib/features/my_mood_tracker/assets/emotions/excited.png'
                    },
                    {
                      'name': 'Silly',
                      'asset':
                          'lib/features/my_mood_tracker/assets/emotions/silly.png'
                    },
                    {
                      'name': 'Bored',
                      'asset':
                          'lib/features/my_mood_tracker/assets/emotions/bored.png'
                    },
                    {
                      'name': 'Sad',
                      'asset':
                          'lib/features/my_mood_tracker/assets/emotions/sad.png'
                    },
                    {
                      'name': 'Angry',
                      'asset':
                          'lib/features/my_mood_tracker/assets/emotions/angry.png'
                    }
                  ].map((mood) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedMood = mood['name'];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedMood == mood['name']
                            ? const Color.fromARGB(
                                255, 255, 203, 230) // darker pink
                            : Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: const Color.fromARGB(255, 255, 214, 234)),
                        ),
                      ),
                      child: Image.asset(
                        mood['asset']!,
                        width: 90,
                        height: 90,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                if (selectedMood != null) ...[
                  Text(
                    'Why do you feel $selectedMood?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedReason,
                    hint: Text('Select a reason'),
                    items: ['Work', 'Family', 'Health', 'Friends', 'Other']
                        .map((reason) {
                      return DropdownMenuItem<String>(
                        value: reason,
                        child: Text(reason),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                    icon: Image.asset(
                      'lib/features/my_mood_tracker/assets/cursor.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'How well did you sleep last night?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: sleepQuality,
                    hint: Text('Select sleep quality'),
                    items: ['Bad', 'Okay', 'Great'].map((quality) {
                      return DropdownMenuItem<String>(
                        value: quality,
                        child: Text(quality),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sleepQuality = value;
                      });
                    },
                    icon: Image.asset(
                      'lib/features/my_mood_tracker/assets/cursor.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => logMood(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 214, 234),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text('Log the Mood',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                ],
                SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: moodHistory.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            moodHistory[index],
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 214, 234),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
