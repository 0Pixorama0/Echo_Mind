# EchoMind (Flutter)

A private AI journal with safe insights — responsive Flutter app for **iOS and
Android**, adapting from small phones to tablets. All core screens, responsive
layout, and mock data, now wired to the EchoMind Node proxy for safety,
reflection, and query (with graceful fallback to local/mock when the backend
isn't running).

> EchoMind helps you reflect and notice patterns. It is **not** a therapist, a
> medical tool, or a crisis service.

## Run it

Requires the Flutter SDK (3.27+ / Dart 3.6+). iOS builds need macOS + Xcode.

This repo holds `lib/`, `pubspec.yaml`, and tests. Generate the platform folders
(`android/`, `ios/`, `web/`, …) once — `flutter create .` preserves the existing
`lib/` and `pubspec.yaml`:

```sh
flutter create .           # adds android/ ios/ web/ runners (one-time)
flutter pub get
flutter run                # pick a device/simulator
# or target explicitly:
flutter run -d chrome      # quick look in a browser
flutter run -d ios         # macOS only
flutter run -d android
```

## Connecting the backend (optional)

The app calls the EchoMind Node proxy (the `eCHOmIND` project) for the safety
classifier, weekly reflection, and query. Without it, each screen falls back to
local/mock behaviour.

```sh
# In the eCHOmIND project:
cp .env.example .env          # add ANTHROPIC_API_KEY
npm install && npm start      # serves http://localhost:3000
```

Point the app at the proxy (defaults: localhost on web/iOS/desktop, 10.0.2.2 on
the Android emulator):

```sh
flutter run --dart-define=ECHOMIND_API=http://192.168.1.5:3000   # physical device / custom host
```

## What's built

| Area | Screen | Notes |
|------|--------|-------|
| Onboarding | `screens/onboarding` | 4-step consent: privacy, AI limits, 18+ age gate — all required before entry |
| Today (home) | `screens/home` | Greeting, persistent "Not a therapist" banner, recent entries, Help + Settings |
| New entry | `screens/journal` | Text + (mocked) voice, 5-point mood tag; `POST /api/safety/classify` runs **first** on save (local backstop offline) |
| Reflect | `screens/reflection` | `POST /api/reflection/weekly` → Claude (Sonnet); sample reflection offline |
| Patterns | `screens/dashboard` | 14-day mood chart (hand-drawn, no chart dep) + recurring themes |
| Ask | `screens/query` | `POST /api/query` RAG over your own entries (Haiku); canned answer offline |
| Crisis help | `screens/crisis` | Reachable from every screen; tap-to-call iCall + Vandrevala |
| Settings | `screens/settings` | Account, subscription, integrations, DPDP export/delete |

## Responsive design ("all sizes")

- `core/responsive.dart` defines breakpoints (compact < 600 < medium < 1024 < expanded).
- `screens/shell/app_shell.dart` switches **bottom navigation (phones)** ↔ **navigation rail (tablets/desktop)** and a new-entry FAB.
- Every screen body is wrapped in `ContentWidth` so reading lines stay comfortable on wide screens; gutters scale with the viewport.
- Light + dark themes via `ThemeMode.system`.

## Safety — important

`core/safety.dart` is a **placeholder classifier, not clinically valid**. Per the
SOW, the real three-tier crisis classifier is written by the clinical advisor,
runs server-side, and must be signed off before any real user touches the
product. The placeholder exists only to demonstrate the L3 → crisis-redirect UX.

## Next steps (toward the SOW MVP)

1. Encrypted local store (SQLite + Keychain/Keystore); replace `MockData`.
2. ~~Node.js proxy + Claude (Haiku/Sonnet tiered); wire `Ask` and `Reflect`.~~ ✅ done — see `eCHOmIND`.
3. Embedding pipeline + Pinecone; real on-device vector match feeding `/api/query` snippets.
4. Clinical, server-side safety classifier replacing `core/safety.dart`.
5. Google Calendar / Gmail (labeled) read-only OAuth.
6. Razorpay subscription; analytics/crash (anonymized).

The existing `eCHOmIND` web project can be repurposed as the backend/admin console.
