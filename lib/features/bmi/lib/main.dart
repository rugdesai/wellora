import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BodyMassIndexApp());
}

class BodyMassIndexApp extends StatelessWidget {
  const BodyMassIndexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body Mass Index',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F4E9),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6B4226),
          secondary: Color(0xFF8C6A4F),
        ),
        textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
          bodyMedium: GoogleFonts.sourceSans3(),
        ),
      ),
      home: const BMICalculatorPage(),
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  String _bmiResult = '';

  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || height == null || weight <= 0 || height <= 0) {
      setState(() {
        _bmiResult = 'Please enter valid weight and height.';
      });
      return;
    }

    double weightKg = _weightUnit == 'kg' ? weight : weight * 0.453592;
    double heightM = _heightUnit == 'cm' ? height / 100 : height * 0.0254;

    double bmi = weightKg / (heightM * heightM);
    final (category, tips) = _getBMICategory(bmi);

    setState(() {
      _bmiResult = '''
Your BMI: ${bmi.toStringAsFixed(1)}
Category: $category

Nutrition Tips:
$tips
''';
    });
  }

  (String, String) _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return (
        'Underweight',
        '• Eat energy-dense, nutrient-rich foods\n• Increase meal frequency\n\nConsult a healthcare professional',
      );
    } else if (bmi <= 24.9) {
      return (
        'Normal (Healthy)',
        '• Maintain balanced meals\n• Stay hydrated and active\n\nKeep up the good work!',
      );
    } else if (bmi <= 29.9) {
      return (
        'Overweight',
        '• Reduce refined sugars\n• Practice portion control\n\nConsider professional guidance',
      );
    } else {
      return (
        'Obese',
        '• Adopt gradual calorie deficit\n• Prioritize fiber and protein\n\nSeek medical support',
      );
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildCalculatorCard(),
              const SizedBox(height: 24),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Body Mass Index',
          style: GoogleFonts.playfairDisplay(
            fontSize: 42,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Calculate your BMI and get personalized nutrition tips.',
          style: GoogleFonts.sourceSans3(
            fontSize: 18,
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCalculatorCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFF1E6D6),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleRow(),
            const SizedBox(height: 16),
            _buildDescriptionText(),
            const SizedBox(height: 24),
            _buildWeightInput(),
            const SizedBox(height: 16),
            _buildHeightInput(),
            const SizedBox(height: 24),
            _buildCalculateButton(),
            if (_bmiResult.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildResultDisplay(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Icon(
          Icons.monitor_weight,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          'BMI Calculator',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      'Enter your weight and height to calculate your Body Mass Index (BMI).',
      style: GoogleFonts.sourceSans3(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Weight', style: _buildLabelStyle()),
        const SizedBox(height: 8),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: _buildInputDecoration(),
        ),
        const SizedBox(height: 8),
        _buildUnitRadioButtons(
          value: _weightUnit,
          options: const {'kg': 'kg', 'lbs': 'lbs'},
          onChanged: (value) => setState(() => _weightUnit = value!),
        ),
      ],
    );
  }

  Widget _buildHeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Height', style: _buildLabelStyle()),
        const SizedBox(height: 8),
        TextField(
          controller: _heightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: _buildInputDecoration(),
        ),
        const SizedBox(height: 8),
        _buildUnitRadioButtons(
          value: _heightUnit,
          options: const {'cm': 'cm', 'in': 'in'},
          onChanged: (value) => setState(() => _heightUnit = value!),
        ),
      ],
    );
  }

  Widget _buildUnitRadioButtons({
    required String value,
    required Map<String, String> options,
    required ValueChanged<String?> onChanged,
  }) {
    final optionEntries = options.entries.toList();
    return Row(
      children: [
        for (int i = 0; i < optionEntries.length; i++) ...[
          Radio<String>(
            value: optionEntries[i].key,
            groupValue: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          Text(optionEntries[i].value, style: GoogleFonts.sourceSans3()),
          if (i != optionEntries.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _calculateBMI,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Calculate BMI',
          style: GoogleFonts.sourceSans3(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildResultDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _bmiResult,
        style: GoogleFonts.sourceSans3(height: 1.6),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'BMI Reference:',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Disclaimer: For informational purposes only.\nConsult a healthcare professional for medical advice.',
          textAlign: TextAlign.center,
          style: GoogleFonts.sourceSans3(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  TextStyle _buildLabelStyle() {
    return GoogleFonts.sourceSans3(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
