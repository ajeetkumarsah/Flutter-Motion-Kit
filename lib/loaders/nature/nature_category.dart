import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// Nature Category styles & enums.
enum MotionNatureStyle {
  /// Fireflies drifting organically inside container spaces with breathing glows.
  firefly,

  /// 3D tornado wind vortex drawing particle dust upwards in spirals.
  tornado,

  /// Periodic volcanic molten eruptions shooting magma sparks under gravity.
  volcano,

  /// Leaves falling gracefully, drifting along lateral sine wind currents.
  leafWind,

  /// Moon overlapping the sun creating corona solar flares and ambient shifts.
  solarEclipse,
}

/// Fireflies drifting organically inside container spaces with breathing glows.
class MotionFireflyLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionFireflyLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionFireflyLoader> createState() => _MotionFireflyLoaderState();
}

class _MotionFireflyLoaderState extends State<MotionFireflyLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FireflyStar> _fireflies = [];
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

    // Spawn 15 organic fireflies with random seeds
    for (int i = 0; i < 15; i++) {
      _fireflies.add(_FireflyStar(
        offset: Offset(_random.nextDouble(), _random.nextDouble()),
        speedX: 0.3 + _random.nextDouble() * 0.7,
        speedY: 0.3 + _random.nextDouble() * 0.7,
        pulseOffset: _random.nextDouble() * 2 * math.pi,
        size: 1.5 + _random.nextDouble() * 2.2,
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
            painter: _FireflyPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              fireflies: _fireflies,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _FireflyStar {
  final Offset offset;
  final double speedX;
  final double speedY;
  final double pulseOffset;
  final double size;

  _FireflyStar({
    required this.offset,
    required this.speedX,
    required this.speedY,
    required this.pulseOffset,
    required this.size,
  });
}

class _FireflyPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_FireflyStar> fireflies;
  final bool glow;

  _FireflyPainter({
    required this.progress,
    required this.color,
    required this.fireflies,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxBounds = size.width * 0.45;

    final flyPaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    // Render drifting fireflies using continuous smooth Sine offset movements
    for (var fly in fireflies) {
      final angleX = progress * 2 * math.pi * fly.speedX + fly.pulseOffset;
      final angleY =
          progress * 2 * math.pi * fly.speedY + fly.pulseOffset * 1.5;

      final x = center.dx +
          maxBounds * (fly.offset.dx * 1.8 - 0.9) +
          (10.0 * math.sin(angleX));
      final y = center.dy +
          maxBounds * (fly.offset.dy * 1.8 - 0.9) +
          (10.0 * math.cos(angleY));
      final pos = Offset(x, y);

      // Breathing glow pulse opacity
      final pulse =
          0.4 + 0.6 * math.sin(progress * 4 * math.pi + fly.pulseOffset);
      final activeColor =
          Color.lerp(color, Colors.yellowAccent, 0.3)!.withValues(alpha: pulse);

      if (glow) {
        glowPaint.color = activeColor.withValues(alpha: pulse * 0.4);
        canvas.drawCircle(pos, fly.size + 4, glowPaint);
      }

      flyPaint.color = activeColor;
      canvas.drawCircle(pos, fly.size, flyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FireflyPainter oldDelegate) => true;
}

/// 3D tornado wind vortex drawing particle dust upwards in spirals.
class MotionTornadoLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionTornadoLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionTornadoLoader> createState() => _MotionTornadoLoaderState();
}

class _MotionTornadoLoaderState extends State<MotionTornadoLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_TornadoDust> _dustParticles = [];
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
      duration: Duration(milliseconds: (2000 / speed).round()),
    )..repeat();

    // Spawn dust particles moving in spirals
    for (int i = 0; i < 28; i++) {
      _dustParticles.add(_TornadoDust(
        seedY: _random.nextDouble(),
        speedOffset: 0.8 + _random.nextDouble() * 0.8,
        angleOffset: _random.nextDouble() * 2 * math.pi,
        size: 1.0 + _random.nextDouble() * 2.2,
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
            painter: _TornadoPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              dust: _dustParticles,
            ),
          );
        },
      ),
    );
  }
}

class _TornadoDust {
  final double seedY; // Starting vertical ratio
  final double speedOffset;
  final double angleOffset;
  final double size;

  _TornadoDust({
    required this.seedY,
    required this.speedOffset,
    required this.angleOffset,
    required this.size,
  });
}

