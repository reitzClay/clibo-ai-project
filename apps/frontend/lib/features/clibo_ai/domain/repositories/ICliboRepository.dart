// lib/features/clibo_ai/domain/repositories/ICliboRepository.dart
import '../entities/temporal_block.dart';

abstract class ICliboRepository {
  Stream<dynamic> get pulseStream;
  
  /// Added to resolve the Cubit compilation error
  Future<List<TemporalBlock>> getTimeline();
  
  Future<String> postImpulse(String message, {String? vision});
}
