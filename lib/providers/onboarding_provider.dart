// lib/providers/onboarding_provider.dart

import 'package:flutter/foundation.dart';
import '../core/models/enums/gender.dart';
import '../core/models/enums/activity_level.dart';
import '../core/models/enums/goal.dart';
import '../core/services/nutrition_service.dart';
import '../core/services/storage_service.dart';

/// Provider per gestire lo stato temporaneo durante l'onboarding
/// I dati vengono salvati SOLO alla fine, nella summary screen
class OnboardingProvider with ChangeNotifier {
  final NutritionService _nutritionService;

  // Dati temporanei dell'onboarding
  String? _name;
  Gender? _gender;
  DateTime? _birthDate;
  double? _heightCm;
  double? _weightKg;
  double? _targetWeightKg;
  ActivityLevel? _activityLevel;
  Goal? _goal;

  bool _isCompleting = false;

  OnboardingProvider()
      : _nutritionService = NutritionService(StorageService());

  // ============ GETTERS ============

  String? get name => _name;
  Gender? get gender => _gender;
  DateTime? get birthDate => _birthDate;
  double? get heightCm => _heightCm;
  double? get weightKg => _weightKg;
  double? get targetWeightKg => _targetWeightKg;
  ActivityLevel? get activityLevel => _activityLevel;
  Goal? get goal => _goal;
  bool get isCompleting => _isCompleting;

  /// Età calcolata dalla data di nascita
  int? get age {
    if (_birthDate == null) return null;
    
    final today = DateTime.now();
    int age = today.year - _birthDate!.year;
    
    if (today.month < _birthDate!.month || 
        (today.month == _birthDate!.month && today.day < _birthDate!.day)) {
      age--;
    }
    
    return age;
  }

  /// Verifica se tutti i dati obbligatori sono stati inseriti
  bool get isComplete {
    final baseComplete = _name != null &&
        _gender != null &&
        _birthDate != null &&
        _heightCm != null &&
        _weightKg != null &&
        _activityLevel != null &&
        _goal != null;

    // Se l'obiettivo è lose/gain weight, serve anche targetWeightKg
    if (_goal == Goal.loseWeight || _goal == Goal.gainWeight) {
      return baseComplete && _targetWeightKg != null;
    }

    return baseComplete;
  }

  /// Verifica se serve il peso obiettivo (solo per lose/gain weight)
  bool get needsTargetWeight {
    return _goal == Goal.loseWeight || _goal == Goal.gainWeight;
  }

  // ============ VALORI CALCOLATI (PREVIEW) ============

  /// BMR calcolato con i dati attuali (per preview nella summary)
  double? get calculatedBMR {
    if (_gender == null || _weightKg == null || _heightCm == null || age == null) {
      return null;
    }
    return NutritionService.calculateBMR(
      gender: _gender!,
      weightKg: _weightKg!,
      heightCm: _heightCm!,
      age: age!,
    );
  }

  /// TDEE calcolato (per preview)
  double? get calculatedTDEE {
    if (calculatedBMR == null || _activityLevel == null) return null;
    return NutritionService.calculateTDEE(
      bmr: calculatedBMR!,
      activityLevel: _activityLevel!,
    );
  }

  /// Calorie target (per preview) - considera peso obiettivo
  int? get calculatedDailyCalories {
    if (calculatedTDEE == null || _goal == null || _weightKg == null) return null;

    double adjustment = 0.0;

    if (_targetWeightKg != null) {
      final weightDifference = (_targetWeightKg! - _weightKg!).abs();

      if (_goal == Goal.loseWeight) {
        final deficit =
            (weightDifference * 100).clamp(300, 800).toDouble();
        adjustment = -deficit;
      } else if (_goal == Goal.gainWeight) {
        final surplus =
            (weightDifference * 80).clamp(200, 500).toDouble();
        adjustment = surplus;
      }
    } else {
      adjustment = _goal!.calorieAdjustment.toDouble();
    }

    return (calculatedTDEE! + adjustment).round();
  }

  /// Proteine target (per preview)
  double? get calculatedProtein {
    if (_weightKg == null) return null;
    return NutritionService.calculateProteinGoal(_weightKg!);
  }

  /// Grassi target (per preview)
  double? get calculatedFats {
    if (_weightKg == null) return null;
    return NutritionService.calculateFatGoal(_weightKg!);
  }

