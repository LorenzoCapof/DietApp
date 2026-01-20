// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'theme.dart';
import '../providers/nutrition_provider.dart';
import '../providers/onboarding_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class EatWiseApp extends StatelessWidget {
  const EatWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NutritionProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: MaterialApp.router(
        title: 'EatWise',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,  // Per MaterialLocalizations
          GlobalWidgetsLocalizations.delegate,   // Per widget base
          GlobalCupertinoLocalizations.delegate, // Se usi Cupertino
        ],
        supportedLocales: const [
          Locale('it', 'IT'),  // Italiano
          Locale('en', 'US'),  // Inglese (fallback)
        ],
        locale: const Locale('it', 'IT'),
      ),
    );
  }
}