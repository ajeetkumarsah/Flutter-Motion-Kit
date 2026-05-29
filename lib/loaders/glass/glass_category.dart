import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_colors.dart';

/// Glassmorphism Loader styles & enums.
enum MotionGlassStyle {
  /// Frosted glass spheres bouncing and sliding softly inside container boundaries.
  glassOrb,

  /// 3D-angled refracting rotating prism crystals with rainbow/prism gradients.
  prismCrystal,

  /// Northern-light style moving smooth mesh gradient ribbons.
  aurora,
}

/// Frosted glass spheres bouncing and sliding inside container boundaries.
class MotionGlassOrbLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionGlassOrbLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionGlassOrbLoader> createState() => _MotionGlassOrbLoaderState();
}

class _MotionGlassOrbLoaderState extends State<MotionGlassOrbLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_GlassOrb> _orbs = [];
  final _random = math.Random();

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

    // Setup 3 translucent glass orbs with unique starting states
    for (int i = 0; i < 3; i++) {
      _orbs.add(_GlassOrb(
        angle: _random.nextDouble() * 2 * math.pi,
        radius: widget.size * 0.18,
        speedOffset: 0.8 + _random.nextDouble() * 0.5,
        phase: _random.nextDouble() * math.pi,
      ));
    }
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
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Underlying soft background light
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _GlassOrbPainter(
                    progress: isReduced ? 0.0 : _controller.value,
                    color: widget.color,
                    orbs: _orbs,
                    glow: widget.glow && !(motion?.performanceMode ?? false),
                  ),
                );
              },
            ),
          ),
          // Frosted Glass overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.01),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassOrb {
  double angle;
  final double radius;
  final double speedOffset;
  final double phase;

  _GlassOrb({
    required this.angle,
    required this.radius,
    required this.speedOffset,
    required this.phase,
  });
}

class _GlassOrbPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_GlassOrb> orbs;
  final bool glow;

  _GlassOrbPainter({
    required this.progress,
    required this.color,
    required this.orbs,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxBounds = size.width * 0.28;

    final orbPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    for (int i = 0; i < orbs.length; i++) {
      final orb = orbs[i];
      final currentAngle =
          (progress * 2 * math.pi * orb.speedOffset) + orb.phase;

      final orbPos = Offset(
        center.dx + maxBounds * math.cos(currentAngle),
        center.dy + maxBounds * math.sin(currentAngle * 1.5),
      );

      // Render glowing aura behind orb
      if (glow) {
        glowPaint.color = color.withValues(alpha: 0.25);
        canvas.drawCircle(orbPos, orb.radius * 1.4, glowPaint);
      }

      // Draw glass filled orb
      final rect = Rect.fromCircle(center: orbPos, radius: orb.radius);
      orbPaint.shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.08),
          color.withValues(alpha: 0.15),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(rect);

      canvas.drawCircle(orbPos, orb.radius, orbPaint);

      // Glass frosted highlight border
      borderPaint.shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.05),
          color.withValues(alpha: 0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

      canvas.drawCircle(orbPos, orb.radius, borderPaint);

      // Draw white highlight spot
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(orbPos.dx - orb.radius * 0.3, orbPos.dy - orb.radius * 0.3),
        orb.radius * 0.15,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GlassOrbPainter oldDelegate) => true;
}

/// 3D refracting rotating prism crystal loader.
class MotionPrismCrystalLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionPrismCrystalLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionPrismCrystalLoader> createState() =>
      _MotionPrismCrystalLoaderState();
}

