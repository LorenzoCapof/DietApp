import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Insights',
          style: GoogleFonts.crimsonPro(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: const Center(
        child: Text('Schermata Insights'),
      ),
    );
  }
}