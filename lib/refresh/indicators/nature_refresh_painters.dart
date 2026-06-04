import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Renders 5 custom-painted natural and fluid pull-to-refresh animations.

// ==========================================
// 1. LIQUID MORPH PAINTER
// ==========================================
class MotionLiquidMorphPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int rippleCount;
  final double waveHeight;

  MotionLiquidMorphPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.rippleCount,
    required this.waveHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);

    if (!isRefreshing) {
      // Pulling phase: Droplet stretches proportionally to pullProgress
      final stretchY =
          (pullProgress * size.height * 0.8).clamp(0.0, size.height);
      path.lineTo(0, 0);
      path.quadraticBezierTo(
        size.width / 2,
        stretchY *
            2.0, // Double bezier height for a satisfying elastic teardrop look
        size.width,
        0,
      );
    } else {
      // Refreshing phase: Morph into a fluid sinusoidal canvas wave
      final baseAmplitude = waveHeight.clamp(5.0, 30.0);
      final phase = refreshProgress * 2.0 * math.pi;

      path.lineTo(0, size.height * 0.3);

      // Plot multi-frequency morphing waves
      for (double x = 0; x <= size.width; x += 4.0) {
        double y = size.height * 0.3;
        for (int r = 0; r < rippleCount; r++) {
          final amp = baseAmplitude / (r + 1);
          final freq = (r + 1) * 2.0 * math.pi / size.width;
          y += math.sin(x * freq + phase * (r + 1)) * amp;
        }
        path.lineTo(x, y);
      }
      path.lineTo(size.width, 0);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MotionLiquidMorphPainter oldDelegate) => true;
}

// ==========================================
// 2. TORNADO PAINTER
// ==========================================
class MotionTornadoPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int particleCount;
  final double windStrength;

  MotionTornadoPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.particleCount,
    required this.windStrength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pPaint = Paint()..style = PaintingStyle.fill;

    // Outer vortex funnel guide lines
    final funnelPaint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final funnelPath = Path();
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);
    final funnelHeight = size.height * progress;

    funnelPath.moveTo(center.dx - 10, size.height);
    funnelPath.lineTo(center.dx + 10, size.height);
    funnelPath.lineTo(
        center.dx + size.width * 0.3 * progress, size.height - funnelHeight);
    funnelPath.lineTo(
        center.dx - size.width * 0.3 * progress, size.height - funnelHeight);
    funnelPath.close();
    canvas.drawPath(funnelPath, funnelPaint);

    // Spiraling vortex particles
    final activeCount = (particleCount * progress).round();
    final time =
        isRefreshing ? refreshProgress * 2 * math.pi : pullProgress * math.pi;

    for (int i = 0; i < activeCount; i++) {
      final t = (i / activeCount + time / (2 * math.pi)) % 1.0;
      final py = size.height - (t * funnelHeight);

      // Funnel width scales outwards at the top
      final currentWidth =
          (10 + (size.width * 0.35 * progress) * t) * windStrength;
      final angle = time * 3.0 + i * (2 * math.pi / activeCount);
      final px = center.dx + math.sin(angle) * currentWidth;

      // Depth perception simulation using scaling and opacity
      final zDepth = math.cos(angle); // -1.0 (behind) to 1.0 (front)
      final scale = 1.5 + (zDepth + 1.0) * 1.5;
      final opacity = 0.2 + (zDepth + 1.0) * 0.4;

      pPaint.color = Color.lerp(color, Colors.white, (zDepth + 1.0) / 4.0)!
          .withValues(alpha: opacity.clamp(0.0, 1.0));

      canvas.drawCircle(Offset(px, py), scale, pPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionTornadoPainter oldDelegate) => true;
}

