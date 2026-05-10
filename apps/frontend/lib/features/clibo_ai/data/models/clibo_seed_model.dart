import '../../domain/entities/clibo_seed.dart';
import '../../domain/entities/temporal_block.dart';

class CliboSeedModel extends CliboSeed {
  const CliboSeedModel({
    super.id,
    required super.branch,
    super.leaf,
    required super.pillar,
    required super.impactValue,
    super.isAiGenerated,
    super.createdAt,
  });

  factory CliboSeedModel.fromJson(Map<String, dynamic> json) {
    return CliboSeedModel(
      id: json['id'],
      branch: json['branch'],
      leaf: json['leaf'],
      pillar: Pillar.values.firstWhere((e) => e.name == json['pillar']),
      impactValue: json['impactValue'] ?? 0,
      isAiGenerated: json['is_ai_generated'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch': branch,
    'leaf': leaf,
    'pillar': pillar.name,
    'impactValue': impactValue,
    'is_ai_generated': isAiGenerated,
    'created_at': createdAt?.toIso8601String(),
  };
}
