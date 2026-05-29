import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/motion_controller.dart';

class MotionFuturisticLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionFuturisticLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionFuturisticLoader> createState() => _MotionFuturisticLoaderState();
}

class _MotionFuturisticLoaderState extends State<MotionFuturisticLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (1800 / speed).round()),
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
            painter: _FuturisticRadarPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _FuturisticRadarPainter extends CustomPainter {
  final double progress;
  final Color color;

  _FuturisticRadarPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Draw outer dashboard ticks
    final tickPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const tickCount = 24;
    final tickLength = radius * 0.08;
    for (int i = 0; i < tickCount; i++) {
      final angle = (i * 2 * math.pi / tickCount);
      final outerPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - tickLength) * math.cos(angle),
        center.dy + (radius - tickLength) * math.sin(angle),
      );
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }

    // 2. Draw rotating radar scanner sweep arc
    final sweepRect = Rect.fromCircle(center: center, radius: radius * 0.85);
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.1),
          color.withValues(alpha: 0.5),
          color,
        ],
        stops: const [0.0, 0.4, 0.8, 1.0],
        transform: GradientRotation(progress * 2 * math.pi),
      ).createShader(sweepRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(sweepRect, 0, 2 * math.pi, false, sweepPaint);

    // 3. Draw middle dashed tracking circle
    final dashPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dashRect = Rect.fromCircle(center: center, radius: radius * 0.55);
    for (double i = 0; i < 360; i += 15) {
      canvas.drawArc(
        dashRect,
        (i + progress * -40) * math.pi / 180,
        8 * math.pi / 180,
        false,
        dashPaint,
      );
    }

    // 4. Draw central pulsing glowing core
    final pulseScale = 0.85 + 0.15 * math.sin(progress * 4 * math.pi);
    final innerPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final innerCoreRadius = radius * 0.3 * pulseScale;
    canvas.drawCircle(center, innerCoreRadius, innerPaint);

    final innerCoreGlow = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerCoreRadius * 0.5, innerCoreGlow);
  }

  @override
  bool shouldRepaint(covariant _FuturisticRadarPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
