import 'package:flutter/material.dart';
import '../widgets/clibo_drawer.dart';
import '../widgets/horizontal_time_bar.dart';

class CliboDashboardPage extends StatefulWidget {
  const CliboDashboardPage({super.key});

  @override
  State<CliboDashboardPage> createState() => _CliboDashboardPageState();
}

class _CliboDashboardPageState extends State<CliboDashboardPage> {
  int _selectedHour = DateTime.now().hour;
  
  // Mock data for visual testing: 10 AM, 2 PM, and 6 PM have goals
  final List<int> _activeGoals = const [10, 14, 18]; 

  @override
  Widget build(BuildContext context) {
    bool hasGoal = _activeGoals.contains(_selectedHour % 24);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          "DREAM MAP", 
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, fontSize: 18)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const CliboDrawer(),
      body: Stack(
        children: [
          // Subtle background "Aura" for depth
          Positioned(
            top: -100, 
            right: -100,
            child: Container(
              width: 300, 
              height: 300, 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: Colors.deepPurple.withOpacity(0.15)
              )
            ),
          ),
          
          // Main Dream Canvas
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.elasticOut,
              child: Padding(
                key: ValueKey<int>(_selectedHour),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // The Hero "Catch" - Fixed Icon name here
                    Hero(
                      tag: 'goal_seed_$_selectedHour',
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasGoal ? Colors.cyanAccent.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                          boxShadow: hasGoal ? [
                            BoxShadow(color: Colors.cyanAccent.withOpacity(0.2), blurRadius: 40)
                          ] : [],
                        ),
                        child: Icon(
                          hasGoal ? Icons.auto_awesome : Icons.radio_button_unchecked,
                          color: hasGoal ? Colors.cyanAccent : Colors.white24,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildGoalCard(hasGoal),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // The Docked Timeline
      bottomNavigationBar: HorizontalTimeBar(
        totalHours: 24,
        hoursWithGoals: _activeGoals,
        onHourSelected: (hour) => setState(() => _selectedHour = hour),
      ),
    );
  }

  Widget _buildGoalCard(bool hasGoal) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${_selectedHour % 24}:00", 
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w200, color: Colors.white70)
          ),
          const SizedBox(height: 10),
          Text(
            hasGoal ? "PROJECT: CLIBO EVOLUTION" : "UNMAPPED TIME",
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 2, 
              fontWeight: FontWeight.bold, 
              color: hasGoal ? Colors.cyanAccent : Colors.white24
            ),
          ),
          const SizedBox(height: 15),
          Text(
            hasGoal 
              ? "The temporal map architecture is stabilizing. Prepare for Visual Storytelling phase." 
              : "Tap the AI Overlay to architect a dream for this hour.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, height: 1.5),
          ),
        ],
      ),
    );
  }
}
