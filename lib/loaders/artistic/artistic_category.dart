import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// Artistic Theme Category styles & enums.
enum MotionArtisticStyle {
  /// Calm Japanese calligraphy ink brush strokes dissolving and fading.
  zenCircle,

  /// Paper folding geometric panels transitioning with shadow facets.
  origami,

  /// Organic SVG path brush outlines drawing complex curves.
  calligraphyStroke,
}

/// Calm Japanese calligraphy ink brush strokes dissolving and fading.
class MotionZenCircleLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionZenCircleLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionZenCircleLoader> createState() => _MotionZenCircleLoaderState();
}

class _MotionZenCircleLoaderState extends State<MotionZenCircleLoader>
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
      duration: Duration(milliseconds: (2600 / speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ZenCirclePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _ZenCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ZenCirclePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw dissolving circular ink strokes resembling Enso Zen circles
    // Stroke width varies along path to resemble dynamic brush pressure
    final double sweep = 2 * math.pi * progress;
    final path = Path();

    for (double a = 0.0; a <= sweep; a += 0.05) {
      // Dynamic pressure radius calculation
      final double pressure = 1.0 - (a / (2 * math.pi)) * 0.75;
      strokePaint.strokeWidth = 1.5 + 5.5 * pressure;
      strokePaint.color = color.withValues(alpha: pressure);

      final double px = center.dx + radius * math.cos(a - math.pi / 2);
      final double py = center.dy + radius * math.sin(a - math.pi / 2);

      if (a == 0.0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
        canvas.drawPath(path, strokePaint);
        path.reset();
        path.moveTo(px, py);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ZenCirclePainter oldDelegate) => true;
}

/// Paper folding geometric panels transitioning with shadow facets.
class MotionOrigamiLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionOrigamiLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionOrigamiLoader> createState() => _MotionOrigamiLoaderState();
}

class _MotionOrigamiLoaderState extends State<MotionOrigamiLoader>
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
      duration: Duration(milliseconds: (3000 / speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _OrigamiPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _OrigamiPainter extends CustomPainter {
  final double progress;
  final Color color;

  _OrigamiPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final side = size.width * 0.35;

    final Paint fillPaint = Paint()..style = PaintingStyle.fill;
    final Paint linePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw an origami crane folding/unfolding pattern (4 quadrant triangles)
    // Dynamic angle representing fold flap rotation
    final double foldAngle = progress * math.pi;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    for (int i = 0; i < 4; i++) {
      canvas.save();
      canvas.rotate(i * math.pi / 2);

      final path = Path();
      // Flap 1
      path.moveTo(0, 0);
      path.lineTo(side, 0);

      // Calculate 3D folding perspective skew
      final double skewX = side * 0.5 * math.cos(foldAngle);
      final double skewY = side * 0.5 * math.sin(foldAngle);

      path.lineTo(skewX, skewY);
      path.close();

      // Shadow facets: alternate colors to simulate folding depth shadows
      final activeColor = Color.lerp(color, Colors.deepOrangeAccent, i / 4)!;
      fillPaint.color = Color.lerp(activeColor, Colors.black, 0.12 * (i % 2))!;

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, linePaint);

      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OrigamiPainter oldDelegate) => true;
}

/// Organic brush outlines drawing complex curves.
class MotionCalligraphyStrokeLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionCalligraphyStrokeLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionCalligraphyStrokeLoader> createState() =>
      _MotionCalligraphyStrokeLoaderState();
}

class _MotionCalligraphyStrokeLoaderState
    extends State<MotionCalligraphyStrokeLoader>
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
      duration: Duration(milliseconds: (2400 / speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _CalligraphyPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _CalligraphyPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CalligraphyPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    final Paint strokePaint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Draw organic infinity symbol calligraphy outline
    final double limit = 2 * math.pi * progress;
    for (double t = 0.0; t <= limit; t += 0.05) {
      // Lemniscate of Bernoulli equations:
      // x = a * cos(t) / (1 + sin^2(t))
      // y = a * sin(t) * cos(t) / (1 + sin^2(t))
      final double scale = radius * 1.3;
      final double denom = 1 + (math.sin(t) * math.sin(t));
      final double x = center.dx + scale * math.cos(t) / denom;
      final double y = center.dy + scale * math.sin(t) * math.cos(t) / denom;

      // Variable pressure stroke width
      strokePaint.strokeWidth = 1.0 + 4.0 * math.sin(t).abs();

      if (t == 0.0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        canvas.drawPath(path, strokePaint);
        path.reset();
        path.moveTo(x, y);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CalligraphyPainter oldDelegate) => true;
}
