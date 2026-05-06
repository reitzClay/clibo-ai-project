// lib/features/clibo_ai/domain/repositories/ICliboRepository.dart
abstract class ICliboRepository {
  Stream<dynamic> get pulseStream;
  Future<String> postImpulse(String message, {String? vision});
}
