import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/motion_controller.dart';

class MotionGradientRotatingLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionGradientRotatingLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionGradientRotatingLoader> createState() =>
      _MotionGradientRotatingLoaderState();
}

class _MotionGradientRotatingLoaderState
    extends State<MotionGradientRotatingLoader>
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
      duration: Duration(milliseconds: (1000 / speed).round()),
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
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: CustomPaint(
              painter: _GradientRingPainter(
                color: widget.color,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final Color color;

  _GradientRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4; // Margin for stroke width

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.2),
          color.withValues(alpha: 0.6),
          color,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(rect);

    canvas.drawCircle(center, radius, paint);

    // Glowing dot leading the gradient sweep
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw dot at 0 degrees / sweep completion position (which is right center Offset(radius, 0))
    canvas.drawCircle(Offset(center.dx + radius, center.dy), 3.0, dotPaint);

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(center.dx + radius, center.dy), 5.0, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
