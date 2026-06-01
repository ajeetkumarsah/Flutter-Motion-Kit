import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// Luxury UI Category styles & enums.
enum MotionLuxuryStyle {
  /// Premium 3D faceted diamond sparkle loader flashing elegant sparks.
  diamondSpark,

  /// Flowing luxury silk fabric waves utilizing overlapping soft golden gradients.
  silkFlow,

  /// Metallic gold shimmer sweep reflecting dynamic metallic shines.
  goldSweep,

  /// Interlocking mechanical chronometer gears executing ticks and cogs.
  premiumWatch,
}

/// Premium 3D faceted diamond sparkle loader flashing elegant sparks.
class MotionDiamondSparkLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionDiamondSparkLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionDiamondSparkLoader> createState() =>
      _MotionDiamondSparkLoaderState();
}

class _MotionDiamondSparkLoaderState extends State<MotionDiamondSparkLoader>
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
            painter: _DiamondSparkPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _DiamondSparkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glow;

  _DiamondSparkPainter({
    required this.progress,
    required this.color,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double w = size.width * 0.58;
    final double h = size.height * 0.58;

    // Draw luxury diamond facets
    final List<Offset> points = [
      Offset(center.dx, center.dy - h * 0.5), // 0. Top Tip
      Offset(center.dx - w * 0.45, center.dy - h * 0.15), // 1. Top Left
      Offset(center.dx - w * 0.5, center.dy + h * 0.05), // 2. Mid Left
      Offset(center.dx, center.dy + h * 0.55), // 3. Bottom Tip
      Offset(center.dx + w * 0.5, center.dy + h * 0.05), // 4. Mid Right
      Offset(center.dx + w * 0.45, center.dy - h * 0.15), // 5. Top Right
      Offset(center.dx - w * 0.15, center.dy - h * 0.15), // 6. Inner Left
      Offset(center.dx + w * 0.15, center.dy - h * 0.15), // 7. Inner Right
    ];

    void drawFacet(int p1, int p2, int p3, List<Color> colors) {
      final path = Path()
        ..moveTo(points[p1].dx, points[p1].dy)
        ..lineTo(points[p2].dx, points[p2].dy)
        ..lineTo(points[p3].dx, points[p3].dy)
        ..close();

      final paint = Paint()
        ..shader = LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromCircle(center: center, radius: w * 0.6))
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);

      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, linePaint);
    }

    final cActive = color;
    final cAmbient = Colors.blue.shade100;
    final cShine = Colors.white;

    // Facet segments
    drawFacet(0, 1, 6, [
      cShine.withValues(alpha: 0.45),
      cActive.withValues(alpha: 0.2),
      cAmbient.withValues(alpha: 0.1)
    ]);
    drawFacet(0, 6, 7, [
      cActive.withValues(alpha: 0.35),
      cShine.withValues(alpha: 0.45),
      cActive.withValues(alpha: 0.25)
    ]);
    drawFacet(0, 7, 5, [
      cShine.withValues(alpha: 0.45),
      cAmbient.withValues(alpha: 0.2),
      cActive.withValues(alpha: 0.1)
    ]);
    drawFacet(1, 2, 6, [
      cActive.withValues(alpha: 0.2),
      cAmbient.withValues(alpha: 0.15),
      cActive.withValues(alpha: 0.25)
    ]);
    drawFacet(5, 7, 4, [
      cActive.withValues(alpha: 0.25),
      cAmbient.withValues(alpha: 0.15),
      cActive.withValues(alpha: 0.2)
    ]);
    drawFacet(6, 2, 3, [
      cActive.withValues(alpha: 0.3),
      cShine.withValues(alpha: 0.1),
      cAmbient.withValues(alpha: 0.2)
    ]);
    drawFacet(7, 3, 4, [
      cActive.withValues(alpha: 0.2),
      cShine.withValues(alpha: 0.1),
      cAmbient.withValues(alpha: 0.3)
    ]);
    drawFacet(6, 7, 3, [
      cShine.withValues(alpha: 0.3),
      cActive.withValues(alpha: 0.4),
      cAmbient.withValues(alpha: 0.15)
    ]);

    // 2. Draw sparkling flares rotating around diamond crown facets
    final sparkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final double phase = progress * 2 * math.pi;
    final List<Offset> flarePositions = [
      Offset(center.dx + w * 0.35 * math.cos(phase),
          center.dy - h * 0.28 + (5.0 * math.sin(phase))),
      Offset(center.dx - w * 0.35 * math.cos(phase * 1.5),
          center.dy + h * 0.18 + (5.0 * math.cos(phase * 1.5))),
    ];

    for (int i = 0; i < flarePositions.length; i++) {
      final pos = flarePositions[i];
      final double scale = 0.5 + 0.5 * math.sin(phase * 3 + i);

      if (scale < 0.2) continue;

      if (glow) {
        glowPaint.color = cActive.withValues(alpha: scale * 0.45);
        canvas.drawCircle(pos, 4.0 * scale, glowPaint);
      }

      // Star sparkle flare lines
      final strokePaint = Paint()
        ..color = Colors.white.withValues(alpha: scale * 0.95)
        ..strokeWidth = 1.0;
      canvas.drawLine(Offset(pos.dx - 6 * scale, pos.dy),
          Offset(pos.dx + 6 * scale, pos.dy), strokePaint);
      canvas.drawLine(Offset(pos.dx, pos.dy - 6 * scale),
          Offset(pos.dx, pos.dy + 6 * scale), strokePaint);

      canvas.drawCircle(pos, 1.8 * scale, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DiamondSparkPainter oldDelegate) => true;
}

