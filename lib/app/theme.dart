// lib/app/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ============ COLORI PRINCIPALI ============
  static const Color primary = Color(0xFF2D5F5D);
  static const Color secondary = Color(0xFFF4E8D8);
  static const Color background = Color(0xFFFAFAF8);
  static const Color surface = Color(0xFFFFFFFF);

  // ============ COLORI ACCENTO ============
  static const Color accent1 = Color(0xFFE8926F); // CTA e interattivi
  static const Color accent2 = Color(0xFFA8C5A0); // Success
  static const Color accent3 = Color(0xFF6B8E8E); // Secondari

  // ============ MACRONUTRIENTI ============
  static const Color carbs = Color(0xFFDEB887);
  static const Color protein = Color(0xFFE8926F);
  static const Color fats = Color(0xFFA8C5A0);

  // ============ FUNZIONALI ============
  static const Color error = Color(0xFFC76856);
  static const Color success = Color(0xFF7BA375);
  static const Color warning = Color(0xFFD4A574);

  // ============ TESTI (migliorati per contrasto) ============
  static const Color textPrimary = Color(0xFF2C3E3D);
  static const Color textSecondary = Color(0xFF57706F); // Scurito per leggibilità
  static const Color textDisabled = Color(0xFFB0B8B8);

  // ============ DESIGN CONSTANTS ============
  static const double radiusCard = 24.0;
  static const double radiusButton = 16.0;
  static const double radiusSmall = 12.0;
  static const double paddingStandard = 16.0;
  static const double cardPadding = 20.0;
  static const double sectionGap = 18.0;

  // ============ RING CONSTANTS ============
  static const double ringDiameter = 220.0;
  static const double ringStrokeWidth = 16.0;

  // ============ THEME DATA ============
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
        // NOME UTENTE - Crimson Pro 700, 36sp (UNICO uso serif)
        displayLarge: GoogleFonts.crimsonPro(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          height: 1.11, // 40/36
          letterSpacing: -0.2,
          color: primary,
        ),

        // Fallback serif per titoli grandi
        displayMedium: GoogleFonts.crimsonPro(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: textPrimary,
        ),

        displaySmall: GoogleFonts.crimsonPro(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: textPrimary,
        ),

        // NUMERO CALORIE GRANDE - Poppins 700, 52sp
        headlineLarge: GoogleFonts.poppins(
          fontSize: 52,
          fontWeight: FontWeight.w700,
          height: 1.1,
          letterSpacing: 0,
          color: textPrimary,
        ),

        // Numeri macro grandi
        headlineMedium: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: 0,
          color: textPrimary,
        ),

        // Section headers
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: 0.2,
          color: textPrimary,
        ),

        // Card titles - Poppins 600, 16-18sp
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: 0.2,
          color: textPrimary,
        ),

        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: 0.2,
          color: textPrimary,
        ),

        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: 0.2,
          color: textPrimary,
        ),

        // Body text - Poppins 400
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.2,
          color: textPrimary,
        ),

        // GREETING TEXT - Poppins 400, 14sp
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43, // 20/14
          letterSpacing: 0.2,
          color: textSecondary,
        ),

        // SUBTEXT RING - Poppins 400, 12sp
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          letterSpacing: 0.2,
          color: textSecondary,
        ),

        // MACRO VALUES - Poppins 600, 16-18sp
        labelLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: 0.2,
          color: textPrimary,
        ),

        // MACRO LABELS - Poppins 500, 12sp
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.5,
          letterSpacing: 0.3,
          color: textSecondary,
        ),

        // DATE CONTROL - Poppins 500, 13sp
        labelSmall: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.38, // 18/13
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

      // ================= BUTTONS =================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent1,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(160, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // ================= INPUT =================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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

      // ================= ICON THEME =================
      iconTheme: const IconThemeData(
        color: primary,
        size: 24,
      ),
    );
  }

  // ================= SHADOWS (iOS-style) =================
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: primary.withOpacity(0.06),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get subtleShadow => [
        BoxShadow(
          color: primary.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  // ================= CUSTOM TEXT STYLES =================
  
  /// Numero ring centrale (923)
  static TextStyle get ringNumberStyle => GoogleFonts.poppins(
    fontSize: 52,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: 0,
    color: textPrimary,
  );

  /// Label sotto numero ring ("Obiettivo 1848 kcal")
  static TextStyle get ringLabelStyle => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.2,
    color: textSecondary,
  );

  /// Stats piccoli ring (Assunte/Bruciate)
  static TextStyle get ringStatsLabelStyle => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.3,
    color: textSecondary,
  );

  static TextStyle get ringStatsValueStyle => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
    color: textPrimary,
  );
}