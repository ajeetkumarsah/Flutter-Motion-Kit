import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// Liquid Loader styles & enums.
enum MotionLiquidStyle {
  /// Gooey lava lamp style liquid blobs morphing and merging together.
  lavaLamp,

  /// Droplets landing on a surface generating fading refraction waves.
  waterDrop,

  /// Ink diffusing and expanding naturally across a gradient background.
  inkSpread,
}

/// Gooey Lava Lamp Loader widget using multiple floating metaball canvas circles.
class MotionLavaLampLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionLavaLampLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionLavaLampLoader> createState() => _MotionLavaLampLoaderState();
}

class _MotionLavaLampLoaderState extends State<MotionLavaLampLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_LavaBlob> _blobs = [];
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

    // Spawn floating blobs
    for (int i = 0; i < 4; i++) {
      _blobs.add(_LavaBlob(
        seedX: _random.nextDouble() * 2 * math.pi,
        seedY: _random.nextDouble() * 2 * math.pi,
        radius: widget.size * (0.2 + _random.nextDouble() * 0.15),
        speedX: 0.5 + _random.nextDouble() * 0.8,
        speedY: 0.5 + _random.nextDouble() * 0.8,
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
            painter: _LavaLampPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              blobs: _blobs,
            ),
          );
        },
      ),
    );
  }
}

class _LavaBlob {
  final double seedX;
  final double seedY;
  final double radius;
  final double speedX;
  final double speedY;

  _LavaBlob({
    required this.seedX,
    required this.seedY,
    required this.radius,
    required this.speedX,
    required this.speedY,
  });
}

class _LavaLampPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_LavaBlob> blobs;

  _LavaLampPainter({
    required this.progress,
    required this.color,
    required this.blobs,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxBounds = size.width * 0.3;

    // Save layer to apply metaball blend
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    final blobPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < blobs.length; i++) {
      final blob = blobs[i];
      final angleX = (progress * 2 * math.pi * blob.speedX) + blob.seedX;
      final angleY = (progress * 2 * math.pi * blob.speedY) + blob.seedY;

      final blobPos = Offset(
        center.dx + maxBounds * math.cos(angleX) * 0.8,
        center.dy + maxBounds * math.sin(angleY) * 0.8,
      );

      // Use a radial gradient to simulate organic gooey metaball fields
      final rect = Rect.fromCircle(center: blobPos, radius: blob.radius * 1.5);
      blobPaint.shader = RadialGradient(
        colors: [
          color,
          color.withValues(alpha: 0.4),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(rect);

      canvas.drawCircle(blobPos, blob.radius * 1.5, blobPaint);
    }

    // Restore layer to draw composite gooey effect
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LavaLampPainter oldDelegate) => true;
}

/// Droplets falling into a surface generating expanding refraction ripple waves.
class MotionWaterRippleLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionWaterRippleLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionWaterRippleLoader> createState() =>
      _MotionWaterRippleLoaderState();
}

class _MotionWaterRippleLoaderState extends State<MotionWaterRippleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_RippleWave> _ripples = [];
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
      final int step = (_controller.value * 3).floor();
      if (_ripples.length < step) {
        _ripples.add(_RippleWave(
          offset: Offset(
            widget.size * (0.2 + _random.nextDouble() * 0.6),
            widget.size * (0.2 + _random.nextDouble() * 0.6),
          ),
          birthTime: _controller.value,
        ));
        if (_ripples.length > 3) {
          _ripples.removeAt(0);
        }
      }
    });
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
            painter: _WaterRipplePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              ripples: _ripples,
              maxRadius: widget.size * 0.35,
            ),
          );
        },
      ),
    );
  }
}

class _RippleWave {
  final Offset offset;
  final double birthTime;

  _RippleWave({
    required this.offset,
    required this.birthTime,
  });
}

class _WaterRipplePainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_RippleWave> ripples;
  final double maxRadius;

  _WaterRipplePainter({
    required this.progress,
    required this.color,
    required this.ripples,
    required this.maxRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final dropPaint = Paint()..style = PaintingStyle.fill;

    for (var ripple in ripples) {
      final t = (progress - ripple.birthTime) % 1.0;
      final currentRadius = maxRadius * t;
      final opacity = 1.0 - t;

      // Draw droplet falling down in the very beginning
      if (t < 0.25) {
        final dropT = t / 0.25;
        final dropY = ripple.offset.dy - (50 * (1.0 - dropT));
        dropPaint.color = color.withValues(alpha: dropT);
        canvas.drawCircle(Offset(ripple.offset.dx, dropY), 3.0, dropPaint);
      }

      // Draw horizontal concentric expanding ripple waves
      paint.color = color.withValues(alpha: opacity * 0.5);
      paint.strokeWidth = 3.0 * opacity;

      // Draw outer distortion wave ring
      canvas.drawCircle(ripple.offset, currentRadius, paint);
      canvas.drawCircle(ripple.offset, currentRadius * 0.65, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaterRipplePainter oldDelegate) => true;
}

/// Ink spreading dynamically across a backing gradient mesh canvas.
class MotionInkSpreadLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionInkSpreadLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionInkSpreadLoader> createState() => _MotionInkSpreadLoaderState();
}

class _MotionInkSpreadLoaderState extends State<MotionInkSpreadLoader>
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
            painter: _InkSpreadPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _InkSpreadPainter extends CustomPainter {
  final double progress;
  final Color color;

  _InkSpreadPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.48;

    final inkPaint = Paint()..style = PaintingStyle.fill;

    // Draw ink splats diffusing radially using sine ripples
    final path = Path();
    final steps = 72;
    final scale = progress;

    // Fades in, expands, and fades out
    final opacity = math.sin(progress * math.pi);
    inkPaint.color = color.withValues(alpha: opacity * 0.8);

    for (int i = 0; i <= steps; i++) {
      final angle = (i * 2 * math.pi) / steps;

      // Calculate complex organic diffusion path edges
      final rippleOffset =
          18.0 * math.sin(angle * 6.0 + progress * 4 * math.pi) +
              8.0 * math.cos(angle * 12.0 - progress * 2 * math.pi);

      final currentRadius = (maxRadius * scale) + (rippleOffset * scale);
      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + currentRadius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, inkPaint);

    // Draw central secondary dark core diffusion ring
    final corePaint = Paint()
      ..color =
          Color.lerp(color, Colors.black, 0.4)!.withValues(alpha: opacity * 0.9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius * 0.45 * scale, corePaint);
  }

  @override
  bool shouldRepaint(covariant _InkSpreadPainter oldDelegate) => true;
}
