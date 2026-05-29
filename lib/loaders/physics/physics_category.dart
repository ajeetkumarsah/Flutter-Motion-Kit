import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_colors.dart';

/// Physics Category styles & enums.
enum MotionPhysicsStyle {
  /// Newton's Cradle swing momentum transferring kinetic collision energy.
  pendulum,

  /// Reactive interlocking spring nodes transferring kinetic wave pulses.
  bounceChain,

  /// Orbital gravity decay particles accelerating around a massive nucleus.
  gravityOrbit,
}

/// Newton's Cradle swing momentum transferring kinetic collision energy.
class MotionPendulumLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionPendulumLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionPendulumLoader> createState() => _MotionPendulumLoaderState();
}

class _MotionPendulumLoaderState extends State<MotionPendulumLoader>
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
            painter: _PendulumPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _PendulumPainter extends CustomPainter {
  final double progress;
  final Color color;

  _PendulumPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final int ballsCount = 5;
    final double ballRadius = size.width * 0.07;
    final double stringLength = size.height * 0.45;

    // Spacing between hanging pivot points
    final double pivotSpacing = ballRadius * 2.0;
    final double startX = center.dx - (pivotSpacing * (ballsCount - 1) / 2);
    final double pivotY = size.height * 0.15;

    // Draw top horizontal bar
    final barPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(startX - ballRadius * 2, pivotY),
      Offset(startX + pivotSpacing * (ballsCount - 1) + ballRadius * 2, pivotY),
      barPaint,
    );

    // Calculate left/right swing angles based on time progress
    // T = [0, 0.5] -> Left ball swings out and back
    // T = [0.5, 1.0] -> Right ball swings out and back
    final double maxAngle =
        math.pi * 0.22; // Maximum swing angle (approx 40 degrees)
    double leftAngle = 0.0;
    double rightAngle = 0.0;

    if (progress < 0.5) {
      // Normalizing to half cycle [0.0, 1.0]
      final t = progress / 0.5;
      // Pendulum swing sine-wave interpolation
      leftAngle = -maxAngle * math.sin(t * math.pi);
    } else {
      final t = (progress - 0.5) / 0.5;
      rightAngle = maxAngle * math.sin(t * math.pi);
    }

    final ballPaint = Paint()..style = PaintingStyle.fill;
    final stringPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1.0;

    for (int i = 0; i < ballsCount; i++) {
      final double pivotX = startX + (i * pivotSpacing);
      final double currentPivotY = pivotY;

      double angle = 0.0;
      if (i == 0) {
        angle = leftAngle;
      } else if (i == ballsCount - 1) {
        angle = rightAngle;
      }

      // Calculate actual coordinates for current ball center
      final double ballX = pivotX + stringLength * math.sin(angle);
      final double ballY = currentPivotY + stringLength * math.cos(angle);
      final Offset ballCenter = Offset(ballX, ballY);

      // Draw thin suspension strings
      canvas.drawLine(Offset(pivotX, currentPivotY), ballCenter, stringPaint);

      // Draw pendulum metal balls with glowing physics highlights
      final rect = Rect.fromCircle(center: ballCenter, radius: ballRadius);

      // Interpolate center balls to be grey/dormant, and active swing balls to be glowing primary color
      final isSwinging = (i == 0 && leftAngle != 0.0) ||
          (i == ballsCount - 1 && rightAngle != 0.0);
      final activeColor = isSwinging ? color : Colors.grey.shade400;

      ballPaint.shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.95),
          activeColor,
          Color.lerp(activeColor, Colors.black, 0.4)!,
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(rect);

      canvas.drawCircle(ballCenter, ballRadius, ballPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PendulumPainter oldDelegate) => true;
}

/// Spring kinetic interlocking bounce chain transferring wave pulses.
class MotionBounceChainLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionBounceChainLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionBounceChainLoader> createState() =>
      _MotionBounceChainLoaderState();
}

