// lib/features/onboarding/screens/diet_preference_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../../core/models/enums/diet_type.dart';
import '../../../providers/onboarding_provider.dart';

/// Schermata per selezionare la dieta preferita
class DietPreferenceScreen extends StatelessWidget {
  const DietPreferenceScreen({super.key});

  void _selectDiet(BuildContext context, DietType diet) {
    context.read<OnboardingProvider>().setDietPreference(diet);
    // Naviga alla prossima schermata di onboarding
    context.go('/onboarding/next-step'); // Modifica con il route appropriato
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/goal'), // Modifica con il route precedente
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
              _buildProgress(6, 7),

              const SizedBox(height: 40),

              // Titolo
              Text(
                'Preferenza alimentare',
                style: Theme.of(context).textTheme.displaySmall,
              ),

              const SizedBox(height: 12),

              // Sottotitolo
              Text(
                'Segui una dieta particolare o hai preferenze alimentari?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              // Lista opzioni
              Expanded(
                child: Consumer<OnboardingProvider>(
                  builder: (context, provider, _) {
                    return ListView(
                      children: DietType.values.map((diet) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDietOption(
                            context,
                            diet: diet,
                            isSelected: provider.dietPreference == diet,
                            onTap: () => _selectDiet(context, diet),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
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

  Widget _buildDietOption(
    BuildContext context, {
    required DietType diet,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusButton),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            // Icona
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconForDiet(diet),
                size: 24,
                color: isSelected ? Colors.white : AppTheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            // Testo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diet.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    diet.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          height: 1.3,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '✓ ${diet.benefits}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Check indicator
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

  IconData _getIconForDiet(DietType diet) {
    switch (diet) {
      case DietType.noDiet:
        return Icons.restaurant;
      case DietType.mediterranean:
        return Icons.set_meal;
      case DietType.vegetarian:
        return Icons.spa;
      case DietType.vegan:
        return Icons.nature;
      case DietType.paleo:
        return Icons.outdoor_grill;
      case DietType.keto:
        return Icons.egg;
      case DietType.lowCarb:
        return Icons.no_food;
      case DietType.intermittentFasting:
        return Icons.schedule;
      case DietType.dukan:
        return Icons.fitness_center;
      case DietType.zone:
        return Icons.balance;
      case DietType.dash:
        return Icons.favorite;
      case DietType.flexitarian:
        return Icons.eco;
      case DietType.wholeFoods:
        return Icons.local_florist;
      case DietType.glutenFree:
        return Icons.block;
      case DietType.lowFat:
        return Icons.water_drop;
      case DietType.pescatarian:
        return Icons.phishing;
    }
  }
}