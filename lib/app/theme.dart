// lib/app/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ============ COLORI PRINCIPALI ============
  static const Color primary = Color(0xFF2D5F5D);
  static const Color secondary = Color(0xFFF4E8D8);
  static const Color background = Color(0xFFFAFAF8);

  /// Surface per card e contenitori
  static const Color surface = Color(0xFFFFFFFF);

  // ============ COLORI ACCENTO ============
  static const Color accent1 = Color(0xFFE8926F); // CTA
  static const Color accent2 = Color(0xFFA8C5A0); // success
  static const Color accent3 = Color(0xFF6B8E8E); // secondary

  // ============ MACRO ============
  static const Color carbs = Color(0xFFDEB887);
  static const Color protein = Color(0xFFE8926F);
  static const Color fats = Color(0xFFA8C5A0);

  // ============ FUNZIONALI ============
  static const Color error = Color(0xFFC76856);
  static const Color success = Color(0xFF7BA375);
  static const Color warning = Color(0xFFD4A574);

  // ============ TESTI ============
  static const Color textPrimary = Color(0xFF2C3E3D);
  static const Color textSecondary = Color(0xFF5F7676);
  static const Color textDisabled = Color(0xFFB0B8B8);

  // ============ DESIGN ============
  static const double radiusCard = 24;
  static const double radiusButton = 16;
  static const double radiusSmall = 12;
  static const double paddingStandard = 16;

  // ============ THEME ============
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: accent1,
      onSecondary: Colors.white,
      tertiary: accent2,
      onTertiary: textPrimary,
      error: error,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,

      // ================= TEXT THEME =================
      textTheme: TextTheme(
        // Greeting / Nome utente (UNICO uso Crimson)
        displayLarge: GoogleFonts.crimsonPro(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: -0.2,
          color: textPrimary,
        ),

        displayMedium: GoogleFonts.crimsonPro(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: textPrimary,
        ),

        // Section titles
        headlineLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: textPrimary,
        ),

        // Card titles
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),

        // Body
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: textSecondary,
        ),

        // Labels / Buttons
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: textSecondary,
        ),
      ),

      // ================= APP BAR =================
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: background,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: primary,
          size: 24,
        ),
      ),

      // ================= CARD =================
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: BorderSide(
            color: primary.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),

      // ================= BUTTON =================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent1,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(48, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ================= INPUT =================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide(
            color: primary.withOpacity(0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 6,
      ),
    );
  }

  // ================= SHADOW =================
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: primary.withOpacity(0.06),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}
