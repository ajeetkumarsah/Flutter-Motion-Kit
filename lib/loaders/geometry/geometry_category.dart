import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_colors.dart';

/// Geometry Category styles & enums.
enum MotionGeometryStyle {
  /// 3D projection impossible cube rotating with infinity dimensions.
  infiniteCube,

  /// Magnetic honeycomb blocks assembling and expanding radially in waves.
  hexagonSwarm,

  /// Recursive scaling tree branches growing fractals with kaleidoscope loops.
  fractal,

  /// Polygon vertices smoothly morphing (Triangle ➔ Square ➔ Pentagon ➔ Hexagon ➔ Octagon).
  polygonMorph,
}

/// 3D projection impossible cube rotating with infinity dimensions.
class MotionInfiniteCubeLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionInfiniteCubeLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionInfiniteCubeLoader> createState() =>
      _MotionInfiniteCubeLoaderState();
}

class _MotionInfiniteCubeLoaderState extends State<MotionInfiniteCubeLoader>
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
            painter: _InfiniteCubePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _InfiniteCubePainter extends CustomPainter {
  final double progress;
  final Color color;

  _InfiniteCubePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width * 0.28;

    // Angle of rotation around Y and X axes
    final angleY = progress * 2 * math.pi;
    final angleX = math.pi / 5 + 0.1 * math.sin(progress * 2 * math.pi);

    // Cube vertices in 3D space
    final List<List<double>> vertices = [
      [-1, -1, -1],
      [1, -1, -1],
      [1, 1, -1],
      [-1, 1, -1],
      [-1, -1, 1],
      [1, -1, 1],
      [1, 1, 1],
      [-1, 1, 1],
    ];

    // Project and rotate vertices
    final List<Offset> points = [];
    for (var v in vertices) {
      double x = v[0];
      double y = v[1];
      double z = v[2];

      // Rotate Y
      double x1 = x * math.cos(angleY) - z * math.sin(angleY);
      double z1 = x * math.sin(angleY) + z * math.cos(angleY);

      // Rotate X
      double y2 = y * math.cos(angleX) - z1 * math.sin(angleX);
      double z2 = y * math.sin(angleX) + z1 * math.cos(angleX);

      // Perspective projection mapping
      final double depth = 3.0;
      final double zoom = depth / (depth - z2 / 2);
      final px = center.dx + x1 * scale * zoom;
      final py = center.dy + y2 * scale * zoom;
      points.add(Offset(px, py));
    }

    final edgePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Define 6 faces by their vertex indices
    final List<List<int>> faces = [
      [0, 1, 2, 3], // Back
      [4, 5, 6, 7], // Front
      [0, 1, 5, 4], // Top
      [2, 3, 7, 6], // Bottom
      [0, 3, 7, 4], // Left
      [1, 2, 6, 5], // Right
    ];

    // Calculate face Z-depth to paint back-to-front (painters algorithm)
    final List<MapEntry<int, double>> faceDepths = [];
    for (int i = 0; i < faces.length; i++) {
      final f = faces[i];
      // Sum the Z coordinates of rotated vertices
      double sumZ = 0;
      for (var idx in f) {
        final z = vertices[idx][2];
        final angleY = progress * 2 * math.pi;
        final x = vertices[idx][0];
        final z1 = x * math.sin(angleY) + z * math.cos(angleY);
        final angleX = math.pi / 5;
        final y = vertices[idx][1];
        final z2 = y * math.sin(angleX) + z1 * math.cos(angleX);
        sumZ += z2;
      }
      faceDepths.add(MapEntry(i, sumZ / 4));
    }

    // Sort faces from back (lowest Z) to front (highest Z)
    faceDepths.sort((a, b) => a.value.compareTo(b.value));

    // Render faces with futuristic translucent gradients
    for (var entry in faceDepths) {
      final faceIdx = entry.key;
      final f = faces[faceIdx];

      final path = Path()
        ..moveTo(points[f[0]].dx, points[f[0]].dy)
        ..lineTo(points[f[1]].dx, points[f[1]].dy)
        ..lineTo(points[f[2]].dx, points[f[2]].dy)
        ..lineTo(points[f[3]].dx, points[f[3]].dy)
        ..close();

      final intensity = 0.15 + (faceIdx / faces.length) * 0.15;
      fillPaint.color = color.withValues(alpha: intensity);

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(
          path, edgePaint..color = Color.lerp(color, Colors.white, 0.15)!);
    }
  }

  @override
  bool shouldRepaint(covariant _InfiniteCubePainter oldDelegate) => true;
}

/// Magnetic honeycomb blocks assembling and expanding radially in waves.
class MotionHexagonSwarmLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionHexagonSwarmLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionHexagonSwarmLoader> createState() =>
      _MotionHexagonSwarmLoaderState();
}

