import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/theme.dart';

class CalorieRingCard extends StatelessWidget {
  final double consumed;
  final double goal;
  final double burned;

  const CalorieRingCard({
    super.key,
    required this.consumed,
    required this.goal,
    this.burned = 0,
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
          // Ring Progress - dimensioni ridotte
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
                    color: AppTheme.accent3.withOpacity(0.12),
                    strokeWidth: AppTheme.ringStrokeWidth,
                  ),
                ),
                // Progress Circle - animato
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return CustomPaint(
                      size: const Size(AppTheme.ringDiameter, AppTheme.ringDiameter),
                      painter: CircleProgressPainter(
                        progress: value,
                        color: AppTheme.accent3,
                        strokeWidth: AppTheme.ringStrokeWidth,
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
          
          // Stats Row - più compatta
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
                color: AppTheme.primary.withOpacity(0.15),
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
          style: AppTheme.ringStatsLabelStyle,
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: AppTheme.ringStatsValueStyle,
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