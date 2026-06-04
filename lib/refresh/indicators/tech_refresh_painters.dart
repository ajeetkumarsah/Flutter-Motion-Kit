import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Renders 11 custom-painted high-fidelity technological, flagship, and cyber pull indicators.

// ==========================================
// 1. ROCKET LAUNCH PAINTER
// ==========================================
class MotionRocketLaunchPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final double rocketSize;
  final double flameIntensity;
  final int particleCount;

  MotionRocketLaunchPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.rocketSize,
    required this.flameIntensity,
    required this.particleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    // Rocket vertical offset (translates upwards during active refreshing)
    final launchY = isRefreshing ? -refreshProgress * size.height * 1.2 : 0.0;
    final rCenter = Offset(
        center.dx, center.dy + size.height * 0.2 * (1.0 - progress) + launchY);

    // 1. Draw Engine Flames & exhaust particles
    final flamePaint = Paint()..style = PaintingStyle.fill;
    final rand = math.Random(1111);

    if (progress > 0.1) {
      final activeFlames = (particleCount * progress * flameIntensity).round();
      for (int i = 0; i < activeFlames; i++) {
        final t =
            (rand.nextDouble() + (isRefreshing ? refreshProgress : 0.0)) % 1.0;
        final flameX = rCenter.dx + (rand.nextDouble() - 0.5) * 12.0 * progress;
        // Flames shoot downwards
        final flameY = rCenter.dy + 15 + t * 30.0 * progress;

        flamePaint.color = Color.lerp(Colors.redAccent, Colors.orangeAccent, t)!
            .withValues(alpha: (1.0 - t) * 0.8 * progress);
        canvas.drawCircle(
            Offset(flameX, flameY), (1.0 - t) * 5.0 * progress, flamePaint);
      }
    }

    // 2. Draw Rocket Hull Outline
    final rocketPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final s = rocketSize / 2;
    final rPath = Path()
      // Nose cone
      ..moveTo(rCenter.dx, rCenter.dy - s)
      ..quadraticBezierTo(rCenter.dx + s * 0.4, rCenter.dy - s * 0.3,
          rCenter.dx + s * 0.4, rCenter.dy + s * 0.4)
      // Right wing fin
      ..lineTo(rCenter.dx + s * 0.85, rCenter.dy + s * 0.8)
      ..lineTo(rCenter.dx + s * 0.4, rCenter.dy + s * 0.6)
      // Base engine exhaust bell
      ..lineTo(rCenter.dx + s * 0.2, rCenter.dy + s * 0.6)
      ..lineTo(rCenter.dx + s * 0.15, rCenter.dy + s * 0.75)
      ..lineTo(rCenter.dx - s * 0.15, rCenter.dy + s * 0.75)
      ..lineTo(rCenter.dx - s * 0.2, rCenter.dy + s * 0.6)
      // Left wing fin
      ..lineTo(rCenter.dx - s * 0.4, rCenter.dy + s * 0.6)
      ..lineTo(rCenter.dx - s * 0.85, rCenter.dy + s * 0.8)
      ..lineTo(rCenter.dx - s * 0.4, rCenter.dy + s * 0.4)
      ..quadraticBezierTo(rCenter.dx - s * 0.4, rCenter.dy - s * 0.3,
          rCenter.dx, rCenter.dy - s)
      ..close();

    canvas.drawPath(rPath, fillPaint);
    canvas.drawPath(rPath, rocketPaint);

    // Rocket window
    canvas.drawCircle(Offset(rCenter.dx, rCenter.dy), s * 0.2, rocketPaint);
  }

  @override
  bool shouldRepaint(covariant MotionRocketLaunchPainter oldDelegate) => true;
}