// ==========================================
// 3. INK SPREAD PAINTER
// ==========================================
class MotionInkSpreadPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final double viscosity;

  MotionInkSpreadPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.viscosity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (!isRefreshing) {
      // Pulling phase: A concentrated droplet slides downwards
      final dropY = size.height * pullProgress.clamp(0.0, 0.5);
      final dropRadius = 8.0 + pullProgress * 4.0;
      canvas.drawCircle(Offset(center.dx, dropY), dropRadius, paint);

      // Trailing thread connection
      final path = Path()
        ..moveTo(center.dx - 2, 0)
        ..lineTo(center.dx + 2, 0)
        ..lineTo(center.dx + 1, dropY)
        ..lineTo(center.dx - 1, dropY)
        ..close();
      canvas.drawPath(path, paint);
    } else {
      // Refreshing phase: Organic spreading blots using radial wave nodes
      final maxRadius = (size.width * 0.45) * refreshProgress.clamp(0.0, 1.0);
      final path = Path();
      final nodeCount = 12;

      for (int i = 0; i < nodeCount; i++) {
        final angle = i * 2 * math.pi / nodeCount;

        // Simulates viscosity using mathematical noise layers
        final waveOffset = math.sin(angle * 3.0 + refreshProgress * 5) *
                8.0 *
                (1.0 - viscosity) +
            math.cos(angle * 5.0 - refreshProgress * 3) *
                4.0 *
                (1.0 - viscosity);

        final r = maxRadius + waveOffset;
        final px = center.dx + r * math.cos(angle);
        final py = center.dy + r * math.sin(angle);

        if (i == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();
      canvas.drawPath(path, paint);

      // Secondary bleeding micro-dots
      final dotsCount = 6;
      for (int i = 0; i < dotsCount; i++) {
        final angle = i * 2 * math.pi / dotsCount + refreshProgress;
        final r = maxRadius * 1.25;
        final px = center.dx + r * math.cos(angle);
        final py = center.dy + r * math.sin(angle);
        final opacity = (1.0 - refreshProgress).clamp(0.0, 0.7);

        paint.color = color.withValues(alpha: opacity);
        canvas.drawCircle(Offset(px, py), 2.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MotionInkSpreadPainter oldDelegate) => true;
}

// ==========================================
// 4. CRYSTAL GROWTH PAINTER
// ==========================================
class MotionCrystalGrowthPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int branchCount;
  final double glowStrength;

  MotionCrystalGrowthPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.branchCount,
    required this.glowStrength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.7);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    final crystalPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 2.0 + glowStrength
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowStrength);

    // Render multiple crystal spears sprouting upwards at symmetrical angles
    for (int i = 0; i < branchCount; i++) {
      final angleFraction = (i / (branchCount - 1)) - 0.5; // -0.5 to 0.5
      final baseAngle = -math.pi / 2 + angleFraction * (math.pi / 3);

      final crystalHeight = size.height * 0.6 * progress;
      final endPoint = Offset(
        center.dx + crystalHeight * math.cos(baseAngle),
        center.dy + crystalHeight * math.sin(baseAngle),
      );

      // Draw backing glow
      canvas.drawLine(center, endPoint, glowPaint);
      // Draw solid crystal core
      canvas.drawLine(center, endPoint, crystalPaint);

      // Secondary diamond crystalline nodes forming on active refresh
      if (progress >= 0.5) {
        final nodeCount = 3;
        final diamondPaint = Paint()
          ..color = Color.lerp(color, Colors.white, 0.45)!
          ..style = PaintingStyle.fill;

        for (int n = 1; n <= nodeCount; n++) {
          final t = n / (nodeCount + 1);
          final pos = Offset.lerp(center, endPoint, t)!;

          // Breathing scale animation
          final pulse = isRefreshing
              ? 1.0 + 0.25 * math.sin(refreshProgress * 4 * math.pi + i * n)
              : 1.0;
          final dSize = 3.0 * t * progress * pulse;

          final dPath = Path()
            ..moveTo(pos.dx, pos.dy - dSize)
            ..lineTo(pos.dx + dSize * 0.7, pos.dy)
            ..lineTo(pos.dx, pos.dy + dSize)
            ..lineTo(pos.dx - dSize * 0.7, pos.dy)
            ..close();
          canvas.drawPath(dPath, diamondPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MotionCrystalGrowthPainter oldDelegate) => true;
}

// ==========================================
// 5. PHOENIX REBIRTH PAINTER
// ==========================================
class MotionPhoenixRebirthPainter extends CustomPainter {
  final double pullProgress;
  final double refreshProgress;
  final bool isRefreshing;
  final Color color;
  final int particleCount;
  final double wingSpan;

  MotionPhoenixRebirthPainter({
    required this.pullProgress,
    required this.refreshProgress,
    required this.isRefreshing,
    required this.color,
    required this.particleCount,
    required this.wingSpan,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final progress = isRefreshing ? 1.0 : pullProgress.clamp(0.0, 1.0);

    // 1. Draw glowing background flame embers
    final emberPaint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(54321);

    for (int i = 0; i < particleCount; i++) {
      final seedY = random.nextDouble();
      final seedX = random.nextDouble() - 0.5;

      // Embers float upwards
      final t =
          (seedY + (isRefreshing ? refreshProgress : pullProgress * 0.5)) % 1.0;
      final px = center.dx + seedX * size.width * 0.4 * progress;
      final py = size.height - (t * size.height * 0.9 * progress);

      final sizeScale = (1.0 - t) * 4.0 * progress;
      final opacity = (1.0 - t) * 0.7 * progress;

      emberPaint.color = Color.lerp(color, Colors.orangeAccent, t)!
          .withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawCircle(Offset(px, py), sizeScale, emberPaint);
    }

    // 2. Draw Phoenix Silhouette rising in center during active refreshing
    if (isRefreshing) {
      final birdPaint = Paint()
        ..color = Color.lerp(color, Colors.white, 0.15)!
        ..style = PaintingStyle.fill;

      final flap = math.sin(refreshProgress * 4 * math.pi) * 12.0 * wingSpan;
      final birdY = center.dy - (refreshProgress * 10.0); // Rises slightly

      final phoenixPath = Path()
        // Head / Crown
        ..moveTo(center.dx, birdY - 18)
        ..quadraticBezierTo(
            center.dx + 2, birdY - 14, center.dx + 4, birdY - 12)
        // Right Wing
        ..quadraticBezierTo(center.dx + 25 * wingSpan, birdY - 15 + flap,
            center.dx + 45 * wingSpan, birdY - 5 + flap)
        ..quadraticBezierTo(center.dx + 25 * wingSpan, birdY + 5 + flap / 2,
            center.dx + 6, birdY + 3)
        // Tail feathers
        ..lineTo(center.dx + 4, birdY + 18)
        ..lineTo(center.dx, birdY + 12)
        ..lineTo(center.dx - 4, birdY + 18)
        // Left Wing
        ..lineTo(center.dx - 6, birdY + 3)
        ..quadraticBezierTo(center.dx - 25 * wingSpan, birdY + 5 + flap / 2,
            center.dx - 45 * wingSpan, birdY - 5 + flap)
        ..quadraticBezierTo(center.dx - 25 * wingSpan, birdY - 15 + flap,
            center.dx - 4, birdY - 12)
        ..quadraticBezierTo(center.dx - 2, birdY - 14, center.dx, birdY - 18)
        ..close();

      canvas.drawPath(phoenixPath, birdPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MotionPhoenixRebirthPainter oldDelegate) => true;
}
