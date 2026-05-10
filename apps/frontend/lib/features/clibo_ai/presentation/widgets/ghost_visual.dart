import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GhostVisual extends StatelessWidget {
  final String pulseLabel;
  final bool isPulsing; 

  const GhostVisual({
    super.key, 
    required this.pulseLabel, 
    required this.isPulsing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => RadialGradient(
            colors: [
              Colors.cyanAccent, 
              isPulsing ? Colors.white : Colors.cyanAccent.withOpacity(0.5)
            ],
          ).createShader(bounds),
          child: Lottie.asset(
            'assets/lottie/blob.json',
            width: 180,
            height: 180,
            animate: true, // Always breathing
            repeat: true,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          pulseLabel.toUpperCase(),
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 12,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}