class _MotionPrismCrystalLoaderState extends State<MotionPrismCrystalLoader>
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
            painter: _PrismCrystalPainter(
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

class _PrismCrystalPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glow;

  _PrismCrystalPainter({
    required this.progress,
    required this.color,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.32;
    final rotationAngle = progress * 2 * math.pi;

    // Glowing prism core aura
    if (glow) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(center, radius, glowPaint);
    }

    // 3D Crystal vertices (Octahedron projection)
    final points = <Offset>[];
    const verticesCount = 6;
    final elevation =
        math.sin(progress * 2 * math.pi) * 0.15; // 3D bobbing tilt

    // Calculate rotated projection points
    for (int i = 0; i < verticesCount; i++) {
      double angle = rotationAngle + (i * 2 * math.pi / verticesCount);
      if (i == 4) {
        // Top peak
        points.add(Offset(center.dx, center.dy - radius * (1.1 + elevation)));
      } else if (i == 5) {
        // Bottom peak
        points.add(Offset(center.dx, center.dy + radius * (1.1 + elevation)));
      } else {
        // Equator ring points
        final factorX = math.cos(angle);
        final factorY = math.sin(angle) * 0.45; // Perspectively squashed ring
        points.add(
            Offset(center.dx + radius * factorX, center.dy + radius * factorY));
      }
    }

    // Draw refractively shaded glass polygon faces
    void drawFace(int p1, int p2, int p3, List<Color> colors) {
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
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, paint);

      // Delicate neon-glass facets highlight
      final borderPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, borderPaint);
    }

    // Draw front faces (depending on perspective position, we render segments to simulate 3D rotation)
    final crystalPurple = Colors.deepPurple.shade300;
    final crystalCyan = Colors.cyan.shade300;
    final crystalPink = Colors.pink.shade300;

    // Face 1: Top to EQ[0]-EQ[1]
    drawFace(4, 0, 1, [
      Colors.white.withValues(alpha: 0.35),
      crystalCyan.withValues(alpha: 0.25),
      color.withValues(alpha: 0.1)
    ]);
    // Face 2: Top to EQ[1]-EQ[2]
    drawFace(4, 1, 2, [
      Colors.white.withValues(alpha: 0.25),
      crystalPink.withValues(alpha: 0.25),
      crystalPurple.withValues(alpha: 0.15)
    ]);
    // Face 3: Top to EQ[2]-EQ[3]
    drawFace(4, 2, 3, [
      crystalPurple.withValues(alpha: 0.3),
      color.withValues(alpha: 0.2),
      Colors.white.withValues(alpha: 0.15)
    ]);
    // Face 4: Top to EQ[3]-EQ[0]
    drawFace(4, 3, 0, [
      crystalCyan.withValues(alpha: 0.3),
      crystalPink.withValues(alpha: 0.2),
      Colors.white.withValues(alpha: 0.25)
    ]);

    // Bottom faces
    drawFace(5, 0, 1, [
      color.withValues(alpha: 0.25),
      crystalPurple.withValues(alpha: 0.2),
      Colors.white.withValues(alpha: 0.1)
    ]);
    drawFace(5, 1, 2, [
      crystalPink.withValues(alpha: 0.3),
      color.withValues(alpha: 0.15),
      crystalCyan.withValues(alpha: 0.15)
    ]);
    drawFace(5, 2, 3, [
      crystalCyan.withValues(alpha: 0.25),
      crystalPurple.withValues(alpha: 0.2),
      Colors.white.withValues(alpha: 0.15)
    ]);
    drawFace(5, 3, 0, [
      Colors.white.withValues(alpha: 0.3),
      crystalPink.withValues(alpha: 0.25),
      color.withValues(alpha: 0.1)
    ]);
  }

  @override
  bool shouldRepaint(covariant _PrismCrystalPainter oldDelegate) => true;
}

/// Floating smooth northern lights mesh gradient ribbon loader.
class MotionAuroraLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionAuroraLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionAuroraLoader> createState() => _MotionAuroraLoaderState();
}

class _MotionAuroraLoaderState extends State<MotionAuroraLoader>
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
      duration: Duration(milliseconds: (4500 / speed).round()),
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
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _AuroraPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              performanceMode: motion?.performanceMode ?? false,
            ),
          );
        },
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool performanceMode;

  _AuroraPainter({
    required this.progress,
    required this.color,
    required this.performanceMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final steps = performanceMode
        ? 18
        : 36; // Save computing complexity on performance mode
    final stepWidth = size.width / steps;

    // Draw three overlapping waving neon bands of color
    final wavesCount = performanceMode ? 2 : 3;
    final secondaryColor = MotionColors.secondaryNeon;
    final tertiaryColor = Colors.cyanAccent;

    for (int w = 0; w < wavesCount; w++) {
      path.reset();

      final activeColor = w == 0
          ? color
          : w == 1
              ? secondaryColor
              : tertiaryColor;

      final phase = progress * 2 * math.pi + (w * math.pi / 2);
      final heightOffset = size.height * (0.35 + w * 0.15);
      final amplitude = size.height * 0.12;

      path.moveTo(0, heightOffset);

      for (int i = 0; i <= steps; i++) {
        final x = i * stepWidth;
        final theta = (i * 2 * math.pi / steps) * 1.5 + phase;
        final y = heightOffset +
            math.sin(theta) * amplitude +
            math.cos(theta * 0.5) * (amplitude * 0.4);

        path.lineTo(x, y);
      }

      // Draw bottom bounds to close the area for beautiful smooth gradient fill
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      final shaderRect = Rect.fromLTWH(0, heightOffset - amplitude * 1.5,
          size.width, size.height - (heightOffset - amplitude * 1.5));
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          colors: [
            activeColor.withValues(alpha: 0.35),
            activeColor.withValues(alpha: 0.08),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(shaderRect);

      canvas.drawPath(path, paint);

      // Neon-glowing highlight border edge on top of wave
      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = activeColor.withValues(alpha: 0.8);

      if (!performanceMode) {
        linePaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      }

      // Create a top path for border drawing
      final borderPath = Path()..moveTo(0, heightOffset);
      for (int i = 0; i <= steps; i++) {
        final x = i * stepWidth;
        final theta = (i * 2 * math.pi / steps) * 1.5 + phase;
        final y = heightOffset +
            math.sin(theta) * amplitude +
            math.cos(theta * 0.5) * (amplitude * 0.4);
        borderPath.lineTo(x, y);
      }

      canvas.drawPath(borderPath, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) => true;
}
