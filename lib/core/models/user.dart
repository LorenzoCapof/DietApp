// lib/core/models/user.dart

import 'package:dietapp/core/models/nutrition.dart';
import 'enums/gender.dart';
import 'enums/activity_level.dart';
import 'enums/goal.dart';
import 'enums/diet_type.dart';

/// Modello utente con dati antropometrici e nutrizionali
class User {
  final String id;
  final String name;

  // Dati antropometrici
  final Gender gender;
  final DateTime birthDate; // Data di nascita (età calcolata automaticamente)
  final double heightCm; // centimetri
  final double weightKg; // kilogrammi
  final double? targetWeightKg; // Peso obiettivo (nullable - solo per lose/gain)
  final DietType dietPreference;

  // Stile di vita e obiettivi
  final ActivityLevel activityLevel;
  final Goal goal;

  User({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.heightCm,
    required this.weightKg,
    this.targetWeightKg,
    required this.activityLevel,
    required this.goal,
    this.dietPreference = DietType.noDiet,
  });

  // ============ VALORI CALCOLATI ============

  /// Età calcolata dalla data di nascita
  int get age {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    
    // Verifica se il compleanno non è ancora avvenuto quest'anno
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }

  /// BMR (Basal Metabolic Rate) - Formula Mifflin St Jeor
  /// Uomo: 10*peso + 6.25*altezza - 5*età + 5
  /// Donna: 10*peso + 6.25*altezza - 5*età - 161
  double get bmr {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return gender == Gender.male ? base + 5 : base - 161;
  }

  /// TDEE (Total Daily Energy Expenditure) = BMR * fattore attività
  double get tdee {
    return bmr * activityLevel.factor;
  }

  /// Calorie target giornaliere (TDEE + adjustment per obiettivo)
  /// Se c'è un peso obiettivo, modifica il deficit/surplus in base alla differenza
  int get dailyCalories {
    double adjustment = 0.0;

    if (targetWeightKg != null) {
      final weightDifference = targetWeightKg! - weightKg;

      if (goal == Goal.loseWeight) {
        final deficit =
            (weightDifference.abs() * 100).clamp(300, 800).toDouble();
        adjustment = -deficit;
      } else if (goal == Goal.gainWeight) {
        final surplus =
            (weightDifference.abs() * 80).clamp(200, 500).toDouble();
        adjustment = surplus;
      }
    } else {
      adjustment = goal.calorieAdjustment.toDouble();
    }

    return (tdee + adjustment).round();
  }

  /// Obiettivo proteine (2.0g per kg di peso corporeo)
  double get proteinGrams {
    return weightKg * 2.0;
  }

  /// Obiettivo grassi (0.8g per kg di peso corporeo)
  double get fatsGrams {
    return weightKg * 0.8;
  }

  /// Obiettivo carboidrati (calorie rimanenti / 4)
  /// 1g proteine = 4 kcal
  /// 1g grassi = 9 kcal
  /// 1g carbo = 4 kcal
  double get carbsGrams {
    final proteinCalories = proteinGrams * 4;
    final fatCalories = fatsGrams * 9;
    final remainingCalories = dailyCalories - proteinCalories - fatCalories;
    return (remainingCalories / 4).clamp(0, double.infinity);
  }

  /// BMI (Body Mass Index) = peso / (altezza_m)²
  double get bmi {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Categoria BMI
  String get bmiCategory {
    if (bmi < 18.5) return 'Sottopeso';
    if (bmi < 25) return 'Normopeso';
    if (bmi < 30) return 'Sovrappeso';
    return 'Obesità';
  }

  /// BMI obiettivo (se presente peso obiettivo)
  double? get targetBmi {
    if (targetWeightKg == null) return null;
    final heightM = heightCm / 100;
    return targetWeightKg! / (heightM * heightM);
  }

  /// Differenza di peso da raggiungere (kg)
  double? get weightDifference {
    if (targetWeightKg == null) return null;
    return targetWeightKg! - weightKg;
  }

  /// Tempo stimato per raggiungere l'obiettivo (settimane)
  /// Perdita sana: 0.5-1 kg/settimana
  /// Aumento massa: 0.25-0.5 kg/settimana
  int? get estimatedWeeks {
    if (weightDifference == null) return null;
    
    final diff = weightDifference!.abs();
    
    if (goal == Goal.loseWeight) {
      // Perdita: 0.5-0.75 kg/settimana (media 0.625)
      return (diff / 0.625).ceil();
    } else if (goal == Goal.gainWeight) {
      // Aumento: 0.25-0.4 kg/settimana (media 0.325)
      return (diff / 0.325).ceil();
    }
    
    return null;
  }

  /// MacroGoals calcolati automaticamente
  MacroGoals get macroGoals => MacroGoals(
        protein: proteinGrams.roundToDouble(),
        carbs: carbsGrams.roundToDouble(),
        fats: fatsGrams.roundToDouble(),
      );

  /// Calorie goal come int (per compatibilità)
  int get dailyCalorieGoal => dailyCalories;

  // ============ VALIDAZIONE ============

  /// Valida che il peso obiettivo sia coerente con l'obiettivo
  bool get isTargetWeightValid {
    if (targetWeightKg == null) {
      // Se goal è maintain, è ok non avere peso obiettivo
      return goal == Goal.maintain;
    }
    
    // Se goal è lose weight, peso obiettivo deve essere minore
    if (goal == Goal.loseWeight && targetWeightKg! >= weightKg) {
      return false;
    }
    
    // Se goal è gain weight, peso obiettivo deve essere maggiore
    if (goal == Goal.gainWeight && targetWeightKg! <= weightKg) {
      return false;
    }
    
    return true;
  }

  // ============ SERIALIZATION ============

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gender': gender.toJson(),
        'birthDate': birthDate.toIso8601String(),
        'heightCm': heightCm,
        'weightKg': weightKg,
        'targetWeightKg': targetWeightKg,
        'activityLevel': activityLevel.toJson(),
        'goal': goal.toJson(),
        'dietPreference': dietPreference.toJson(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        gender: Gender.fromJson(json['gender']),
        birthDate: DateTime.parse(json['birthDate']),
        heightCm: json['heightCm'],
        weightKg: json['weightKg'],
        targetWeightKg: json['targetWeightKg'],
        activityLevel: ActivityLevel.fromJson(json['activityLevel']),
        goal: Goal.fromJson(json['goal']),
        dietPreference: json['dietPreference'] != null 
            ? DietType.fromJson(json['dietPreference'])
            : DietType.noDiet,
      );

  // ============ COPY WITH ============

  User copyWith({
    String? id,
    String? name,
    Gender? gender,
    DateTime? birthDate,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    ActivityLevel? activityLevel,
    Goal? goal,
    DietType? dietPreference,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      dietPreference: dietPreference ?? this.dietPreference,
    );
  }
}