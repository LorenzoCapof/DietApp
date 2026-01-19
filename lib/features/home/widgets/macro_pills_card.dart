import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';

class MacroPillsCard extends StatelessWidget {
  final double protein;
  final double proteinGoal;
  final double carbs;
  final double carbsGoal;
  final double fats;
  final double fatsGoal;

  const MacroPillsCard({
    super.key,
    required this.protein,
    required this.proteinGoal,
    required this.carbs,
    required this.carbsGoal,
    required this.fats,
    required this.fatsGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MacroPill(
            label: 'Carboidrati',
            value: carbs,
            goal: carbsGoal,
            color: AppTheme.carbs,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MacroPill(
            label: 'Proteine',
            value: protein,
            goal: proteinGoal,
            color: AppTheme.protein,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MacroPill(
            label: 'Grassi',
            value: fats,
            goal: fatsGoal,
            color: AppTheme.fats,
          ),
        ),
      ],
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String label;
  final double value;
  final double goal;
  final Color color;

  const _MacroPill({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / goal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${value.toInt()}/${goal.toInt()}g',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}