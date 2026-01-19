import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (hasItems)
                      Text(
                        '${_getRecommendedCalories(type)} · ${totalCalories.toInt()} kcal',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              // Pulsante + con hit target 44x44
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  onPressed: onAdd,
                  icon: Icon(
                    hasItems ? Icons.add_circle : Icons.add_circle_outline,
                    color: AppTheme.primary,
                    size: 26,
                  ),
                  padding: EdgeInsets.zero,
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      meal.items.first.name,
                      style: Theme.of(context).textTheme.bodyMedium,
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
        return 'Consigliato 370-555 kcal';
      case MealType.lunch:
        return 'Consigliato 555-740 kcal';
      case MealType.dinner:
        return 'Consigliato 555-740 kcal';
      case MealType.snack:
        return 'Consigliato 185-280 kcal';
    }
  }
}