import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_colors.dart';

/// Space Category styles & enums.
enum MotionSpaceStyle {
  /// Star particles spiraling in a high-gravity vortex into a central dark singularity.
  blackHole,

  /// Multi-arm rotating galaxy with nebula dust trails and depth parallax.
  galaxy,

  /// Hyperspace warp speed perspective with star trails stretching outwards.
  warpSpeed,
}

/// Star particles accelerating in a spiral vortex into a central dark singularity.
class MotionBlackHoleLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionBlackHoleLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionBlackHoleLoader> createState() => _MotionBlackHoleLoaderState();
}

class _MotionBlackHoleLoaderState extends State<MotionBlackHoleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_SpaceStar> _stars = [];
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

    // Initialize 25 star particles with varied orbits
    for (int i = 0; i < 25; i++) {
      _stars.add(_SpaceStar(
        angle: _random.nextDouble() * 2 * math.pi,
        distanceRatio: 0.2 + _random.nextDouble() * 0.8,
        speedFactor: 0.6 + _random.nextDouble() * 1.2,
        size: 1.0 + _random.nextDouble() * 2.5,
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

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _BlackHolePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              stars: _stars,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _SpaceStar {
  double angle;
  double distanceRatio;
  final double speedFactor;
  final double size;

  _SpaceStar({
    required this.angle,
    required this.distanceRatio,
    required this.speedFactor,
    required this.size,
  });
}

class _BlackHolePainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_SpaceStar> stars;
  final bool glow;

  _BlackHolePainter({
    required this.progress,
    required this.color,
    required this.stars,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.48;

    // Draw accretion disk aura
    if (glow) {
      final diskPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.4),
            MotionColors.secondaryNeon.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(center, maxRadius * 0.65, diskPaint);
    }

    // Update and draw star trails spiraling inward
    final starPaint = Paint()..style = PaintingStyle.fill;
    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var star in stars) {
      // Calculate continuous inward spiral progress
      final starProgress = (progress * star.speedFactor) % 1.0;
      final currentDistance = maxRadius *
          (star.distanceRatio - starProgress * star.distanceRatio)
              .clamp(0.05, 1.0);
      final currentAngle = star.angle +
          (starProgress * 4 * math.pi); // Multiple spiral revolutions

      // Skip drawing if too close to the event horizon singularity
      if (currentDistance < maxRadius * 0.12) continue;

      final starPos = Offset(
        center.dx + currentDistance * math.cos(currentAngle),
        center.dy + currentDistance * math.sin(currentAngle),
      );

      // Dynamic acceleration color shifting to red-shift as it approaches core
      final distanceNorm = (currentDistance / maxRadius).clamp(0.0, 1.0);
      final activeColor =
          Color.lerp(MotionColors.secondaryNeon, color, distanceNorm)!;

      // Draw particle trail lines
      final prevAngle = star.angle + ((starProgress - 0.04) * 4 * math.pi);
      final prevDistance = maxRadius *
          (star.distanceRatio - (starProgress - 0.04) * star.distanceRatio)
              .clamp(0.05, 1.0);
      final prevPos = Offset(
        center.dx + prevDistance * math.cos(prevAngle),
        center.dy + prevDistance * math.sin(prevAngle),
      );

      trailPaint.color =
          activeColor.withValues(alpha: 0.4 * (1.0 - distanceNorm));
      trailPaint.strokeWidth = star.size * 0.6;
      canvas.drawLine(prevPos, starPos, trailPaint);

      // Draw star body
      starPaint.color = Color.lerp(Colors.white, activeColor, 0.4)!;
      canvas.drawCircle(starPos, star.size, starPaint);
    }

    // Singularity center core
    final corePaint = Paint()
      ..color = const Color(0xFF030308)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius * 0.12, corePaint);

    // Singularity event horizon glowing edge
    final eventPaint = Paint()
      ..color = color.withValues(alpha: 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (glow) {
      eventPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    }
    canvas.drawCircle(center, maxRadius * 0.125, eventPaint);
  }

  @override
  bool shouldRepaint(covariant _BlackHolePainter oldDelegate) => true;
}

/// Multi-arm rotating spiral galaxy with nebula trails and parallax depth.
class MotionGalaxyLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionGalaxyLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionGalaxyLoader> createState() => _MotionGalaxyLoaderState();
}

class _MotionGalaxyLoaderState extends State<MotionGalaxyLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_GalaxyStar> _stars = [];
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
      duration: Duration(milliseconds: (6000 / speed).round()),
    )..repeat();

    // Generate 40 stars arranged inside spiral arms
    const armsCount = 3;
    for (int i = 0; i < 40; i++) {
      final arm = i % armsCount;
      final armAngle = (arm * 2 * math.pi) / armsCount;

      // Logarithmic spiral math: angle increases as distance increases
      final distanceRatio = 0.15 + _random.nextDouble() * 0.85;
      final spiralAngle = armAngle +
          (distanceRatio * 2.5 * math.pi) +
          (_random.nextDouble() * 0.35 - 0.175);

      _stars.add(_GalaxyStar(
        initialAngle: spiralAngle,
        distanceRatio: distanceRatio,
        size: 1.0 + _random.nextDouble() * 2.2,
        alphaOffset: 0.4 + _random.nextDouble() * 0.6,
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

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _GalaxyPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              stars: _stars,
            ),
          );
        },
      ),
    );
  }
}

