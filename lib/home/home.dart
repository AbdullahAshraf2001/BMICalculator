import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  final void Function(bool) onToggleTheme;
  final bool isDarkMode;
  const BMICalculator({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Male';
  String _result = '';
  String _advice = '';

  void _calculateBMI() {
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);
    final int? age = int.tryParse(_ageController.text);

    if (weight != null && height != null && height > 0 && age != null) {
      final double heightInMeters = height / 100;
      final double bmi = weight / (heightInMeters * heightInMeters);
      String category;
      String advice;

      if (bmi < 18.5) {
        category = "Underweight";
        advice =
            "\nYou are underweight. Consider eating more nutritious foods and consulting a dietitian.";
        if (_selectedGender == 'Male') {
          advice +=
              "\nAs a male, low BMI might affect muscle mass and energy levels.";
        } else {
          advice +=
              "\nAs a female, it may lead to hormonal or fertility concerns.";
        }
      } else if (bmi < 24.9) {
        category = "Normal weight";
        advice =
            "\nGreat! Maintain your weight with a balanced diet and regular exercise.";
      } else if (bmi < 29.9) {
        category = "Overweight";
        advice =
            "You are slightly overweight. Try incorporating daily exercise and healthy meals.";
        if (_selectedGender == 'Female') {
          advice +=
              "\nWomen may benefit from cardio and strength workouts to manage weight effectively.";
        } else {
          advice +=
              "\nMen can focus on increasing activity and reducing processed foods.";
        }
      } else {
        category = "Obese";
        advice =
            "You are in the obese range. It's a good idea to speak with a healthcare provider for support.";
        if (_selectedGender == 'Female') {
          advice +=
              "\nWomen with high BMI should watch for joint and heart issues.";
        } else {
          advice +=
              "\nObesity in men can lead to higher risk of heart disease and diabetes.";
        }
      }

      if (age < 18) {
        advice +=
            "\nNote: As you're under 18, BMI categories may not apply accurately. Consider consulting a pediatrician.";
      } else if (age > 60) {
        advice +=
            "\nAt your age, maintaining strength and mobility is as important as BMI. Consider speaking to a doctor for a full health check.";
      }

      setState(() {
        _result =
            "BMI: ${bmi.toStringAsFixed(1)} ($category)\nGender: $_selectedGender, Age: $age";
        _advice = advice;
      });
    } else {
      setState(() {
        _result = "Please enter valid inputs.";
        _advice = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Switch(value: widget.isDarkMode, onChanged: widget.onToggleTheme),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(labelText: 'Gender'),
              items:
                  ['Male', 'Female'].map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedGender = val!;
                });
              },
            ),
            SizedBox(height: 16),
            _buildInputField('Age', _ageController),
            _buildInputField('Weight (kg)', _weightController),
            _buildInputField('Height (cm)', _heightController),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: Text('Calculate BMI'),
            ),
            SizedBox(height: 30),
            if (_result.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _result,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _advice,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.number,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
