import 'package:equatable/equatable.dart';

enum Pillar { SOCIAL, PHYSICAL, EMOTIONAL, CAREER, INTELLECTUAL, ENVIRONMENTAL, SPIRITUAL }

class TemporalBlock extends Equatable {
  final int? id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final int priority;
  final Pillar pillar;
  final String blockType; 
  final bool isCompleted;

  const TemporalBlock({
    this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.pillar,
    required this.blockType,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, title, startTime, endTime, priority, pillar, blockType, isCompleted];
}
