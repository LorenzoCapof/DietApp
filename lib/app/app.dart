// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'theme.dart';
import '../providers/nutrition_provider.dart';

class EatWiseApp extends StatelessWidget {
  const EatWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NutritionProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'EatWise',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
  }
}