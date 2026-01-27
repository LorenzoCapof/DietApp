// lib/app/router.dart

import 'package:dietapp/core/models/meal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import '../features/home/screens/home_screen.dart';
import '../features/pantry/screens/pantry_screen.dart';
import '../features/recipes/screens/recipes_screen.dart';
import '../features/insights/screens/insights_screen.dart';
import '../features/profile/screens/profile_screen.dart';

// Onboarding screens
import '../features/onboarding/screens/onboarding_intro_screen.dart';
import '../features/onboarding/screens/name_screen.dart';
import '../features/onboarding/screens/gender_screen.dart';
import '../features/onboarding/screens/birthdate_screen.dart';
import '../features/onboarding/screens/body_screen.dart';
import '../features/onboarding/screens/activity_level_screen.dart';
import '../features/onboarding/screens/goal_screen.dart';
import '../features/onboarding/screens/target_weight_screen.dart';
import '../features/onboarding/screens/summary_screen.dart';

// Ricette / Dispensa
import '../features/pantry/screens/products_list_screen.dart';
import '../shared/widgets/barcode/barcode_scanner_screen.dart';
import '../features/recipes/screens/recipes_list_screen.dart';
import '../features/pantry/screens/product_detail_screen.dart';

// Meals
import '../features/meals/screens/add_meal_products_screen.dart';

import '../core/services/storage_service.dart';

/// Router principale dell'app con controllo onboarding
final GoRouter router = GoRouter(
  initialLocation: '/home',
  
  // Redirect per controllare se l'utente deve fare onboarding
  redirect: (context, state) async {
    final storage = StorageService();
    final hasUser = await storage.hasUser();
    
    // Se non ha un utente salvato e non è già nell'onboarding
    if (!hasUser && !state.matchedLocation.startsWith('/onboarding')) {
      return '/onboarding';
    }
    
    // Se ha un utente salvato e sta cercando di accedere all'onboarding
    if (hasUser && state.matchedLocation.startsWith('/onboarding')) {
      return '/home';
    }
    
    return null; // Nessun redirect necessario
  },
  
  routes: [
    // ============ ONBOARDING ROUTES (Fullscreen) ============
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingIntroScreen(),
    ),
    GoRoute(
      path: '/onboarding/name',
      builder: (context, state) => const NameScreen(),
    ),
    GoRoute(
      path: '/onboarding/gender',
      builder: (context, state) => const GenderScreen(),
    ),
    GoRoute(
      path: '/onboarding/birthdate',
      builder: (context, state) => const BirthDateScreen(),
    ),
    GoRoute(
      path: '/onboarding/body',
      builder: (context, state) => const BodyScreen(),
    ),
    GoRoute(
      path: '/onboarding/activity',
      builder: (context, state) => const ActivityLevelScreen(),
    ),
    GoRoute(
      path: '/onboarding/goal',
      builder: (context, state) => const GoalScreen(),
    ),
    GoRoute(
      path: '/onboarding/target-weight',
      builder: (context, state) => const TargetWeightScreen(),
    ),
    GoRoute(
      path: '/onboarding/summary',
      builder: (context, state) => const SummaryScreen(),
    ),
    
    // ============ MAIN APP ROUTES (Con Shell) ============
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/pantry',
          builder: (context, state) => const PantryScreen(),
        ),
        GoRoute(
          path: '/recipes',
          builder: (context, state) => const RecipesScreen(),
        ),
        GoRoute(
          path: '/insights',
          builder: (context, state) => const InsightsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    
    // Route per Dispensa / Ricette
    GoRoute(
      path: '/products-list/:category',
      builder: (context, state) {
        final category = Uri.decodeComponent(state.pathParameters['category']!);
        return ProductsListScreen(category: category);
      },
    ),
    GoRoute(
      path: '/barcode-scanner',
      builder: (context, state) => const BarcodeScannerScreen(),
    ),
    GoRoute(
      path: '/product-detail/:barcode',
      builder: (context, state) {
        final barcode = state.pathParameters['barcode']!;
        return ProductDetailScreen(barcode: barcode);
      },
    ),
    GoRoute(
      path: '/recipes-list/:category',
      builder: (context, state) {
        final category = Uri.decodeComponent(state.pathParameters['category']!);
        return RecipesListScreen(category: category);
      },
    ),

    // Route per aggiungere prodotti a un pasto
    GoRoute(
      path: '/add-meal-products/:mealType/:date',
      builder: (context, state) {
        final mealTypeStr = state.pathParameters['mealType']!;
        final dateStr = state.pathParameters['date']!;
        
        // Parse MealType
        final mealType = MealType.values.firstWhere(
          (e) => e.name == mealTypeStr,
          orElse: () => MealType.lunch,
        );
        
        // Parse Date
        final date = DateTime.tryParse(dateStr) ?? DateTime.now();
        
        return AddMealProductsScreen(
          mealType: mealType,
          date: date,
        );
      },
    ),

    // Route aggiuntive fuori dalla shell (fullscreen)
    // Esempio per future schermate di dettaglio
    // GoRoute(
    //   path: '/recipe/:id',
    //   builder: (context, state) {
    //     final recipeId = state.pathParameters['id']!;
    //     return RecipeDetailScreen(recipeId: recipeId);
    //   },
    // ),
  ],
);