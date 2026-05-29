import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_colors.dart';

/// Gaming Category styles & enums.
enum MotionGamingStyle {
  /// Circular golden shield progress bar emitting floating level-up energy sparks.
  xpProgress,

  /// Dual counter-rotating RPG magic circles emitting radial fire bursts.
  bossFight,

  /// Retro arcade style 8-bit glitched grid blocks scaling in sequence.
  pixel,
}

/// Sweeping golden shield progress bar emitting floating level-up energy sparks.
class MotionXpProgressLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionXpProgressLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionXpProgressLoader> createState() => _MotionXpProgressLoaderState();
}

class _MotionXpProgressLoaderState extends State<MotionXpProgressLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_XpSpark> _sparks = [];
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
      duration: Duration(milliseconds: (2500 / speed).round()),
    )..repeat();

    // Setup sparkling energy packets
    for (int i = 0; i < 12; i++) {
      _sparks.add(_XpSpark(
        angleOffset: _random.nextDouble() * 2 * math.pi,
        speed: 0.5 + _random.nextDouble() * 1.0,
        distanceFactor: 0.8 + _random.nextDouble() * 0.4,
        size: 1.5 + _random.nextDouble() * 2.0,
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
          // Add level up elastic bounce scale-up effect
          final progress = isReduced ? 0.0 : _controller.value;
          final isNearCompletion = progress > 0.85;
          final double scale = isNearCompletion
              ? 1.0 + 0.12 * math.sin((progress - 0.85) * (math.pi / 0.15))
              : 1.0;

          return Transform.scale(
            scale: scale,
            child: CustomPaint(
              painter: _XpProgressPainter(
                progress: progress,
                color: widget.color,
                sparks: _sparks,
                glow: widget.glow && !(motion?.performanceMode ?? false),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _XpSpark {
  final double angleOffset;
  final double speed;
  final double distanceFactor;
  final double size;

  _XpSpark({
    required this.angleOffset,
    required this.speed,
    required this.distanceFactor,
    required this.size,
  });
}

class _XpProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_XpSpark> sparks;
  final bool glow;

  _XpProgressPainter({
    required this.progress,
    required this.color,
    required this.sparks,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Draw background track ring
    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(center, radius, trackPaint);

    // Draw sweeping golden arcade ring
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color,
          const Color(0xFFFFD700), // Gold highlight
        ],
        stops: const [0.0, 0.7, 1.0],
        transform: GradientRotation(-math.pi / 2 + progress * 2 * math.pi),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progress * 2 * math.pi,
      false,
      progressPaint,
    );

    // Glowing shield core
    if (glow) {
      final coreGlow = Paint()
        ..color = color.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(center, radius - 4, coreGlow);
    }

    // RPG central emblem (Shield / Crossed swords placeholder)
    final emblemPaint = Paint()
      ..color = Color.lerp(color, const Color(0xFFFFD700), 0.5)!
          .withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final emblemPath = Path();
    final shieldRadius = radius * 0.5;
    // Draw simplified heroic dynamic crest shape inside shield
    emblemPath.moveTo(center.dx, center.dy - shieldRadius);
    emblemPath.quadraticBezierTo(
        center.dx + shieldRadius * 0.8,
        center.dy - shieldRadius * 0.8,
        center.dx + shieldRadius * 0.7,
        center.dy);
    emblemPath.quadraticBezierTo(
        center.dx + shieldRadius * 0.6,
        center.dy + shieldRadius * 0.7,
        center.dx,
        center.dy + shieldRadius * 1.1);
    emblemPath.quadraticBezierTo(
        center.dx - shieldRadius * 0.6,
        center.dy + shieldRadius * 0.7,
        center.dx - shieldRadius * 0.7,
        center.dy);
    emblemPath.quadraticBezierTo(center.dx - shieldRadius * 0.8,
        center.dy - shieldRadius * 0.8, center.dx, center.dy - shieldRadius);
    emblemPath.close();

    canvas.drawPath(emblemPath, emblemPaint);

    // Draw energy sparks escaping upwards
    final sparkPaint = Paint()..style = PaintingStyle.fill;
    for (var spark in sparks) {
      final localProg = (progress * spark.speed) % 1.0;
      final dist = radius * (1.0 + 0.3 * localProg * spark.distanceFactor);
      final angle =
          spark.angleOffset + (localProg * math.pi * 0.3); // Slight float swirl

      final sparkPos = Offset(
        center.dx + dist * math.cos(angle),
        center.dy + dist * math.sin(angle),
      );

      final opacity = (1.0 - localProg).clamp(0.0, 1.0);
      sparkPaint.color =
          const Color(0xFFFFD700).withValues(alpha: opacity * 0.9);
      canvas.drawCircle(
          sparkPos, spark.size * (1.0 - localProg * 0.5), sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _XpProgressPainter oldDelegate) => true;
}

/// Dual counter-rotating RPG magic circles emitting radial fire bursts.
class MotionBossFightLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionBossFightLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionBossFightLoader> createState() => _MotionBossFightLoaderState();
}

class _MotionBossFightLoaderState extends State<MotionBossFightLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FireParticle> _fireParticles = [];
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

    _controller.addListener(() {
      // Periodic pulse triggering shockwave fire rings
      final value = _controller.value;
      if (value > 0.49 && value < 0.51 && _fireParticles.length < 15) {
        _spawnShockwave();
      }
    });

    _spawnShockwave();
  }

  void _spawnShockwave() {
    for (int i = 0; i < 18; i++) {
      final angle = (i * 2 * math.pi) / 18;
      _fireParticles.add(_FireParticle(
        angle: angle + (_random.nextDouble() * 0.15 - 0.075),
        speed: 1.2 + _random.nextDouble() * 0.8,
        size: 2.0 + _random.nextDouble() * 3.0,
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
          // Filter out older particles
          final value = _controller.value;
          _fireParticles.removeWhere((p) {
            final t = (value - p.birthTime) % 1.0;
            return t > 0.45;
          });

          return CustomPaint(
            painter: _BossFightPainter(
              progress: isReduced ? 0.0 : value,
              color: widget.color,
              particles: _fireParticles,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _FireParticle {
  final double angle;
  final double speed;
  final double size;
  final double birthTime;

  _FireParticle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.birthTime,
  });
}

class _BossFightPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_FireParticle> particles;
  final bool glow;

  _BossFightPainter({
    required this.progress,
    required this.color,
    required this.particles,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.45;

    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 1. Draw outer magic runic circle (rotates clockwise)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * math.pi);

    // Runic ring border
    canvas.drawCircle(Offset.zero, maxRadius, ringPaint);
    canvas.drawCircle(Offset.zero, maxRadius * 0.85, ringPaint);

    // Draw 8 magic runes ticks
    final runePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0;
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi) / 8;
      canvas.drawLine(
        Offset(maxRadius * 0.85 * math.cos(angle),
            maxRadius * 0.85 * math.sin(angle)),
        Offset(maxRadius * math.cos(angle), maxRadius * math.sin(angle)),
        runePaint,
      );
    }
    canvas.restore();

    // 2. Draw inner magic pattern (rotates counter-clockwise)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-progress * 2 * math.pi * 1.5);

    // Inner pentagram / triangle star pattern
    final starPaint = Paint()
      ..color = MotionColors.secondaryNeon.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final starPath = Path();
    final innerR = maxRadius * 0.75;
    for (int i = 0; i < 3; i++) {
      final angle = (i * 2 * math.pi) / 3;
      final x = innerR * math.cos(angle);
      final y = innerR * math.sin(angle);
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, starPaint);

    canvas.restore();

    // 3. Draw active shockwave explosion particles
    final particlePaint = Paint()..style = PaintingStyle.fill;
    final fireColors = [
      Colors.white,
      const Color(0xFFFF4B2B), // Flare Red
      const Color(0xFFFFD700), // Fire Yellow
    ];

    for (var p in particles) {
      final t = (progress - p.birthTime) % 1.0;
      final travelDistance =
          maxRadius * 0.45 + (maxRadius * 0.85 * t * p.speed);

      final pos = Offset(
        center.dx + travelDistance * math.cos(p.angle),
        center.dy + travelDistance * math.sin(p.angle),
      );

      final fade = (1.0 - t / 0.45).clamp(0.0, 1.0);
      final cIdx = (t * 3 * p.speed).floor().clamp(0, fireColors.length - 1);

      particlePaint.color = fireColors[cIdx].withValues(alpha: fade * 0.95);
      canvas.drawCircle(pos, p.size * fade, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BossFightPainter oldDelegate) => true;
}

/// Retro arcade style 8-bit glitched grid blocks scaling in sequence.
class MotionPixelLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionPixelLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionPixelLoader> createState() => _MotionPixelLoaderState();
}

class _MotionPixelLoaderState extends State<MotionPixelLoader>
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
            painter: _PixelGridPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _PixelGridPainter extends CustomPainter {
  final double progress;
  final Color color;

  _PixelGridPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridCount = 4; // 4x4 Pixel block grid
    final padding = 3.0;
    final cellSize = (size.width - (padding * (gridCount - 1))) / gridCount;

    final cellPaint = Paint()..style = PaintingStyle.fill;
    final rand = math.Random(12345);

    // Simulate retro CRT screen flicker scanlines
    final scanlineColor = Colors.white.withValues(alpha: 0.05);
    final scanlinePaint = Paint()
      ..color = scanlineColor
      ..strokeWidth = 1.0;

    for (int y = 0; y < gridCount; y++) {
      for (int x = 0; x < gridCount; x++) {
        // Calculate unique spatial sequence delay
        final cellIndex = y * gridCount + x;
        final cellDelay = cellIndex / (gridCount * gridCount);

        final localProg = (progress - cellDelay) % 1.0;
        final scale = 0.35 + 0.65 * math.sin(localProg * math.pi);

        final cellX = x * (cellSize + padding);
        final cellY = y * (cellSize + padding);

        final centerCellX = cellX + cellSize / 2;
        final centerCellY = cellY + cellSize / 2;

        final scaledCellSize = cellSize * scale;

        // Apply dynamic glitch color shifts (neon cyan / red-purple spikes)
        final colorRand = rand.nextDouble();
        Color cellColor = color;
        if (localProg < 0.08 && colorRand < 0.15) {
          cellColor =
              MotionColors.secondaryNeon; // 8-bit cyber pink glitch trigger
        } else if (localProg < 0.08 && colorRand > 0.85) {
          cellColor = Colors.yellowAccent;
        }

        cellPaint.color =
            cellColor.withValues(alpha: (0.15 + 0.85 * scale).clamp(0.0, 1.0));

        final rect = Rect.fromCenter(
          center: Offset(centerCellX, centerCellY),
          width: scaledCellSize,
          height: scaledCellSize,
        );

        // Draw 8-bit block pixels
        canvas.drawRect(rect, cellPaint);
      }
    }

    // Draw CRT scanning line
    final scanY = size.height * progress;
    canvas.drawLine(Offset(0, scanY), Offset(size.width, scanY), scanlinePaint);
  }

  @override
  bool shouldRepaint(covariant _PixelGridPainter oldDelegate) => true;
}
