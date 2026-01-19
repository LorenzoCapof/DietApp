// lib/providers/nutrition_provider.dart

import 'package:flutter/foundation.dart';
import '../core/models/user.dart';
import '../core/models/daily_log.dart';
import '../core/models/meal.dart';
import '../core/models/food_item.dart';
import '../core/services/nutrition_service.dart';
import '../core/services/storage_service.dart';

class NutritionProvider with ChangeNotifier {
  final NutritionService _service;

  User? _currentUser;
  DailyLog? _currentLog;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  NutritionProvider() : _service = NutritionService(StorageService()) {
    _initialize();
  }

  // ============ GETTERS ============

  User? get currentUser => _currentUser;
  DailyLog? get currentLog => _currentLog;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  // Calorie
  double get consumedCalories => _currentLog?.totalNutrition.calories ?? 0;
  double get calorieGoal => _currentUser?.dailyCalorieGoal.toDouble() ?? 2000;
  double get calorieProgress => calorieGoal > 0 ? consumedCalories / calorieGoal : 0;

  // Macros
  double get consumedProtein => _currentLog?.totalNutrition.protein ?? 0;
  double get proteinGoal => _currentUser?.macroGoals.protein ?? 100;
  double get proteinProgress => proteinGoal > 0 ? consumedProtein / proteinGoal : 0;

  double get consumedCarbs => _currentLog?.totalNutrition.carbs ?? 0;
  double get carbsGoal => _currentUser?.macroGoals.carbs ?? 250;
  double get carbsProgress => carbsGoal > 0 ? consumedCarbs / carbsGoal : 0;

  double get consumedFats => _currentLog?.totalNutrition.fats ?? 0;
  double get fatsGoal => _currentUser?.macroGoals.fats ?? 70;
  double get fatsProgress => fatsGoal > 0 ? consumedFats / fatsGoal : 0;

  // Tracking
  int get waterGlasses => _currentLog?.tracking.waterGlasses ?? 0;
  int get fruitServings => _currentLog?.tracking.fruitServings ?? 0;
  int get veggieServings => _currentLog?.tracking.veggieServings ?? 0;

  // Meals
  List<Meal> get breakfastMeals => 
      _currentLog?.mealsOfType(MealType.breakfast) ?? [];
  List<Meal> get lunchMeals => 
      _currentLog?.mealsOfType(MealType.lunch) ?? [];
  List<Meal> get dinnerMeals => 
      _currentLog?.mealsOfType(MealType.dinner) ?? [];
  List<Meal> get snackMeals => 
      _currentLog?.mealsOfType(MealType.snack) ?? [];

  // ============ INITIALIZATION ============

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _service.getOrCreateUser();
      await _loadDailyLog(_selectedDate);
    } catch (e) {
      debugPrint('Error initializing: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============ DATE NAVIGATION ============

  Future<void> selectDate(DateTime date) async {
    _selectedDate = DateTime(date.year, date.month, date.day);
    await _loadDailyLog(_selectedDate);
  }

  Future<void> goToNextDay() async {
    await selectDate(_selectedDate.add(const Duration(days: 1)));
  }

  Future<void> goToPreviousDay() async {
    await selectDate(_selectedDate.subtract(const Duration(days: 1)));
  }

  Future<void> goToToday() async {
    await selectDate(DateTime.now());
  }

  // ============ DATA LOADING ============

  Future<void> _loadDailyLog(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentLog = await _service.getDailyLog(date);
    } catch (e) {
      debugPrint('Error loading daily log: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadDailyLog(_selectedDate);
  }

  // ============ MEAL OPERATIONS ============

  Future<void> addMeal(MealType type, List<FoodItem> items) async {
    try {
      _currentLog = await _service.addMeal(_selectedDate, type, items);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding meal: $e');
    }
  }

  Future<void> removeMeal(String mealId) async {
    try {
      _currentLog = await _service.removeMeal(_selectedDate, mealId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing meal: $e');
    }
  }

  // ============ TRACKING OPERATIONS ============

  Future<void> updateWater(int glasses) async {
    try {
      _currentLog = await _service.updateWater(_selectedDate, glasses);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating water: $e');
    }
  }

  Future<void> incrementWater() async {
    await updateWater(waterGlasses + 1);
  }

  Future<void> decrementWater() async {
    if (waterGlasses > 0) {
      await updateWater(waterGlasses - 1);
    }
  }

  Future<void> updateFruit(int servings) async {
    try {
      _currentLog = await _service.updateFruit(_selectedDate, servings);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating fruit: $e');
    }
  }

  Future<void> incrementFruit() async {
    await updateFruit(fruitServings + 1);
  }

  Future<void> decrementFruit() async {
    if (fruitServings > 0) {
      await updateFruit(fruitServings - 1);
    }
  }

  Future<void> updateVeggies(int servings) async {
    try {
      _currentLog = await _service.updateVeggies(_selectedDate, servings);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating veggies: $e');
    }
  }

  Future<void> incrementVeggies() async {
    await updateVeggies(veggieServings + 1);
  }

  Future<void> decrementVeggies() async {
    if (veggieServings > 0) {
      await updateVeggies(veggieServings - 1);
    }
  }

  // ============ SAMPLE DATA ============

  Future<void> loadSampleData() async {
    try {
      await _service.addSampleData(_selectedDate);
      await refresh();
    } catch (e) {
      debugPrint('Error loading sample data: $e');
    }
  }
}