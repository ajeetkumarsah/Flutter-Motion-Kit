import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_colors.dart';

/// Minimalist Category styles & enums.
enum MotionMinimalStyle {
  /// Self-drawing infinity loop path using Lemniscate vectors.
  lineDraw,

  /// Seamless morphing shape interpolation (Circle ➔ Square ➔ Triangle ➔ Circle).
  morphShape,

  /// 3D waving curved silk ribbon waving dynamically along a sine path.
  infiniteRibbon,
}

/// Self-drawing infinity loop path using Lemniscate of Bernoulli vectors.
class MotionLineDrawLoader extends StatefulWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const MotionLineDrawLoader({
    super.key,
    required this.color,
    required this.size,
    this.strokeWidth = 3.0,
  });

  @override
  State<MotionLineDrawLoader> createState() => _MotionLineDrawLoaderState();
}

class _MotionLineDrawLoaderState extends State<MotionLineDrawLoader>
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
      duration: Duration(milliseconds: (2000 / speed).round()),
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
            painter: _LineDrawPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _LineDrawPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _LineDrawPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double a = size.width * 0.42; // Infinity scale factor

    // Mathematically plot Lemniscate of Bernoulli curve: (x^2+y^2)^2 = 2a^2(x^2-y^2)
    final path = Path();
    final totalPoints = 120;

    // Draw sweeping self-drawing path segments
    // Progress controls the strokeStart and strokeEnd percentage limits
    final int visiblePoints = (totalPoints * 0.65).round(); // visible arc chunk
    final int startIdx = (progress * totalPoints).round();

    bool isFirst = true;
    for (int i = 0; i <= visiblePoints; i++) {
      final idx = (startIdx + i) % totalPoints;
      final t = (idx / totalPoints) * 2 * math.pi;

      // Lemniscate parametric coordinates
      final denom = 1 + math.pow(math.sin(t), 2);
      final double x = (a * math.cos(t)) / denom;
      final double y = (a * math.sin(t) * math.cos(t)) / denom;

      final point = Offset(center.dx + x, center.dy + y);
      if (isFirst) {
        path.moveTo(point.dx, point.dy);
        isFirst = false;
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    final pathPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Apply linear gradient fading edge highlights along the drawn curve
    pathPaint.shader = SweepGradient(
      colors: [
        color.withValues(alpha: 0.15),
        color,
        color,
        color.withValues(alpha: 0.15),
      ],
      stops: const [0.0, 0.45, 0.55, 1.0],
      transform: GradientRotation(progress * 2 * math.pi),
    ).createShader(Rect.fromCircle(center: center, radius: a));

    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant _LineDrawPainter oldDelegate) => true;
}

/// Seamless morphing shape interpolation (Circle ➔ Square ➔ Triangle ➔ Circle).
class MotionMorphShapeLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionMorphShapeLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionMorphShapeLoader> createState() => _MotionMorphShapeLoaderState();
}

class _MotionMorphShapeLoaderState extends State<MotionMorphShapeLoader>
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
            painter: _MorphShapePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _MorphShapePainter extends CustomPainter {
  final double progress;
  final Color color;

  _MorphShapePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double maxR = size.width * 0.32;

    // Define 36 vertices to perform continuous vector morph interpolation
    final int verticesCount = 36;
    final List<Offset> pointsCircle = [];
    final List<Offset> pointsSquare = [];
    final List<Offset> pointsTriangle = [];

    // 1. Precompute static shape vertex coordinates
    for (int i = 0; i < verticesCount; i++) {
      final double theta = (i * 2 * math.pi) / verticesCount;

      // Circle coordinates
      pointsCircle.add(Offset(math.cos(theta), math.sin(theta)));

      // Square coordinates (Projecting circle onto square borders)
      final double sqCos = math.cos(theta);
      final double sqSin = math.sin(theta);
      final double sqFactor = 1.0 / math.max(sqCos.abs(), sqSin.abs());
      pointsSquare.add(Offset(sqCos * sqFactor, sqSin * sqFactor));

      // Triangle coordinates (Equilateral pointing upwards)
      // Represented by three linear facet intersections
      double triR = 1.0;
      final double modTheta =
          (theta + math.pi / 6) % (2 * math.pi / 3) - (math.pi / 3);
      triR = 0.5 / math.cos(modTheta);
      // Tilt triangle pointing up
      final rotatedTheta = theta - math.pi / 2;
      pointsTriangle.add(
          Offset(triR * math.cos(rotatedTheta), triR * math.sin(rotatedTheta)));
    }

    // 2. Interpolate based on time sections:
    // Progress: [0.0 - 0.33] Circle ➔ Square
    // Progress: [0.33 - 0.66] Square ➔ Triangle
    // Progress: [0.66 - 1.0] Triangle ➔ Circle
    final List<Offset> activeCoordinates = [];
    double phaseProg = 0.0;
    int phase = 0;

    if (progress < 0.33) {
      phase = 0;
      phaseProg = progress / 0.33;
    } else if (progress < 0.66) {
      phase = 1;
      phaseProg = (progress - 0.33) / 0.33;
    } else {
      phase = 2;
      phaseProg = (progress - 0.66) / 0.34;
    }

    // Smooth step easing curves to make transitions extremely elegant
    final double easedT = Curves.easeInOutCubic.transform(phaseProg);

    for (int i = 0; i < verticesCount; i++) {
      Offset pStart;
      Offset pEnd;

      if (phase == 0) {
        pStart = pointsCircle[i];
        pEnd = pointsSquare[i];
      } else if (phase == 1) {
        pStart = pointsSquare[i];
        pEnd = pointsTriangle[i];
      } else {
        pStart = pointsTriangle[i];
        pEnd = pointsCircle[i];
      }

      final double lerpX =
          center.dx + maxR * Offset.lerp(pStart, pEnd, easedT)!.dx;
      final double lerpY =
          center.dy + maxR * Offset.lerp(pStart, pEnd, easedT)!.dy;
      activeCoordinates.add(Offset(lerpX, lerpY));
    }

    // 3. Draw morph path
    final path = Path()
      ..moveTo(activeCoordinates[0].dx, activeCoordinates[0].dy);
    for (int i = 1; i < verticesCount; i++) {
      path.lineTo(activeCoordinates[i].dx, activeCoordinates[i].dy);
    }
    path.close();

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..shader = LinearGradient(
        colors: [color, MotionColors.secondaryNeon],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: maxR))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _MorphShapePainter oldDelegate) => true;
}

