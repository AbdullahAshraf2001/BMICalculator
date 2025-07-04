import 'package:flutter/material.dart';
import 'package:flutter_application_2/home/utilities/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BMICalculatorApp());
  }
}
