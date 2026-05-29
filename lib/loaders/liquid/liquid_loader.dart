import 'dart:math' as math;

import 'package:flutter/material.dart';

class MotionLiquidLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionLiquidLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionLiquidLoader> createState() => _MotionLiquidLoaderState();
}

class _MotionLiquidLoaderState extends State<MotionLiquidLoader>
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
          return ClipPath(
            clipper: _CircularClipper(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.color.withValues(alpha: 0.3),
                  width: 3.0,
                ),
              ),
              child: CustomPaint(
                painter: _LiquidPainter(
                  progress: _controller.value,
                  color: widget.color,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addOval(Offset.zero & size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _LiquidPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LiquidPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw base background container tint
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawPaint(bgPaint);

    final path1 = Path();
    final path2 = Path();

    // Constant 50% water fill level height
    final waterHeight = size.height * 0.52;

    path1.moveTo(0, size.height);
    path2.moveTo(0, size.height);

    // Compute waves using dual offset sine equations
    for (double x = 0; x <= size.width; x++) {
      final angle1 = (x / size.width * 2 * math.pi) + (progress * 2 * math.pi);
      final y1 = waterHeight + 6 * math.sin(angle1);
      path1.lineTo(x, y1);

      final angle2 = (x / size.width * 2 * math.pi) -
          (progress * 2 * math.pi) +
          (math.pi / 2);
      final y2 = waterHeight + 5 * math.sin(angle2);
      path2.lineTo(x, y2);
    }

    path1.lineTo(size.width, size.height);
    path1.close();

    path2.lineTo(size.width, size.height);
    path2.close();

    // Render both waves overlapping for a beautiful fluid depth
    final wavePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path2, wavePaint);
    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