/// Waving curved silk ribbon along a 3D horizontal path.
class MotionInfiniteRibbonLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionInfiniteRibbonLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionInfiniteRibbonLoader> createState() =>
      _MotionInfiniteRibbonLoaderState();
}

class _MotionInfiniteRibbonLoaderState extends State<MotionInfiniteRibbonLoader>
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
            painter: _InfiniteRibbonPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _InfiniteRibbonPainter extends CustomPainter {
  final double progress;
  final Color color;

  _InfiniteRibbonPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double steps = 40.0;
    final double stepWidth = size.width / steps;

    final pathTop = Path();
    final pathBottom = Path();
    final waveAmplitude = size.height * 0.16;

    // Draw three interlocking spatial sine waves creating depth ribbon
    for (int r = 0; r < 2; r++) {
      pathTop.reset();
      pathBottom.reset();

      final ribbonColor = r == 0 ? color : MotionColors.secondaryNeon;
      final phaseOffset = progress * 2 * math.pi + (r * math.pi);

      final activePaint = Paint()..style = PaintingStyle.fill;

      // Render vertical polygon strips along sine coordinates
      for (int i = 0; i <= steps; i++) {
        final x = i * stepWidth;
        // Waving sine calculations
        final theta = (i * 2.2 * math.pi / steps) + phaseOffset;
        final baseHeight = center.dy + math.sin(theta) * waveAmplitude;

        // Ribbon thickness oscillates based on cosine perspective values (looks like 3D twist)
        final double thickness = size.height * 0.08 * (1.2 + math.cos(theta));

        final yTop = baseHeight - thickness / 2;
        final yBottom = baseHeight + thickness / 2;

        if (i == 0) {
          pathTop.moveTo(x, yTop);
          pathBottom.moveTo(x, yBottom);
        } else {
          pathTop.lineTo(x, yTop);
          pathBottom.lineTo(x, yBottom);
        }
      }

      // Close polygon to construct ribbon body
      final compositePath = Path();
      compositePath.addPath(pathTop, Offset.zero);

      // Trace bottom back in reverse direction to close perfectly
      final reverseBottom = Path();
      for (int i = steps.round(); i >= 0; i--) {
        final x = i * stepWidth;
        final theta = (i * 2.2 * math.pi / steps) + phaseOffset;
        final baseHeight = center.dy + math.sin(theta) * waveAmplitude;
        final double thickness = size.height * 0.08 * (1.2 + math.cos(theta));
        final yBottom = baseHeight + thickness / 2;

        if (i == steps.round()) {
          reverseBottom.moveTo(x, yBottom);
        } else {
          reverseBottom.lineTo(x, yBottom);
        }
      }
      compositePath.lineTo(size.width, center.dy);
      compositePath.addPath(reverseBottom, Offset.zero);
      compositePath.close();

      // Ribbon shading using metallic-like linear gradients
      activePaint.shader = LinearGradient(
        colors: [
          ribbonColor.withValues(alpha: 0.85),
          Colors.white.withValues(alpha: 0.95),
          Color.lerp(ribbonColor, Colors.black, 0.45)!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(
          0, center.dy - waveAmplitude * 1.5, size.width, waveAmplitude * 3));

      canvas.drawPath(compositePath, activePaint);

      // Ribbon edge lining strokes
      final strokePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawPath(compositePath, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _InfiniteRibbonPainter oldDelegate) => true;
}
