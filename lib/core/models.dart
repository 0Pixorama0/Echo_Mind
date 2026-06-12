import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Five-point mood scale attached to each journal entry.
enum Mood { rough, low, okay, good, great }

extension MoodInfo on Mood {
  String get label => switch (this) {
        Mood.rough => 'Rough',
        Mood.low => 'Low',
        Mood.okay => 'Okay',
        Mood.good => 'Good',
        Mood.great => 'Great',
      };

  String get emoji => switch (this) {
        Mood.rough => '😣',
        Mood.low => '😔',
        Mood.okay => '😐',
        Mood.good => '🙂',
        Mood.great => '😄',
      };

  /// 1..5
  int get score => index + 1;

  Color get color => AppColors.moodSpectrum[index];
}

/// A single journal entry. In the real app the raw [text] lives only in
/// encrypted on-device storage (SQLite + Keychain/Keystore); only embeddings
/// reach the cloud. Here it's in-memory mock data.
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.createdAt,
    required this.text,
    required this.mood,
    this.themes = const [],
    this.fromVoice = false,
  });

  final String id;
  final DateTime createdAt;
  final String text;
  final Mood mood;
  final List<String> themes;
  final bool fromVoice;
}

/// A recurring theme surfaced on the pattern dashboard.
class ThemePattern {
  const ThemePattern({
    required this.label,
    required this.mentions,
    required this.trend,
  });

  final String label;
  final int mentions;

  /// -1 (easing) .. 0 (steady) .. 1 (rising)
  final double trend;
}

/// The weekly AI-generated reflection summary.
class WeeklyReflection {
  const WeeklyReflection({
    required this.weekLabel,
    required this.summary,
    required this.highlights,
    required this.gentleNudge,
  });

  final String weekLabel;
  final String summary;
  final List<String> highlights;
  final String gentleNudge;
}

/// A crisis helpline shown in the always-available safety flow.
class CrisisResource {
  const CrisisResource({
    required this.name,
    required this.phone,
    required this.description,
    this.hours = '24/7',
  });

  final String name;
  final String phone;
  final String description;
  final String hours;
}