class _TornadoPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_TornadoDust> dust;

  _TornadoPainter({
    required this.progress,
    required this.color,
    required this.dust,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double maxW = size.width * 0.45;
    final double funnelHeight = size.height * 0.8;

    final dustPaint = Paint()..style = PaintingStyle.fill;

    for (var particle in dust) {
      // Particles rise up from bottom to top vertically
      final localProg =
          (progress * particle.speedOffset + particle.seedY) % 1.0;
      final y = size.height * 0.9 - (funnelHeight * localProg);

      // As they rise, the orbital radius expands (funnel shape)
      final radius = maxW * (0.15 + 0.85 * localProg);
      final angle = particle.angleOffset +
          (localProg * 6 * math.pi); // Sweeping spiral spin

      // 3D squashed perspective circle coordinates
      final x = center.dx + radius * math.cos(angle);
      final perspectiveY =
          y + (radius * 0.22 * math.sin(angle)); // perspective tilt

      final opacity = math.sin(localProg * math.pi).clamp(0.0, 1.0);
      dustPaint.color = color.withValues(alpha: opacity * 0.7);

      canvas.drawCircle(Offset(x, perspectiveY),
          particle.size * (0.8 + localProg * 0.8), dustPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TornadoPainter oldDelegate) => true;
}

/// Periodic volcanic molten eruptions shooting magma sparks under gravity.
class MotionVolcanoLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionVolcanoLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionVolcanoLoader> createState() => _MotionVolcanoLoaderState();
}

class _MotionVolcanoLoaderState extends State<MotionVolcanoLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_MagmaSpark> _sparks = [];
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
      duration: Duration(milliseconds: (2000 / speed).round()),
    )..repeat();

    _controller.addListener(() {
      // Trigger new volcanic blast periodically
      final val = _controller.value;
      if (val > 0.49 && val < 0.51 && _sparks.length < 20) {
        _erupt();
      }
    });

    _erupt();
  }

  void _erupt() {
    for (int i = 0; i < 15; i++) {
      final angle = -math.pi / 2 +
          (_random.nextDouble() * 0.8 -
              0.4); // Erupt straight up with slight spread
      _sparks.add(_MagmaSpark(
        angle: angle,
        velocity: 1.5 + _random.nextDouble() * 2.0,
        size: 1.5 + _random.nextDouble() * 2.5,
        birthTime: _controller.value,
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
          final value = _controller.value;
          // Filter expired magma sparks
          _sparks.removeWhere((p) {
            final t = (value - p.birthTime) % 1.0;
            return t > 0.48;
          });

          return CustomPaint(
            painter: _VolcanoPainter(
              progress: isReduced ? 0.0 : value,
              color: widget.color,
              sparks: _sparks,
            ),
          );
        },
      ),
    );
  }
}

class _MagmaSpark {
  final double angle;
  final double velocity;
  final double size;
  final double birthTime;

  _MagmaSpark({
    required this.angle,
    required this.velocity,
    required this.size,
    required this.birthTime,
  });
}

class _VolcanoPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_MagmaSpark> sparks;

  _VolcanoPainter({
    required this.progress,
    required this.color,
    required this.sparks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double volcanicBaseY = size.height * 0.85;

    // 1. Draw volcano silhouette contour
    final mountainPaint = Paint()
      ..color = const Color(0xFF16141D)
      ..style = PaintingStyle.fill;
    final mountainPath = Path();
    mountainPath.moveTo(size.width * 0.1, size.height * 0.9);
    mountainPath.quadraticBezierTo(size.width * 0.35, size.height * 0.85,
        size.width * 0.42, volcanicBaseY);
    mountainPath.lineTo(size.width * 0.58, volcanicBaseY);
    mountainPath.quadraticBezierTo(size.width * 0.65, size.height * 0.85,
        size.width * 0.9, size.height * 0.9);
    mountainPath.close();
    canvas.drawPath(mountainPath, mountainPaint);

    // Glowing mountain lava chamber peak
    final craterPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawLine(Offset(size.width * 0.42, volcanicBaseY),
        Offset(size.width * 0.58, volcanicBaseY), craterPaint);

    // 2. Draw erupting sparks traveling under Gravity (dx = V*t*cos, dy = V*t*sin + 0.5*g*t^2)
    final sparkPaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final double gravity = 8.0;

    for (var spark in sparks) {
      final t = (progress - spark.birthTime) % 1.0;
      final tSec = t * 12; // Speed multiplier

      // Physics vector calculations
      final dx =
          spark.velocity * tSec * math.cos(spark.angle) * (size.width * 0.15);
      final dy = (spark.velocity * tSec * math.sin(spark.angle) +
              0.5 * gravity * tSec * tSec) *
          (size.height * 0.08);

      final sparkPos = Offset(center.dx + dx, volcanicBaseY + dy);
      final opacity = (1.0 - t / 0.48).clamp(0.0, 1.0);

      // Lava colors (yellow hot center to red cooling edges)
      final sparkColor = Color.lerp(Colors.yellowAccent, color, t / 0.48)!
          .withValues(alpha: opacity);

      // Flare glow
      glowPaint.color = sparkColor.withValues(alpha: opacity * 0.35);
      canvas.drawCircle(sparkPos, spark.size + 2.5, glowPaint);

      sparkPaint.color = sparkColor;
      canvas.drawCircle(sparkPos, spark.size, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _VolcanoPainter oldDelegate) => true;
}

/// Leaves falling gracefully, drifting along lateral sine wind currents.
class MotionLeafWindLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionLeafWindLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionLeafWindLoader> createState() => _MotionLeafWindLoaderState();
}

class _MotionLeafWindLoaderState extends State<MotionLeafWindLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Leaf> _leaves = [];
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

    // Spawn falling leaves across parallax depths
    for (int i = 0; i < 8; i++) {
      _leaves.add(_Leaf(
        startXRatio: _random.nextDouble(),
        speedOffset: 0.6 + _random.nextDouble() * 0.6,
        phase: _random.nextDouble() * 2 * math.pi,
        depthScale: 0.5 + _random.nextDouble() * 0.5,
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
            painter: _LeafWindPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              leaves: _leaves,
            ),
          );
        },
      ),
    );
  }
}

