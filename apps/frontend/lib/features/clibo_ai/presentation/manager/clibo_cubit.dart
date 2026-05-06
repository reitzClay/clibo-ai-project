import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ICliboRepository.dart';
import '../../domain/entities/clibo_ui_state.dart';

class CliboCubit extends Cubit<CliboUiState> {
  final ICliboRepository repository;
  StreamSubscription? _pulseSubscription;

  // Removed _initPulse() from constructor to prevent Isolate Hang
  CliboCubit({required this.repository}) : super(CliboUiState.initial());

  /// Explicitly start connection logic after UI mount
  void startPulsing() {
    _pulseSubscription?.cancel();
    _pulseSubscription = repository.pulseStream.listen(
      (event) {
        emit(state.copyWith(
          status: CliboStatus.idle,
          currentPulse: event.toString(),
        ));
      },
      onError: (err) {
        emit(state.copyWith(status: CliboStatus.error, lastReply: "Pulse Lost."));
      },
    );
  }

  Future<void> sendImpulse(String message, {String? visionData}) async {
    if (message.isEmpty && visionData == null) return;
    emit(state.copyWith(status: CliboStatus.thinking, lastReply: "Thinking..."));

    try {
      final reply = await repository.postImpulse(message, vision: visionData);
      emit(state.copyWith(status: CliboStatus.replyReceived, lastReply: reply));
    } catch (e) {
      emit(state.copyWith(status: CliboStatus.error, lastReply: "Path severed."));
    }
  }

  @override
  Future<void> close() {
    _pulseSubscription?.cancel();
    return super.close();
  }
}
