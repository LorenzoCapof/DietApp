import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/app_theme.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Ricette',
          style: GoogleFonts.crimsonPro(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: const Center(
        child: Text('Schermata Ricette'),
      ),
    );
  }
}