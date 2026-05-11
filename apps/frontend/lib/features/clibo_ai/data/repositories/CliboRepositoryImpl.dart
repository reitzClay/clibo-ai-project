// lib/features/clibo_ai/data/repositories/clibo_repository_impl.dart

import '../../domain/entities/temporal_block.dart';
import '../../domain/repositories/ICliboRepository.dart';
import '../datasources/clibo_socket_provider.dart';
import '../models/pulse_event_model.dart';

class CliboRepositoryImpl implements ICliboRepository {
  final CliboSocketProvider dataSource;
  
  CliboRepositoryImpl(this.dataSource);

  @override
  Stream<dynamic> get pulseStream => dataSource.pulseStream;

  @override
  Future<List<TemporalBlock>> getTimeline() async {
    // Note: If your dataSource doesn't have fetchTimeline yet, 
    // it should perform a standard GET request to /timeline
    try {
      final List<dynamic> rawData = await dataSource.fetchTimeline();
      return rawData.map((json) => TemporalBlockModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Failed to retrieve temporal timeline: $e");
    }
  }

  @override
  Future<String> postImpulse(String message, {String? vision}) async {
    // This now correctly awaits the Map returned by the provider
    final data = await dataSource.sendImpulse(message, visionData: vision);
    
    // Safety check for the 'reply' key from your backend JSON
    return data['reply'] ?? "Impulse synchronized.";
  }
}
