import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}
class _CalculatorPageState extends State<CalculatorPage> {
  final MathFieldEditingController _mathFieldController =
      MathFieldEditingController();
  String _result = '';
  String _rawInput = '';

  /// Converts LaTeX-style input to a parsable mathematical expression.
  String _convertLatexToMath(String latexInput) {
    String sanitizedInput = latexInput;
    // Replace multiplication (\cdot) with *
    sanitizedInput = sanitizedInput.replaceAll(r'\cdot', '*');
    sanitizedInput = sanitizedInput.replaceAll(r'\sqrt', 'sqrt');
    // Replace \pi with pi (MathExpressions understands 'pi')
    sanitizedInput = sanitizedInput.replaceAll(r'\pi', 'pi');
    sanitizedInput = sanitizedInput.replaceAll('e', 'numberEuler');
    // Replace logarithms (\log and \ln)
    sanitizedInput = sanitizedInput.replaceAll(r'\ln', 'ln');
   // Replace nested fractions (\frac{a}{b}) with ((a)/(b)) recursively
    final regex = RegExp(r'\\frac\{([^{}]+)\}\{([^{}]+)\}');
    while (regex.hasMatch(sanitizedInput)) {
      sanitizedInput = sanitizedInput.replaceAllMapped(regex, (match) {
        final numerator = match.group(1)!;
        final denominator = match.group(2)!;
        return '(($numerator)/($denominator))';
      });
    }
    // Replace logarithms with base (\log_{base}(argument))
    sanitizedInput = sanitizedInput
        // Further process the sanitized input to convert it to a parseable format
     .replaceAllMapped(RegExp(r'sqrt\[(\d+)\]\{([^{}]+)\}'), (match) {
      final degree = match.group(1)!;
      final radicand = match.group(2)!;
      double a = double.parse(radicand);
      double b = double.parse(degree);
      if (b == 2) {
        return 'sqrt($a)';
      } else {
        num c = pow(a, 1 / b);
        return '$c';
      }
    })
    // Replace logarithms with base (\log_{base}(argument))
    .replaceAllMapped(RegExp(r'\\log_{([^{}]+)}\(([^()]+)\)'), (match) {
      final base = match.group(1)!;
      final argument = match.group(2)!;
      double a = double.parse(argument);
      double b = double.parse(base);
      double c = log(a) / log(b);
      return c.toString();
    })
    // Replace trigonometric function sin
    .replaceAllMapped(RegExp(r'\\sin\(([^()]+)\)'), (match) {
      final argument = match.group(1)!;
      double a = double.parse(argument);
      double c = sin(a);
      String d = c.toString();
      return d;
    })
     // Replace trigonometric function cos
    .replaceAllMapped(RegExp(r'\\cos\(([^()]+)\)'), (match) {
      final argument = match.group(1)!;
      double a = double.parse(argument);
      double c = cos(a);
      String d = c.toString();
      return d;
    })
     // Replace trigonometric function tan
    .replaceAllMapped(RegExp(r'\\tan\(([^()]+)\)'), (match) {
      final argument = match.group(1)!;
      double a = double.parse(argument);
      double c = tan(a);
      String d = c.toString();
      return d;
    })
     // Replace trigonometric function sin inverse
    .replaceAllMapped(RegExp(r'\\sin\^{-1}\(([^()]+)\)'), (match) {
      final argument = match.group(1)!;
      double a = double.parse(argument);
      double c = asin(a);
      return c.toString();
    })
     // Replace trigonometric function cos inverse
    .replaceAllMapped(RegExp(r'\\cos\^{-1}\(([^()]+)\)'), (match) {
      final argument = match.group(1)!;
      double a = double.parse(argument);
      double c = acos(a);
      return c.toString();
    })
     // Replace trigonometric function tan inverse
    .replaceAllMapped(RegExp(r'\\tan\^{-1}\(([^()]+)\)'), (match) {
      final argument = match.group(1)!;
      double a = double.parse(argument);
      double c = atan(a);
      return c.toString();
    });

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

      // Bind pi to its value;
      contextModel.bindVariable(Variable('pi'), Number(3.141592653589793));
      contextModel.bindVariable(Variable('numberEuler'), Number(2.7182818285));

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

  void _calculateClear() {
    setState(() {
      _mathFieldController.clear();
      _rawInput = '';
      _result = '';
    });
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
              variables: const [
                'x',
                'y',
                'z',
                'a',
                'b',
                'c',
              ],
              controller: _mathFieldController,
              decoration: const InputDecoration(
                hintText: 'Enter expression here...',
              ),
              autofocus: true,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateClear,
                  style: const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(Colors.red)),
                  child: const Text(
                    'Clear',
                  ),
                ),
                ElevatedButton(
                  onPressed: _calculateResult,
                  style: const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(Colors.green)),
                  child: const Text('Calculate'),
                ),
              ],
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
