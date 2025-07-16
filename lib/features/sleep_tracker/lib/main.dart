import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SleepTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SleepTrackerHomePage(),
    );
  }
}

final TextEditingController _notesController = TextEditingController();

class SleepTrackerHomePage extends StatefulWidget {
  @override
  _SleepTrackerHomePageState createState() => _SleepTrackerHomePageState();
}

class _SleepTrackerHomePageState extends State<SleepTrackerHomePage> {
  TimeOfDay? sleepTime;
  TimeOfDay? wakeTime;
  String? sleepQuality;
  String? sleepNotes;
  List<Map<String, String>> sleepHistory = [];
  String? latestAnalysis;
  Color analysisColor = Colors.grey;

  Future<void> selectTime(BuildContext context, bool isSleepTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isSleepTime) {
          sleepTime = picked;
        } else {
          wakeTime = picked;
        }
      });
    }
  }

  double calculateSleepDuration(TimeOfDay sleep, TimeOfDay wake) {
    DateTime now = DateTime.now();
    DateTime sleepDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      sleep.hour,
      sleep.minute,
    );
    DateTime wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      wake.hour,
      wake.minute,
    );

    if (wakeDateTime.isBefore(sleepDateTime)) {
      wakeDateTime = wakeDateTime.add(Duration(days: 1));
    }

    Duration sleepDuration = wakeDateTime.difference(sleepDateTime);
    return sleepDuration.inMinutes / 60.0;
  }

  String analyzeSleep(double duration, String quality) {
    if (duration < 5) {
      analysisColor = Colors.red;
      return "Sleep was too short! Try getting at least 7 hours.";
    } else if (duration >= 5 && duration < 7) {
      analysisColor = const Color.fromARGB(255, 255, 213, 151);
      return "Slightly insufficient sleep. Try to get more rest.";
    } else if (duration >= 7 && duration <= 9) {
      if (quality == "Great") {
        analysisColor = Colors.green;
        return "Excellent! Your sleep is healthy.";
      } else {
        analysisColor = Colors.blue;
        return "Good sleep duration, but quality could improve.";
      }
    } else {
      analysisColor = Colors.purple;
      return "Too much sleep may indicate fatigue. Try adjusting your routine.";
    }
  }

  void logSleep() {
    if (sleepTime != null && wakeTime != null && sleepQuality != null) {
      double duration = calculateSleepDuration(sleepTime!, wakeTime!);
      String analysis = analyzeSleep(duration, sleepQuality!);

      final String formattedSleep =
          "Slept from ${sleepTime!.format(context)} to ${wakeTime!.format(context)}";
      final String quality = "Quality: $sleepQuality";
      final String notes = sleepNotes != null ? "Notes: $sleepNotes" : "";

      setState(() {
        latestAnalysis = analysis;
        sleepHistory.insert(0, {
          "text":
              "$formattedSleep | $quality | Duration: ${duration.toStringAsFixed(1)} hrs",
          "analysis": analysis,
        });

        sleepTime = null;
        wakeTime = null;
        sleepQuality = null;
        sleepNotes = null;
      });
      _notesController.clear();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sleep Analysis"),
            content: Text(
              analysis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: analysisColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sleep Tracker',
          style: GoogleFonts.dynaPuff(
            textStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 2,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 214, 142),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Wallpaper background with overlay in nested Stack
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'lib/features/sleep_tracker/assets/yellow.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(color: Colors.white.withOpacity(0.4)),
            ],
          ),

          // Main content with padding and column (no scroll view here)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (latestAnalysis != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: analysisColor.withOpacity(0.2),
                      border: Border.all(color: analysisColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      latestAnalysis!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: analysisColor,
                      ),
                    ),
                  ),
                SizedBox(height: 15),
                Text(
                  "When did you go to sleep?",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 227, 144),
                  ),
                  onPressed: () => selectTime(context, true),
                  child: Text(
                    sleepTime != null
                        ? sleepTime!.format(context)
                        : "Select Sleep Time",
                  ),
                ),
                SizedBox(height: 15),
                Text("When did you wake up?", style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 227, 144),
                  ),
                  onPressed: () => selectTime(context, false),
                  child: Text(
                    wakeTime != null
                        ? wakeTime!.format(context)
                        : "Select Wake Time",
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "How was your sleep quality?",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: sleepQuality,
                  hint: Text("Select Quality"),
                  items:
                      ["Bad", "Okay", "Great"].map((quality) {
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
                ),
                SizedBox(height: 15),
                Center(
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Any notes about your sleep?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.yellow[50],
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (value) {
                        sleepNotes = value;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: logSleep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 227, 144),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Log Sleep",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "Sleep History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                if (sleepHistory.isNotEmpty)
                  Card(
                    color: Colors.yellow[50],
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sleepHistory.first["text"]!),
                          SizedBox(height: 6),
                          Text(
                            sleepHistory.first["analysis"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
