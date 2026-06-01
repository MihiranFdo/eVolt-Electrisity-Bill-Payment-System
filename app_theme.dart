import 'package:flutter/material.dart';

// ─── Colour Palette ────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const Color bgDeep        = Color(0xFF040D1F);
  static const Color bgPrimary     = Color(0xFF0A1628);
  static const Color surface       = Color(0xFF0D1F3C);
  static const Color surfaceRaised = Color(0xFF112240);
  static const Color surface3      = Color(0xFF0A1628);
  static const Color border        = Color(0xFF1E3A5F);

  static const Color accentBlue    = Color(0xFF38BDF8);
  static const Color actionBlue1   = Color(0xFF1565C0);
  static const Color actionBlue2   = Color(0xFF1A7FD4);

  static const Color successGreen  = Color(0xFF4ADE80);
  static const Color warningOrange = Color(0xFFFB923C);
  static const Color alertBadge   = Color(0xFFFF6B35);
  static const Color dangerRed     = Color(0xFFF87171);
  static const Color supportPurple = Color(0xFFC084FC);

  static const Color textPrimary   = Color(0xFFE8F4FF);
  static const Color textSecondary = Color(0xFF7EB8F7);
  static const Color textMuted     = Color(0xFF3A5A8A);
  static const Color textHint      = Color(0xFF4A7FA5);

  // Bill card gradient colours
  static const Color billGrad1     = Color(0xFF1A4A8C);
  static const Color billGrad2     = Color(0xFF0E7DB8);

  // Action gradient
  static const LinearGradient actionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [actionBlue1, actionBlue2],
  );

  static const LinearGradient billGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [billGrad1, billGrad2],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF040D1F), Color(0xFF071535), Color(0xFF0A1E45)],
  );
}

// ─── Text Styles ──────────────────────────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  // Plus Jakarta Sans equivalents → use GoogleFonts in real project
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w800,
    letterSpacing: -1, color: AppColors.textPrimary,
  );
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700,
    letterSpacing: -0.5, color: AppColors.textPrimary,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 9, fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}

// ─── App Theme ─────────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentBlue,
      secondary: AppColors.actionBlue2,
      surface: AppColors.surface,
      error: AppColors.dangerRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgPrimary,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgPrimary,
      selectedItemColor: AppColors.accentBlue,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10),
      elevation: 0,
    ),
  );
}