/// Flowing luxury silk fabric waves utilizing overlapping soft golden gradients.
class MotionSilkFlowLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionSilkFlowLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionSilkFlowLoader> createState() => _MotionSilkFlowLoaderState();
}

class _MotionSilkFlowLoaderState extends State<MotionSilkFlowLoader>
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
            painter: _SilkFlowPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _SilkFlowPainter extends CustomPainter {
  final double progress;
  final Color color;

  _SilkFlowPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double steps = 48;
    final double stepWidth = size.width / steps;

    // Draw three dense flowing ribbons (like gold silk fabric folds)
    for (int r = 0; r < 3; r++) {
      final pathTop = Path();
      final pathBottom = Path();

      final ribbonColor = r == 0
          ? color
          : r == 1
              ? const Color(0xFFFFD700) // Gold
              : const Color(0xFFFFA500); // Amber Orange

      final phase = progress * 2 * math.pi + (r * math.pi / 3);
      final double waveHeight = size.height * (0.35 + r * 0.12);
      final double amplitude = size.height * 0.1;

      pathTop.moveTo(0, waveHeight);
      pathBottom.moveTo(0, waveHeight + size.height * 0.15);

      for (int i = 0; i <= steps; i++) {
        final x = i * stepWidth;
        final theta = (i * 1.5 * math.pi / steps) + phase;
        final baseHeight = waveHeight + math.sin(theta) * amplitude;

        final double thickness =
            size.height * 0.1 * (1.1 + math.cos(theta * 0.8));
        pathTop.lineTo(x, baseHeight - thickness / 2);
        pathBottom.lineTo(x, baseHeight + thickness / 2);
      }

      // Close path
      final compositePath = Path()..addPath(pathTop, Offset.zero);
      final reverseBottom = Path();
      for (int i = steps.round(); i >= 0; i--) {
        final x = i * stepWidth;
        final theta = (i * 1.5 * math.pi / steps) + phase;
        final baseHeight = waveHeight + math.sin(theta) * amplitude;
        final double thickness =
            size.height * 0.1 * (1.1 + math.cos(theta * 0.8));
        reverseBottom.lineTo(x, baseHeight + thickness / 2);
      }
      compositePath.addPath(reverseBottom, Offset.zero);
      compositePath.close();

      final activePaint = Paint()
        ..shader = LinearGradient(
          colors: [
            ribbonColor.withValues(alpha: 0.15),
            ribbonColor.withValues(alpha: 0.55),
            Colors.white.withValues(alpha: 0.65),
            ribbonColor.withValues(alpha: 0.15),
          ],
          stops: const [0.0, 0.45, 0.55, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(
            Rect.fromLTWH(0, waveHeight - amplitude, size.width, amplitude * 3))
        ..style = PaintingStyle.fill;

      canvas.drawPath(compositePath, activePaint);

      // Fine golden lining border
      final strokePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke;
      canvas.drawPath(compositePath, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SilkFlowPainter oldDelegate) => true;
}

/// Metallic gold shimmer sweep reflecting premium metallic shines.
class MotionGoldSweepLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionGoldSweepLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionGoldSweepLoader> createState() => _MotionGoldSweepLoaderState();
}

class _MotionGoldSweepLoaderState extends State<MotionGoldSweepLoader>
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

    return Container(
      width: widget.size,
      height: widget.size * 0.65, // Rectangular card ratio
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF0F0E0A),
        border: Border.all(
            color: const Color(0xFFFFD700).withValues(alpha: 0.25), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _GoldSweepPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _GoldSweepPainter extends CustomPainter {
  final double progress;
  final Color color;

  _GoldSweepPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw central premium crown badge silhouette
    final badgePaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.height * 0.3;

    canvas.drawCircle(Offset(cx, cy), r, badgePaint);

    // 2. Draw moving diagonal premium metallic gold shimmer sweep gradient
    // Sweeps from left dx = -size.width to right dx = size.width*2
    final double sweepDx = -size.width * 0.5 + (size.width * 1.8 * progress);

    final sweepPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFFFFD700).withValues(alpha: 0.05),
          const Color(0xFFFFF3A7)
              .withValues(alpha: 0.45), // Hot gold shine center
          const Color(0xFFFFD700).withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(sweepDx, 0, size.width * 0.6, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sweepPaint);

    // Delicate gold boundary highlights
    final borderPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(cx, cy), r, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _GoldSweepPainter oldDelegate) => true;
}

/// Interlocking mechanical watch gears executing ticks and cogs cogs cogs.
class MotionPremiumWatchLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionPremiumWatchLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionPremiumWatchLoader> createState() =>
      _MotionPremiumWatchLoaderState();
}

