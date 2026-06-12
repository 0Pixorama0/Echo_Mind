import 'models.dart';

/// In-memory sample content so every screen renders without a backend.
/// Replace with the encrypted local store + Claude pipeline later.
class MockData {
  MockData._();

  static DateTime _daysAgo(int d) =>
      DateTime.now().subtract(Duration(days: d));

  static final List<JournalEntry> entries = [
    JournalEntry(
      id: 'e1',
      createdAt: _daysAgo(0).copyWith(hour: 22, minute: 10),
      text:
          'Long standup, then back-to-back reviews. Shipped the release but I '
          'barely ate. Calmer once I closed the laptop and went for a walk.',
      mood: Mood.okay,
      themes: ['work pressure', 'skipping meals'],
    ),
    JournalEntry(
      id: 'e2',
      createdAt: _daysAgo(1).copyWith(hour: 21, minute: 5),
      text:
          'Slept badly again — woke at 3am thinking about the roadmap. Good '
          'chat with Priya at lunch helped though.',
      mood: Mood.low,
      themes: ['sleep', 'work pressure'],
      fromVoice: true,
    ),
    JournalEntry(
      id: 'e3',
      createdAt: _daysAgo(2).copyWith(hour: 20, minute: 40),
      text:
          'Actually a good day. Finished the design doc early and went to the '
          'gym. Felt in control for once.',
      mood: Mood.good,
      themes: ['exercise', 'momentum'],
    ),
    JournalEntry(
      id: 'e4',
      createdAt: _daysAgo(4).copyWith(hour: 23, minute: 15),
      text:
          'Overwhelmed. Too many threads, manager pinged late again. Keep '
          'feeling behind no matter how much I do.',
      mood: Mood.rough,
      themes: ['work pressure', 'overwhelm'],
    ),
    JournalEntry(
      id: 'e5',
      createdAt: _daysAgo(6).copyWith(hour: 19, minute: 30),
      text:
          'Quiet weekend. Cooked, called home, read a bit. Recharged.',
      mood: Mood.great,
      themes: ['rest', 'family'],
    ),
  ];

  /// 14-day mood trend (1..5), oldest → newest, for the dashboard chart.
  static const List<double> moodTrend = [
    3, 2, 4, 3, 1, 2, 5, 3, 2, 4, 1, 3, 2, 3,
  ];

  static const List<ThemePattern> themes = [
    ThemePattern(label: 'Work pressure', mentions: 9, trend: 0.6),
    ThemePattern(label: 'Sleep', mentions: 5, trend: 0.3),
    ThemePattern(label: 'Exercise', mentions: 4, trend: -0.2),
    ThemePattern(label: 'Family & rest', mentions: 3, trend: -0.4),
  ];

  static const WeeklyReflection weeklyReflection = WeeklyReflection(
    weekLabel: 'This week',
    summary:
        'Work pressure showed up in most of your entries, often tied to late '
        'pings and a packed calendar. Your steadier days followed exercise, '
        'a proper meal, or time away from the laptop — your own notes point to '
        'what helps.',
    highlights: [
      'Sleep was disrupted on 3 of 7 nights, usually after evening work.',
      'Your best-rated days both involved movement or rest.',
      'You named "feeling behind" twice — a recurring thread worth watching.',
    ],
    gentleNudge:
        'You already know what steadies you. One small protected break this '
        'week might be worth trying.',
  );

  /// Helplines from the SOW. Shown in the always-available crisis flow.
  static const List<CrisisResource> crisisResources = [
    CrisisResource(
      name: 'iCall',
      phone: '9152987821',
      description:
          'Free psychosocial counselling by trained professionals (TISS).',
      hours: 'Mon–Sat, 8am–10pm',
    ),
    CrisisResource(
      name: 'Vandrevala Foundation',
      phone: '18602662345',
      description: 'Free mental health support and crisis helpline.',
      hours: '24/7',
    ),
  ];

  /// Canned answers for the conversational query demo.
  static const Map<String, String> sampleAnswers = {
    'default':
        'Looking across your recent entries, work pressure came up most — '
        'especially around late-evening pings and a full calendar. The days '
        'you rated higher tended to follow exercise, a proper meal, or time '
        'offline.\n\nThis is a reflection of your own notes, not advice.',
  };
}