class _MotionHexagonSwarmLoaderState extends State<MotionHexagonSwarmLoader>
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
      duration: Duration(milliseconds: (2500 / speed).round()),
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
            painter: _HexagonSwarmPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _HexagonSwarmPainter extends CustomPainter {
  final double progress;
  final Color color;

  _HexagonSwarmPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final hexRadius = size.width * 0.12;

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Grid of 7 hexagons (1 center, 6 surrounding)
    final List<Offset> positions = [Offset.zero];

    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final dist = hexRadius * math.sqrt(3);
      positions.add(Offset(dist * math.cos(angle), dist * math.sin(angle)));
    }

    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final delay = i * 0.12;
      final localProg = (progress - delay) % 1.0;

      // Elastic breathing scale
      final scale = 0.5 + 0.5 * math.sin(localProg * math.pi);
      final r = hexRadius * scale;

      final hexCenter =
          center + pos * (0.8 + 0.4 * math.sin(localProg * math.pi));

      final hexPath = Path();
      for (int side = 0; side < 6; side++) {
        final sideAngle = side * math.pi / 3;
        final px = hexCenter.dx + r * math.cos(sideAngle);
        final py = hexCenter.dy + r * math.sin(sideAngle);
        if (side == 0) {
          hexPath.moveTo(px, py);
        } else {
          hexPath.lineTo(px, py);
        }
      }
      hexPath.close();

      final activeColor =
          Color.lerp(color, MotionColors.secondaryNeon, i / positions.length)!;
      fillPaint.color = activeColor.withValues(alpha: 0.2 + 0.6 * scale);

      canvas.drawPath(hexPath, fillPaint);
      canvas.drawPath(hexPath, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HexagonSwarmPainter oldDelegate) => true;
}

/// Recursive scaling tree branches growing fractals with kaleidoscope loops.
class MotionFractalLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionFractalLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionFractalLoader> createState() => _MotionFractalLoaderState();
}

class _MotionFractalLoaderState extends State<MotionFractalLoader>
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
      duration: Duration(milliseconds: (3500 / speed).round()),
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
            painter: _FractalPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _FractalPainter extends CustomPainter {
  final double progress;
  final Color color;

  _FractalPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final len = size.width * 0.22;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final maxDepth = 4;
    final swingAngle = (math.pi / 6) + 0.15 * math.sin(progress * 2 * math.pi);

    // Draw a snowflake-like 3-way fractal system from center
    for (int i = 0; i < 3; i++) {
      final angle = i * 2 * math.pi / 3 + progress * 0.4;
      final end = Offset(
          center.dx + len * math.cos(angle), center.dy + len * math.sin(angle));
      canvas.drawLine(center, end, linePaint);

      _drawBranch(
          canvas, end, angle, len * 0.65, 1, maxDepth, swingAngle, linePaint);
    }
  }

  void _drawBranch(Canvas canvas, Offset start, double angle, double length,
      int depth, int maxDepth, double swingAngle, Paint paint) {
    if (depth > maxDepth) return;

    paint.color = color.withValues(alpha: 1.0 - (depth / maxDepth) * 0.6);
    paint.strokeWidth = (2.0 - (depth / maxDepth) * 1.5).clamp(0.5, 2.0);

    // Left branch
    final leftAngle = angle - swingAngle;
    final leftEnd = Offset(start.dx + length * math.cos(leftAngle),
        start.dy + length * math.sin(leftAngle));
    canvas.drawLine(start, leftEnd, paint);
    _drawBranch(canvas, leftEnd, leftAngle, length * 0.65, depth + 1, maxDepth,
        swingAngle, paint);

    // Right branch
    final rightAngle = angle + swingAngle;
    final rightEnd = Offset(start.dx + length * math.cos(rightAngle),
        start.dy + length * math.sin(rightAngle));
    canvas.drawLine(start, rightEnd, paint);
    _drawBranch(canvas, rightEnd, rightAngle, length * 0.65, depth + 1,
        maxDepth, swingAngle, paint);
  }

  @override
  bool shouldRepaint(covariant _FractalPainter oldDelegate) => true;
}

/// Polygon vertices smoothly morphing (Triangle ➔ Square ➔ Pentagon ➔ Hexagon ➔ Octagon).
class MotionPolygonMorphLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionPolygonMorphLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionPolygonMorphLoader> createState() =>
      _MotionPolygonMorphLoaderState();
}

class _MotionPolygonMorphLoaderState extends State<MotionPolygonMorphLoader>
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
            painter: _PolygonMorphPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _PolygonMorphPainter extends CustomPainter {
  final double progress;
  final Color color;

  _PolygonMorphPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    final Paint borderPaint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint fillPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // Smoothly morphing side count: Triangle (3) -> Octagon (8)
    final double morphedSides = 3.0 + 5.0 * progress;
    final int baseSides = morphedSides.floor();
    final int nextSides = baseSides + 1;
    final double t = morphedSides - baseSides;

    final List<Offset> points = [];

    // We map a unified circular angle step
    const stepsCount = 24;
    for (int i = 0; i < stepsCount; i++) {
      // Base polygon point
      final double angleBase =
          (i * baseSides / stepsCount).floor() * 2 * math.pi / baseSides;
      final double bx = radius * math.cos(angleBase);
      final double by = radius * math.sin(angleBase);

      // Next polygon point
      final double angleNext =
          (i * nextSides / stepsCount).floor() * 2 * math.pi / nextSides;
      final double nx = radius * math.cos(angleNext);
      final double ny = radius * math.sin(angleNext);

      // Lerp between points to create smooth vertex morphing
      final double px = center.dx + (bx + (nx - bx) * t);
      final double py = center.dy + (by + (ny - by) * t);
      points.add(Offset(px, py));
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _PolygonMorphPainter oldDelegate) => true;
}

extension _MathExt on math.Random {
  // Simple helper
}

extension _DoubleExt on double {
  // Simple helper
}

extension _OffsetExt on Offset {
  // Simple helper
}

// Avoid naming conflicts, use inline logic
