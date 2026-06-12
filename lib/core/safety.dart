// ============================================================================
//  SAFETY CLASSIFIER — PLACEHOLDER ONLY. NOT CLINICALLY VALID.
// ============================================================================
//
//  Per the EchoMind SOW, every journal entry must pass through a three-tier
//  crisis classifier *before any other AI processing*. The real classifier:
//
//    • is written and version-controlled by the clinical advisor,
//    • runs server-side (so criteria can be updated without an app release),
//    • is measured against recall ≥ 95% / precision ≥ 85% on L3,
//    • and must be signed off before ANY real user touches the product.
//
//  The implementation below exists ONLY to drive the UI scaffold's crisis
//  redirect flow during design/demo. The keyword check is intentionally crude
//  and MUST NOT be shipped or relied upon to keep anyone safe. Replace it with
//  the clinical, server-side classifier before launch.
// ============================================================================

/// Three safety tiers from the SOW.
enum SafetyLevel {
  /// Normal stress / sadness → standard journaling flow.
  l1Normal,

  /// Concerning pattern → soft, optional suggestion of support.
  l2Concerning,

  /// Crisis indicators → immediate helpline redirect; AI flow disabled.
  l3Crisis,
}

abstract interface class SafetyClassifier {
  SafetyLevel classify(String entryText);
}

/// Demo-only placeholder. Returns [SafetyLevel.l3Crisis] on a tiny keyword set
/// purely so the crisis UI can be exercised. See the file header.
class PlaceholderSafetyClassifier implements SafetyClassifier {
  const PlaceholderSafetyClassifier();

  static const _demoCrisisKeywords = [
    'suicide',
    'kill myself',
    'end it all',
    'self harm',
    'self-harm',
    'want to die',
  ];

  @override
  SafetyLevel classify(String entryText) {
    final lower = entryText.toLowerCase();
    for (final kw in _demoCrisisKeywords) {
      if (lower.contains(kw)) return SafetyLevel.l3Crisis;
    }
    // Real classifier would also detect L2 patterns over time; placeholder
    // treats everything else as normal.
    return SafetyLevel.l1Normal;
  }
}
