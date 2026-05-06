import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HorizontalTimeBar extends StatefulWidget {
  final int totalHours;
  final Function(int hour)? onHourSelected; // Callback for the "Chronos-Zoom"
  final List<int> hoursWithGoals; // Pass hours that have existing "Dream Seeds"

  const HorizontalTimeBar({
    super.key,
    this.totalHours = 24,
    this.onHourSelected,
    this.hoursWithGoals = const [], // Default empty to avoid null issues
  });

  @override
  State<HorizontalTimeBar> createState() => _HorizontalTimeBarState();
}

class _HorizontalTimeBarState extends State<HorizontalTimeBar> {
  int? _selectedHour;

  @override
  void initState() {
    super.initState();
    // Default selection to current hour on load for immediate context
    _selectedHour = DateTime.now().hour;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Taller for bottom-dock presence
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        // Top border creates separation from the Dream Canvas above
        border: const Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        top: false, // Ensures padding only for the bottom home indicator/notch
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.totalHours,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            final hour = index % 24;
            final isSelected = _selectedHour == index;
            final hasGoal = widget.hoursWithGoals.contains(hour);
            final isNow = hour == DateTime.now().hour && widget.totalHours == 24;

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact(); // Physical "docking" feel
                setState(() => _selectedHour = index);
                widget.onHourSelected?.call(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                // Corrected: Removed invalid 'tightFor' and using standard Curves
                curve: Curves.easeOutExpo, 
                width: isSelected ? 90 : 70,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.deepPurple.withOpacity(0.5) 
                      : (isNow ? Colors.deepPurpleAccent.withOpacity(0.1) : Colors.white.withOpacity(0.02)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.cyanAccent : (isNow ? Colors.deepPurpleAccent : Colors.white10),
                    width: isSelected ? 1.5 : 0.5,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.15),
                      blurRadius: 12,
                      spreadRadius: 1,
                    )
                  ] : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$hour:00",
                      style: TextStyle(
                        color: isSelected || isNow ? Colors.white : Colors.white38,
                        fontSize: isSelected ? 16 : 13,
                        fontWeight: isSelected || isNow ? FontWeight.bold : FontWeight.w300,
                        letterSpacing: isSelected ? 1.2 : 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // THE SEED: Hero source for the Dream Canvas transition
                    Hero(
                      tag: 'goal_seed_$index',
                      child: Container(
                        width: isSelected ? 12 : 6,
                        height: isSelected ? 12 : 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasGoal ? Colors.cyanAccent : (isSelected ? Colors.white24 : Colors.transparent),
                          boxShadow: hasGoal ? [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.6), 
                              blurRadius: isSelected ? 10 : 4,
                            )
                          ] : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
