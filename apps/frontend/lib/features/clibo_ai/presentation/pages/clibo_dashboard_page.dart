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
  int _selectedHourIdx = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CliboCubit, CliboUiState>(
      builder: (context, state) {
        final activeBlocks = state.timeline.where((block) {
          return block.startTime.hour == (_selectedHourIdx % 24);
        }).toList();

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFF050505),
          appBar: AppBar(
            title: const Text(
              "CLIBO S.P.E.C.I.E.S.",
              style: TextStyle(
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.sync,
                  color: state.isPulsing ? Colors.cyanAccent : Colors.white24,
                  size: 18,
                ),
                onPressed: () => context.read<CliboCubit>().syncTemporalData(),
              ),
            ],
          ),
          drawer: const CliboDrawer(),
          body: Stack(
            children: [
              _buildBackgroundAura(),
              if (state.isPulsing) _buildPulseOverlay(),
              
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildTemporalHeader(),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation.drive(Tween(begin: 0.98, end: 1.0)),
                              child: child,
                            ),
                          );
                        },
                        child: TemporalRoomView(
                          key: ValueKey<int>(_selectedHourIdx),
                          hourIdx: _selectedHourIdx,
                          blocks: activeBlocks,
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildTemporalHeader() {
    return Column(
      children: [
        Text(
          "TEMPORAL DOMAIN",
          style: TextStyle(
            color: Colors.cyanAccent.withOpacity(0.5),
            fontSize: 10,
            letterSpacing: 3,
          ),
        ),
        Text(
          "${(_selectedHourIdx % 24).toString().padLeft(2, '0')}:00",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w100,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildPulseOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundAura() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF0A192F), Colors.black],
          ),
        ),
      ),
    );
  }
}
