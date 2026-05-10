import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/clibo_cubit.dart';
import '../../domain/entities/clibo_ui_state.dart';
import '../widgets/ghost_visual.dart';

class CliboOverlayPage extends StatelessWidget {
  const CliboOverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Material is required for text styling, but we keep it transparent
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<CliboCubit, CliboUiState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The Vagus Nerve Visualizer
                GhostVisual(
                  pulseLabel: state.currentPulse,
                  isPulsing: state.isPulsing || state.status == CliboStatus.thinking,
                ),
                
                // Minimal text feedback for the "Impulse" reply
                if (state.lastReply.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Text(
                      state.lastReply,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
