class MacroGoals {
  final double protein;  // grammi
  final double carbs;    // grammi
  final double fats;     // grammi

  MacroGoals({
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  Map<String, dynamic> toJson() => {
    'protein': protein,
    'carbs': carbs,
    'fats': fats,
  };

  factory MacroGoals.fromJson(Map<String, dynamic> json) => MacroGoals(
    protein: json['protein'],
    carbs: json['carbs'],
    fats: json['fats'],
  );
}

class NutritionInfo {
  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  NutritionInfo.zero()
      : calories = 0,
        protein = 0,
        carbs = 0,
        fats = 0;

  NutritionInfo operator +(NutritionInfo other) => NutritionInfo(
    calories: calories + other.calories,
    protein: protein + other.protein,
    carbs: carbs + other.carbs,
    fats: fats + other.fats,
  );

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fats': fats,
  };

  factory NutritionInfo.fromJson(Map<String, dynamic> json) => NutritionInfo(
    calories: json['calories'],
    protein: json['protein'],
    carbs: json['carbs'],
    fats: json['fats'],
  );
}