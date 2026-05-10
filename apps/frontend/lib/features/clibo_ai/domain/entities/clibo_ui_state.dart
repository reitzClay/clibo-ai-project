import 'package:equatable/equatable.dart';
import 'clibo_seed.dart';
import 'temporal_block.dart';

enum CliboStatus { connecting, idle, thinking, replyReceived, error }

class CliboUiState extends Equatable {
  final CliboStatus status;
  final String lastReply;
  final String currentPulse;
  
  // The S.P.E.C.I.E.S. Data
  final List<TemporalBlock> timeline; 
  final List<CliboSeed> seeds; // Added: Long-term goals
  final bool isPulsing; 
  final String? errorMessage;

  const CliboUiState({
    required this.status,
    this.lastReply = "Waiting for impulse...",
    this.currentPulse = "IDLE",
    this.timeline = const [],
    this.seeds = const [], // Initialized as empty
    this.isPulsing = false,
    this.errorMessage,
  });

  factory CliboUiState.initial() => const CliboUiState(
    status: CliboStatus.connecting,
  );

  CliboUiState copyWith({
    CliboStatus? status,
    String? lastReply,
    String? currentPulse,
    List<TemporalBlock>? timeline,
    List<CliboSeed>? seeds, // Added to copyWith
    bool? isPulsing,
    String? errorMessage,
  }) {
    return CliboUiState(
      status: status ?? this.status,
      lastReply: lastReply ?? this.lastReply,
      currentPulse: currentPulse ?? this.currentPulse,
      timeline: timeline ?? this.timeline,
      seeds: seeds ?? this.seeds,
      isPulsing: isPulsing ?? this.isPulsing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status, 
    lastReply, 
    currentPulse, 
    timeline, 
    seeds, 
    isPulsing, 
    errorMessage
  ];
}
