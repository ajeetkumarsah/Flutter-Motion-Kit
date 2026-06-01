import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// Experimental Theme Category styles & enums.
enum MotionExperimentalStyle {
  /// Distorted melting clock faces executing temporal blurs and reverse speeds.
  timeWarp,

  /// Sci-fi energy vortex portals sucking in floating warp particles.
  portal,

  /// Cracking spatial rifts leaking neon light beams and glitching.
  dimensionalRift,

  /// Zooming 3D tunnel wormholes with glowing cosmic particle stars.
  wormhole,
}

/// Distorted melting clock faces executing temporal blurs and reverse speeds.
class MotionTimeWarpLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionTimeWarpLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionTimeWarpLoader> createState() => _MotionTimeWarpLoaderState();
}

class _MotionTimeWarpLoaderState extends State<MotionTimeWarpLoader>
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
            painter: _TimeWarpPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _TimeWarpPainter extends CustomPainter {
  final double progress;
  final Color color;

  _TimeWarpPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    final borderPaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final handPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Melt/distort the circle dynamically using bezier/trig offsets
    final path = Path();
    for (double i = 0.0; i <= 360; i += 5.0) {
      final angle = i * math.pi / 180;
      final distortion =
          1.0 + 0.12 * math.sin(angle * 3.0 + progress * 2 * math.pi);

      final double x = center.dx + radius * distortion * math.cos(angle);
      final double y = center.dy + radius * distortion * math.sin(angle);

      if (i == 0.0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, borderPaint);

    // Dynamic ticking clock hands moving in warped reverse ratios
    final double hourAngle = -progress * 2 * math.pi;
    final double minAngle = -progress * 24 * math.pi;

    final hourTip = Offset(
      center.dx + radius * 0.45 * math.cos(hourAngle - math.pi / 2),
      center.dy + radius * 0.45 * math.sin(hourAngle - math.pi / 2),
    );
    final minTip = Offset(
      center.dx + radius * 0.7 * math.cos(minAngle - math.pi / 2),
      center.dy + radius * 0.7 * math.sin(minAngle - math.pi / 2),
    );

    canvas.drawLine(center, hourTip, handPaint..strokeWidth = 3.5);
    canvas.drawLine(
        center,
        minTip,
        handPaint
          ..strokeWidth = 1.8
          ..color = Colors.cyanAccent);

    // Core pin
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _TimeWarpPainter oldDelegate) => true;
}

/// Sci-fi energy vortex portals sucking in floating warp particles.
class MotionPortalLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionPortalLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionPortalLoader> createState() => _MotionPortalLoaderState();
}

class _MotionPortalLoaderState extends State<MotionPortalLoader>
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
            painter: _PortalPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _PortalPainter extends CustomPainter {
  final double progress;
  final Color color;

  _PortalPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.46;

    // Draw rotating neon energy portal spiral ring
    final Paint spiralPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final sweepRect = Rect.fromCircle(center: center, radius: maxRadius);

    final sweepGradient = SweepGradient(
      colors: [
        color,
        Colors.deepPurpleAccent,
        Colors.pinkAccent,
        Colors.cyanAccent,
        color,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(-progress * 2 * math.pi),
    ).createShader(sweepRect);

    spiralPaint.shader = sweepGradient;

    // Draw spiral layers sucking in
    for (int i = 0; i < 4; i++) {
      final r = maxRadius * (1.0 - i * 0.22);
      canvas.drawCircle(center, r,
          spiralPaint..strokeWidth = (3.0 - i * 0.6).clamp(1.0, 3.0));
    }

    // Warp particles getting sucked into center
    final Paint particlePaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final double localProg = (progress + (i / 8)) % 1.0;
      // Shrinking radius spirals inwards
      final double r = maxRadius * (1.0 - localProg);
      final double angle = localProg * 4 * math.pi + i * math.pi / 4;

      final double px = center.dx + r * math.cos(angle);
      final double py = center.dy + r * math.sin(angle);

      final opacity = math.sin(localProg * math.pi);
      particlePaint.color = Colors.white.withValues(alpha: opacity);

      canvas.drawCircle(Offset(px, py), 2.0, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PortalPainter oldDelegate) => true;
}

/// Cracking spatial rifts leaking neon light beams and glitching.
class MotionDimensionalRiftLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionDimensionalRiftLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionDimensionalRiftLoader> createState() =>
      _MotionDimensionalRiftLoaderState();
}

