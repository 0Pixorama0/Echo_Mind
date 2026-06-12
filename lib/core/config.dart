/// App-wide configuration.
class Config {
  Config._();

  /// Base URL of the EchoMind Node proxy (the eCHOmIND project).
  ///
  /// Override at build/run time with:
  ///   flutter run --dart-define=ECHOMIND_API=http://192.168.1.5:3000
  ///
  /// Defaults by platform when no override is given:
  ///   • Web / iOS simulator / desktop → http://localhost:3000
  ///   • Android emulator              → http://10.0.2.2:3000  (host loopback)
  static const String _override =
      String.fromEnvironment('ECHOMIND_API', defaultValue: '');

  static String apiBaseUrl({required bool isAndroid}) {
    if (_override.isNotEmpty) return _override;
    return isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
  }
}
