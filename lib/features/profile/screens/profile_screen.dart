import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Profilo',
          style: GoogleFonts.crimsonPro(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: const Center(
        child: Text('Schermata Profilo'),
      ),
    );
  }
}