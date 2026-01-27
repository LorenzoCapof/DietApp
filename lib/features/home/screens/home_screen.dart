// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../providers/nutrition_provider.dart';
import '../../../core/models/meal.dart';
import '../widgets/calorie_ring_card.dart';
import '../widgets/macro_pills_card.dart';
import '../widgets/meal_card.dart';
import '../widgets/tracking_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _dragDistance = 0.0;
  static const double _dragThreshold = 100.0;
  static const double _velocityThreshold = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<NutritionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.currentLog == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              // accumula lo spostamento orizzontale
              onHorizontalDragUpdate: (details) {
                _dragDistance += details.delta.dx;
              },
              onHorizontalDragEnd: (details) {
                final vx = details.velocity.pixelsPerSecond.dx;

                // swipe right (dx positivo) -> previous day
                if (_dragDistance > _dragThreshold || vx > _velocityThreshold) {
                  provider.goToPreviousDay();
                  HapticFeedback.selectionClick();
                }
                // swipe left (dx negativo) -> next day (solo se non è oggi)
                else if (_dragDistance < -_dragThreshold || vx < -_velocityThreshold) {
                  if (!_isToday(provider.selectedDate)) {
                    provider.goToNextDay();
                    HapticFeedback.selectionClick();
                  }
                }

                // reset accumulatore
                _dragDistance = 0.0;
              },
              child: CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: _buildHeader(context, provider),
                  ),

                  // Date Navigation
                  SliverToBoxAdapter(
                    child: _buildDateNavigation(context, provider),
                  ),

                  // Content
                  SliverPadding(
                    padding: const EdgeInsets.all(AppTheme.paddingStandard),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        CalorieRingCard(
                          consumed: provider.consumedCalories,
                          goal: provider.calorieGoal,
                          burned: 0,
                          consumedProtein: provider.consumedProtein,
                          consumedCarbs: provider.consumedCarbs,
                          consumedFats: provider.consumedFats,
                        ),

                        const SizedBox(height: AppTheme.sectionGap),

                        // Macro Pills
                        MacroPillsCard(
                          protein: provider.consumedProtein,
                          proteinGoal: provider.proteinGoal,
                          carbs: provider.consumedCarbs,
                          carbsGoal: provider.carbsGoal,
                          fats: provider.consumedFats,
                          fatsGoal: provider.fatsGoal,
                        ),

                        const SizedBox(height: 24),

                        // Section Title
                        Text(
                          'DIARIO ALIMENTARE',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Meals
                        MealCard(
                          type: MealType.breakfast,
                          meals: provider.breakfastMeals,
                          onAdd: (type) => _navigateToAddProducts(context, provider, type),
                        ),

                        const SizedBox(height: 12),

                        MealCard(
                          type: MealType.lunch,
                          meals: provider.lunchMeals,
                          onAdd: (type) => _navigateToAddProducts(context, provider, type),
                        ),

                        const SizedBox(height: 12),

                        MealCard(
                          type: MealType.dinner,
                          meals: provider.dinnerMeals,
                          onAdd: (type) => _navigateToAddProducts(context, provider, type),
                        ),

                        const SizedBox(height: 12),

                        MealCard(
                          type: MealType.snack,
                          meals: provider.snackMeals,
                          onAdd: (type) => _navigateToAddProducts(context, provider, type),
                        ),

                        const SizedBox(height: 24),

                        // Tracking Section
                        Text(
                          'TRACKING GIORNALIERO',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        TrackingCard(
                          waterGlasses: provider.waterGlasses,
                          fruitServings: provider.fruitServings,
                          veggieServings: provider.veggieServings,
                          onWaterIncrement: () => provider.incrementWater(),
                          onWaterDecrement: () => provider.decrementWater(),
                          onFruitIncrement: () => provider.incrementFruit(),
                          onFruitDecrement: () => provider.decrementFruit(),
                          onVeggiesIncrement: () => provider.incrementVeggies(),
                          onVeggiesDecrement: () => provider.decrementVeggies(),
                        ),

                        const SizedBox(height: 20),

                        // Debug Button
                        if (provider.currentLog?.meals.isEmpty ?? true)
                          Center(
                            child: TextButton(
                              onPressed: () => provider.loadSampleData(),
                              child: Text(
                                'Carica dati di esempio',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NutritionProvider provider) {
    final userName = provider.currentUser?.name ?? 'Utente';
    final greeting = _getGreeting();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.paddingStandard,
        20,
        AppTheme.paddingStandard,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            '$greeting,',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          // Nome
          Text(
            userName,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavigation(BuildContext context, NutritionProvider provider) {
    final selectedDate = provider.selectedDate;
    final isToday = _isToday(selectedDate);
    final dateFormat = DateFormat('d MMMM', 'it_IT');
    final displayDate = isToday ? 'OGGI' : dateFormat.format(selectedDate).toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulsante precedente
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: () => provider.goToPreviousDay(),
              icon: const Icon(Icons.chevron_left),
              color: AppTheme.primary,
              iconSize: 24,
              padding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(width: 12),

          // Data corrente
          GestureDetector(
            onTap: () => provider.goToToday(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    displayDate,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: _isToday(selectedDate) ? null : () => provider.goToNextDay(),
              icon: const Icon(Icons.chevron_right),
              color: _isToday(selectedDate) ? AppTheme.textDisabled : AppTheme.primary,
              iconSize: 24,
              padding: EdgeInsets.zero,
              disabledColor: AppTheme.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buongiorno';
    if (hour < 18) return 'Buon pomeriggio';
    return 'Buonasera';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _navigateToAddProducts(
    BuildContext context,
    NutritionProvider provider,
    MealType type,
  ) {
    final dateStr = provider.selectedDate.toIso8601String().split('T')[0];
    context.push('/add-meal-products/${type.name}/$dateStr');
  }
}
