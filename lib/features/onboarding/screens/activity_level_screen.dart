// lib/features/onboarding/screens/activity_level_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../../core/models/enums/activity_level.dart';
import '../../../providers/onboarding_provider.dart';

/// Schermata per selezionare il livello di attività fisica
class ActivityLevelScreen extends StatelessWidget {
  const ActivityLevelScreen({super.key});

  void _selectLevel(BuildContext context, ActivityLevel level) {
    context.read<OnboardingProvider>().setActivityLevel(level);
    context.go('/onboarding/goal');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/body'),
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
              _buildProgress(5, 7),

              const SizedBox(height: 40),

              // Titolo
              Text(
                'Livello di attività',
                style: Theme.of(context).textTheme.displaySmall,
              ),

              const SizedBox(height: 12),

              // Sottotitolo
              Text(
                'Quanto sei attivo durante la settimana?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              // Lista opzioni
              Expanded(
                child: Consumer<OnboardingProvider>(
                  builder: (context, provider, _) {
                    return ListView(
                      children: ActivityLevel.values.map((level) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildLevelOption(
                            context,
                            level: level,
                            isSelected: provider.activityLevel == level,
                            onTap: () => _selectLevel(context, level),
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

  Widget _buildLevelOption(
    BuildContext context, {
    required ActivityLevel level,
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
                _getIconForLevel(level),
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
                    level.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
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

  IconData _getIconForLevel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return Icons.event_seat;
      case ActivityLevel.lightlyActive:
        return Icons.directions_walk;
      case ActivityLevel.moderatelyActive:
        return Icons.directions_run;
      case ActivityLevel.veryActive:
        return Icons.fitness_center;
      case ActivityLevel.extraActive:
        return Icons.sports_mma;
    }
  }
}