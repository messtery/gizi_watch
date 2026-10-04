import 'dart:math' as math;

import 'package:flutter/material.dart';

class NutritionOrbit extends StatelessWidget {
  const NutritionOrbit({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 142,
            height: 142,
            decoration: const BoxDecoration(
              color: Color(0xFFE6E0D1),
              shape: BoxShape.circle,
            ),
          ),

          Transform.rotate(
            angle: -math.pi / 8,
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2F6541), width: 6),
              ),
            ),
          ),

          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: Color(0xFFF7F3E9),
              shape: BoxShape.circle,
            ),
          ),

          Positioned(
            top: 33,
            left: 50,
            child: _circle(28, const Color(0xFFF0B65E)),
          ),

          Positioned(
            right: 27,
            top: 45,
            child: _circle(25, const Color(0xFF76A783)),
          ),

          Positioned(
            bottom: 28,
            left: 55,
            child: _circle(27, const Color(0xFFC86F47)),
          ),

          Positioned(
            top: 4,
            right: 7,
            child: _circle(18, const Color(0xFFD8E4F1)),
          ),

          Positioned(
            bottom: 10,
            left: 7,
            child: _circle(13, const Color(0xFFF3D2B7)),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
