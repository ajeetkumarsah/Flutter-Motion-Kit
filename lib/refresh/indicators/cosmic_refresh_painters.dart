import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Renders 4 custom-painted gravitational, orbit, and cosmic pull indicators.

// ==========================================
// 1. BLACK HOLE PAINTER
// ==========================================
class MotionBlackHolePainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int particleCount;
  final double eventHorizonSize;
  final double gravityStrength;
  final double rotationSpeed;

  MotionBlackHolePainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.particleCount,
    required this.eventHorizonSize,
    required this.gravityStrength,
    required this.rotationSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    // 1. Draw glowing event horizon core in the center
    final corePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final coreRadius = (eventHorizonSize / 2) * (0.5 + progress * 0.5);
    final pulse = isRefreshing
        ? 1.0 + 0.15 * math.sin(refreshProgress * 4 * math.pi)
        : 1.0;

    // Draw event horizon glow and solid core
    canvas.drawCircle(center, coreRadius * pulse + 4, glowPaint);
    canvas.drawCircle(center, coreRadius * pulse, corePaint);

    // Outline accent ring
    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, coreRadius * pulse, borderPaint);

    // 2. Draw spiraling accretion disk particles
    final pPaint = Paint()..style = PaintingStyle.fill;
    final rand = math.Random(12345);

    for (int i = 0; i < particleCount; i++) {
      final initialAngle =
          i * (2 * math.pi / particleCount) + rand.nextDouble();
      final speedFactor = 0.5 + rand.nextDouble() * 0.5;

      // Spiraling collapse physics loop
      double t = (isRefreshing
              ? (refreshProgress * speedFactor * rotationSpeed)
              : (pullProgress * 0.5 * speedFactor * rotationSpeed)) %
          1.0;

      // As progress reaches threshold, gravity draws stars into a logarithmic spiral
      final attraction = math.pow(1.0 - t, 2) * gravityStrength;
      final currentRadius =
          (size.width * 0.45 * (1.0 - progress * 0.5)) * attraction +
              coreRadius;

      final currentAngle = initialAngle + t * 4 * math.pi;
      final px = center.dx + currentRadius * math.cos(currentAngle);
      final py = center.dy + currentRadius * math.sin(currentAngle);

      final pScale = 1.5 + (1.0 - t) * 2.0;
      final opacity = (1.0 - t).clamp(0.0, 1.0) * progress;

      pPaint.color = Color.lerp(color, Colors.white, 1.0 - t)!
          .withValues(alpha: opacity.clamp(0.0, 1.0));

      canvas.drawCircle(Offset(px, py), pScale, pPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionBlackHolePainter oldDelegate) => true;
}

// ==========================================
// 2. PLANET ORBIT PAINTER
// ==========================================
class MotionPlanetOrbitPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int planetCount;
  final double planetSize;
  final double orbitSpeed;

  MotionPlanetOrbitPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.planetCount,
    required this.planetSize,
    required this.orbitSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    // 1. Central Golden Star (Sun)
    final sunPaint = Paint()
      ..color = Colors.amberAccent
      ..style = PaintingStyle.fill;
    final sunGlow = Paint()
      ..color = Colors.amber.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final sunPulse = isRefreshing
        ? 1.0 + 0.1 * math.sin(refreshProgress * 6 * math.pi)
        : 1.0;
    canvas.drawCircle(center, 7.0 * sunPulse + 3, sunGlow);
    canvas.drawCircle(center, 7.0 * sunPulse, sunPaint);

    // 2. Concentric Orbit Rings & Planets
    final orbitPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final planetPaint = Paint()..style = PaintingStyle.fill;
    final time = isRefreshing
        ? refreshProgress * 2 * math.pi * orbitSpeed
        : pullProgress * math.pi * 0.2;

    for (int i = 0; i < planetCount; i++) {
      // Planet orbit radiuses spaced out
      final baseRadius =
          (16.0 + i * (size.width * 0.35 / planetCount)) * progress;

      // Draw elliptic orbit paths
      canvas.drawCircle(center, baseRadius, orbitPaint);

      // Orbital trigonometric calculations
      final speedScale = 1.0 / (i + 1); // Closer planets orbit faster
      final angle = time * speedScale + (i * 2.0 * math.pi / planetCount);
      final px = center.dx + baseRadius * math.cos(angle);
      final py = center.dy + baseRadius * math.sin(angle);

      // Depth perspective projection
      final zDepth = math.cos(angle);
      final pRadius =
          (planetSize / 2) * (0.8 + (zDepth + 1.0) * 0.4) * progress;
      final opacity = (0.4 + (zDepth + 1.0) * 0.3) * progress;

      planetPaint.color =
          Color.lerp(color, Colors.white10, (zDepth + 1.0) / 4.0)!
              .withValues(alpha: opacity.clamp(0.0, 1.0));

      canvas.drawCircle(Offset(px, py), pRadius, planetPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionPlanetOrbitPainter oldDelegate) => true;
}

