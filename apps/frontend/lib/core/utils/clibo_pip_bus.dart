import 'dart:async';

/// Unified cross-feature communication payloads for CliboPip components
class PipEvent {
  final int selectedHourIndex;
  final Map<String, dynamic>? telemetryPayload;

  PipEvent({
    required this.selectedHourIndex,
    this.telemetryPayload,
  });
}

class CliboPipBus {
  // Shared global stream channel across infrastructure and UI layers
  static final StreamController<PipEvent> _pipeline = StreamController<PipEvent>.broadcast();

  static Stream<PipEvent> get stream => _pipeline.stream;

  /// Broadcasts tracking parameters globally down to listening targets
  static void emit(PipEvent event) {
    if (!_pipeline.isClosed) {
      _pipeline.add(event);
    }
  }

  static void dispose() {
    _pipeline.close();
  }
}
