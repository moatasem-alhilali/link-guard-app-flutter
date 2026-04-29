import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/verdict_result.dart';
import '../services/scan_service.dart';
import '../utils/url_validator.dart';

// ─────────────────────────────────────────────────────────
//  Scan History Provider
// ─────────────────────────────────────────────────────────
class HistoryNotifier extends Notifier<List<VerdictResult>> {
  @override
  List<VerdictResult> build() => [];

  void add(VerdictResult result) {
    // Keep the newest first, max 20 items
    state = [result, ...state.take(19)].toList();
  }

  void clear() => state = [];
}

final historyProvider = NotifierProvider<HistoryNotifier, List<VerdictResult>>(
  HistoryNotifier.new,
);

// ─────────────────────────────────────────────────────────
//  Scan State Provider
// ─────────────────────────────────────────────────────────
class ScanNotifier extends Notifier<ScanState> {
  @override
  ScanState build() => const ScanState();

  Future<void> scan(String rawUrl) async {
    // Validate URL
    final validation = UrlValidator.validate(rawUrl);
    if (!validation.isValid) {
      state = ScanState(error: validation.errorKey!.tr());
      return;
    }

    state = const ScanState(isLoading: true);

    try {
      final data = await checkWithGoogle(validation.normalizedUrl!);
      final result = VerdictResult(
        verdict: data['verdict'] as String,
        provider: data['provider'] as String,
        reason: (data['reason_key'] as String).tr(),
        score: data['score'] as String?,
        url: validation.normalizedUrl!,
        scannedAt: DateTime.now(),
      );

      state = ScanState(result: result);
      ref.read(historyProvider.notifier).add(result);
    } on ApiException catch (e) {
      state = ScanState(error: e.message.tr());
    } catch (_) {
      state = ScanState(error: 'error_api'.tr());
    }
  }

  void reset() => state = const ScanState();
}

final scanProvider = NotifierProvider<ScanNotifier, ScanState>(
  ScanNotifier.new,
);
