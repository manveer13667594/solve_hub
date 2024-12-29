import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final MathFieldEditingController _mathFieldController = MathFieldEditingController();
  String _result = '';
  String _rawInput = '';

  /// Converts LaTeX-style input to a parsable mathematical expression.
  String _convertLatexToMath(String latexInput) {
    String sanitizedInput = latexInput;

    // Replace multiplication (\cdot) with *
    sanitizedInput = sanitizedInput.replaceAll(r'\cdot', '*');

    // Replace nested fractions (\frac{a}{b}) with ((a)/(b)) recursively
    final regex = RegExp(r'\\frac\{([^{}]+)\}\{([^{}]+)\}');
    while (regex.hasMatch(sanitizedInput)) {
      sanitizedInput = sanitizedInput.replaceAllMapped(regex, (match) {
        final numerator = match.group(1)!;
        final denominator = match.group(2)!;
        return '(($numerator)/($denominator))';
      });
    }

    return sanitizedInput;
  }

  void _calculateResult() {
    try {                                         
      // Retrieve raw input from MathField
      final input = _mathFieldController.currentEditingValue();
      _rawInput = input;

      // Convert LaTeX input to a parsable math expression
      final sanitizedInput = _convertLatexToMath(input);

      // Log transformations for debugging
      print('Raw Input: $input');
      print('Sanitized Input: $sanitizedInput');

      // Parse and evaluate the sanitized expression
      final parser = Parser();
      final expression = parser.parse(sanitizedInput);
      final contextModel = ContextModel();
      final evaluated = expression.evaluate(EvaluationType.REAL, contextModel);

      // Update the result
      setState(() {
        _result = evaluated.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error in expression!';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Math Calculator')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            MathField(
              keyboardType: MathKeyboardType.expression,
              variables: const['x', 'y', 'z', 'a', 'b', 'c'],
              controller: _mathFieldController,
              decoration: const InputDecoration(
                hintText: 'Enter expression here...',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateResult,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 20),
            Text(
              'Raw Input: $_rawInput',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Text(
              'Result: $_result',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
