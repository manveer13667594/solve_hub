import 'package:flutter/material.dart';

class FormulaCategoryWidget extends StatelessWidget {
  const FormulaCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 150,
                  child: Column(
                    children: [
                      Image.asset(
                        'lib/assets/images/maths.jpg',
                        height: 100,
                      ),
                      const Text(
                        'Algebra',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Text(
                        'Explore linear equations, quadratic formulas, and polynomials.',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                    // C:\Users\DELL\Desktop\Flutter\solve_hub\lib\assets\images\maths.jpg
                  ),
                ),
              );
  }
}