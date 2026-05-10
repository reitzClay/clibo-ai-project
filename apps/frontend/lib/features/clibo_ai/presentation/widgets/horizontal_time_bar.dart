import 'package:flutter/material.dart';
import '../../domain/entities/temporal_block.dart';

class HorizontalTimeBar extends StatelessWidget {
  final int totalHours;
  final List<TemporalBlock> activeBlocks; // Renamed from 'activeSeeds'
  final Function(int) onSelectionChanged;

  const HorizontalTimeBar({
    super.key,
    required this.totalHours,
    required this.activeBlocks,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.black.withOpacity(0.5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalHours,
        itemBuilder: (context, index) {
          // Logic to check if this hour has a block
          final hasData = activeBlocks.any((b) => b.startTime.hour == (index % 24));
          
          return GestureDetector(
            onTap: () => onSelectionChanged(index),
            child: Container(
              width: 40,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: hasData ? Colors.cyanAccent.withOpacity(0.2) : Colors.white10,
              child: Center(child: Text("${index % 24}h", style: const TextStyle(fontSize: 10))),
            ),
          );
        },
      ),
    );
  }
}