// ==========================================
// 3. MAGNETIC ORB PAINTER
// ==========================================
class MotionMagneticOrbPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int particleCount;
  final double orbRadius;
  final double magneticForce;

  MotionMagneticOrbPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.particleCount,
    required this.orbRadius,
    required this.magneticForce,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    // 1. Draw central core glowing orb
    final orbPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final orbGlow = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final pulse = isRefreshing
        ? 1.0 + 0.12 * math.sin(refreshProgress * 5 * math.pi)
        : 1.0;
    final currentOrbRadius = orbRadius * progress * pulse;

    canvas.drawCircle(center, currentOrbRadius + 4, orbGlow);
    canvas.drawCircle(center, currentOrbRadius, orbPaint);

    // 2. Draw magnetic filings flowing into the orb
    final filingPaint = Paint()..style = PaintingStyle.fill;
    final rand = math.Random(67890);

    for (int i = 0; i < particleCount; i++) {
      final initialAngle =
          i * (2 * math.pi / particleCount) + rand.nextDouble();
      final speedFactor = 0.6 + rand.nextDouble() * 0.4;

      // Filings pull progress coordinate
      double t = (isRefreshing
              ? (refreshProgress * speedFactor * 1.5)
              : (pullProgress * 0.7 * speedFactor)) %
          1.0;

      // Physics equation: Attraction pulls filings inwards
      // Attraction scales with magneticForce attribute
      final pullStrength = math.pow(1.0 - t, 3.0 * magneticForce);
      final currentRadius =
          (size.width * 0.48 * pullStrength) + currentOrbRadius;

      final px = center.dx + currentRadius * math.cos(initialAngle);
      final py = center.dy + currentRadius * math.sin(initialAngle);

      // Filings lengthen/align along magnetic field lines
      final opacity = (1.0 - t).clamp(0.0, 1.0) * progress;
      filingPaint.color =
          Color.lerp(color, Colors.white, 1.0 - t)!.withValues(alpha: opacity);

      // Draw elongated filing lines
      final endX = px + 4.0 * (1.0 - t) * math.cos(initialAngle) * progress;
      final endY = py + 4.0 * (1.0 - t) * math.sin(initialAngle) * progress;

      final filingLinePaint = Paint()
        ..color = filingPaint.color
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(px, py), Offset(endX, endY), filingLinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionMagneticOrbPainter oldDelegate) => true;
}

// ==========================================
// 4. PORTAL PAINTER
// ==========================================
class MotionPortalPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int particleCount;
  final double portalRadius;
  final double swirlSpeed;

  MotionPortalPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.particleCount,
    required this.portalRadius,
    required this.swirlSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    final activeRadius = portalRadius * progress;
    final time =
        isRefreshing ? refreshProgress * 2 * math.pi : pullProgress * math.pi;

    // 1. Draw alternating rotating depth rings
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    const layerCount = 3;
    for (int l = 0; l < layerCount; l++) {
      final ringRadius = activeRadius * (1.0 - l * 0.25);
      final strokeW = 3.5 - l * 0.8;

      // Alternate rotations
      final rot = time * swirlSpeed * (l % 2 == 0 ? 1.0 : -1.2);

      // Sweep shader creates gaseous swirl depth illusion
      final sweepRect = Rect.fromCircle(center: center, radius: ringRadius);
      final ringShader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.15),
          Color.lerp(color, Colors.cyan, 0.45)!,
          color,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
        transform: GradientRotation(rot),
      ).createShader(sweepRect);

      ringPaint.shader = ringShader;
      ringPaint.strokeWidth = strokeW;
      glowPaint.shader = ringShader;
      glowPaint.strokeWidth = strokeW + 2;

      // Draw swirling portal rings
      canvas.drawCircle(center, ringRadius, glowPaint);
      canvas.drawCircle(center, ringRadius, ringPaint);
    }

    // 2. Draw swirling energy particles floating out of depth
    final pPaint = Paint()..style = PaintingStyle.fill;
    final rand = math.Random(13579);

    for (int i = 0; i < particleCount; i++) {
      final speedFactor = 0.5 + rand.nextDouble() * 0.5;
      final initialAngle =
          i * (2 * math.pi / particleCount) + rand.nextDouble();

      double t = (isRefreshing
              ? (refreshProgress * speedFactor)
              : (pullProgress * 0.4 * speedFactor)) %
          1.0;

      // Swirling portal depth: particles float outwards from center
      final currentRadius = activeRadius * t;
      final angle = initialAngle + t * 5 * math.pi * swirlSpeed;
      final px = center.dx + currentRadius * math.cos(angle);
      final py = center.dy + currentRadius * math.sin(angle);

      final pScale = 1.0 + t * 2.0;
      final opacity = math.sin(t * math.pi) * progress; // Fades in and out

      pPaint.color = Color.lerp(color, Colors.cyanAccent, t)!
          .withValues(alpha: opacity.clamp(0.0, 1.0));

      canvas.drawCircle(Offset(px, py), pScale, pPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionPortalPainter oldDelegate) => true;
}