class _MotionBounceChainLoaderState extends State<MotionBounceChainLoader>
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
      duration: Duration(milliseconds: (2200 / speed).round()),
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
            painter: _BounceChainPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _BounceChainPainter extends CustomPainter {
  final double progress;
  final Color color;

  _BounceChainPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final int nodeCount = 4;
    final double radius = size.width * 0.085;
    final double spacing = radius * 2.3;
    final double startX = center.dx - (spacing * (nodeCount - 1) / 2);

    final linePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final List<Offset> positions = [];
    for (int i = 0; i < nodeCount; i++) {
      final double x = startX + (i * spacing);

      // Calculate elastic wave bouncing motion
      final delay = i * 0.18;
      final localProg = (progress - delay) % 1.0;

      // Spring bounce formula using smooth elastic peak
      final double bounce =
          math.sin(localProg * math.pi) * (size.height * 0.22);
      final double y = center.dy - (localProg < 0.5 ? bounce : 0.0);

      positions.add(Offset(x, y));
    }

    // 1. Draw spring connector lines between balls
    for (int i = 0; i < nodeCount - 1; i++) {
      canvas.drawLine(positions[i], positions[i + 1], linePaint);
    }

    // 2. Draw nodes with gradient fills
    final nodePaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < nodeCount; i++) {
      final rect = Rect.fromCircle(center: positions[i], radius: radius);
      final activeColor =
          Color.lerp(color, MotionColors.secondaryNeon, i / (nodeCount - 1))!;

      nodePaint.shader = LinearGradient(
        colors: [
          Colors.white,
          activeColor,
          Color.lerp(activeColor, Colors.black, 0.3)!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

      canvas.drawCircle(positions[i], radius, nodePaint);

      // Glossy border
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(positions[i], radius, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BounceChainPainter oldDelegate) => true;
}

/// Orbital gravity decay particles accelerating around a massive nucleus.
class MotionGravityOrbitLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionGravityOrbitLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionGravityOrbitLoader> createState() =>
      _MotionGravityOrbitLoaderState();
}

class _MotionGravityOrbitLoaderState extends State<MotionGravityOrbitLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_GravityPlanet> _planets = [];
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
      duration: Duration(milliseconds: (3500 / speed).round()),
    )..repeat();

    // Spawn 3 dynamic orbital planets experiencing gravitational acceleration
    for (int i = 0; i < 3; i++) {
      _planets.add(_GravityPlanet(
        eccentricity: 0.3 + i * 0.15,
        semiMajorAxis: widget.size * (0.24 + i * 0.08),
        speedScale: 1.0 + (3 - i) * 0.5,
        phase: _random.nextDouble() * 2 * math.pi,
        size: 2.0 + _random.nextDouble() * 2.5,
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
            painter: _GravityOrbitPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              planets: _planets,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _GravityPlanet {
  final double eccentricity; // Ellipse stretch factor
  final double semiMajorAxis; // Orbital size radius
  final double speedScale;
  final double phase;
  final double size;

  _GravityPlanet({
    required this.eccentricity,
    required this.semiMajorAxis,
    required this.speedScale,
    required this.phase,
    required this.size,
  });
}

class _GravityOrbitPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_GravityPlanet> planets;
  final bool glow;

  _GravityOrbitPainter({
    required this.progress,
    required this.color,
    required this.planets,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final coreRadius = size.width * 0.09;

    // Draw central high-mass gravity sun core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          color,
          color.withValues(alpha: 0.1),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius * 1.5))
      ..style = PaintingStyle.fill;

    if (glow) {
      final coreGlow = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, coreRadius * 1.5, coreGlow);
    }
    canvas.drawCircle(center, coreRadius, corePaint);

    // Render orbiting planets with Kepler's physical speed scaling (faster at perihelion)
    final planetPaint = Paint()..style = PaintingStyle.fill;
    final pathPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (var planet in planets) {
      final semiMinorAxis = planet.semiMajorAxis *
          math.sqrt(1 - planet.eccentricity * planet.eccentricity);

      // Draw faint elliptical orbital track lines
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: planet.semiMajorAxis * 2,
          height: semiMinorAxis * 2,
        ),
        pathPaint,
      );

      // Calculate eccentric anomaly: Kepler speed adjustments
      final angle = progress * planet.speedScale * 2 * math.pi + planet.phase;
      // Animate planet center offset coordinates on ellipse
      final x = center.dx + planet.semiMajorAxis * math.cos(angle);
      final y = center.dy + semiMinorAxis * math.sin(angle);
      final planetPos = Offset(x, y);

      // Orbital planet color shifts based on proximity speed
      final distance = (planetPos - center).distance;
      final speedFactor =
          1.0 - (distance / planet.semiMajorAxis).clamp(0.0, 1.0);
      final activeColor =
          Color.lerp(color, MotionColors.secondaryNeon, speedFactor)!;

      planetPaint.color = Color.lerp(Colors.white, activeColor, 0.25)!;
      canvas.drawCircle(planetPos, planet.size, planetPaint);

      // Orbit glowing trace halo
      if (glow) {
        final glowPaint = Paint()
          ..color = activeColor.withValues(alpha: 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(planetPos, planet.size + 2, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GravityOrbitPainter oldDelegate) => true;
}
