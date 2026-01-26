import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/theme.dart';

class CalorieRingCard extends StatefulWidget {
  final double consumed;
  final double goal;
  final double burned;
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
  State<CalorieRingCard> createState() => _CalorieRingCardState();
}

class _CalorieRingCardState extends State<CalorieRingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _consumedAnimation;
  late Animation<double> _proteinAnimation;
  late Animation<double> _carbsAnimation;
  late Animation<double> _fatsAnimation;

  double _previousConsumed = 0;
  double _previousProtein = 0;
  double _previousCarbs = 0;
  double _previousFats = 0;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _initializeAnimations();
    _controller.forward();
  }

  @override
  void didUpdateWidget(CalorieRingCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Se i valori cambiano, riavvia l'animazione
    if (oldWidget.consumed != widget.consumed ||
        oldWidget.consumedProtein != widget.consumedProtein ||
        oldWidget.consumedCarbs != widget.consumedCarbs ||
        oldWidget.consumedFats != widget.consumedFats) {
      
      _previousConsumed = oldWidget.consumed;
      _previousProtein = oldWidget.consumedProtein;
      _previousCarbs = oldWidget.consumedCarbs;
      _previousFats = oldWidget.consumedFats;

      _initializeAnimations();
      _controller.forward(from: 0);
    }
  }

  void _initializeAnimations() {
    _consumedAnimation = Tween<double>(
      begin: _previousConsumed,
      end: widget.consumed,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _proteinAnimation = Tween<double>(
      begin: _previousProtein,
      end: widget.consumedProtein,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _carbsAnimation = Tween<double>(
      begin: _previousCarbs,
      end: widget.consumedCarbs,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fatsAnimation = Tween<double>(
      begin: _previousFats,
      end: widget.consumedFats,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Ring Progress animato
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
                
                // Progress Circle multi-colore (ANIMATO)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final consumed = _consumedAnimation.value;
                    final progress = (consumed / widget.goal).clamp(0.0, 1.0);
                    
                    return CustomPaint(
                      size: const Size(AppTheme.ringDiameter, AppTheme.ringDiameter),
                      painter: MacroCircleProgressPainter(
                        progress: progress,
                        strokeWidth: AppTheme.ringStrokeWidth,
                        consumed: consumed,
                        proteinCalories: _proteinAnimation.value * 4,
                        carbsCalories: _carbsAnimation.value * 4,
                        fatsCalories: _fatsAnimation.value * 9,
                      ),
                    );
                  },
                ),
                
                // Center Content (STATICO - usa widget.consumed)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Calorie rimanenti',
                      style: AppTheme.ringLabelStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ((widget.goal - widget.consumed).clamp(0, widget.goal)).toInt().toString(),
                      style: AppTheme.ringNumberStyle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Obiettivo ${widget.goal.toInt()} kcal',
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
                value: widget.consumed.toInt(),
              ),
              Container(
                height: 32,
                width: 1,
                color: AppTheme.primary.withValues(alpha: 0.15),
              ),
              _StatItem(
                label: 'Bruciate (kcal)',
                value: widget.burned.toInt(),
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
  final double consumed;
  final double proteinCalories;
  final double carbsCalories;
  final double fatsCalories;

  MacroCircleProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.consumed,
    required this.proteinCalories,
    required this.carbsCalories,
    required this.fatsCalories,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
        
    if (consumed == 0) return;
    
    final proteinPercent = proteinCalories / consumed;
    final carbsPercent = carbsCalories / consumed;
    final fatsPercent = fatsCalories / consumed;

    final totalSweepAngle = 2 * math.pi * progress;
    
    double currentAngle = -math.pi / 2;

    // Arco CARBOIDRATI
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
    
    // Arco PROTEINE
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
    
    // Arco GRASSI
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
        oldDelegate.consumed != consumed ||
        oldDelegate.carbsCalories != carbsCalories ||
        oldDelegate.proteinCalories != proteinCalories ||
        oldDelegate.fatsCalories != fatsCalories;
  }
}