import 'package:equatable/equatable.dart';
import 'temporal_block.dart'; // To reference the Pillars

class CliboSeed extends Equatable {
  final int? id;
  final String branch;      // The high-level category
  final String? leaf;      // The specific detail or "note" (TEXT in Postgres)
  final Pillar pillar;     // SOCIAL, PHYSICAL, etc.
  final int impactValue;   // How much this moves the needle
  final bool isAiGenerated;
  final DateTime? createdAt;

  const CliboSeed({
    this.id,
    required this.branch,
    this.leaf,
    required this.pillar,
    required this.impactValue,
    this.isAiGenerated = false,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, branch, leaf, pillar, impactValue, isAiGenerated, createdAt];
}
