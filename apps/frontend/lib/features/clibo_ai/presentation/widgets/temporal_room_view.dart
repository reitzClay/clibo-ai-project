import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/species_theme.dart';
import 'horizontal_time_bar.dart';

class TemporalRoomView extends StatelessWidget {
  final int hourIdx;
  final List<CliboDataSeed> seeds;

  const TemporalRoomView({
    super.key,
    required this.hourIdx,
    required this.seeds,
  });

  @override
  Widget build(BuildContext context) {
    // 120 FPS Scaling: 1 min = 8px
    const double minToPx = 8.0;
    const double totalTapeWidth = 60 * minToPx;
    
    // Stack Logic Constants
    const double laneHeight = 54.0; 
    const double topPadding = 10.0;  

    return Container(
      // Height can be adjusted or removed based on parent constraints
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.02),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrinks to top
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TACTICAL HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BIO_LOG.${hourIdx % 24}:00",
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 20, 
                  fontWeight: FontWeight.w900, 
                  color: Colors.white,
                  letterSpacing: 2.0
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "LINK_SYNC",
                  style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 10), // Reduced spacing to pull content up
          
          // 2. THE BIO-SCANNER STAGE
          SizedBox(
            height: 180, // Slightly tighter height
            child: Stack(
              alignment: Alignment.topCenter, // Align stack contents to the top
              children: [
                // CENTRAL CLIBO ENTITY (The Reacting Blob)
                // Shifted slightly up using Transform.translate if needed, 
                // but alignment: Alignment.topCenter does the heavy lifting.
                Opacity(
                  opacity: 0.9,
                  child: Lottie.asset(
                    'assets/lottie/blob.json',
                    fit: BoxFit.contain,
                    width: 320,
                  ),
                ),

                // THE TEMPORAL TAPE (HORIZONTAL SCANNER)
                RepaintBoundary(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: 180, 
                      width: totalTapeWidth,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Background Grid
                          ...List.generate(5, (index) => Positioned(
                            left: index * 15 * minToPx,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 1, 
                              color: Colors.white.withOpacity(0.05)
                            ),
                          )),

                          // The Seeds (The Tape Segments)
                          if (seeds.isEmpty)
                            const Center(
                              child: Text(
                                "DATA_VACUUM :: NO_SEEDS", 
                                style: TextStyle(color: Colors.white12, fontSize: 9, fontFamily: 'monospace')
                              ),
                            )
                          else
                            ...seeds.asMap().entries.map((entry) {
                              final int idx = entry.key;
                              final CliboDataSeed seed = entry.value;
                              final double topOffset = topPadding + (idx * laneHeight);
                              
                              return _buildTacticalTapeSegment(
                                context, 
                                seed, 
                                minToPx, 
                                topOffset
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTacticalTapeSegment(
      BuildContext context, 
      CliboDataSeed seed, 
      double minToPx, 
      double topOffset
  ) {
    final speciesTheme = Theme.of(context).extension<SpeciesTheme>()!;
    final color = _getColorForType(seed.type, speciesTheme);
    
    final double left = seed.startMinute * minToPx;
    final double width = (seed.endMinute - seed.startMinute) * minToPx;

    return Positioned(
      left: left,
      top: topOffset,
      height: 48,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            border: Border(
              left: BorderSide(color: color, width: 4),
              top: BorderSide(color: color.withOpacity(0.1), width: 0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  seed.label?.toUpperCase() ?? "SEED_ID",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color, 
                    fontSize: 10, 
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                  ),
                ),
                if (width > 50)
                  Text(
                    "${seed.endMinute - seed.startMinute}m",
                    style: TextStyle(
                      color: color.withOpacity(0.6), 
                      fontSize: 8, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForType(SpeciesType type, SpeciesTheme theme) {
    switch (type) {
      case SpeciesType.physical: return theme.physical;
      case SpeciesType.emotional: return theme.emotional;
      case SpeciesType.cognitive: return theme.cognitive;
      case SpeciesType.social: return theme.social;
      case SpeciesType.media: return theme.media;
      case SpeciesType.spiritual: return theme.spiritual;
      case SpeciesType.environmental: return theme.environmental;
      case SpeciesType.interpersonal: return theme.interpersonal;
      default: return Colors.cyanAccent;
    }
  }
}
