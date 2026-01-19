import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../../core/models/meal.dart';

class MealCard extends StatelessWidget {
  final MealType type;
  final List<Meal> meals;
  final VoidCallback onAdd;

  const MealCard({
    super.key,
    required this.type,
    required this.meals,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories = meals.fold<double>(
      0,
      (sum, meal) => sum + meal.totalNutrition.calories,
    );

    final hasItems = meals.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                type.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.displayName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (hasItems)
                      Text(
                        'Consigliato ${_getRecommendedCalories(type)} - ${totalCalories.toInt()} kcal',
                        style: GoogleFonts.crimsonPro(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onAdd,
                icon: Icon(
                  hasItems ? Icons.add_circle : Icons.add_circle_outline,
                  color: AppTheme.primary,
                  size: 28,
                ),
              ),
            ],
          ),
          if (hasItems) ...[
            const SizedBox(height: 12),
            ...meals.map((meal) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    meal.items.first.imageUrl ?? '🍽️',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      meal.items.first.name,
                      style: GoogleFonts.crimsonPro(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  String _getRecommendedCalories(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return '370-555 kcal';
      case MealType.lunch:
        return '555-740 kcal';
      case MealType.dinner:
        return '555-740 kcal';
      case MealType.snack:
        return '185-280 kcal';
    }
  }
}