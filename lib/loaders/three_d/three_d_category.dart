import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// 3D Theme Category styles & enums.
enum MotionThreeDStyle {
  /// Parallax 3D floating cubes rotating with smooth lighting and dropshadows.
  floatingCube,

  /// Stacked isometric building blocks assembling dynamically in space.
  isometric,

  /// Rotating holographic wireframe sphere planet with CRT scanning lines.
  holographicSphere,
}

/// Parallax 3D floating cubes rotating with smooth lighting and dropshadows.
class MotionFloatingCubeLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionFloatingCubeLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionFloatingCubeLoader> createState() =>
      _MotionFloatingCubeLoaderState();
}

class _MotionFloatingCubeLoaderState extends State<MotionFloatingCubeLoader>
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
            painter: _FloatingCubePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _FloatingCubePainter extends CustomPainter {
  final double progress;
  final Color color;

  _FloatingCubePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width * 0.22;

    // We draw two overlapping floating cubes to create a depth parallax effect
    _drawCube(
        canvas,
        center -
            Offset(0, size.height * 0.08 * math.sin(progress * 2 * math.pi)),
        scale,
        progress,
        0.4);
    _drawCube(
        canvas,
        center +
            Offset(0, size.height * 0.08 * math.sin(progress * 2 * math.pi)),
        scale * 0.65,
        -progress * 1.5,
        0.15);
  }

  void _drawCube(Canvas canvas, Offset cubeCenter, double scale, double prog,
      double alphaVal) {
    final angleY = prog * 2 * math.pi;
    final angleX = math.pi / 6;

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

    final List<Offset> points = [];
    for (var v in vertices) {
      double x = v[0];
      double y = v[1];
      double z = v[2];

      double x1 = x * math.cos(angleY) - z * math.sin(angleY);
      double z1 = x * math.sin(angleY) + z * math.cos(angleY);

      double y2 = y * math.cos(angleX) - z1 * math.sin(angleX);
      double z2 = y * math.sin(angleX) + z1 * math.cos(angleX);

      final double depth = 3.5;
      final double zoom = depth / (depth - z2 / 2);
      points.add(Offset(cubeCenter.dx + x1 * scale * zoom,
          cubeCenter.dy + y2 * scale * zoom));
    }

    final edgePaint = Paint()
      ..color = color.withValues(alpha: alphaVal + 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    final List<List<int>> faces = [
      [0, 1, 2, 3], // Back
      [4, 5, 6, 7], // Front
      [0, 1, 5, 4], // Top
      [2, 3, 7, 6], // Bottom
      [0, 3, 7, 4], // Left
      [1, 2, 6, 5], // Right
    ];

    for (var f in faces) {
      final path = Path()
        ..moveTo(points[f[0]].dx, points[f[0]].dy)
        ..lineTo(points[f[1]].dx, points[f[1]].dy)
        ..lineTo(points[f[2]].dx, points[f[2]].dy)
        ..lineTo(points[f[3]].dx, points[f[3]].dy)
        ..close();

      fillPaint.color = color.withValues(alpha: alphaVal);
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, edgePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingCubePainter oldDelegate) => true;
}

/// Stacked isometric building blocks assembling dynamically in space.
class MotionIsometricLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionIsometricLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionIsometricLoader> createState() => _MotionIsometricLoaderState();
}

