class VerdictResult {
  final String verdict; // SAFE, SUSPICIOUS, MALICIOUS, UNKNOWN
  final String provider;
  final String reason;
  final String? score;
  final String url;
  final DateTime scannedAt;

  const VerdictResult({
    required this.verdict,
    required this.provider,
    required this.reason,
    required this.url,
    required this.scannedAt,
    this.score,
  });

  bool get isSafe => verdict.toUpperCase() == 'SAFE';
  bool get isSuspicious => verdict.toUpperCase() == 'SUSPICIOUS';
  bool get isMalicious => verdict.toUpperCase() == 'MALICIOUS';
}

class ScanState {
  final bool isLoading;
  final VerdictResult? result;
  final String? error;

  const ScanState({
    this.isLoading = false,
    this.result,
    this.error,
  });

  ScanState copyWith({
    bool? isLoading,
    VerdictResult? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return ScanState(
      isLoading: isLoading ?? this.isLoading,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : (error ?? this.error),
    );
  }
}
