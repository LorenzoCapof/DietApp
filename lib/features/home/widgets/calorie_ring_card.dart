import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/theme.dart';

class CalorieRingCard extends StatelessWidget {
  final double consumed;
  final double goal;
  final double burned;
  
  // NUOVO: Dati macronutrienti per colorare il ring
  final double consumedProtein;
  final double consumedCarbs;
  final double consumedFats;

  const CalorieRingCard({
    super.key,
    required this.consumed,
    required this.goal,
    this.burned = 0,
    this.consumedProtein = 0,
    this.consumedCarbs = 0,
    this.consumedFats = 0,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (goal - consumed).clamp(0, goal);
    final progress = (consumed / goal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Ring Progress - ora colorato per macronutrienti
          SizedBox(
            height: AppTheme.ringDiameter,
            width: AppTheme.ringDiameter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Circle
                CustomPaint(
                  size: const Size(AppTheme.ringDiameter, AppTheme.ringDiameter),
                  painter: CircleProgressPainter(
                    progress: 1.0,
                    color: AppTheme.accent3.withValues(alpha: 0.12),
                    strokeWidth: AppTheme.ringStrokeWidth,
                  ),
                ),
                // NUOVO: Progress Circle multi-colore basato su macro
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return CustomPaint(
                      size: const Size(AppTheme.ringDiameter, AppTheme.ringDiameter),
                      painter: MacroCircleProgressPainter(
                        progress: value,
                        strokeWidth: AppTheme.ringStrokeWidth,
                        goal: goal, // CORRETTO: Passa goal come parametro
                        // Calorie da ciascun macro (protein=4kcal/g, carbs=4kcal/g, fats=9kcal/g)
                        proteinCalories: consumedProtein * 4,
                        carbsCalories: consumedCarbs * 4,
                        fatsCalories: consumedFats * 9,
                      ),
                    );
                  },
                ),
                // Center Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Calorie rimanenti',
                      style: AppTheme.ringLabelStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      remaining.toInt().toString(),
                      style: AppTheme.ringNumberStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Obiettivo ${goal.toInt()} kcal',
                      style: AppTheme.ringLabelStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                label: 'Assunte (kcal)',
                value: consumed.toInt(),
              ),
              Container(
                height: 32,
                width: 1,
                color: AppTheme.primary.withValues(alpha: 0.15),
              ),
              _StatItem(
                label: 'Bruciate (kcal)',
                value: burned.toInt(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.ringStatsLabelStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: AppTheme.ringStatsValueStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// Painter per il background
class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MacroCircleProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final double goal;
  final double proteinCalories;
  final double carbsCalories;
  final double fatsCalories;

  MacroCircleProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.goal,
    required this.proteinCalories,
    required this.carbsCalories,
    required this.fatsCalories,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
        
    // Se non ci sono calorie, non disegnare nulla
    if (goal == 0) return;
    
    // Calcola la percentuale di ciascun macro sul totale consumato
    final proteinPercent = proteinCalories / goal;
    final carbsPercent = carbsCalories / goal;
    final fatsPercent = fatsCalories / goal;

    // Angolo totale da disegnare (basato sul progress complessivo)
    final totalSweepAngle = 2 * math.pi * progress;
    
    double currentAngle = -math.pi / 2; // Inizia dall'alto (ore 12)

    // Disegna arco CARBOIDRATI (beige)
    if (carbsPercent > 0) {
      final carbsSweep = totalSweepAngle * carbsPercent;
      final carbsPaint = Paint()
        ..color = AppTheme.carbs
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        carbsSweep,
        false,
        carbsPaint,
      );
      
      currentAngle += carbsSweep;
    }
    
    // Disegna arco PROTEINE (arancione)
    if (proteinPercent > 0) {
      final proteinSweep = totalSweepAngle * proteinPercent;
      final proteinPaint = Paint()
        ..color = AppTheme.protein
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        proteinSweep,
        false,
        proteinPaint,
      );
      
      currentAngle += proteinSweep;
    }
    
    // Disegna arco GRASSI (verde)
    if (fatsPercent > 0) {
      final fatsSweep = totalSweepAngle * fatsPercent;
      final fatsPaint = Paint()
        ..color = AppTheme.fats
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        fatsSweep,
        false,
        fatsPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MacroCircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.goal != goal ||
        oldDelegate.carbsCalories != carbsCalories ||
        oldDelegate.proteinCalories != proteinCalories ||
        oldDelegate.fatsCalories != fatsCalories;
  }
}