// ==========================================
// 2. DNA HELIX PAINTER
// ==========================================
class MotionDnaHelixPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final Color strandColorB;
  final int nodeCount;
  final double rotationSpeed;

  MotionDnaHelixPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.strandColorB,
    required this.nodeCount,
    required this.rotationSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);
    final time = isRefreshing
        ? refreshProgress * 2 * math.pi * rotationSpeed
        : pullProgress * math.pi * 0.5;

    final linePaint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()..style = PaintingStyle.fill;

    // Draw vertical DNA helix strands
    for (int i = 0; i < nodeCount; i++) {
      final tFraction = i / (nodeCount - 1);
      final py = size.height * 0.15 + tFraction * size.height * 0.7 * progress;

      // Elliptic trigonometric depth mapping
      final angle = time * 2.0 + tFraction * 3.0 * math.pi;

      final widthScale = size.width * 0.35 * progress;
      final pxA = size.width / 2 + math.sin(angle) * widthScale;
      final pxB = size.width / 2 - math.sin(angle) * widthScale;

      final zDepthA = math.cos(angle); // -1.0 to 1.0
      final zDepthB = -zDepthA;

      // Draw connection rung between nodes
      final rungOpacity = (0.1 + (zDepthA + zDepthB + 2.0) * 0.1) * progress;
      linePaint.color =
          Colors.white.withValues(alpha: rungOpacity.clamp(0.0, 1.0));
      canvas.drawLine(Offset(pxA, py), Offset(pxB, py), linePaint);

      // Node A: Primary color strand
      final nodeRadiusA = 2.5 + (zDepthA + 1.0) * 1.5;
      final opacityA = 0.3 + (zDepthA + 1.0) * 0.35;
      nodePaint.color = Color.lerp(color, Colors.white, (zDepthA + 1.0) / 4.0)!
          .withValues(alpha: opacityA * progress);
      canvas.drawCircle(Offset(pxA, py), nodeRadiusA, nodePaint);

      // Node B: Secondary color strand
      final nodeRadiusB = 2.5 + (zDepthB + 1.0) * 1.5;
      final opacityB = 0.3 + (zDepthB + 1.0) * 0.35;
      nodePaint.color =
          Color.lerp(strandColorB, Colors.white, (zDepthB + 1.0) / 4.0)!
              .withValues(alpha: opacityB * progress);
      canvas.drawCircle(Offset(pxB, py), nodeRadiusB, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionDnaHelixPainter oldDelegate) => true;
}

// ==========================================
// 3. JELLY BOUNCE PAINTER
// ==========================================
class MotionJellyBouncePainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final double elasticity;
  final int bounceCount;

  MotionJellyBouncePainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.elasticity,
    required this.bounceCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double wobbleY = size.height * 0.45;

    if (!isRefreshing) {
      // Pulling phase: stretched canvas base
      wobbleY =
          (pullProgress * size.height * 0.65).clamp(0.0, size.height * 0.85);
    } else {
      // Refreshing phase: wobbling elastic spring physics
      final decay = math.exp(-refreshProgress * 5.0 * elasticity);
      final frequency = bounceCount * 2.0 * math.pi;
      final springHeight = size.height * 0.45;
      wobbleY =
          springHeight + math.sin(refreshProgress * frequency) * 15.0 * decay;
    }

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, wobbleY * 0.3)
      ..quadraticBezierTo(size.width / 2, wobbleY, size.width, wobbleY * 0.3)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MotionJellyBouncePainter oldDelegate) => true;
}

// ==========================================
// 4. INFINITY SYMBOL PAINTER
// ==========================================
class MotionInfinitySymbolPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final double strokeWidth;
  final bool glowEnabled;

  MotionInfinitySymbolPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.strokeWidth,
    required this.glowEnabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    final basePaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw baseline infinity background path using Lemniscate equation
    final infinityPath = Path();
    final a = size.width * 0.32;

    for (int angleDeg = 0; angleDeg <= 360; angleDeg += 4) {
      final rad = angleDeg * math.pi / 180.0;
      final denom = 1 + math.pow(math.sin(rad), 2);
      final x = (a * math.cos(rad)) / denom;
      final y = (a * math.sin(rad) * math.cos(rad)) / denom;

      if (angleDeg == 0) {
        infinityPath.moveTo(center.dx + x, center.dy + y);
      } else {
        infinityPath.lineTo(center.dx + x, center.dy + y);
      }
    }
    infinityPath.close();
    canvas.drawPath(infinityPath, basePaint);

    // Animating glowing trace stroke continuously around the loop
    if (progress > 0.05) {
      final tracePaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth + 0.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..strokeWidth = strokeWidth + 6.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

      final tracePath = Path();

      // Calculate start and end offsets along Lemniscate coordinates
      final time = isRefreshing ? refreshProgress : pullProgress * 0.4;
      final startAngle = (time * 360.0).round();
      final length = (45.0 * progress).round(); // Trace segment length

      for (int i = 0; i <= length; i++) {
        final currentDeg = (startAngle + i) % 360;
        final rad = currentDeg * math.pi / 180.0;
        final denom = 1 + math.pow(math.sin(rad), 2);
        final x = (a * math.cos(rad)) / denom;
        final y = (a * math.sin(rad) * math.cos(rad)) / denom;

        if (i == 0) {
          tracePath.moveTo(center.dx + x, center.dy + y);
        } else {
          tracePath.lineTo(center.dx + x, center.dy + y);
        }
      }

      if (glowEnabled) {
        canvas.drawPath(tracePath, glowPaint);
      }
      canvas.drawPath(tracePath, tracePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionInfinitySymbolPainter oldDelegate) => true;
}

