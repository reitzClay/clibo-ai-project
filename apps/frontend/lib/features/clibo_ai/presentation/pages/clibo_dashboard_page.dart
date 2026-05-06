import 'package:flutter/material.dart';
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
  
  final List<CliboDataSeed> _activeSeeds = [
    CliboDataSeed(hourIndex: 10, type: SpeciesType.physical, label: "Gym Session"),
    CliboDataSeed(hourIndex: 10, type: SpeciesType.media, label: "Progress Photo"), // Multi-seed example
    CliboDataSeed(hourIndex: 14, type: SpeciesType.cognitive, label: "Deep Work"),
    CliboDataSeed(hourIndex: 18, type: SpeciesType.social, label: "Dinner Meeting"),
    CliboDataSeed(hourIndex: 20, type: SpeciesType.media, label: "Evening Photo"),
  ];

  @override
  Widget build(BuildContext context) {
    final hourSeeds = _activeSeeds.where((s) => s.hourIndex == _selectedHourIdx).toList();
    final bool hasData = hourSeeds.isNotEmpty;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          "CLIBO S.P.E.C.I.E.S.", 
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, fontSize: 16)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const CliboDrawer(),
      body: Stack(
        children: [
          _buildBackgroundAura(),
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
                      tag: 'goal_seed_$_selectedHourIdx',
                      child: Icon(
                        hasData ? Icons.auto_awesome_motion : Icons.radio_button_unchecked,
                        color: hasData ? Colors.cyanAccent : Colors.white10,
                        size: 45,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Refactored Multi-Dimension View
                    TemporalRoomView(
                      hourIdx: _selectedHourIdx,
                      seeds: hourSeeds,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HorizontalTimeBar(
        totalHours: 720,
        activeSeeds: _activeSeeds,
        onSelectionChanged: (index) {
          setState(() => _selectedHourIdx = index);
        },
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
