// lib/core/services/nutrition_service.dart

import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/nutrition.dart';
import '../models/daily_log.dart';
import '../models/meal.dart';
import '../models/food_item.dart';
import '../models/enums/gender.dart';
import '../models/enums/activity_level.dart';
import '../models/enums/goal.dart';
import 'storage_service.dart';

/// Service per logica nutrizionale e gestione dati
class NutritionService {
  final StorageService _storage;
  final _uuid = const Uuid();

  NutritionService(this._storage);

  // ============ USER MANAGEMENT ============

  /// Verifica se esiste un utente (per routing)
  Future<bool> hasUser() async {
    return await _storage.hasUser();
  }

  /// Recupera l'utente corrente (null se non esiste - NO DEFAULT)
  Future<User?> getUser() async {
    return await _storage.getUser();
  }

  /// Crea un nuovo utente con i dati dall'onboarding
  Future<User> createUser({
    required String name,
    required Gender gender,
    required DateTime birthDate,
    required double heightCm,
    required double weightKg,
    double? targetWeightKg,
    required ActivityLevel activityLevel,
    required Goal goal,
  }) async {
    final user = User(
      id: _uuid.v4(),
      name: name,
      gender: gender,
      birthDate: birthDate,
      heightCm: heightCm,
      weightKg: weightKg,
      targetWeightKg: targetWeightKg,
      activityLevel: activityLevel,
      goal: goal,
    );

    await _storage.saveUser(user);
    return user;
  }

  /// Aggiorna l'utente esistente
  Future<void> updateUser(User user) async {
    await _storage.saveUser(user);
  }

  // ============ CALCOLI NUTRIZIONALI (Static Methods) ============

  /// Calcola BMR (Basal Metabolic Rate) - Formula Mifflin St Jeor
  static double calculateBMR({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return gender == Gender.male ? base + 5 : base - 161;
  }

  /// Calcola TDEE (Total Daily Energy Expenditure)
  static double calculateTDEE({
    required double bmr,
    required ActivityLevel activityLevel,
  }) {
    return bmr * activityLevel.factor;
  }

  /// Calcola calorie target giornaliere
  static int calculateDailyCalories({
    required double tdee,
    required Goal goal,
  }) {
    return (tdee + goal.calorieAdjustment).round();
  }

  /// Calcola obiettivo proteine (2.0g/kg)
  static double calculateProteinGoal(double weightKg) {
    return weightKg * 2.0;
  }

  /// Calcola obiettivo grassi (0.8g/kg)
  static double calculateFatGoal(double weightKg) {
    return weightKg * 0.8;
  }

  /// Calcola obiettivo carboidrati (calorie rimanenti / 4)
  static double calculateCarbGoal({
    required int dailyCalories,
    required double proteinGrams,
    required double fatGrams,
  }) {
    final proteinCalories = proteinGrams * 4;
    final fatCalories = fatGrams * 9;
    final remainingCalories = dailyCalories - proteinCalories - fatCalories;
    return (remainingCalories / 4).clamp(0, double.infinity);
  }

  /// Calcola BMI (Body Mass Index)
  static double calculateBMI({
    required double weightKg,
    required double heightCm,
  }) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  // ============ DAILY LOG MANAGEMENT ============

  Future<DailyLog> getDailyLog(DateTime date) async {
    final log = await _storage.getDailyLog(date);
    if (log != null) return log;

    // Crea log vuoto per il giorno
    final newLog = DailyLog(
      id: _uuid.v4(),
      date: _normalizeDate(date),
      meals: [],
      tracking: DailyTracking(),
    );

    await _storage.saveDailyLog(newLog);
    return newLog;
  }

  Future<void> saveDailyLog(DailyLog log) async {
    await _storage.saveDailyLog(log);
  }

  // ============ MEAL OPERATIONS ============

  Future<DailyLog> addMeal(DateTime date, MealType type, List<FoodItem> items) async {
    final log = await getDailyLog(date);

    final meal = Meal(
      id: _uuid.v4(),
      type: type,
      items: items,
      timestamp: DateTime.now(),
    );

    final updatedLog = log.copyWith(
      meals: [...log.meals, meal],
    );

    await saveDailyLog(updatedLog);
    return updatedLog;
  }

  Future<DailyLog> removeMeal(DateTime date, String mealId) async {
    final log = await getDailyLog(date);

    final updatedLog = log.copyWith(
      meals: log.meals.where((m) => m.id != mealId).toList(),
    );

    await saveDailyLog(updatedLog);
    return updatedLog;
  }

  // ============ TRACKING OPERATIONS ============

  Future<DailyLog> updateWater(DateTime date, int glasses) async {
    final log = await getDailyLog(date);

    final updatedLog = log.copyWith(
      tracking: DailyTracking(
        waterGlasses: glasses,
        fruitServings: log.tracking.fruitServings,
        veggieServings: log.tracking.veggieServings,
      ),
    );

    await saveDailyLog(updatedLog);
    return updatedLog;
  }

  Future<DailyLog> updateFruit(DateTime date, int servings) async {
    final log = await getDailyLog(date);

    final updatedLog = log.copyWith(
      tracking: DailyTracking(
        waterGlasses: log.tracking.waterGlasses,
        fruitServings: servings,
        veggieServings: log.tracking.veggieServings,
      ),
    );

    await saveDailyLog(updatedLog);
    return updatedLog;
  }

  Future<DailyLog> updateVeggies(DateTime date, int servings) async {
    final log = await getDailyLog(date);

    final updatedLog = log.copyWith(
      tracking: DailyTracking(
        waterGlasses: log.tracking.waterGlasses,
        fruitServings: log.tracking.fruitServings,
        veggieServings: servings,
      ),
    );

    await saveDailyLog(updatedLog);
    return updatedLog;
  }

  // ============ HELPERS ============

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // ============ MOCK DATA (per testing) ============

  Future<void> addSampleData(DateTime date) async {
    final log = await getDailyLog(date);

    final breakfast = Meal(
      id: _uuid.v4(),
      type: MealType.breakfast,
      items: [
        FoodItem(
          id: _uuid.v4(),
          name: 'Cappuccino e Cornetto',
          nutrition: NutritionInfo(
            calories: 370,
            protein: 50,
            carbs: 105,
            fats: 30,
          ),
          servingSize: 100,
        ),
      ],
      timestamp: DateTime.now(),
    );

    final lunch = Meal(
      id: _uuid.v4(),
      type: MealType.lunch,
      items: [
        FoodItem(
          id: _uuid.v4(),
          name: 'Spaghetti al Pomodoro',
          nutrition: NutritionInfo(
            calories: 555,
            protein: 250,
            carbs: 60,
            fats: 260,
          ),
          servingSize: 200,
        ),
      ],
      timestamp: DateTime.now(),
    );

    final updatedLog = log.copyWith(
      meals: [breakfast, lunch],
      tracking: DailyTracking(
        waterGlasses: 4,
        fruitServings: 2,
        veggieServings: 3,
      ),
    );

    await saveDailyLog(updatedLog);
  }
}