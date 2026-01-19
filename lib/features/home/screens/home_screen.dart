// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../providers/nutrition_provider.dart';
import '../../../core/models/meal.dart';
import '../widgets/calorie_ring_card.dart';
import '../widgets/macro_pills_card.dart';
import '../widgets/meal_card.dart';
import '../widgets/tracking_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                      // Calorie Ring
                      CalorieRingCard(
                        consumed: provider.consumedCalories,
                        goal: provider.calorieGoal,
                        burned: 0,
                      ),
                      
                      const SizedBox(height: 20),
                      
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
                        'REGISTRO ALIMENTARE',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Meals
                      MealCard(
                        type: MealType.breakfast,
                        meals: provider.breakfastMeals,
                        onAdd: () => _showAddMealDialog(context, provider, MealType.breakfast),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      MealCard(
                        type: MealType.lunch,
                        meals: provider.lunchMeals,
                        onAdd: () => _showAddMealDialog(context, provider, MealType.lunch),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      MealCard(
                        type: MealType.dinner,
                        meals: provider.dinnerMeals,
                        onAdd: () => _showAddMealDialog(context, provider, MealType.dinner),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      MealCard(
                        type: MealType.snack,
                        meals: provider.snackMeals,
                        onAdd: () => _showAddMealDialog(context, provider, MealType.snack),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Tracking Section
                      Text(
                        'TRACKING GIORNALIERO',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      TrackingCard(
                        waterGlasses: provider.waterGlasses,
                        fruitServings: provider.fruitServings,
                        veggieServings: provider.veggieServings,
                        onWaterIncrement: () => provider.incrementWater(),
                        onFruitIncrement: () => provider.incrementFruit(),
                        onVeggiesIncrement: () => provider.incrementVeggies(),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Debug Button (rimuovi in produzione)
                      if (provider.currentLog?.meals.isEmpty ?? true)
                        TextButton(
                          onPressed: () => provider.loadSampleData(),
                          child: const Text('Carica dati di esempio'),
                        ),
                    ]),
                  ),
                ),
              ],
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
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting,',
            style: GoogleFonts.crimsonPro(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userName,
            style: GoogleFonts.crimsonPro(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => provider.goToPreviousDay(),
            icon: const Icon(Icons.chevron_left),
            color: AppTheme.primary,
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () => provider.goToToday(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  displayDate,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: _isToday(selectedDate) ? null : () => provider.goToNextDay(),
            icon: const Icon(Icons.chevron_right),
            color: _isToday(selectedDate) ? AppTheme.textDisabled : AppTheme.primary,
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

  void _showAddMealDialog(BuildContext context, NutritionProvider provider, MealType type) {
    // Placeholder per future implementazioni
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aggiungi ${type.displayName} - Coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}