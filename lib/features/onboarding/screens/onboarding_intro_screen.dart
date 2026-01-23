// lib/features/onboarding/screens/onboarding_intro_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';

/// Schermata introduttiva dell'onboarding
class OnboardingIntroScreen extends StatelessWidget {
  const OnboardingIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingStandard * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Logo / Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 60,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: 40),

              // Titolo
              Text(
                'Benvenuto in EatWise',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Sottotitolo
              Text(
                'Il tuo assistente personale per un\'alimentazione equilibrata e consapevole',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Features
              _buildFeature(
                context,
                icon: Icons.calculate,
                title: 'Piano personalizzato',
                description: 'Calcolato sui tuoi obiettivi',
              ),

              const SizedBox(height: 20),

              _buildFeature(
                context,
                icon: Icons.insights,
                title: 'Tracciamento completo',
                description: 'Calorie, macro e abitudini',
              ),

              const SizedBox(height: 20),

              _buildFeature(
                context,
                icon: Icons.trending_up,
                title: 'Risultati duraturi',
                description: 'Basato sulla scienza',
              ),

              const Spacer(),

              // CTA Button
              ElevatedButton(
                onPressed: () => context.go('/onboarding/name'),
                child: const Text('Inizia'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.accent2.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}