class _MotionDimensionalRiftLoaderState
    extends State<MotionDimensionalRiftLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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
      duration: Duration(milliseconds: (1500 / speed).round()),
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
          final glitch = !isReduced && (_random.nextDouble() < 0.22);
          return CustomPaint(
            painter: _RiftPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              glitch: glitch,
            ),
          );
        },
      ),
    );
  }
}

class _RiftPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glitch;

  _RiftPainter({
    required this.progress,
    required this.color,
    required this.glitch,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw cracking spatial rift path across center
    final Paint riftPaint = Paint()
      ..color = glitch ? Colors.redAccent : color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(w * 0.1, h * 0.5);
    path.lineTo(w * 0.35, h * 0.38 + (glitch ? 10 : 0));
    path.lineTo(w * 0.65, h * 0.62 + (glitch ? -8 : 0));
    path.lineTo(w * 0.9, h * 0.5);

    // Glowing atmosphere background behind crack
    final Paint glowPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, glowPaint);

    // Spatial rift core outline
    canvas.drawPath(path, riftPaint);

    // Leaking light particles emerging from crack
    final Paint leakPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final double localProg = (progress + (i / 6)) % 1.0;
      final double x = w * 0.25 + w * 0.5 * localProg;

      // Follow path height plus drifting vertical leakage
      final double drift = math.sin(localProg * 2 * math.pi + i) * h * 0.22;
      final double y = h * 0.5 + drift;

      final opacity = math.sin(localProg * math.pi);
      leakPaint.color = Colors.cyanAccent.withValues(alpha: opacity);

      canvas.drawCircle(Offset(x, y), 2.5, leakPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RiftPainter oldDelegate) => true;
}

/// Zooming 3D tunnel wormholes with glowing cosmic particle stars.
class MotionWormholeLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionWormholeLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionWormholeLoader> createState() => _MotionWormholeLoaderState();
}

class _MotionWormholeLoaderState extends State<MotionWormholeLoader>
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
            painter: _WormholePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _WormholePainter extends CustomPainter {
  final double progress;
  final Color color;

  _WormholePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.48;

    // Draw zooming 3D concentric circles extending from center to boundaries
    final Paint tunnelPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const layersCount = 6;
    for (int i = 0; i < layersCount; i++) {
      // Zooming progress mapping
      final double layerProg = (progress + (i / layersCount)) % 1.0;
      final double r = maxRadius * layerProg;

      final opacity = layerProg; // Fades out as it zooms closer/larger
      tunnelPaint.color = color.withValues(alpha: (1.0 - opacity) * 0.45);
      tunnelPaint.strokeWidth = 0.5 + 2.0 * layerProg;

      canvas.drawCircle(center, r, tunnelPaint);
    }

    // Glowing starlight dots zooming in the 3D tunnel
    final Paint starPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final double starProg = (progress + (i / 12)) % 1.0;
      final double r = maxRadius * starProg;

      final angle = i * (2 * math.pi / 12) + (progress * 0.5);
      final double px = center.dx + r * math.cos(angle);
      final double py = center.dy + r * math.sin(angle);

      final opacity = starProg;
      starPaint.color = Colors.cyanAccent.withValues(alpha: 1.0 - opacity);

      canvas.drawCircle(Offset(px, py), 1.0 + 2.5 * starProg, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WormholePainter oldDelegate) => true;
}
