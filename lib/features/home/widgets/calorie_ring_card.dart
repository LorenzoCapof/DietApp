import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final remaining = goal - consumed;
    final progress = (consumed / goal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Ring Progress
          SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Circle
                CustomPaint(
                  size: const Size(200, 200),
                  painter: CircleProgressPainter(
                    progress: 1.0,
                    color: AppTheme.primary.withOpacity(0.1),
                    strokeWidth: 16,
                  ),
                ),
                // Progress Circle
                CustomPaint(
                  size: const Size(200, 200),
                  painter: CircleProgressPainter(
                    progress: progress,
                    color: AppTheme.primary,
                    strokeWidth: 16,
                  ),
                ),
                // Center Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Rimanenti',
                      style: GoogleFonts.crimsonPro(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      remaining.toInt().toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Obiettivo ${goal.toInt()} kcal',
                      style: GoogleFonts.crimsonPro(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Assunte',
                value: consumed.toInt(),
              ),
              Container(
                height: 40,
                width: 1,
                color: AppTheme.primary.withOpacity(0.2),
              ),
              _StatItem(
                label: 'Bruciate',
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
          style: GoogleFonts.crimsonPro(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
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