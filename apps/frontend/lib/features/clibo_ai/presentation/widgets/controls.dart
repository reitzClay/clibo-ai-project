import 'package:flutter/material.dart';

class CliboControls extends StatefulWidget {
  final bool isConnecting;
  final Function(String message) onSend;
  final VoidCallback? onVisionRequest;

  const CliboControls({
    super.key,
    required this.isConnecting,
    required this.onSend,
    this.onVisionRequest,
  });

  @override
  State<CliboControls> createState() => _CliboControlsState();
}

class _CliboControlsState extends State<CliboControls> {
  final TextEditingController _inputController = TextEditingController();

  void _handleSend() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _inputController.clear();
      // Dismiss keyboard if active
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _inputController,
      style: const TextStyle(color: Colors.white),
      enabled: !widget.isConnecting,
      decoration: InputDecoration(
        hintText: widget.isConnecting ? "Waking Pulse..." : "Enter impulse...",
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white10,
        // The "Vision" Eye Icon
        prefixIcon: IconButton(
          icon: const Icon(Icons.remove_red_eye, color: Colors.cyanAccent),
          onPressed: widget.onVisionRequest,
        ),
        // The "Send" Bolt Icon
        suffixIcon: IconButton(
          icon: const Icon(Icons.bolt, color: Colors.cyanAccent),
          onPressed: _handleSend,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: (_) => _handleSend(),
    );
  }
}
