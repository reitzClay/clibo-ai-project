import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:lottie/lottie.dart';

class CliboOverlayBody extends StatefulWidget {
  const CliboOverlayBody({super.key});

  @override
  State<CliboOverlayBody> createState() => _CliboOverlayBodyState();
}

class _CliboOverlayBodyState extends State<CliboOverlayBody> {
  final TextEditingController _inputController = TextEditingController();
  
  // Connect via reversed port (adb reverse tcp:8080 tcp:8080)
  final _pulseChannel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/clibo-pulse'),
  );

  String _lastReply = "Waiting for impulse...";
  bool _isConnecting = true;

  @override
  void initState() {
    super.initState();
    // Verification log for the Vagus Nerve
    _pulseChannel.ready.then((_) {
      setState(() => _isConnecting = false);
    });
  }

  /// 🧠 THE SENSORY PATH: Sends text to the Quarkus Brain
  Future<void> _sendImpulse() async {
    final message = _inputController.text;
    if (message.isEmpty) return;

    _inputController.clear();
    setState(() => _lastReply = "Thinking...");

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/clibo/impulse'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "message": message,
          "sessionId": "clibo-user-01",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _lastReply = data['reply'] ?? "...");
      } else {
        setState(() => _lastReply = "Brain stutter: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _lastReply = "Sensory path severed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyan.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 💓 THE PULSE: Real-time Kafka status via WebSocket
            StreamBuilder(
              stream: _pulseChannel.stream,
              initialData: "IDLE",
              builder: (context, snapshot) {
                final pulse = snapshot.data.toString();
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/blob.json',
                      width: 120,
                      height: 120,
                      animate: pulse != "IDLE", 
                      repeat: true,
                    ),
                    Text(
                      pulse,
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            // 🗣️ THE SENSORY FEEDBACK
            Text(
              _lastReply,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 15),
            // 📝 INPUT
            TextField(
              controller: _inputController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: _isConnecting ? "Connecting..." : "Enter impulse...",
                hintStyle: const TextStyle(color: Colors.white54),
                suffixIcon: IconButton(
                  onPressed: _sendImpulse,
                  icon: const Icon(Icons.bolt, color: Colors.cyanAccent),
                ),
                border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
              ),
              onSubmitted: (_) => _sendImpulse(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _pulseChannel.sink.close();
    super.dispose();
  }
}
