// lib/features/clibo_ai/presentation/widgets/temporal_room_view.dart

import 'package:flutter/material.dart';
import '../../domain/entities/temporal_block.dart';

class TemporalRoomView extends StatelessWidget {
  final int hourIdx;
  final List<TemporalBlock> blocks;

  const TemporalRoomView({
    super.key,
    required this.hourIdx,
    required this.blocks,
  });

  Color _getPillarColor(Pillar pillar) {
    switch (pillar) {
      case Pillar.PHYSICAL: return Colors.redAccent;
      case Pillar.INTELLECTUAL: return Colors.cyanAccent;
      case Pillar.SOCIAL: return Colors.orangeAccent;
      case Pillar.EMOTIONAL: return Colors.pinkAccent;
      case Pillar.CAREER: return Colors.blueAccent;
      case Pillar.ENVIRONMENTAL: return Colors.greenAccent;
      case Pillar.SPIRITUAL: return Colors.deepPurpleAccent;
    }
  }

  void _showBlockDetails(BuildContext context, TemporalBlock block) {
    final pillarColor = _getPillarColor(block.pillar);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: pillarColor.withOpacity(0.5), width: 1)),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 30),
            Text(block.pillar.name, style: TextStyle(color: pillarColor, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(block.title.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
            const Divider(color: Colors.white10, height: 40),
            Text("PROTOCOL TELEMETRY", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, letterSpacing: 1)),
            const SizedBox(height: 12),
            Text(
              block.description ?? "No telemetry data recorded for this temporal node.",
              style: const TextStyle(color: Colors.white70, height: 1.6, fontSize: 14),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: pillarColor),
                const SizedBox(width: 8),
                Text(block.location, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (blocks.isEmpty) return _buildEmptyVoid();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        final block = blocks[index];
        final pillarColor = _getPillarColor(block.pillar);

        return GestureDetector(
          onTap: () => _showBlockDetails(context, block),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: pillarColor.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: pillarColor.withOpacity(0.1), width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 4, height: 30,
                  decoration: BoxDecoration(
                    color: pillarColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [BoxShadow(color: pillarColor.withOpacity(0.4), blurRadius: 8)],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        block.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        block.pillar.name,
                        style: TextStyle(color: pillarColor.withOpacity(0.5), fontSize: 10, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 18, color: Colors.white.withOpacity(0.1)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyVoid() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.blur_on, size: 40, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 16),
          Text(
            "NO ACTIVE IMPULSES",
            style: TextStyle(color: Colors.white.withOpacity(0.1), letterSpacing: 3, fontSize: 10, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