class _Leaf {
  final double startXRatio;
  final double speedOffset;
  final double phase;
  final double depthScale;

  _Leaf({
    required this.startXRatio,
    required this.speedOffset,
    required this.phase,
    required this.depthScale,
  });
}

class _LeafWindPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_Leaf> leaves;

  _LeafWindPainter({
    required this.progress,
    required this.color,
    required this.leaves,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leafPaint = Paint()..style = PaintingStyle.fill;

    for (var leaf in leaves) {
      // Leaves fall from top bounds to bottom bounds
      final localProg = (progress * leaf.speedOffset) % 1.0;
      final y = size.height * (localProg - 0.1);

      // Wind current sine forces drift leaves laterally
      final drift = 12.0 * math.sin(progress * 2 * math.pi * 1.5 + leaf.phase);
      final x = size.width * leaf.startXRatio + drift;

      final opacity = math.sin(localProg * math.pi).clamp(0.0, 1.0);
      final leafSize = 4.0 * leaf.depthScale;

      // Color shifts by depth (shadow green to front light green)
      final activeColor =
          Color.lerp(Colors.green.shade900, color, leaf.depthScale)!
              .withValues(alpha: opacity * 0.8);

      leafPaint.color = activeColor;

      // Render actual curved leaf outline path
      final path = Path();
      canvas.save();
      canvas.translate(x, y);
      canvas
          .rotate(progress * 2 * math.pi * leaf.speedOffset * 0.8 + leaf.phase);

      path.moveTo(0, -leafSize);
      path.quadraticBezierTo(leafSize * 0.6, -leafSize * 0.2, 0, leafSize);
      path.quadraticBezierTo(-leafSize * 0.6, -leafSize * 0.2, 0, -leafSize);
      path.close();

      canvas.drawPath(path, leafPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _LeafWindPainter oldDelegate) => true;
}

/// Moon overlapping the sun creating corona solar flares and ambient shifts.
class MotionSolarEclipseLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionSolarEclipseLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionSolarEclipseLoader> createState() =>
      _MotionSolarEclipseLoaderState();
}

class _MotionSolarEclipseLoaderState extends State<MotionSolarEclipseLoader>
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
            painter: _SolarEclipsePainter(
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

class _SolarEclipsePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glow;

  _SolarEclipsePainter({
    required this.progress,
    required this.color,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width * 0.28;

    // 1. Draw glowing background corona flares
    // When moon aligns perfectly at progress = 0.5, corona flares glow brightest
    final alignmentIntensity = 1.0 - (progress - 0.5).abs() * 2.0;

    final sunPaint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    if (glow) {
      final coronaPaint = Paint()
        ..color = Color.lerp(color, Colors.white, 0.4)!
            .withValues(alpha: 0.35 + 0.55 * alignmentIntensity)
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, 12 + 10 * alignmentIntensity);
      canvas.drawCircle(
          center, radius * (1.1 + 0.3 * alignmentIntensity), coronaPaint);
    }

    // Draw active glowing sun core
    canvas.drawCircle(center, radius, sunPaint);

    // 2. Draw black moon sliding horizontally
    // Moon moves from left dx = -radius*2.2 to right dx = radius*2.2
    final double moonDx = radius * 2.2 * (progress * 2.0 - 1.0);
    final moonPos = Offset(center.dx + moonDx, center.dy);

    final moonPaint = Paint()
      ..color = const Color(0xFF07070E)
      ..style = PaintingStyle.fill;

    // Draw solid eclipsing moon
    canvas.drawCircle(moonPos, radius * 0.99, moonPaint);

    // Lunar rim ring highlight
    if (glow && alignmentIntensity > 0.7) {
      final rimPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.6 * alignmentIntensity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(center, radius * 1.005, rimPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SolarEclipsePainter oldDelegate) => true;
}
