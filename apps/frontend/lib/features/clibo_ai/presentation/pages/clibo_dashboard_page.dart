// lib/features/clibo_ai/presentation/pages/clibo_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/clibo_cubit.dart';
import '../../domain/entities/clibo_ui_state.dart';
import '../widgets/clibo_drawer.dart';
import '../widgets/horizontal_time_bar.dart';
import '../widgets/temporal_room_view.dart';

class CliboDashboardPage extends StatefulWidget {
  const CliboDashboardPage({super.key});

  @override
  State<CliboDashboardPage> createState() => _CliboDashboardPageState();
}

class _CliboDashboardPageState extends State<CliboDashboardPage> {
  // We keep local selection for UI focus, but pull DATA from the Cubit
  int _selectedHourIdx = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CliboCubit, CliboUiState>(
      builder: (context, state) {
        // FILTER: Find blocks that match the selected hour
        // Note: Real logic would compare DateTime objects from state.timeline
        final activeBlocks = state.timeline.where((block) {
          return block.startTime.hour == (_selectedHourIdx % 24);
        }).toList();

        final bool hasData = activeBlocks.isNotEmpty;

        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text("CLIBO S.P.E.C.I.E.S.", 
              style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, fontSize: 16)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          drawer: const CliboDrawer(),
          body: Stack(
            children: [
              _buildBackgroundAura(),
              // reactive Pulse indicator (The Vagus Nerve)
              if (state.isPulsing) _buildPulseOverlay(), 
              
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    key: ValueKey<int>(_selectedHourIdx),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'goal_block_$_selectedHourIdx',
                          child: Icon(
                            hasData ? Icons.auto_awesome_motion : Icons.radio_button_unchecked,
                            color: hasData ? Colors.cyanAccent : Colors.white10,
                            size: 45,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Real data from Quarkus flowing here
                        TemporalRoomView(
                          hourIdx: _selectedHourIdx,
                          blocks: activeBlocks, 
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: HorizontalTimeBar(
              totalHours: 720,
              activeBlocks: state.timeline,
              onSelectionChanged: (index) {
                setState(() => _selectedHourIdx = index);
              },
            ),
          ),

        );
      },
    );
  }

  Widget _buildPulseOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.cyanAccent.withOpacity(0.02),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 1)),
      ),
    );
  }

  Widget _buildBackgroundAura() {
    return Positioned(
      top: -50, left: -50,
      child: Container(
        width: 250, height: 250, 
        decoration: BoxDecoration(
          shape: BoxShape.circle, 
          color: Colors.cyanAccent.withOpacity(0.05)
        )
      ),
    );
  }
}
