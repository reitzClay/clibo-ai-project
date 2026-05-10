import '../../domain/entities/temporal_block.dart';

class TemporalBlockModel extends TemporalBlock {
  const TemporalBlockModel({
    super.id,
    required super.title,
    required super.startTime,
    required super.endTime,
    required super.priority,
    required super.pillar,
    required super.blockType,
    super.isCompleted,
  });

  /// The "Digestive" factory: Converts Quarkus JSON to Flutter Entities
  factory TemporalBlockModel.fromJson(Map<String, dynamic> json) {
    return TemporalBlockModel(
      id: json['id'],
      title: json['title'] ?? 'Untitled Impulse',
      // Quarkus sends timestamps like "2026-05-11 10:00:14"
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      priority: json['priority'] ?? 3,
      pillar: Pillar.values.firstWhere(
        (e) => e.name == json['pillar'],
        orElse: () => Pillar.INTELLECTUAL,
      ),
      blockType: json['blockType'] ?? 'TASK',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'priority': priority,
    'pillar': pillar.name,
    'blockType': blockType,
    'isCompleted': isCompleted,
  };
}
