import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/species_theme.dart';

enum SpeciesType { social, physical, emotional, cognitive, interpersonal, environmental, spiritual, media }

class CliboDataSeed {
  final int hourIndex;
  final SpeciesType type;
  final String? label;
  final String? subLabel;
  final int startMinute; 
  final int endMinute;   

  CliboDataSeed({
    required this.hourIndex,
    required this.type,
    this.label,
    this.subLabel,
    this.startMinute = 0, 
    this.endMinute = 59,  
  });
}

class HorizontalTimeBar extends StatefulWidget {
  final int totalHours;
  final Function(int index)? onSelectionChanged;
  final List<CliboDataSeed> activeSeeds;

  const HorizontalTimeBar({
    super.key,
    this.totalHours = 720,
    this.onSelectionChanged,
    this.activeSeeds = const [],
  });

  @override
  State<HorizontalTimeBar> createState() => _HorizontalTimeBarState();
}

class _HorizontalTimeBarState extends State<HorizontalTimeBar> {
  int? _selectedIdx;
  double _zoomLevel = 1.0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedIdx = DateTime.now().hour;
  }

  void _snapToHour(double itemWidth) {
    if (!_scrollController.hasClients) return;
    final double offset = _scrollController.offset;
    final int nearestIndex = (offset / itemWidth).round();
    _scrollController.animateTo(
      nearestIndex * itemWidth,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Width logic remains, but margins are removed for a continuous line
    final double itemWidth = (85.0 * _zoomLevel).clamp(50.0, 200.0);
    final bool isZoomedOut = _zoomLevel < 0.6;
    final speciesTheme = Theme.of(context).extension<SpeciesTheme>()!;

    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        // Continuous line at the top of the bar
        border: const Border(top: BorderSide(color: Colors.cyanAccent, width: 0.2)),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: GestureDetector(
          onScaleUpdate: (details) {
            setState(() => _zoomLevel = (_zoomLevel * details.scale).clamp(0.4, 2.5));
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                _snapToHour(itemWidth);
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.totalHours,
              // Padding removed to allow line to reach edges
              itemBuilder: (context, index) {
                return _HourSlot(
                  index: index,
                  width: itemWidth,
                  isSelected: _selectedIdx == index,
                  isZoomedOut: isZoomedOut,
                  seeds: widget.activeSeeds.where((s) => s.hourIndex == index).toList(),
                  speciesTheme: speciesTheme,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedIdx = index);
                    widget.onSelectionChanged?.call(index);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HourSlot extends StatelessWidget {
  final int index;
  final double width;
  final bool isSelected;
  final bool isZoomedOut;
  final List<CliboDataSeed> seeds;
  final SpeciesTheme speciesTheme;
  final VoidCallback onTap;

  const _HourSlot({
    required this.index,
    required this.width,
    required this.isSelected,
    required this.isZoomedOut,
    required this.seeds,
    required this.speciesTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int hour = index % 24;
    final DateTime date = DateTime.now()
        .subtract(Duration(hours: DateTime.now().hour))
        .add(Duration(hours: index));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        // Card-style margins removed for "Continuous" look
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyanAccent.withOpacity(0.08) : Colors.transparent,
          // Individual card borders replaced with a continuous vertical "Tick" system
          border: Border(
            left: BorderSide(
              color: hour == 0 ? Colors.cyanAccent.withOpacity(0.5) : Colors.white10,
              width: hour == 0 ? 1.5 : 0.5,
            ),
            // Bottom highlight for selection
            bottom: isSelected 
              ? const BorderSide(color: Colors.cyanAccent, width: 2) 
              : BorderSide.none,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isZoomedOut || hour == 0)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  hour == 0 ? DateFormat('MMM d').format(date) : "$hour:00",
                  style: TextStyle(
                    fontSize: isSelected ? 14 : 11,
                    color: isSelected ? Colors.cyanAccent : Colors.white38,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              height: 12,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 2,
                runSpacing: 2,
                children: seeds.take(4).map((seed) => _buildDot(seed)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(CliboDataSeed seed) {
    final color = _getColor(seed.type);
    return Container(
      width: isSelected ? 8 : 5,
      height: isSelected ? 8 : 5,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          if (isSelected) BoxShadow(color: color.withOpacity(0.6), blurRadius: 4)
        ],
      ),
    );
  }

  Color _getColor(SpeciesType type) {
    switch (type) {
      case SpeciesType.physical: return speciesTheme.physical;
      case SpeciesType.emotional: return speciesTheme.emotional;
      case SpeciesType.cognitive: return speciesTheme.cognitive;
      case SpeciesType.social: return speciesTheme.social;
      case SpeciesType.media: return speciesTheme.media;
      case SpeciesType.spiritual: return speciesTheme.spiritual;
      case SpeciesType.environmental: return speciesTheme.environmental;
      case SpeciesType.interpersonal: return speciesTheme.interpersonal;
      default: return Colors.cyanAccent;
    }
  }
}
