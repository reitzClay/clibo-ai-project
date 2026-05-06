import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CliboSocketProvider {
  // Constants moved out of UI
  static const String _baseUrl = 'http://localhost:8080';
  static const String _wsUrl = 'ws://localhost:8080/clibo-pulse';

  WebSocketChannel connectPulse() {
    return WebSocketChannel.connect(Uri.parse(_wsUrl));
  }

  Future<Map<String, dynamic>> sendImpulse(String message, {String? visionData}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/clibo/impulse'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "message": message.isEmpty ? "What do you see?" : message,
        "sessionId": "clibo-user-01",
        "base64Media": visionData,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Path severed: ${response.statusCode}");
    }
  }
}
