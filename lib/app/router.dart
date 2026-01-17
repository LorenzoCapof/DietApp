// lib/app/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import '../features/home/screens/home_screen.dart';
import '../features/pantry/screens/pantry_screen.dart';
import '../features/recipes/screens/recipes_screen.dart';
import '../features/insights/screens/insights_screen.dart';
import '../features/profile/screens/profile_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
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