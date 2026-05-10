import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class CliboSocketProvider {
  // Constants moved out of UI
  static const String _baseUrl = 'http://localhost:8080';
  static const String _wsUrl = 'ws://localhost:8080/clibo-pulse';

   WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _pulseController = StreamController.broadcast();

  // The "Life-Line": Widgets/Overlay listen to this
  Stream<Map<String, dynamic>> get pulseStream => _pulseController.stream;

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      
      _channel!.stream.listen(
        (data) {
          _pulseController.add(jsonDecode(data));
        },
        onDone: () => _retryConnection(),
        onError: (e) => _retryConnection(),
      );
    } catch (e) {
      _retryConnection();
    }
  }

  void _retryConnection() {
    // Basic back-off logic: Wait 5 seconds and try to reconnect
    Future.delayed(const Duration(seconds: 5), () => connect());
  }

  Future<Map<String, dynamic>> sendImpulse(String message, {String? visionData}) async {
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
      // Return the decoded body so the Repository can read the 'reply'
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
