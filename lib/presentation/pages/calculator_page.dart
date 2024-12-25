import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String inputText = '';
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: MathField(
        keyboardType: MathKeyboardType
            .expression, // Specify the keyboard type (expression or number only).
        variables: [
          'x',
          'y',
          'z',
        ], // Specify the variables the user can use (only in expression mode).
        decoration: InputDecoration(
          hintText: 'Enter here...',
        ), // Decorate the input field using the familiar InputDecoration.
        autofocus: true, // Enable or disable autofocus of the input field.
      ),
    );
  }
}
