import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 96,
  });

  @override
  Widget build(BuildContext context) {
    final double innerSize = size * 0.60;
    final double smallCircleSize = size * 0.19;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE9E3D4),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F3EC),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF183C29),
              width: size * 0.04,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: size * 0.125,
                top: size * 0.145,
                child: Container(
                  width: smallCircleSize,
                  height: smallCircleSize,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9B95F),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                right: size * 0.105,
                bottom: size * 0.105,
                child: Container(
                  width: smallCircleSize,
                  height: smallCircleSize,
                  decoration: const BoxDecoration(
                    color: Color(0xFF79A88A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}