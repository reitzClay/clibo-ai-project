import 'package:flutter/material.dart';

class CliboBubble extends StatelessWidget {
  final String text;

  const CliboBubble({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    );
  }
}
