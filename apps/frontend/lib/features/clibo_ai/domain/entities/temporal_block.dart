// lib/features/clibo_ai/domain/entities/temporal_block.dart

import 'package:equatable/equatable.dart';

enum Pillar { SOCIAL, PHYSICAL, EMOTIONAL, CAREER, INTELLECTUAL, ENVIRONMENTAL, SPIRITUAL }

class TemporalBlock extends Equatable {
  final int? id;
  final String title;
  final String? description; // Missing field restored
  final DateTime startTime;
  final DateTime endTime;
  final int priority;
  final Pillar pillar;
  final String blockType; 
  final bool isCompleted;
  final String location; // Missing field restored

  const TemporalBlock({
    this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.pillar,
    required this.blockType,
    this.isCompleted = false,
    required this.location,
  });

  factory TemporalBlock.fromJson(Map<String, dynamic> json) {
    return TemporalBlock(
      id: json['id'] as int?,
      title: json['title'] ?? 'Unknown Protocol',
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      priority: json['priority'] ?? 3,
      pillar: Pillar.values.firstWhere(
        (e) => e.toString().split('.').last == json['pillar'],
        orElse: () => Pillar.SPIRITUAL,
      ),
      blockType: json['blockType'] ?? 'TASK',
      isCompleted: json['isCompleted'] ?? false,
      location: json['location'] ?? 'Home Base',
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        priority,
        pillar,
        blockType,
        isCompleted,
        location,
      ];
}
