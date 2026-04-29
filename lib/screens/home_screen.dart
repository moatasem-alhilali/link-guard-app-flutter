// ignore_for_file: deprecated_member_use
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/models/verdict_result.dart';
import '../core/providers/scan_provider.dart';
import '../core/providers/theme_provider.dart';
import '../core/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScan() {
    _focusNode.unfocus();
    ref.read(scanProvider.notifier).scan(_controller.text);
  }

  void _onClear() {
    _controller.clear();
    ref.read(scanProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = context.locale;
    final isRtl = locale.languageCode == 'ar';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: _Background(
          isDark: isDark,
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        _TopBar(isDark: isDark),
                        const SizedBox(height: 40),
                        _HeroSection(isDark: isDark),
                        const SizedBox(height: 36),
                        _ScanCard(
                          controller: _controller,
                          focusNode: _focusNode,
                          onScan: _onScan,
                          onClear: _onClear,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 20),
                        const _ResultSection(),
                        const SizedBox(height: 32),
                        const _HistorySection(),
                        const SizedBox(height: 40),
                        _PoweredBy(isDark: isDark),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Background
// ─────────────────────────────────────────────────────────
class _Background extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _Background({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF080D1C), Color(0xFF0D1B2E)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF0F4FF), Color(0xFFE8F2FF)],
              ),
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Top Bar
// ─────────────────────────────────────────────────────────
class _TopBar extends ConsumerWidget {
  final bool isDark;
  const _TopBar({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = context.locale.languageCode == 'ar';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _PillButton(
          label: 'lang_toggle'.tr(),
          onTap: () {
            final next = isAr ? const Locale('en') : const Locale('ar');
            context.setLocale(next);
          },
          isDark: isDark,
          icon: Icons.translate_rounded,
        ),
        _PillButton(
          label: '',
          onTap: () => ref.read(themeProvider.notifier).toggle(),
          isDark: isDark,
          icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.3);
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final IconData icon;

  const _PillButton({
    required this.label,
    required this.onTap,
    required this.isDark,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? const Color(0xFF1C2535) : Colors.white;
    final border = isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0);
    final fg = isDark ? Colors.white : const Color(0xFF0F172A);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Hero Section
// ─────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final bool isDark;
  const _HeroSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.4),
                blurRadius: 36,
                spreadRadius: 4,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.shield_rounded, color: Colors.white, size: 46),
        )
            .animate()
            .scale(
              begin: const Offset(0.4, 0.4),
              duration: 700.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 400.ms),
        const SizedBox(height: 22),
        Text(
          'app_name'.tr(),
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.3),
        const SizedBox(height: 8),
        Text(
          'tagline'.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Scan Card
// ─────────────────────────────────────────────────────────
class _ScanCard extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onScan;
  final VoidCallback onClear;
  final bool isDark;

  const _ScanCard({
    required this.controller,
    required this.focusNode,
    required this.onScan,
    required this.onClear,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanProvider);
    final card = isDark ? const Color(0xFF111827) : Colors.white;
    final border = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.07),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.url,
            autocorrect: false,
            style: GoogleFonts.robotoMono(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            onSubmitted: (_) => onScan(),
            decoration: InputDecoration(
              hintText: 'input_hint'.tr(),
              hintStyle: GoogleFonts.outfit(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF94A3B8),
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.all(14),
                child: Icon(Icons.link_rounded, color: Color(0xFF3B82F6), size: 22),
              ),
              suffixIcon: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, val, child) => val.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: isDark
                              ? const Color(0xFF6B7280)
                              : const Color(0xFF94A3B8),
                          size: 20,
                        ),
                        onPressed: onClear,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: 300.ms,
            child: scanState.isLoading
                ? _LoadingBtn(key: const ValueKey('loading'))
                : ElevatedButton.icon(
                    key: const ValueKey('scan'),
                    onPressed: onScan,
                    icon: const Icon(Icons.travel_explore_rounded, size: 20),
                    label: Text('check_button'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms, duration: 500.ms).slideY(begin: 0.2);
  }
}

class _LoadingBtn extends StatelessWidget {
  const _LoadingBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'scanning'.tr(),
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Result Section
// ─────────────────────────────────────────────────────────
class _ResultSection extends ConsumerWidget {
  const _ResultSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.error != null) {
      return _ErrorCard(message: state.error!, isDark: isDark)
          .animate()
          .fadeIn(duration: 350.ms)
          .slideY(begin: 0.15);
    }

    if (state.result != null) {
      return _VerdictCard(result: state.result!, isDark: isDark)
          .animate()
          .fadeIn(duration: 450.ms)
          .slideY(begin: 0.2)
          .scale(begin: const Offset(0.96, 0.96));
    }

    return const SizedBox.shrink();
  }
}

