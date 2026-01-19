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
  
  /// CTA e elementi interattivi
  static const Color accent1 = Color(0xFFE8926F);
  
  /// successi e obiettivi raggiunti
  static const Color accent2 = Color(0xFFA8C5A0);
  
  /// elementi secondari
  static const Color accent3 = Color(0xFF6B8E8E);

  // ============ COLORI MACRONUTRIENTI ============
  
  /// Carboidrati
  static const Color carbs = Color(0xFFDEB887);
  
  /// Proteine
  static const Color protein = Color(0xFFE8926F);
  
  /// Grassi
  static const Color fats = Color(0xFFA8C5A0);

  // ============ COLORI FUNZIONALI ============
  
  /// Errori e alert
  static const Color error = Color(0xFFC76856);
  
  /// Successi
  static const Color success = Color(0xFF7BA375);
  
  /// Warning
  static const Color warning = Color(0xFFD4A574);

  // ============ COLORI TESTO ============
  
  /// Testo principale
  static const Color textPrimary = Color(0xFF2C3E3D);
  
  /// Testo secondario
  static const Color textSecondary = Color(0xFF6B8080);
  
  /// Testo disabilitato
  static const Color textDisabled = Color(0xFFB0B8B8);

  // ============ COSTANTI DESIGN ============
  
  static const double radiusCard = 24.0;
  static const double radiusButton = 16.0;
  static const double radiusSmall = 12.0;
  static const double paddingStandard = 20.0;

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
      
      // Typography con Google Fonts
      textTheme: TextTheme(
        // Display - Per titoli molto grandi (serif morbido)
        displayLarge: GoogleFonts.crimsonPro(
          fontSize: 57,
          fontWeight: FontWeight.w600,
          height: 1.1,
          letterSpacing: -0.5,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.crimsonPro(
          fontSize: 45,
          fontWeight: FontWeight.w600,
          height: 1.15,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.crimsonPro(
          fontSize: 36,
          fontWeight: FontWeight.w500,
          height: 1.2,
          color: textPrimary,
        ),
        
        // Headline - Per titoli sezioni (serif)
        headlineLarge: GoogleFonts.crimsonPro(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.crimsonPro(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.crimsonPro(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: textPrimary,
        ),
        
        // Title - Per titoli card (sans-serif geometrico)
        titleLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0.15,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0.1,
          color: textPrimary,
        ),
        
        // Body - Per testi normali (serif)
        bodyLarge: GoogleFonts.crimsonPro(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.5,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.crimsonPro(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.25,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.crimsonPro(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          letterSpacing: 0.4,
          color: textSecondary,
        ),
        
        // Label - Per etichette e bottoni (sans-serif)
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0.1,
          color: textPrimary,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: 0.5,
          color: textPrimary,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 1.3,
          letterSpacing: 0.5,
          color: textSecondary,
        ),
      ),
      
      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.crimsonPro(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: primary,
          size: 24,
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        shadowColor: primary.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: BorderSide(
            color: primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide(
            color: primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide(
            color: primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: const BorderSide(
            color: primary,
            width: 2,
          ),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // ============ HELPER UTILITIES ============
  
  /// Ombra soft per card
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];
}