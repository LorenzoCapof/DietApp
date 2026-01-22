import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class TrackingCard extends StatelessWidget {
  final int waterGlasses;
  final int fruitServings;
  final int veggieServings;
  final VoidCallback onWaterIncrement;
  final VoidCallback onFruitIncrement;
  final VoidCallback onVeggiesIncrement;

  const TrackingCard({
    super.key,
    required this.waterGlasses,
    required this.fruitServings,
    required this.veggieServings,
    required this.onWaterIncrement,
    required this.onFruitIncrement,
    required this.onVeggiesIncrement,
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
            iconPath: '../assets/icons/tracking/water.png',
            label: 'Acqua',
            count: waterGlasses,
            goal: 8,
            unit: 'bicchieri',
            onIncrement: onWaterIncrement,
          ),
          const SizedBox(height: 14),
          _TrackingItem(
            iconPath: '../assets/icons/tracking/fruit.png',
            label: 'Frutta',
            count: fruitServings,
            goal: 3,
            unit: 'porzioni',
            onIncrement: onFruitIncrement,
          ),
          const SizedBox(height: 14),
          _TrackingItem(
            iconPath: '../assets/icons/tracking/veggies.png',
            label: 'Verdura',
            count: veggieServings,
            goal: 4,
            unit: 'porzioni',
            onIncrement: onVeggiesIncrement,
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

  const _TrackingItem({
    required this.iconPath,
    required this.label,
    required this.count,
    required this.goal,
    required this.unit,
    required this.onIncrement,
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
        // Hit target 44x44
        SizedBox(
          width: 44,
          height: 44,
          child: IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add_circle, color: AppTheme.accent2),
            iconSize: 28,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