  /// Carboidrati target (per preview)
  double? get calculatedCarbs {
    if (calculatedDailyCalories == null ||
        calculatedProtein == null ||
        calculatedFats == null) {
      return null;
    }
    return NutritionService.calculateCarbGoal(
      dailyCalories: calculatedDailyCalories!,
      proteinGrams: calculatedProtein!,
      fatGrams: calculatedFats!,
    );
  }

  /// BMI calcolato (per preview)
  double? get calculatedBMI {
    if (_weightKg == null || _heightCm == null) return null;
    return NutritionService.calculateBMI(
      weightKg: _weightKg!,
      heightCm: _heightCm!,
    );
  }

  /// BMI obiettivo (se presente peso obiettivo)
  double? get calculatedTargetBMI {
    if (_targetWeightKg == null || _heightCm == null) return null;
    return NutritionService.calculateBMI(
      weightKg: _targetWeightKg!,
      heightCm: _heightCm!,
    );
  }

  /// Differenza di peso da raggiungere
  double? get weightDifference {
    if (_targetWeightKg == null || _weightKg == null) return null;
    return _targetWeightKg! - _weightKg!;
  }

  /// Tempo stimato per raggiungere l'obiettivo (settimane)
  int? get estimatedWeeks {
    if (weightDifference == null || _goal == null) return null;
    
    final diff = weightDifference!.abs();
    
    if (_goal == Goal.loseWeight) {
      return (diff / 0.625).ceil(); // 0.5-0.75 kg/settimana
    } else if (_goal == Goal.gainWeight) {
      return (diff / 0.325).ceil(); // 0.25-0.4 kg/settimana
    }
    
    return null;
  }

  // ============ SETTERS ============

  void setName(String name) {
    _name = name.trim();
    notifyListeners();
  }

  void setGender(Gender gender) {
    _gender = gender;
    notifyListeners();
  }

  void setBirthDate(DateTime birthDate) {
    _birthDate = birthDate;
    notifyListeners();
  }

  void setHeight(double heightCm) {
    _heightCm = heightCm;
    notifyListeners();
  }

  void setWeight(double weightKg) {
    _weightKg = weightKg;
    notifyListeners();
  }

  void setTargetWeight(double? targetWeightKg) {
    _targetWeightKg = targetWeightKg;
    notifyListeners();
  }

  void setActivityLevel(ActivityLevel level) {
    _activityLevel = level;
    notifyListeners();
  }

  void setGoal(Goal goal) {
    _goal = goal;
    // Se passa da lose/gain a maintain, resetta targetWeight
    if (goal == Goal.maintain) {
      _targetWeightKg = null;
    }
    notifyListeners();
  }

  // ============ VALIDAZIONE ============

  /// Valida che il peso obiettivo sia coerente con l'obiettivo
  bool isTargetWeightValid(double targetWeight) {
    if (_weightKg == null || _goal == null) return false;
    
    if (_goal == Goal.loseWeight) {
      return targetWeight < _weightKg!;
    }
    
    if (_goal == Goal.gainWeight) {
      return targetWeight > _weightKg!;
    }
    
    return true; // maintain non richiede validazione
  }

  // ============ COMPLETAMENTO ONBOARDING ============

  /// Completa l'onboarding creando e salvando l'utente
  /// Ritorna true se successo, false se errore
  Future<bool> completeOnboarding() async {
    if (!isComplete) {
      debugPrint('Onboarding incompleto - dati mancanti');
      return false;
    }

    _isCompleting = true;
    notifyListeners();

    try {
      // Crea l'utente con i dati raccolti
      await _nutritionService.createUser(
        name: _name!,
        gender: _gender!,
        birthDate: _birthDate!,
        heightCm: _heightCm!,
        weightKg: _weightKg!,
        targetWeightKg: _targetWeightKg,
        activityLevel: _activityLevel!,
        goal: _goal!,
      );

      debugPrint('Onboarding completato - utente salvato');
      return true;
    } catch (e) {
      debugPrint('Errore completamento onboarding: $e');
      return false;
    } finally {
      _isCompleting = false;
      notifyListeners();
    }
  }

  /// Reset di tutti i dati (per ricominciare l'onboarding)
  void reset() {
    _name = null;
    _gender = null;
    _birthDate = null;
    _heightCm = null;
    _weightKg = null;
    _targetWeightKg = null;
    _activityLevel = null;
    _goal = null;
    _isCompleting = false;
    notifyListeners();
  }
}