// ==========================================
// 5. NEURAL NETWORK PAINTER
// ==========================================
class MotionNeuralNetworkPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int nodeCount;
  final double glowRadius;

  MotionNeuralNetworkPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.nodeCount,
    required this.glowRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    final nodePaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()..style = PaintingStyle.stroke;

    // Seed locations using math to avoid mutable state inside paint
    final List<Offset> points = [];
    final rand = math.Random(98765);

    final activeNodes = (nodeCount * progress).round();
    final maxDistance = size.width * 0.35 * progress;

    for (int i = 0; i < activeNodes; i++) {
      final initialAngle = i * (2 * math.pi / activeNodes);
      final rOffset = 10.0 + rand.nextDouble() * (size.width * 0.32);

      // Gentle orbit drift
      final driftTime = isRefreshing ? refreshProgress * 2 * math.pi : 0.0;
      final angle = initialAngle + driftTime * 0.25;

      final px = center.dx + rOffset * math.cos(angle) * progress;
      final py = center.dy + rOffset * math.sin(angle) * progress;
      points.add(Offset(px, py));
    }

    // 1. Draw connecting synaptic wires
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final dist = (points[i] - points[j]).distance;
        if (dist < maxDistance) {
          final opacity = (1.0 - (dist / maxDistance)).clamp(0.0, 0.45);
          linePaint
            ..color = color.withValues(alpha: opacity)
            ..strokeWidth = 1.0;
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }

    // 2. Draw synaptic nodes
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);

    for (int i = 0; i < points.length; i++) {
      final pulse = isRefreshing
          ? 1.0 + 0.25 * math.sin(refreshProgress * 4 * math.pi + i)
          : 1.0;
      final nRadius = 3.0 * progress * pulse;

      canvas.drawCircle(points[i], nRadius + 2.5, glowPaint);

      nodePaint.color = Color.lerp(color, Colors.white, 0.25 * (1.0 - pulse))!;
      canvas.drawCircle(points[i], nRadius, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionNeuralNetworkPainter oldDelegate) => true;
}

