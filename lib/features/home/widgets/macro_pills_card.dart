import 'package:flutter/material.dart';

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
            icon: '🌾',
            value: carbs,
            goal: carbsGoal,
            color: AppTheme.carbs,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MacroPill(
            label: 'Proteine',
            icon: '🥩',
            value: protein,
            goal: proteinGoal,
            color: AppTheme.protein,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MacroPill(
            label: 'Grassi',
            icon: '🥑',
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
  final String icon;
  final double value;
  final double goal;
  final Color color;

  const _MacroPill({
    required this.label,
    required this.icon,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / goal).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${value.toInt()}g · $percentage%',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: color.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 7,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
