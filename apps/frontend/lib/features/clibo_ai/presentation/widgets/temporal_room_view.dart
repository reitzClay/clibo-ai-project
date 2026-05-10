import 'package:flutter/material.dart';
import '../../domain/entities/temporal_block.dart';

class TemporalRoomView extends StatelessWidget {
  final int hourIdx;
  final List<TemporalBlock> blocks; // Renamed from 'seeds'

  const TemporalRoomView({
    super.key,
    required this.hourIdx,
    required this.blocks, // Now matches the Dashboard call
  });

  @override
  Widget build(BuildContext context) {
    if (blocks.isEmpty) return const Text("CHAMBER VACANT", style: TextStyle(color: Colors.white10));
    
    return Column(
      children: blocks.map((block) => Text(
        block.title, 
        style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)
      )).toList(),
    );
  }
}
