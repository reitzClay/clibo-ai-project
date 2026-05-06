enum CliboStatus { 
  connecting, 
  idle, 
  thinking, 
  replyReceived, 
  error 
}

class CliboUiState {
  final CliboStatus status;
  final String lastReply;
  final String currentPulse;

  const CliboUiState({
    required this.status,
    this.lastReply = "Waiting for impulse...",
    this.currentPulse = "IDLE",
  });

  // Helper for the initial state
  factory CliboUiState.initial() => const CliboUiState(
    status: CliboStatus.connecting,
  );

  // CopyWith for the Cubit to emit partial updates
  CliboUiState copyWith({
    CliboStatus? status,
    String? lastReply,
    String? currentPulse,
  }) {
    return CliboUiState(
      status: status ?? this.status,
      lastReply: lastReply ?? this.lastReply,
      currentPulse: currentPulse ?? this.currentPulse,
    );
  }
}
