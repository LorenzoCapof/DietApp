import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/theme.dart';

class NutritionScoreCircle extends StatelessWidget {
  final int score; // 0-100

  const NutritionScoreCircle({
    super.key,
    required this.score,
  });

  Color _getScoreColor() {
    if (score >= 80) return const Color(0xFF4CAF50); // Green
    if (score >= 60) return const Color(0xFF8BC34A); // Light green
    if (score >= 40) return const Color(0xFFFFC107); // Yellow/Orange
    if (score >= 20) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor();
    final percentage = score / 100;

    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: const Size(160, 160),
            painter: _CirclePainter(
              color: AppTheme.background,
              percentage: 1.0,
              strokeWidth: 16,
            ),
          ),
          // Progress arc
          CustomPaint(
            size: const Size(160, 160),
            painter: _CirclePainter(
              color: color,
              percentage: percentage,
              strokeWidth: 16,
            ),
          ),
          // Score text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score.toString(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
              ),
              Text(
                '/ 100',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color color;
  final double percentage;
  final double strokeWidth;

  _CirclePainter({
    required this.color,
    required this.percentage,
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

    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}