class _VerdictCard extends StatelessWidget {
  final VerdictResult result;
  final bool isDark;

  const _VerdictCard({required this.result, required this.isDark});

  String get _verdictKey {
    switch (result.verdict.toUpperCase()) {
      case 'SAFE':
        return 'result_safe';
      case 'SUSPICIOUS':
        return 'result_suspicious';
      case 'MALICIOUS':
        return 'result_malicious';
      default:
        return 'result_unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.verdictColor(result.verdict);
    final icon = AppTheme.verdictIcon(result.verdict);
    final card = isDark ? const Color(0xFF111827) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDark ? 0.12 : 0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon bubble
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.18),
                  blurRadius: 22,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 38),
          ),
          const SizedBox(height: 18),
          Text(
            _verdictKey.tr(),
            style: GoogleFonts.outfit(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.reason,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 20),
          _UrlChip(url: result.url, isDark: isDark),
          const SizedBox(height: 14),
          Row(
            children: [
              _MetaChip(
                label: 'provider_label'.tr(),
                value: result.provider,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              if (result.score != null)
                _MetaChip(
                  label: 'score_label'.tr(),
                  value: result.score!,
                  isDark: isDark,
                  accentColor: color,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UrlChip extends StatelessWidget {
  final String url;
  final bool isDark;
  const _UrlChip({required this.url, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9);
    final fg = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: url));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              url,
              style: GoogleFonts.robotoMono(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.link_rounded, size: 14, color: fg),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                url,
                style: GoogleFonts.robotoMono(fontSize: 12, color: fg),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color? accentColor;

  const _MetaChip({
    required this.label,
    required this.value,
    required this.isDark,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasAccent = accentColor != null;
    final bg = hasAccent
        ? accentColor!.withOpacity(0.1)
        : (isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9));
    final valueFg = hasAccent
        ? accentColor!
        : (isDark ? Colors.white : const Color(0xFF0F172A));
    final labelFg = isDark ? const Color(0xFF6B7280) : const Color(0xFF94A3B8);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: labelFg,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueFg,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final bool isDark;

  const _ErrorCard({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFEF4444);
    final card = isDark ? const Color(0xFF111827) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: red.withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_rounded, color: red, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  History Section
// ─────────────────────────────────────────────────────────
class _HistorySection extends ConsumerWidget {
  const _HistorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('history_title'.tr(),
                style: Theme.of(context).textTheme.headlineMedium),
            TextButton.icon(
              onPressed: () => ref.read(historyProvider.notifier).clear(),
              icon: const Icon(Icons.delete_sweep_rounded, size: 18),
              label: Text('history_clear'.tr()),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...history.asMap().entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _HistoryItem(result: e.value, isDark: isDark)
                .animate(delay: Duration(milliseconds: 50 * e.key))
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.08),
          ),
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final VerdictResult result;
  final bool isDark;

  const _HistoryItem({required this.result, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.verdictColor(result.verdict);
    final icon = AppTheme.verdictIcon(result.verdict);
    final card = isDark ? const Color(0xFF111827) : Colors.white;
    final border = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
    final timeStr = DateFormat('HH:mm').format(result.scannedAt);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.url,
                  style: GoogleFonts.robotoMono(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 2),
                Text(
                  result.provider,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeStr,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF6B7280)
                      : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  result.verdict,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Footer
// ─────────────────────────────────────────────────────────
class _PoweredBy extends StatelessWidget {
  final bool isDark;
  const _PoweredBy({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'powered_by'.tr(),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFF374151) : const Color(0xFFCBD5E1),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
