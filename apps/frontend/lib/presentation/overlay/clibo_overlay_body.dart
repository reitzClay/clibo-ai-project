import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final GlobalKey _boundaryKey = GlobalKey();
  
  // adb reverse tcp:8080 tcp:8080 must be active on MSI
  final _pulseChannel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/clibo-pulse'),
  );

  String _lastReply = "Waiting for impulse...";
  bool _isConnecting = true;

  @override
  void initState() {
    super.initState();
    _pulseChannel.ready.then((_) {
      if (mounted) setState(() => _isConnecting = false);
    });
  }

  Future<String?> _captureVision() async {
    try {
      RenderRepaintBoundary boundary = 
          _boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return base64Encode(byteData!.buffer.asUint8List());
    } catch (e) {
      return null;
    }
  }

  Future<void> _sendImpulse({bool withVision = false}) async {
    final message = _inputController.text;
    String? visionData;

    if (message.isEmpty && !withVision) return;
    _inputController.clear();
    setState(() => _lastReply = "Thinking...");

    if (withVision) visionData = await _captureVision();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/clibo/impulse'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "message": message.isEmpty ? "What do you see?" : message,
          "sessionId": "clibo-user-01",
          "base64Media": visionData,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _lastReply = data['reply'] ?? "...");
      }
    } catch (e) {
      setState(() => _lastReply = "Path severed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: RepaintBoundary(
        key: _boundaryKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.cyan.withOpacity(0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder(
                stream: _pulseChannel.stream,
                initialData: "IDLE",
                builder: (context, snapshot) {
                  final pulse = snapshot.data.toString();
                  return Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/blob.json',
                        width: 140,
                        height: 140,
                        animate: pulse != "IDLE", 
                        repeat: true,
                      ),
                      Text(pulse, style: const TextStyle(color: Colors.cyanAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(_lastReply, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(height: 18),
              TextField(
                controller: _inputController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: _isConnecting ? "Waking Pulse..." : "Enter impulse...",
                  prefixIcon: IconButton(icon: const Icon(Icons.remove_red_eye, color: Colors.cyanAccent), onPressed: () => _sendImpulse(withVision: true)),
                  suffixIcon: IconButton(icon: const Icon(Icons.bolt, color: Colors.cyanAccent), onPressed: () => _sendImpulse()),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                onSubmitted: (_) => _sendImpulse(),
              ),
            ],
          ),
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
