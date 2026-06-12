import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'models.dart';

/// Result of a safety classification. [crisis] true means L3 — the UI must
/// redirect to crisis help and disable normal AI flow.
class SafetyResult {
  const SafetyResult({required this.level, required this.crisis});
  final String level; // 'l1' | 'l2' | 'l3'
  final bool crisis;

  factory SafetyResult.fromJson(Map<String, dynamic> j) => SafetyResult(
        level: (j['level'] ?? 'l1') as String,
        crisis: (j['crisis'] ?? false) as bool,
      );
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Thin client for the EchoMind Node proxy. No journal content is persisted
/// server-side; the proxy uses each request only to build one prompt.
class EchoMindApi {
  EchoMindApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _base = baseUrl ?? Config.apiBaseUrl(isAndroid: _isAndroid);

  final http.Client _client;
  final String _base;

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static const _timeout = Duration(seconds: 20);

  Uri _u(String path) => Uri.parse('$_base$path');

  Future<Map<String, dynamic>> _post(
      String path, Map<String, dynamic> body) async {
    final res = await _client
        .post(
          _u(path),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    final decoded = res.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(res.body) as Map<String, dynamic>;

    if (res.statusCode >= 400) {
      throw ApiException(
          (decoded['error'] as String?) ?? 'Request failed (${res.statusCode})');
    }
    return decoded;
  }

  /// The FIRST step on any text. Returns L1/L2/L3.
  Future<SafetyResult> classify(String text) async {
    final json = await _post('/api/safety/classify', {'text': text});
    return SafetyResult.fromJson(json);
  }

  /// Weekly reflection. Returns the reflection, or null if the backend flagged
  /// a crisis (caller should route to crisis help).
  Future<WeeklyReflection?> weeklyReflection(List<JournalEntry> entries) async {
    final json = await _post('/api/reflection/weekly', {
      'entries': [
        for (final e in entries)
          {
            'date': e.createdAt.toIso8601String().split('T').first,
            'mood': e.mood.label,
            'text': e.text,
            'themes': e.themes,
          },
      ],
    });

    if (json['crisis'] == true) return null;

    final r = (json['reflection'] as Map?)?.cast<String, dynamic>() ?? {};
    return WeeklyReflection(
      weekLabel: 'This week',
      summary: (r['summary'] ?? '') as String,
      highlights: ((r['highlights'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      gentleNudge: (r['gentleNudge'] ?? '') as String,
    );
  }

  /// Conversational query over the user's own snippets (RAG). Returns the
  /// answer text, or null if the backend flagged a crisis.
  Future<String?> query(String question, List<JournalEntry> snippets) async {
    final json = await _post('/api/query', {
      'query': question,
      'snippets': [
        for (final s in snippets)
          {
            'date': s.createdAt.toIso8601String().split('T').first,
            'text': s.text,
          },
      ],
    });

    if (json['crisis'] == true) return null;
    return (json['answer'] ?? '') as String;
  }

  void dispose() => _client.close();
}
