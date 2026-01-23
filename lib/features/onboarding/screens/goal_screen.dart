// lib/features/onboarding/screens/goal_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../../core/models/enums/goal.dart';
import '../../../providers/onboarding_provider.dart';

/// Schermata per selezionare l'obiettivo nutrizionale
class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  void _selectGoal(BuildContext context, Goal goal) {
    context.read<OnboardingProvider>().setGoal(goal);
    
    // Se l'obiettivo è lose/gain weight, vai alla schermata peso obiettivo
    // Se è maintain, vai direttamente al summary
    if (goal == Goal.loseWeight || goal == Goal.gainWeight) {
      context.go('/onboarding/target-weight');
    } else {
      context.go('/onboarding/summary');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/activity'),
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
                'Il tuo obiettivo',
                style: Theme.of(context).textTheme.displaySmall,
              ),

              const SizedBox(height: 12),

              // Sottotitolo
              Text(
                'Cosa vuoi raggiungere?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              // Lista obiettivi
              Expanded(
                child: Consumer<OnboardingProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      children: Goal.values.map((goal) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildGoalOption(
                            context,
                            goal: goal,
                            isSelected: provider.goal == goal,
                            onTap: () => _selectGoal(context, goal),
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

  Widget _buildGoalOption(
    BuildContext context, {
    required Goal goal,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color goalColor;
    switch (goal) {
      case Goal.loseWeight:
        goalColor = AppTheme.accent1;
        break;
      case Goal.maintain:
        goalColor = AppTheme.accent2;
        break;
      case Goal.gainWeight:
        goalColor = AppTheme.primary;
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? goalColor.withValues(alpha: 0.12)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          border: Border.all(
            color: isSelected
                ? goalColor
                : AppTheme.primary.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Emoji/Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? goalColor
                        : goalColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      goal.iconAsset,
                      width: 28,
                      height: 28,
                      color: isSelected ? Colors.white : goalColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Titolo
                Expanded(
                  child: Text(
                    goal.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isSelected ? goalColor : AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                // Check indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: goalColor,
                    size: 28,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Descrizione
            Text(
              goal.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? goalColor.withValues(alpha: 0.8) : AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}