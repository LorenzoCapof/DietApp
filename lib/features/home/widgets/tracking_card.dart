import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class TrackingCard extends StatelessWidget {
  final int waterGlasses;
  final int fruitServings;
  final int veggieServings;
  final VoidCallback onWaterIncrement;
  final VoidCallback onWaterDecrement;
  final VoidCallback onFruitIncrement;
  final VoidCallback onFruitDecrement;
  final VoidCallback onVeggiesIncrement;
  final VoidCallback onVeggiesDecrement;

  const TrackingCard({
    super.key,
    required this.waterGlasses,
    required this.fruitServings,
    required this.veggieServings,
    required this.onWaterIncrement,
    required this.onWaterDecrement,
    required this.onFruitIncrement,
    required this.onFruitDecrement,
    required this.onVeggiesIncrement,
    required this.onVeggiesDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tracking Giornaliero',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _TrackingItem(
            iconPath: 'assets/icons/tracking/water.png',
            label: 'Acqua',
            count: waterGlasses,
            goal: 8,
            unit: 'bicchieri',
            onIncrement: onWaterIncrement,
            onDecrement: onWaterDecrement,
          ),
          const SizedBox(height: 14),
          _TrackingItem(
            iconPath: 'assets/icons/tracking/fruit.png',
            label: 'Frutta',
            count: fruitServings,
            goal: 3,
            unit: 'porzioni',
            onIncrement: onFruitIncrement,
            onDecrement: onFruitDecrement,
          ),
          const SizedBox(height: 14),
          _TrackingItem(
            iconPath: 'assets/icons/tracking/veggies.png',
            label: 'Verdura',
            count: veggieServings,
            goal: 4,
            unit: 'porzioni',
            onIncrement: onVeggiesIncrement,
            onDecrement: onVeggiesDecrement,
          ),
        ],
      ),
    );
  }
}

class _TrackingItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final int count;
  final int goal;
  final String unit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _TrackingItem({
    required this.iconPath,
    required this.label,
    required this.count,
    required this.goal,
    required this.unit,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 32,
          height: 32,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.check_circle, size: 32),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                '$count/$goal $unit',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        // Pulsanti decremento e incremento (hit target 44x44 cada)
        SizedBox(
          width: 88,
          height: 44,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove_circle_outline, color: AppTheme.textSecondary),
                iconSize: 28,
                padding: EdgeInsets.zero,
              ),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_circle, color: AppTheme.textSecondary),
                iconSize: 28,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
