import 'package:flutter/material.dart';

/// EchoMind's semantic palette.
///
/// The product is a calm, private reflective journal — the palette leans warm
/// and quiet (sage + ink on a soft off-white), deliberately *not* clinical.
/// Crisis affordances use a distinct, unmistakable coral so they never blend
/// into the rest of the UI.
class AppColors {
  AppColors._();

  // Brand
  static const Color sage = Color(0xFF6F9E8E); // primary, calm green
  static const Color sageDark = Color(0xFF3F6B5E);
  static const Color mint = Color(0xFF8FD9C0); // dark-theme primary
  static const Color ink = Color(0xFF1F2421); // near-black text
  static const Color sand = Color(0xFFFAF7F2); // light background
  static const Color clay = Color(0xFFE9E2D6); // light surface tint

  // Crisis / safety — distinct, never used decoratively
  static const Color crisis = Color(0xFFE0675B);
  static const Color crisisDark = Color(0xFFB9483D);

  // Mood spectrum (rough → great)
  static const List<Color> moodSpectrum = [
    Color(0xFFD98E7A), // rough
    Color(0xFFD9B27A), // low
    Color(0xFFCBCBA8), // okay
    Color(0xFF9FC9A8), // good
    Color(0xFF6FB59A), // great
  ];

  static const Color lightScrim = Color(0x14000000);
  static const Color darkSurface = Color(0xFF181D1B);
  static const Color darkBg = Color(0xFF111513);
}
