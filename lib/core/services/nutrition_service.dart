import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/nutrition.dart';
import '../models/daily_log.dart';
import '../models/meal.dart';
import '../models/food_item.dart';
import 'storage_service.dart';

class NutritionService {
  final StorageService _storage;
  final _uuid = const Uuid();

  NutritionService(this._storage);

  // ============ USER MANAGEMENT ============

  Future<User> getOrCreateUser() async {
    final user = await _storage.getUser();
    if (user != null) return user;

    // Crea utente di default
    final newUser = User(
      id: _uuid.v4(),
      name: 'Marco',
      dailyCalorieGoal: 1848,
      macroGoals: MacroGoals(
        protein: 92,
        carbs: 231,
        fats: 62,
      ),
    );

    await _storage.saveUser(newUser);
    return newUser;
  }

  Future<void> updateUser(User user) async {
    await _storage.saveUser(user);
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

    // Aggiungi pasti di esempio
    final breakfast = Meal(
      id: _uuid.v4(),
      type: MealType.breakfast,
      items: [
        FoodItem(
          id: _uuid.v4(),
          name: 'Colazione',
          nutrition: NutritionInfo(
            calories: 370,
            protein: 15,
            carbs: 45,
            fats: 12,
          ),
          servingSize: 100,
          imageUrl: '🥐',
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
          name: 'Pranzo',
          nutrition: NutritionInfo(
            calories: 555,
            protein: 35,
            carbs: 60,
            fats: 18,
          ),
          servingSize: 200,
          imageUrl: '🍝',
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