// ==========================================
// 6. CLOCKWORK PAINTER
// ==========================================
class MotionClockworkPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int gearCount;
  final double gearSize;

  MotionClockworkPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.gearCount,
    required this.gearSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);
    final time = isRefreshing
        ? refreshProgress * 2 * math.pi
        : pullProgress * math.pi * 0.8;

    // Renders interlocking differential gears
    final centerGear = Offset(size.width / 2, size.height / 2);
    _drawProceduralGear(
        canvas, centerGear, gearSize * 0.8 * progress, time, 12);

    if (gearCount >= 2) {
      // Secondary interlocking gear engaged radially
      final offsetDist = gearSize * 0.95 * progress;
      final secondaryCenter = Offset(centerGear.dx + offsetDist, centerGear.dy);
      // Differential counter-rotations
      final rot2 = -time * 1.5;
      _drawProceduralGear(
          canvas, secondaryCenter, gearSize * 0.5 * progress, rot2, 8);
    }

    if (gearCount >= 3) {
      // Tertiary gear engaged vertically
      final offsetDist = gearSize * 0.95 * progress;
      final tertiaryCenter = Offset(centerGear.dx, centerGear.dy - offsetDist);
      final rot3 = -time * 1.5;
      _drawProceduralGear(
          canvas, tertiaryCenter, gearSize * 0.5 * progress, rot3, 8);
    }
  }

  void _drawProceduralGear(Canvas canvas, Offset center, double radius,
      double rotation, int teethCount) {
    if (radius <= 1.0) return;

    final gearPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final path = Path();
    final step = 2 * math.pi / teethCount;

    for (int i = 0; i < teethCount; i++) {
      final baseAngle = i * step + rotation;

      // Draw gear teeth geometry: inner, tip, and transitions
      final a1 = baseAngle - step * 0.25;
      final a2 = baseAngle - step * 0.12;
      final a3 = baseAngle + step * 0.12;
      final a4 = baseAngle + step * 0.25;

      final innerR = radius * 0.82;
      final outerR = radius * 1.15;

      if (i == 0) {
        path.moveTo(center.dx + innerR * math.cos(a1),
            center.dy + innerR * math.sin(a1));
      } else {
        path.lineTo(center.dx + innerR * math.cos(a1),
            center.dy + innerR * math.sin(a1));
      }

      path.lineTo(
          center.dx + outerR * math.cos(a2), center.dy + outerR * math.sin(a2));
      path.lineTo(
          center.dx + outerR * math.cos(a3), center.dy + outerR * math.sin(a3));
      path.lineTo(
          center.dx + innerR * math.cos(a4), center.dy + innerR * math.sin(a4));
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, gearPaint);

    // Inner axle ring
    canvas.drawCircle(center, radius * 0.35, gearPaint);
    canvas.drawCircle(center, 2.5, gearPaint);
  }

  @override
  bool shouldRepaint(covariant MotionClockworkPainter oldDelegate) => true;
}

// ==========================================
// 7. ORIGAMI BIRD PAINTER
// ==========================================
class MotionOrigamiBirdPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final double birdScale;

  MotionOrigamiBirdPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.birdScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final s = birdScale * progress;
    final flap = isRefreshing
        ? math.sin(refreshProgress * 4 * math.pi) * (s * 0.45)
        : 0.0;

    // Origami vector folding coordinates
    final origamiPath = Path()
      // Body centerline
      ..moveTo(center.dx - s, center.dy) // tail
      ..lineTo(center.dx + s * 0.8, center.dy - s * 0.1) // head
      ..lineTo(center.dx + s * 0.4, center.dy + s * 0.35) // chest
      ..lineTo(center.dx - s, center.dy) // tail

      // Right wing facet panel
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx + s * 0.25, center.dy - s - flap)
      ..lineTo(center.dx + s * 0.45, center.dy - s * 0.1)
      ..lineTo(center.dx, center.dy)

      // Left wing facet panel
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx - s * 0.1, center.dy + s + flap)
      ..lineTo(center.dx + s * 0.4, center.dy + s * 0.35)
      ..lineTo(center.dx, center.dy)

      // Origami head crease segment
      ..moveTo(center.dx + s * 0.8, center.dy - s * 0.1)
      ..lineTo(center.dx + s * 1.15, center.dy + s * 0.1)
      ..lineTo(center.dx + s * 0.7, center.dy + s * 0.2)
      ..close();

    canvas.drawPath(origamiPath, fillPaint);
    canvas.drawPath(origamiPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant MotionOrigamiBirdPainter oldDelegate) => true;
}

