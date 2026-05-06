// lib/features/clibo_ai/data/repositories/CliboRepositoryImpl.dart
import '../../domain/repositories/ICliboRepository.dart';
import '../datasources/clibo_socket_provider.dart';

class CliboRepositoryImpl implements ICliboRepository {
  final CliboSocketProvider dataSource;
  CliboRepositoryImpl(this.dataSource);

  @override
  Stream<dynamic> get pulseStream => dataSource.connectPulse().stream;

  @override
  Future<String> postImpulse(String message, {String? vision}) async {
    final data = await dataSource.sendImpulse(message, visionData: vision);
    return data['reply'] ?? "...";
  }
}
