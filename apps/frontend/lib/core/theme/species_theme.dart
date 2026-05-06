import 'package:flutter/material.dart';

class SpeciesTheme extends ThemeExtension<SpeciesTheme> {
  final Color social;
  final Color physical;
  final Color emotional;
  final Color cognitive;
  final Color interpersonal;
  final Color environmental;
  final Color spiritual;
  final Color media; // Added for the new launchpad integration

  const SpeciesTheme({
    required this.social,
    required this.physical,
    required this.emotional,
    required this.cognitive,
    required this.interpersonal,
    required this.environmental,
    required this.spiritual,
    required this.media,
  });

  @override
  ThemeExtension<SpeciesTheme> copyWith() => this; // Simplified for initial setup

  @override
  ThemeExtension<SpeciesTheme> lerp(ThemeExtension<SpeciesTheme>? other, double t) {
    if (other is! SpeciesTheme) return this;
    return SpeciesTheme(
      social: Color.lerp(social, other.social, t)!,
      physical: Color.lerp(physical, other.physical, t)!,
      emotional: Color.lerp(emotional, other.emotional, t)!,
      cognitive: Color.lerp(cognitive, other.cognitive, t)!,
      interpersonal: Color.lerp(interpersonal, other.interpersonal, t)!,
      environmental: Color.lerp(environmental, other.environmental, t)!,
      spiritual: Color.lerp(spiritual, other.spiritual, t)!,
      media: Color.lerp(media, other.media, t)!,
    );
  }

  // Dark Mode Palette
  static const dark = SpeciesTheme(
    social: Color(0xFFFF8A65),        // Deep Orange
    physical: Color(0xFFEF5350),      // Soft Red
    emotional: Color(0xFFEC407A),     // Pink
    cognitive: Color(0xFF42A5F5),     // Blue
    interpersonal: Color(0xFF66BB6A), // Green
    environmental: Color(0xFF26A69A), // Teal
    spiritual: Color(0xFFAB47BC),     // Purple
    media: Color(0xFFFFCA28),         // Amber
  );
}