class _MotionIsometricLoaderState extends State<MotionIsometricLoader>
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
            painter: _IsometricPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _IsometricPainter extends CustomPainter {
  final double progress;
  final Color color;

  _IsometricPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.55);
    final side = size.width * 0.16;

    // We draw 3 stacked blocks that move elastically up/down
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.2;
      final localProg = (progress - delay) % 1.0;
      final double bounce =
          math.sin(localProg * math.pi) * (size.height * 0.15);

      final blockCenter =
          center - Offset(0, i * side * 0.9 + (localProg < 0.5 ? bounce : 0.0));
      _drawBlock(canvas, blockCenter, side,
          Color.lerp(color, Colors.deepPurpleAccent, i / 3)!);
    }
  }

  void _drawBlock(Canvas canvas, Offset pos, double side, Color blockColor) {
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Top face
    final topPath = Path()
      ..moveTo(pos.dx, pos.dy - side * 0.5)
      ..lineTo(pos.dx + side * 0.86, pos.dy)
      ..lineTo(pos.dx, pos.dy + side * 0.5)
      ..lineTo(pos.dx - side * 0.86, pos.dy)
      ..close();
    fillPaint.color = Color.lerp(blockColor, Colors.white, 0.25)!;
    canvas.drawPath(topPath, fillPaint);
    canvas.drawPath(topPath, linePaint);

    // Left face
    final leftPath = Path()
      ..moveTo(pos.dx - side * 0.86, pos.dy)
      ..lineTo(pos.dx, pos.dy + side * 0.5)
      ..lineTo(pos.dx, pos.dy + side * 1.3)
      ..lineTo(pos.dx - side * 0.86, pos.dy + side * 0.8)
      ..close();
    fillPaint.color = blockColor;
    canvas.drawPath(leftPath, fillPaint);
    canvas.drawPath(leftPath, linePaint);

    // Right face
    final rightPath = Path()
      ..moveTo(pos.dx, pos.dy + side * 0.5)
      ..lineTo(pos.dx + side * 0.86, pos.dy)
      ..lineTo(pos.dx + side * 0.86, pos.dy + side * 0.8)
      ..lineTo(pos.dx, pos.dy + side * 1.3)
      ..close();
    fillPaint.color = Color.lerp(blockColor, Colors.black, 0.25)!;
    canvas.drawPath(rightPath, fillPaint);
    canvas.drawPath(rightPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _IsometricPainter oldDelegate) => true;
}

/// Rotating holographic wireframe sphere planet with CRT scanning lines.
class MotionHolographicSphereLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionHolographicSphereLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionHolographicSphereLoader> createState() =>
      _MotionHolographicSphereLoaderState();
}

class _MotionHolographicSphereLoaderState
    extends State<MotionHolographicSphereLoader>
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
            painter: _HolographicSpherePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _HolographicSpherePainter extends CustomPainter {
  final double progress;
  final Color color;

  _HolographicSpherePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.44;

    // Paint configs for wireframe rings
    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Outer backing atmosphere glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, glowPaint);

    // 1. Draw horizontal latitude rings (flattening oval perspective)
    const latCount = 5;
    for (int i = 1; i < latCount; i++) {
      final double latProg = i / latCount;
      final double h = radius * math.cos(latProg * math.pi);
      final double w = radius * math.sin(latProg * math.pi);

      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(center.dx, center.dy + h),
            width: w * 2,
            height: w * 0.25),
        ringPaint,
      );
    }

    // 2. Draw rotating vertical longitude rings (spinning arcs)
    const lonCount = 6;
    for (int i = 0; i < lonCount; i++) {
      final double lonProg = (progress + (i / lonCount)) % 1.0;
      final double widthFactor = math.cos(lonProg * math.pi);
      final double opacity = math.sin(lonProg * math.pi);

      ringPaint.color = color.withValues(alpha: 0.15 + opacity * 0.35);

      canvas.drawOval(
        Rect.fromCenter(
            center: center,
            width: radius * 2 * widthFactor,
            height: radius * 2),
        ringPaint,
      );
    }

    // 3. Draw outer structural ring outline
    canvas.drawCircle(
        center,
        radius,
        ringPaint
          ..color = color
          ..strokeWidth = 1.5);

    // 4. CRT Horizontal Scanning lines sweep
    final scanPaint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;
    final scanY = center.dy - radius + radius * 2 * progress;
    final scanWidth =
        radius * math.sqrt(1.0 - math.pow((scanY - center.dy) / radius, 2));
    canvas.drawLine(Offset(center.dx - scanWidth, scanY),
        Offset(center.dx + scanWidth, scanY), scanPaint);
  }

  @override
  bool shouldRepaint(covariant _HolographicSpherePainter oldDelegate) => true;
}
