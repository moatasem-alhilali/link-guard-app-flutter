import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Brand Colors
  static const Color _primaryBlue = Color(0xFF3B82F6);
  static const Color _accentBlue = Color(0xFF60A5FA);

  static const Color _safe = Color(0xFF22C55E);
  static const Color _suspicious = Color(0xFFF59E0B);
  static const Color _malicious = Color(0xFFEF4444);
  static const Color _unknown = Color(0xFF6B7280);

  // Dark Theme
  static const Color _darkBg = Color(0xFF0A0F1E);
  static const Color _darkSurface = Color(0xFF111827);
  static const Color _darkCard = Color(0xFF1F2937);
  static const Color _darkBorder = Color(0xFF374151);
  static const Color _darkText = Color(0xFFF9FAFB);
  static const Color _darkSubText = Color(0xFF9CA3AF);

  // Light Theme
  static const Color _lightBg = Color(0xFFF8FAFF);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightCard = Color(0xFFF1F5F9);
  static const Color _lightBorder = Color(0xFFE2E8F0);
  static const Color _lightText = Color(0xFF0F172A);
  static const Color _lightSubText = Color(0xFF64748B);

  static TextTheme _buildTextTheme(Color textColor, Color subTextColor) {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: -0.3,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: subTextColor,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: subTextColor,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  static ThemeData get dark {
    final textTheme = _buildTextTheme(_darkText, _darkSubText);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryBlue,
        secondary: _accentBlue,
        surface: _darkSurface,
        error: _malicious,
      ),
      scaffoldBackgroundColor: _darkBg,
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryBlue, width: 2),
        ),
        hintStyle: GoogleFonts.outfit(color: _darkSubText),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData get light {
    final textTheme = _buildTextTheme(_lightText, _lightSubText);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primaryBlue,
        secondary: _accentBlue,
        surface: _lightSurface,
        error: _malicious,
      ),
      scaffoldBackgroundColor: _lightBg,
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryBlue, width: 2),
        ),
        hintStyle: GoogleFonts.outfit(color: _lightSubText),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
    );
  }

  // Verdict Colors
  static Color verdictColor(String verdict) {
    switch (verdict.toUpperCase()) {
      case 'SAFE':
        return _safe;
      case 'SUSPICIOUS':
        return _suspicious;
      case 'MALICIOUS':
        return _malicious;
      default:
        return _unknown;
    }
  }

  static IconData verdictIcon(String verdict) {
    switch (verdict.toUpperCase()) {
      case 'SAFE':
        return Icons.verified_rounded;
      case 'SUSPICIOUS':
        return Icons.warning_amber_rounded;
      case 'MALICIOUS':
        return Icons.gpp_bad_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}