class _MotionPremiumWatchLoaderState extends State<MotionPremiumWatchLoader>
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
      duration: Duration(milliseconds: (4000 / speed).round()),
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
          // Chronometer mechanical tick step rotation (8 tick steps per revolution)
          final progress = isReduced ? 0.0 : _controller.value;
          final double tickedProgress = (progress * 12).floor() / 12.0;

          return CustomPaint(
            painter: _PremiumWatchPainter(
              progress: tickedProgress,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _PremiumWatchPainter extends CustomPainter {
  final double progress;
  final Color color;

  _PremiumWatchPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw two interlocking gearwheels
    // Gear A: Large main gear in center-left
    final double gearRadiusA = size.width * 0.28;
    final gearCenterA =
        Offset(center.dx - size.width * 0.12, center.dy - size.height * 0.08);

    // Gear B: Small driving gear in bottom-right
    final double gearRadiusB = size.width * 0.18;
    final gearCenterB = Offset(
        gearCenterA.dx +
            (gearRadiusA + gearRadiusB - 1.2) * math.cos(math.pi / 5),
        gearCenterA.dy +
            (gearRadiusA + gearRadiusB - 1.2) * math.sin(math.pi / 5));

    _drawWatchGear(
        canvas, gearCenterA, gearRadiusA, progress * 2 * math.pi, color, 16);
    _drawWatchGear(
        canvas,
        gearCenterB,
        gearRadiusB,
        -progress * 2 * math.pi * (gearRadiusA / gearRadiusB) + (math.pi / 16),
        const Color(0xFFFFD700),
        10);
  }

  void _drawWatchGear(Canvas canvas, Offset center, double radius, double angle,
      Color gearColor, int cogsCount) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final gearPaint = Paint()
      ..color = gearColor
      ..style = PaintingStyle.fill;

    // Draw central main gear core body
    canvas.drawCircle(
        Offset.zero,
        radius * 0.85,
        Paint()
          ..color = gearColor.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill);

    // Draw cogs cogs rectangular segments
    final double cogWidth = radius * 0.14;
    final double cogHeight = radius * 0.2;

    for (int i = 0; i < cogsCount; i++) {
      final double theta = (i * 2 * math.pi) / cogsCount;
      canvas.save();
      canvas.rotate(theta);
      canvas.translate(0, -radius);

      // Draw rectangular cog teeth
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset.zero, width: cogWidth, height: cogHeight),
          const Radius.circular(2.0),
        ),
        gearPaint,
      );
      canvas.restore();
    }

    // Outer metal ring cogs frame
    final rimPaint = Paint()
      ..color = gearColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset.zero, radius, rimPaint);

    // Draw interior gear spoke spokes
    final spokePaint = Paint()
      ..color = gearColor.withValues(alpha: 0.8)
      ..strokeWidth = 1.8;
    for (int i = 0; i < 4; i++) {
      final double spokeAngle = (i * 2 * math.pi) / 4;
      canvas.drawLine(
        Offset.zero,
        Offset(radius * 0.85 * math.cos(spokeAngle),
            radius * 0.85 * math.sin(spokeAngle)),
        spokePaint,
      );
    }

    // Central rivet pin
    canvas.drawCircle(
        Offset.zero,
        radius * 0.2,
        Paint()
          ..color = Colors.white30
          ..style = PaintingStyle.fill);
    canvas.drawCircle(
        Offset.zero,
        radius * 0.1,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PremiumWatchPainter oldDelegate) => true;
}
