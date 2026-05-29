import 'dart:math' as math;

import 'package:flutter/material.dart';

class MotionDnaLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionDnaLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionDnaLoader> createState() => _MotionDnaLoaderState();
}

class _MotionDnaLoaderState extends State<MotionDnaLoader>
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
      width: widget.size * 1.5,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _DnaPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _DnaPainter extends CustomPainter {
  final double progress;
  final Color color;

  _DnaPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    const dotCount = 8;
    final maxAmplitude = size.height * 0.35;
    final paddingX = size.width * 0.1;
    final activeWidth = size.width - (paddingX * 2);

    for (int i = 0; i < dotCount; i++) {
      // Calculate horizontal position
      final ratio = i / (dotCount - 1);
      final x = paddingX + ratio * activeWidth;

      // Base angle based on position + animation progress
      final angle = (ratio * 2 * math.pi) + (progress * 2 * math.pi);

      // Amplitude for strand A and B (out of phase by 180 degrees or PI)
      final yA = centerY + maxAmplitude * math.sin(angle);
      final yB = centerY + maxAmplitude * math.sin(angle + math.pi);

      // Depth perception (scale dot sizes based on Z-depth / cosine)
      final scaleA = 0.6 + 0.4 * math.cos(angle);
      final scaleB = 0.6 + 0.4 * math.cos(angle + math.pi);

      // Draw connecting rung lines (only if they are somewhat visible/not overlapping too much)
      final connectorPaint = Paint()
        ..color = color.withValues(alpha: 0.2)
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(x, yA), Offset(x, yB), connectorPaint);

      // Draw Helix strand A node
      final paintA = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, yA), 4.5 * scaleA, paintA);

      // Draw Helix strand B node
      final paintB = Paint()
        ..color = Color.lerp(color, Colors.deepPurple, 0.4) ?? color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, yB), 4.5 * scaleB, paintB);
    }
  }

  @override
  bool shouldRepaint(covariant _DnaPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
