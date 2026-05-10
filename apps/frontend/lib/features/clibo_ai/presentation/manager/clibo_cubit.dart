import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ICliboRepository.dart';
import '../../domain/entities/clibo_ui_state.dart';
import '../../data/models/pulse_event_model.dart'; 
import '../../domain/entities/temporal_block.dart';


class CliboCubit extends Cubit<CliboUiState> {
  final ICliboRepository repository;
  StreamSubscription? _pulseSubscription;

  CliboCubit({required this.repository}) : super(CliboUiState.initial());

  void startPulsing() {
    _pulseSubscription?.cancel();
    _pulseSubscription = repository.pulseStream.listen(
      (event) => _handleIncomingPulse(event),
      onError: (err) => emit(state.copyWith(errorMessage: "Pulse Lost.")),
    );
  }

  void _handleIncomingPulse(dynamic event) {
    // If the backend sends a list of blocks (The Negotiator's output)
    if (event is Map<String, dynamic> && event.containsKey('suggestedSchedule')) {
      final List rawBlocks = event['suggestedSchedule'];
      final newBlocks = rawBlocks.map((b) => TemporalBlockModel.fromJson(b)).toList();
      
      emit(state.copyWith(
        timeline: newBlocks, // This updates your Horizontal Time Bar
        isPulsing: false,    // Stop the Lottie 'thinking' animation
      ));
    } else {
      // Handle simple text pulses/vitals
      print("Heartbeat received: $event");
    }
  }

  Future<void> sendImpulse(String message, {String? visionData}) async {
    // Trigger the 'blob.json' pulsing animation immediately
    emit(state.copyWith(isPulsing: true));

    try {
      final reply = await repository.postImpulse(message, vision: visionData);
      // We don't necessarily set isPulsing to false here because 
      // the real 'answer' comes back via the WebSocket pulseStream.
    } catch (e) {
      emit(state.copyWith(isPulsing: false, errorMessage: "Path severed."));
    }
  }

  @override
  Future<void> close() {
    _pulseSubscription?.cancel();
    return super.close();
  }
}
