/// AppConfig – reads API keys injected at build time via --dart-define-from-file.
///
/// Keys are compiled into the binary and are NOT stored as plain text
/// in assets or source code. The config.json file is excluded from git.
///
/// Build commands:
///   flutter run   --dart-define-from-file=config.json
///   flutter build appbundle --release --dart-define-from-file=config.json
class AppConfig {
  AppConfig._();

  // ── Google Safe Browsing ──────────────────────────────────
  static const String googleSafeBrowsingKey = String.fromEnvironment(
    'GOOGLE_SAFE_BROWSING_KEY',
    defaultValue: '',
  );

  // ── VirusTotal ────────────────────────────────────────────
  static const String virusTotalApiKey = String.fromEnvironment(
    'VIRUSTOTAL_API_KEY',
    defaultValue: '',
  );

  // ── Validation ────────────────────────────────────────────

  /// Returns true when all required API keys are present.
  static bool get isConfigured =>
      googleSafeBrowsingKey.isNotEmpty && virusTotalApiKey.isNotEmpty;

  /// Throws an [AssertionError] in debug mode if keys are missing.
  /// Silent in release mode to avoid leaking config info.
  static void assertConfigured() {
    assert(
      googleSafeBrowsingKey.isNotEmpty,
      '\n\n'
      '══════════════════════════════════════════════════════\n'
      '  GOOGLE_SAFE_BROWSING_KEY is not set!\n'
      '  Run with: flutter run --dart-define-from-file=config.json\n'
      '  Copy config.example.json → config.json and fill in keys.\n'
      '══════════════════════════════════════════════════════\n',
    );
    assert(
      virusTotalApiKey.isNotEmpty,
      '\n\n'
      '══════════════════════════════════════════════════════\n'
      '  VIRUSTOTAL_API_KEY is not set!\n'
      '  Run with: flutter run --dart-define-from-file=config.json\n'
      '  Copy config.example.json → config.json and fill in keys.\n'
      '══════════════════════════════════════════════════════\n',
    );
  }
}
