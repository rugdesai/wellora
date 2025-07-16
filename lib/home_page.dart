import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight, // maintain full-screen layout
            child: Stack(
              children: [
                // Background Image
                SizedBox.expand(
                  child: Image.asset(
                    'assets/pinkaura.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                // Logo + Title
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/Logo.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'wellora',
                          style: GoogleFonts.kalam(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 249, 144, 179),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Section with Tools
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: BottomWaveClipper(),
                    child: Container(
                      color: Colors.black,
                      height: screenHeight * 0.55,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 40.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Daily Tools',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Mood Tracker
                            ListTile(
                              leading:
                                  const Icon(Icons.mood, color: Colors.pink),
                              title: const Text(
                                'Mood Tracker',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () =>
                                  Navigator.pushNamed(context, '/mood'),
                            ),

                            // To-Do List
                            ListTile(
                              leading: const Icon(Icons.check_circle,
                                  color: Colors.pink),
                              title: const Text(
                                'Planner',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () =>
                                  Navigator.pushNamed(context, '/todo'),
                            ),

                            // Sleep Tracker
                            ListTile(
                              leading: const Icon(Icons.nightlight_round,
                                  color: Colors.pink),
                              title: const Text(
                                'Sleep Tracker',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () =>
                                  Navigator.pushNamed(context, '/sleep'),
                            ),

                            // Journal
                            ListTile(
                              leading:
                                  const Icon(Icons.book, color: Colors.pink),
                              title: const Text(
                                'Journal',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () =>
                                  Navigator.pushNamed(context, '/journal'),
                            ),
                            // bmi
                            ListTile(
                              leading:
                                  const Icon(Icons.book, color: Colors.pink),
                              title: const Text(
                                'BMI',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () => Navigator.pushNamed(context, '/bmi'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
