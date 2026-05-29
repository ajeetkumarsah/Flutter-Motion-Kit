import 'dart:math' as math;

import 'package:flutter/material.dart';

class MotionOrbitLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionOrbitLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionOrbitLoader> createState() => _MotionOrbitLoaderState();
}

class _MotionOrbitLoaderState extends State<MotionOrbitLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _OrbitPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final double progress;
  final Color color;

  _OrbitPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final coreRadius = size.width / 8;
    final orbitRadius = size.width * 0.35;

    // 1. Draw central glowing core
    final corePaint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, coreRadius, corePaint);

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, coreRadius + 4, glowPaint);

    // 2. Draw outer orbital line paths
    final orbitLinePaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, orbitRadius, orbitLinePaint);

    // 3. Draw planets revolving along the orbit (with delays)
    final planetCount = 3;
    for (int i = 0; i < planetCount; i++) {
      final delay = i * (2 * math.pi / planetCount);
      final angle = (progress * 2 * math.pi) + delay;

      final planetX = center.dx + orbitRadius * math.cos(angle);
      final planetY = center.dy + orbitRadius * math.sin(angle);
      final planetCenter = Offset(planetX, planetY);
      final planetRadius = size.width / 18;

      final planetPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(planetCenter, planetRadius, planetPaint);

      // Tail trailing glow
      final tailPaint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(planetCenter, planetRadius + 2, tailPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
