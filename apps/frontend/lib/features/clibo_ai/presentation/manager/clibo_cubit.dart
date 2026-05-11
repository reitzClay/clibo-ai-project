// lib/features/clibo_ai/presentation/manager/clibo_cubit.dart

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

  Future<void> syncTemporalData() async {
    emit(state.copyWith(isPulsing: true));
    try {
      final List<TemporalBlock> currentTimeline = await repository.getTimeline();
      
      emit(state.copyWith(
        timeline: currentTimeline,
        isPulsing: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isPulsing: false, 
        errorMessage: "Synchronization failed: Path severed."
      ));
    }
  }

  void startPulsing() {
    _pulseSubscription?.cancel();
    _pulseSubscription = repository.pulseStream.listen(
      (event) => _handleIncomingPulse(event),
      onError: (err) => emit(state.copyWith(errorMessage: "Pulse Lost.")),
    );
  }

  void _handleIncomingPulse(dynamic event) {
    if (event is Map<String, dynamic> && event.containsKey('suggestedSchedule')) {
      final List rawBlocks = event['suggestedSchedule'];
      final newBlocks = rawBlocks.map((b) => TemporalBlockModel.fromJson(b)).toList();
      
      emit(state.copyWith(
        timeline: newBlocks,
        isPulsing: false,
        errorMessage: null,
      ));
    }
  }

  Future<void> sendImpulse(String message, {String? visionData}) async {
    emit(state.copyWith(isPulsing: true));
    try {
      // Logic adjusted: Capture the String reply if needed
      final String acknowledgment = await repository.postImpulse(message, vision: visionData);
      print("S.P.E.C.I.E.S. Acknowledgment: $acknowledgment");
      
      // We keep isPulsing true because the actual schedule update 
      // usually arrives via the WebSocket pulseStream.
    } catch (e) {
      emit(state.copyWith(isPulsing: false, errorMessage: "Impulse failed."));
    }
  }

  @override
  Future<void> close() {
    _pulseSubscription?.cancel();
    return super.close();
  }
}
