// lib/core/models/daily_log.dart

import 'package:dietapp/core/models/meal.dart';
import 'package:dietapp/core/models/nutrition.dart';

/// Tracking giornaliero (acqua, frutta, verdura)
class DailyTracking {
  final int waterGlasses;
  final int fruitServings;
  final int veggieServings;

  DailyTracking({
    this.waterGlasses = 0,
    this.fruitServings = 0,
    this.veggieServings = 0,
  });

  Map<String, dynamic> toJson() => {
    'waterGlasses': waterGlasses,
    'fruitServings': fruitServings,
    'veggieServings': veggieServings,
  };

  factory DailyTracking.fromJson(Map<String, dynamic> json) => DailyTracking(
    waterGlasses: json['waterGlasses'] ?? 0,
    fruitServings: json['fruitServings'] ?? 0,
    veggieServings: json['veggieServings'] ?? 0,
  );
}

/// Log giornaliero completo con pasti e tracking
class DailyLog {
  final String id;
  final DateTime date;
  final List<Meal> meals;
  final DailyTracking tracking;

  DailyLog({
    required this.id,
    required this.date,
    required this.meals,
    required this.tracking,
  });

  /// Nutrizione totale del giorno (somma di tutti i pasti)
  NutritionInfo get totalNutrition => meals.fold(
    NutritionInfo.zero(),
    (sum, meal) => sum + meal.totalNutrition,
  );

  /// Ottiene tutti i pasti di un tipo specifico
  List<Meal> mealsOfType(MealType type) {
    return meals.where((meal) => meal.type == type).toList();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'meals': meals.map((m) => m.toJson()).toList(),
    'tracking': tracking.toJson(),
  };

  factory DailyLog.fromJson(Map<String, dynamic> json) => DailyLog(
    id: json['id'],
    date: DateTime.parse(json['date']),
    meals: (json['meals'] as List).map((m) => Meal.fromJson(m)).toList(),
    tracking: DailyTracking.fromJson(json['tracking']),
  );

  /// CopyWith per aggiornamenti immutabili
  DailyLog copyWith({
    String? id,
    DateTime? date,
    List<Meal>? meals,
    DailyTracking? tracking,
  }) {
    return DailyLog(
      id: id ?? this.id,
      date: date ?? this.date,
      meals: meals ?? this.meals,
      tracking: tracking ?? this.tracking,
    );
  }
}