class _GalaxyStar {
  final double initialAngle;
  final double distanceRatio;
  final double size;
  final double alphaOffset;

  _GalaxyStar({
    required this.initialAngle,
    required this.distanceRatio,
    required this.size,
    required this.alphaOffset,
  });
}

class _GalaxyPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_GalaxyStar> stars;

  _GalaxyPainter({
    required this.progress,
    required this.color,
    required this.stars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.46;

    // Draw galaxy core bulge
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          color.withValues(alpha: 0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 0.45));
    canvas.drawCircle(center, maxRadius * 0.35, corePaint);

    // Draw spiral arms stars
    final starPaint = Paint()..style = PaintingStyle.fill;
    final rotation = progress * 2 * math.pi;

    for (var star in stars) {
      // Stars rotate at speed varying inversely with their distance (Keplerian velocity simulation)
      final orbitalSpeed =
          rotation * (1.2 / math.sqrt(star.distanceRatio + 0.1));
      final currentAngle = star.initialAngle + orbitalSpeed;
      final dist = maxRadius * star.distanceRatio;

      final starPos = Offset(
        center.dx + dist * math.cos(currentAngle),
        center.dy + dist * math.sin(currentAngle),
      );

      // Color based on distance (Hot blue-white center to cold red edges)
      final activeColor = Color.lerp(
        Colors.white,
        Color.lerp(
            color, MotionColors.secondaryNeon, star.distanceRatio * 0.7)!,
        star.distanceRatio,
      )!;

      // Pulse opacity softly
      final pulse =
          0.7 + 0.3 * math.sin(progress * 4 * math.pi + star.initialAngle);
      starPaint.color = activeColor.withValues(alpha: star.alphaOffset * pulse);
      canvas.drawCircle(starPos, star.size, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GalaxyPainter oldDelegate) => true;
}

/// Starfield hyperspace perspective with stretching star trails.
class MotionWarpSpeedLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionWarpSpeedLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionWarpSpeedLoader> createState() => _MotionWarpSpeedLoaderState();
}

class _MotionWarpSpeedLoaderState extends State<MotionWarpSpeedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_WarpStar> _stars = [];
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
      duration: Duration(milliseconds: (1800 / speed).round()),
    )..repeat();

    // Spawn stars spreading outward
    for (int i = 0; i < 30; i++) {
      final angle = _random.nextDouble() * 2 * math.pi;
      _stars.add(_WarpStar(
        cosAngle: math.cos(angle),
        sinAngle: math.sin(angle),
        startDistance: 0.05 + _random.nextDouble() * 0.25,
        speedFactor: 1.0 + _random.nextDouble() * 1.5,
        width: 1.0 + _random.nextDouble() * 2.0,
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
        color: const Color(0xFF030308),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WarpSpeedPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              stars: _stars,
            ),
          );
        },
      ),
    );
  }
}

class _WarpStar {
  final double cosAngle;
  final double sinAngle;
  final double startDistance;
  final double speedFactor;
  final double width;

  _WarpStar({
    required this.cosAngle,
    required this.sinAngle,
    required this.startDistance,
    required this.speedFactor,
    required this.width,
  });
}

class _WarpSpeedPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_WarpStar> stars;

  _WarpSpeedPainter({
    required this.progress,
    required this.color,
    required this.stars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxBounds = size.width * 0.7; // Outer limits

    final starPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var star in stars) {
      // Exponential outwards travel to simulate true 3D perspective
      final localProg = (progress * star.speedFactor) % 1.0;
      final distCurrent =
          maxBounds * math.pow(star.startDistance + localProg, 3.0);
      // Star stretches longer as it moves faster at the edges
      final distPrev = maxBounds *
          math.pow(
              star.startDistance + (localProg - 0.05).clamp(0.0, 1.0), 3.0);

      if (distCurrent > maxBounds) continue;

      final startPos = Offset(
        center.dx + distPrev * star.cosAngle,
        center.dy + distPrev * star.sinAngle,
      );

      final endPos = Offset(
        center.dx + distCurrent * star.cosAngle,
        center.dy + distCurrent * star.sinAngle,
      );

      // Star fade-in and stretch fade-out
      final opacity = math.sin(localProg * math.pi).clamp(0.0, 1.0);
      final activeColor = Color.lerp(color, Colors.white, localProg)!;

      starPaint.color = activeColor.withValues(alpha: opacity);
      starPaint.strokeWidth = star.width * (0.5 + 2.0 * localProg);

      canvas.drawLine(startPos, endPos, starPaint);
    }

    // Warp core central glowing pinpoint
    final corePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, 4.0, corePaint);
  }

  @override
  bool shouldRepaint(covariant _WarpSpeedPainter oldDelegate) => true;
}
