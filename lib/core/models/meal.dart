import 'package:dietapp/core/models/food_item.dart';
import 'package:dietapp/core/models/nutrition.dart';

enum MealType {
  breakfast,
  lunch,
  dinner,
  snack;

  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Colazione';
      case MealType.lunch:
        return 'Pranzo';
      case MealType.dinner:
        return 'Cena';
      case MealType.snack:
        return 'Spuntino';
    }
  }

  String get emoji {
    switch (this) {
      case MealType.breakfast:
        return '🌅';
      case MealType.lunch:
        return '☀️';
      case MealType.dinner:
        return '🌙';
      case MealType.snack:
        return '🍎';
    }
  }
}

class Meal {
  final String id;
  final MealType type;
  final List<FoodItem> items;
  final DateTime timestamp;

  Meal({
    required this.id,
    required this.type,
    required this.items,
    required this.timestamp,
  });

  NutritionInfo get totalNutrition => items.fold(
    NutritionInfo.zero(),
    (sum, item) => sum + item.nutrition,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'items': items.map((i) => i.toJson()).toList(),
    'timestamp': timestamp.toIso8601String(),
  };

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    id: json['id'],
    type: MealType.values.firstWhere((e) => e.name == json['type']),
    items: (json['items'] as List).map((i) => FoodItem.fromJson(i)).toList(),
    timestamp: DateTime.parse(json['timestamp']),
  );
}