// lib/features/onboarding/screens/gender_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../../core/models/enums/gender.dart';
import '../../../providers/onboarding_provider.dart';

/// Schermata per selezionare il genere
class GenderScreen extends StatelessWidget {
  const GenderScreen({super.key});

  void _selectGender(BuildContext context, Gender gender) {
    context.read<OnboardingProvider>().setGender(gender);
    context.go('/onboarding/birthdate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/name'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingStandard * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Progress indicator
              _buildProgress(2, 7),

              const SizedBox(height: 40),

              // Titolo
              Text(
                'Qual è il tuo genere?',
                style: Theme.of(context).textTheme.displaySmall,
              ),

              const SizedBox(height: 12),

              // Sottotitolo
              Text(
                'Useremo questa informazione per calcolare il tuo metabolismo basale',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 40),

              // Opzioni genere
              Consumer<OnboardingProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      _buildGenderOption(
                        context,
                        gender: Gender.male,
                        icon: Icons.male,
                        isSelected: provider.gender == Gender.male,
                        onTap: () => _selectGender(context, Gender.male),
                      ),
                      const SizedBox(height: 16),
                      _buildGenderOption(
                        context,
                        gender: Gender.female,
                        icon: Icons.female,
                        isSelected: provider.gender == Gender.female,
                        onTap: () => _selectGender(context, Gender.female),
                      ),
                    ],
                  );
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgress(int current, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $current di $total',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: current / total,
          backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
          valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildGenderOption(
    BuildContext context, {
    required Gender gender,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusButton),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.1)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.primary.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : AppTheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                gender.displayName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}