// ==========================================
// 8. LIGHTNING CHARGE PAINTER
// ==========================================
class MotionLightningChargePainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int boltCount;
  final double chargeLevel;

  MotionLightningChargePainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.boltCount,
    required this.chargeLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    // 1. Draw capacitor/battery outline charging
    final boxPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final boxRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.55,
      height: 25.0 * progress,
    );
    canvas.drawRRect(
        RRect.fromRectAndRadius(boxRect, const Radius.circular(6)), boxPaint);

    // Charging liquid level
    if (progress > 0.05) {
      final fillPaint = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;
      final chargeW = size.width * 0.53 * progress * chargeLevel;
      final fillRect = Rect.fromLTWH(
        boxRect.left + 2,
        boxRect.top + 2,
        chargeW,
        boxRect.height - 4,
      );
      canvas.drawRRect(
          RRect.fromRectAndRadius(fillRect, const Radius.circular(4)),
          fillPaint);
    }

    // 2. Draw Branching Neon Lightning bolts upon release/refresh
    if (isRefreshing) {
      final boltPaint = Paint()
        ..color = Color.lerp(color, Colors.white, 0.45)!
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;

      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..strokeWidth = 7.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      final rand = math.Random(
          (refreshProgress * 15).floor()); // Generates crackle subdivisions

      for (int b = 0; b < boltCount; b++) {
        final startX = size.width * 0.25 + b * (size.width * 0.5 / boltCount);
        final startPoint = Offset(startX, boxRect.top + 2);

        final boltPath = Path()..moveTo(startPoint.dx, startPoint.dy);
        Offset currentPoint = startPoint;

        while (currentPoint.dy < boxRect.bottom - 2) {
          final dy = 6.0;
          final dx = (rand.nextDouble() - 0.5) * 12.0;
          currentPoint = Offset(currentPoint.dx + dx, currentPoint.dy + dy);
          boltPath.lineTo(currentPoint.dx, currentPoint.dy);
        }

        canvas.drawPath(boltPath, glowPaint);
        canvas.drawPath(boltPath, boltPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MotionLightningChargePainter oldDelegate) =>
      true;
}

// ==========================================
// 9. FIREWORKS PAINTER
// ==========================================
class MotionFireworksPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int explosionCount;
  final int particleCount;

  MotionFireworksPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.explosionCount,
    required this.particleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    if (!isRefreshing) {
      // Pulling phase: Rockets rising upwards
      final rocketPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      final rocketY = size.height - progress * size.height * 0.5;

      canvas.drawCircle(Offset(size.width / 2, rocketY), 3.0, rocketPaint);
      canvas.drawLine(
        Offset(size.width / 2, size.height),
        Offset(size.width / 2, rocketY),
        Paint()
          ..color = color.withValues(alpha: 0.15)
          ..strokeWidth = 1.0,
      );
    } else {
      // Refreshing phase: Exploding firework bursts under gravity
      final pPaint = Paint()..style = PaintingStyle.fill;
      final rand = math.Random(4567);

      for (int exp = 0; exp < explosionCount; exp++) {
        // Multi-point explosion centers
        final cx = size.width * 0.25 +
            exp *
                (size.width *
                    0.5 /
                    (explosionCount > 1 ? (explosionCount - 1) : 1));
        final cy = size.height * 0.35 + (exp % 2 == 0 ? -10.0 : 10.0);
        final center = Offset(cx, cy);

        final expProgress = (refreshProgress * 1.5 - exp * 0.2) % 1.0;
        if (expProgress <= 0.0) continue;

        for (int i = 0; i < particleCount; i++) {
          final initialAngle =
              i * (2 * math.pi / particleCount) + rand.nextDouble();
          final speed = 0.5 + rand.nextDouble() * 0.5;

          // Expanding radius with gravity drag
          final radius = size.width * 0.35 * expProgress * speed;
          final px = center.dx + radius * math.cos(initialAngle);

          // gravity coordinates pulling embers downwards
          final gravity = 25.0 * math.pow(expProgress, 2.0);
          final py = center.dy + radius * math.sin(initialAngle) + gravity;

          final scale = (1.0 - expProgress) * 4.0;
          final opacity = (1.0 - expProgress) * 0.85;

          pPaint.color = Color.lerp(color, Colors.orangeAccent, expProgress)!
              .withValues(alpha: opacity.clamp(0.0, 1.0));

          canvas.drawCircle(Offset(px, py), scale, pPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MotionFireworksPainter oldDelegate) => true;
}

// ==========================================
// 10. HOLOGRAM PAINTER
// ==========================================
class MotionHologramPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final double scanSpeed;
  final double glitchAmount;

  MotionHologramPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.scanSpeed,
    required this.glitchAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);
    final time = isRefreshing ? refreshProgress : pullProgress * 0.5;

    // 1. Draw backing technological hologram perspective grid
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.06 * progress)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final cell = size.width / 8;
    for (double i = cell; i < size.width; i += cell) {
      canvas.drawLine(
          Offset(i, 0), Offset(i, size.height * progress), gridPaint);
      canvas.drawLine(
          Offset(0, i * progress), Offset(size.width, i * progress), gridPaint);
    }

    // 2. Draw moving scan lines
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.25 * progress)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Dynamic scan line y index
    final scanY = (time * scanSpeed * size.height) % size.height;

    // Simulate glitch horizontal offsets
    final rand = math.Random((time * 30).floor());
    double glitchX = 0.0;
    if (rand.nextDouble() < 0.15 * glitchAmount) {
      glitchX = (rand.nextDouble() - 0.5) * 16.0 * glitchAmount;
    }

    canvas.drawLine(Offset(0, scanY), Offset(size.width, scanY), linePaint);

    // Draw target tracking circle with retro glitch elements
    final trackingPaint = Paint()
      ..color = color.withValues(alpha: 0.45 * progress)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2 + glitchX, size.height / 2);
    final tRadius = size.width * 0.18 * progress;
    canvas.drawCircle(center, tRadius, trackingPaint);

    // Four outer crosshair brackets
    final bracketLen = 6.0 * progress;
    canvas.drawLine(Offset(center.dx - tRadius, center.dy),
        Offset(center.dx - tRadius + bracketLen, center.dy), trackingPaint);
    canvas.drawLine(Offset(center.dx + tRadius, center.dy),
        Offset(center.dx + tRadius - bracketLen, center.dy), trackingPaint);
    canvas.drawLine(Offset(center.dx, center.dy - tRadius),
        Offset(center.dx, center.dy - tRadius + bracketLen), trackingPaint);
    canvas.drawLine(Offset(center.dx, center.dy + tRadius),
        Offset(center.dx, center.dy + tRadius - bracketLen), trackingPaint);
  }

  @override
  bool shouldRepaint(covariant MotionHologramPainter oldDelegate) => true;
}

