import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/clibo_cubit.dart';
import '../../domain/entities/clibo_ui_state.dart';
import '../widgets/ghost_visual.dart';
import '../widgets/bubble.dart';
import '../widgets/controls.dart';

class CliboOverlayPage extends StatelessWidget {
  const CliboOverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<CliboCubit, CliboUiState>(
        builder: (context, state) {
          return Container(
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
                // 👻 Delegated to specialized widget
                GhostVisual(
                  pulseLabel: state.currentPulse,
                  isAnimating: state.status == CliboStatus.thinking || state.currentPulse != "IDLE",
                ),
                const SizedBox(height: 10),
                
                // 💬 Delegated to bubble widget
                CliboBubble(text: state.lastReply),
                const SizedBox(height: 20),
                
                // ⚡ Delegated to controls widget
                CliboControls(
                  isConnecting: state.status == CliboStatus.connecting,
                  onSend: (msg) => context.read<CliboCubit>().sendImpulse(msg),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
