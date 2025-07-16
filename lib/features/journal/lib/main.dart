import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class MyJournalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Enables Material 3 UI which uses proper icons
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: JournalHomePage(),
    );
  }
}

class JournalHomePage extends StatefulWidget {
  @override
  _JournalHomePageState createState() => _JournalHomePageState();
}

class _JournalHomePageState extends State<JournalHomePage> {
  DateTime selectedDate = DateTime.now();
  List<String> journalHistory = [];
  TextEditingController journalController = TextEditingController();
  String? currentEntry; // To hold the current journal entry before logging it

  // Function to log journal entry
  void logJournal(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    setState(() {
      // Store the current entry and clear the text field
      currentEntry = 'On $formattedDate: ${journalController.text}';
      // Add it to the journal history
      journalHistory.insert(0, currentEntry!);
    });

    // Show confirmation message
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          // Check if the widget's context is still valid before popping
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        });
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 240, 247),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Text(
            'Feeling Good, Entry Saved for $formattedDate!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        );
      },
    );

    // Reset fields after logging
    setState(() {
      selectedDate = DateTime.now();
      journalController.clear();
      currentEntry = null; // Clear current entry after logging
    });
  }

  // Date picker function
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
          'JOURNAL',
          style: GoogleFonts.dynaPuff(
            textStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 2,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 169, 215, 187),
      ),
      body: Stack(
        children: [
          // Background image
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/features/journal/assets/green.jpg'),
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
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligning to the left
              children: [
                // Selected Date (aligned left)
                Text(
                  "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),

                // Change Date Button (aligned left and smaller font)
                ElevatedButton(
                  onPressed: _selectDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 215, 255, 230),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Change Date',
                    style: TextStyle(fontSize: 14), // Smaller font size
                  ),
                ),
                SizedBox(height: 20),

                // Centered "What's on your mind?"
                Center(
                  child: Text(
                    'What\'s on your mind?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),

                // Journal Entry TextField with opacity
                TextField(
                  controller: journalController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: ' Write your thoughts...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Increased border radius for more rounded corners
                    ),
                    filled: true,
                    fillColor:
                        Colors.white.withOpacity(0.1), // Transparent input box
                  ),
                ),
                SizedBox(height: 20),

                // Log Journal Button (centered)
                Center(
                  child: ElevatedButton(
                    onPressed: () => logJournal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 181, 222, 197),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(
                      'Log Journal',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Journal History (now showing only previous entries)
                // Removed history display as per your request
              ],
            ),
          ),
        ],
      ),
    );
  }
}
