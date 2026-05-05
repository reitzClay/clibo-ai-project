import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:lottie/lottie.dart';

/// ------------------------------------------------------------------------------
/// 👻 1. OVERLAY ENTRY POINT (Autonomous Isolate)
/// ------------------------------------------------------------------------------
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CliboOverlayBody(),
    ),
  );
}

void main() {
  runApp(const CliboApp());
}

class CliboApp extends StatelessWidget {
  const CliboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const CliboControlPanel(),
    );
  }
}

class CliboControlPanel extends StatelessWidget {
  const CliboControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clibo Controller")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final bool status = await FlutterOverlayWindow.isPermissionGranted();
                if (!status) {
                  await FlutterOverlayWindow.requestPermission();
                }
                if (await FlutterOverlayWindow.isActive()) return;
                await FlutterOverlayWindow.showOverlay(
                  enableDrag: true,
                  flag: OverlayFlag.focusPointer,
                  visibility: NotificationVisibility.visibilityPublic,
                  height: WindowSize.matchParent,
                  width: WindowSize.matchParent,
                );
              },
              icon: const Icon(Icons.visibility),
              label: const Text("Summon Clibo Body"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => FlutterOverlayWindow.closeOverlay(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.1)),
              icon: const Icon(Icons.visibility_off),
              label: const Text("Dismiss Body"),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------------------
/// 🧬 2. THE CLIBO BODY (The actual Overlay UI)
/// ------------------------------------------------------------------------------
class CliboOverlayBody extends StatefulWidget {
  const CliboOverlayBody({super.key});

  @override
  State<CliboOverlayBody> createState() => _CliboOverlayBodyState();
}

class _CliboOverlayBodyState extends State<CliboOverlayBody> {
  final TextEditingController _inputController = TextEditingController();
  
  // adb reverse tcp:8080 tcp:8080 must be active
  final _pulseChannel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/clibo-pulse'),
  );

  String _lastReply = "Waiting for impulse...";

  /// 🧠 THE SENSORY PATH: REST Communication
  Future<void> _sendImpulse() async {
    final message = _inputController.text;
    if (message.isEmpty) return;

    _inputController.clear();
    setState(() => _lastReply = "Thinking...");

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/clibo/impulse'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message, "sessionId": "clibo-1"}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _lastReply = data['reply'] ?? "...");
      } else {
        setState(() => _lastReply = "Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _lastReply = "Path severed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 💓 THE PULSE: WebSocket Stream
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
                    Text(
                      pulse,
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              _lastReply,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _inputController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter impulse...",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white10,
                suffixIcon: IconButton(
                  onPressed: _sendImpulse,
                  icon: const Icon(Icons.bolt, color: Colors.cyanAccent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
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
