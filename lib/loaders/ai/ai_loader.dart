import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A high-performance glowing AI neural network intelligence loading node.
///
/// Features a centralized pulsating core nucleus and concentric rotating orbital arcs
/// designed with glowing canvas sweeps.
class MotionAiLoader extends StatefulWidget {
  /// The color accent of the central core and rotating outer neural arcs.
  final Color color;

  /// The dimensional bounding size (width and height constraints) of the loader canvas.
  final double size;

  /// Creates a [MotionAiLoader] instance.
  const MotionAiLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionAiLoader> createState() => _MotionAiLoaderState();
}

class _MotionAiLoaderState extends State<MotionAiLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
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
            painter: _AiPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _AiPainter extends CustomPainter {
  final double progress;
  final Color color;

  _AiPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius - 4);

    // 1. Draw outer ring rotating clockwise
    final outerPaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final outerAngleStart = progress * 2 * math.pi;
    canvas.drawArc(rect, outerAngleStart, math.pi * 0.6, false, outerPaint);
    canvas.drawArc(
        rect, outerAngleStart + math.pi, math.pi * 0.6, false, outerPaint);

    // 2. Draw middle ring rotating counter-clockwise
    final midPaint = Paint()
      ..color = Color.lerp(color, Colors.cyan, 0.5)!.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final midRect = Rect.fromCircle(center: center, radius: radius * 0.7);
    final midAngleStart = -progress * 3 * math.pi;
    canvas.drawArc(midRect, midAngleStart, math.pi * 0.8, false, midPaint);
    canvas.drawArc(
        midRect, midAngleStart + math.pi, math.pi * 0.4, false, midPaint);

    // 3. Draw inner pulsing neon core
    final pulseScale = 0.85 + 0.15 * math.sin(progress * 4 * math.pi);
    final innerPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final innerCoreRadius = radius * 0.4 * pulseScale;
    canvas.drawCircle(center, innerCoreRadius, innerPaint);

    final innerCoreGlow = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerCoreRadius * 0.6, innerCoreGlow);
  }

  @override
  bool shouldRepaint(covariant _AiPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