// ==========================================
// 11. SIGNATURE PAINTER
// ==========================================
class MotionSignaturePainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int particleCount;
  final double glowStrength;

  MotionSignaturePainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.particleCount,
    required this.glowStrength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    // Hardcoded target keypoints representing standard 'M' logo shape
    final s = size.width * 0.22 * progress;
    final List<Offset> logoTargets = [
      Offset(center.dx - s, center.dy + s), // Left base
      Offset(center.dx - s, center.dy - s * 0.8), // Left peak
      Offset(center.dx, center.dy + s * 0.25), // Center dip
      Offset(center.dx + s, center.dy - s * 0.8), // Right peak
      Offset(center.dx + s, center.dy + s), // Right base
    ];

    final pPaint = Paint()..style = PaintingStyle.fill;
    final rand = math.Random(24680);

    // Particles gather according to pullProgress and lock into 'M' logo points
    for (int i = 0; i < particleCount; i++) {
      final targetIndex = i % logoTargets.length;
      final target = logoTargets[targetIndex];

      // Initial scattered coordinates
      final seedAngle = i * (2 * math.pi / particleCount) + rand.nextDouble();
      final seedRadius = size.width * 0.45 * (0.8 + rand.nextDouble() * 0.4);
      final scatterPoint = Offset(
        center.dx + seedRadius * math.cos(seedAngle),
        center.dy + seedRadius * math.sin(seedAngle),
      );

      // Lerp between scattered positions and M logo targets
      final gather = progress;
      final px = lerpDouble(scatterPoint.dx, target.dx, gather)!;
      final py = lerpDouble(scatterPoint.dy, target.dy, gather)!;

      // Pulse scaling on active refreshing
      final pulse = isRefreshing
          ? 1.0 + 0.15 * math.sin(refreshProgress * 4 * math.pi + i)
          : 1.0;
      final pRadius = (2.0 + rand.nextDouble() * 2.0) * progress * pulse;

      pPaint.color = Color.lerp(color, Colors.white, i / particleCount)!
          .withValues(alpha: progress);
      canvas.drawCircle(Offset(px, py), pRadius, pPaint);
    }

    // Connect targeted nodes with fine neon lines
    if (progress > 0.15) {
      final linePaint = Paint()
        ..color = color.withValues(alpha: 0.3 * progress)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      final path = Path()..moveTo(logoTargets[0].dx, logoTargets[0].dy);
      for (int i = 1; i < logoTargets.length; i++) {
        path.lineTo(logoTargets[i].dx, logoTargets[i].dy);
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionSignaturePainter oldDelegate) => true;
}
