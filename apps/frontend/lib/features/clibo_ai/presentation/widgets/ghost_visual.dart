import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GhostVisual extends StatelessWidget {
  final String pulseLabel;
  final bool isAnimating;

  const GhostVisual({
    super.key, 
    required this.pulseLabel, 
    required this.isAnimating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/lottie/blob.json',
          width: 140,
          height: 140,
          animate: isAnimating,
          repeat: true,
        ),
        Text(
          pulseLabel,
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
