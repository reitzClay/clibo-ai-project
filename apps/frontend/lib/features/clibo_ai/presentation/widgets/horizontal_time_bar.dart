// lib/features/clibo_ai/presentation/widgets/horizontal_time_bar.dart

import 'package:flutter/material.dart';
import '../../domain/entities/temporal_block.dart';

class HorizontalTimeBar extends StatelessWidget {
  final int totalHours;
  final List<TemporalBlock> activeBlocks;
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
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalHours,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final hourLabel = index % 24;
          final hasData = activeBlocks.any((b) => b.startTime.hour == hourLabel);
          
          return GestureDetector(
            onTap: () => onSelectionChanged(index),
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.white.withOpacity(0.02), width: 0.5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${hourLabel}H",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: hasData ? FontWeight.bold : FontWeight.normal,
                      color: hasData ? Colors.cyanAccent : Colors.white24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 4,
                    height: hasData ? 12 : 4,
                    decoration: BoxDecoration(
                      color: hasData ? Colors.cyanAccent : Colors.white10,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: hasData ? [
                        BoxShadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 4)
                      ] : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
