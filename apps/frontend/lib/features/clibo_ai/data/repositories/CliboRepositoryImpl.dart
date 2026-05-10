import '../../domain/repositories/ICliboRepository.dart';
import '../datasources/clibo_socket_provider.dart';

class CliboRepositoryImpl implements ICliboRepository {
  final CliboSocketProvider dataSource;
  
  CliboRepositoryImpl(this.dataSource);

  // FIXED: Connect to the broadcast stream getter we defined in the provider
  @override
  Stream<dynamic> get pulseStream => dataSource.pulseStream;

  @override
  Future<String> postImpulse(String message, {String? vision}) async {
    // This now correctly awaits the Map returned by the provider
    final data = await dataSource.sendImpulse(message, visionData: vision);
    
    // Safety check for the 'reply' key from your backend JSON
    return data['reply'] ?? "Impulse synchronized.";
  }
}
