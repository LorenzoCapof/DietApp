// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header personalizzato
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingStandard),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buongiorno,',
                      style: GoogleFonts.crimsonPro(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nome Utente',
                      style: GoogleFonts.crimsonPro(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contenuto principale
            SliverPadding(
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildPlaceholderCard('Calorie Ring'),
                  const SizedBox(height: 16),
                  _buildPlaceholderCard('Macro Pills'),
                  const SizedBox(height: 16),
                  _buildPlaceholderCard('Timeline Pasti'),
                  const SizedBox(height: 16),
                  _buildPlaceholderCard('AI Insight'),
                  const SizedBox(height: 16),
                  _buildPlaceholderCard('Hydration Tracker'),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(String title) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}