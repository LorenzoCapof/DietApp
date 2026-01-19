import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      padding: const EdgeInsets.all(20),
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
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _TrackingItem(
            icon: '💧',
            label: 'Acqua',
            count: waterGlasses,
            goal: 8,
            unit: 'bicchieri',
            onIncrement: onWaterIncrement,
          ),
          const SizedBox(height: 12),
          _TrackingItem(
            icon: '🍎',
            label: 'Frutta',
            count: fruitServings,
            goal: 3,
            unit: 'porzioni',
            onIncrement: onFruitIncrement,
          ),
          const SizedBox(height: 12),
          _TrackingItem(
            icon: '🥦',
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
  final String icon;
  final String label;
  final int count;
  final int goal;
  final String unit;
  final VoidCallback onIncrement;

  const _TrackingItem({
    required this.icon,
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
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count/$goal $unit',
                style: GoogleFonts.crimsonPro(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle, color: AppTheme.accent2),
          iconSize: 28,
        ),
      ],
    );
  }
}