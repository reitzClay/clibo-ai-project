// lib/features/clibo_ai/data/datasources/clibo_socket_provider.dart

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class CliboSocketProvider {
  static const String _baseUrl = 'http://localhost:8080';
  static const String _wsUrl = 'ws://localhost:8080/clibo-pulse';

  WebSocketChannel? _channel;
  
  // Explicitly typed as Map<String, dynamic> to match your Repository expectations
  final StreamController<Map<String, dynamic>> _pulseController = StreamController<Map<String, dynamic>>.broadcast();

  // The "Life-Line": Widgets/Overlay listen to this
  Stream<Map<String, dynamic>> get pulseStream => _pulseController.stream;

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      
      _channel!.stream.listen(
        (data) {
          try {
            final decoded = jsonDecode(data) as Map<String, dynamic>;
            _pulseController.add(decoded);
          } catch (e) {
            print("S.P.E.C.I.E.S. Pulse Decode Error: $e");
          }
        },
        onDone: () => _retryConnection(),
        onError: (e) => _retryConnection(),
      );
    } catch (e) {
      _retryConnection();
    }
  }

  void _retryConnection() {
    print("Vagus Link lost. Re-establishing in 5 seconds...");
    Future.delayed(const Duration(seconds: 5), () => connect());
  }

  /// REST: Fetches the current temporal timeline (Required by CliboRepositoryImpl)
  Future<List<dynamic>> fetchTimeline() async {
    final response = await http.get(Uri.parse('$_baseUrl/timeline'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Temporal sync failed: Status ${response.statusCode}");
    }
  }

  /// Sends a command to the AI Brain
  Future<Map<String, dynamic>> sendImpulse(String message, {String? visionData}) async {
    // Aligned with Quarkus endpoint for goal creation/processing
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/goals'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": message,
        "pillar": "INTELLECTUAL",
        "targetValue": 10,
        "base64Media": visionData,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Path severed: ${response.statusCode}");
    }
  }

  void dispose() {
    _channel?.sink.close();
    _pulseController.close();
  }
}
