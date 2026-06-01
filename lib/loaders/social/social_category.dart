import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// Social Theme Category styles & enums.
enum MotionSocialStyle {
  /// Reels circular border neon progress sweeps with elastic bounce transitions.
  reelsUpload,

  /// Broadcasting signal bars emitting continuous pulsing broadcast waves.
  liveStream,

  /// Smooth gradient story ring borders sweeping neon glows in sequential progress loops.
  storyRing,
}

/// Reels circular border neon progress sweeps with elastic bounce transitions.
class MotionReelsUploadLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionReelsUploadLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionReelsUploadLoader> createState() =>
      _MotionReelsUploadLoaderState();
}

class _MotionReelsUploadLoaderState extends State<MotionReelsUploadLoader>
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
            painter: _ReelsUploadPainter(
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

class _ReelsUploadPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glow;

  _ReelsUploadPainter({
    required this.progress,
    required this.color,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Outer circular neon sweep ring
    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final sweepRect = Rect.fromCircle(center: center, radius: radius);

    // Multi-color gradient sweep (Instagram-like pink-yellow-blue)
    final sweepGradient = SweepGradient(
      colors: const [
        Colors.pinkAccent,
        Colors.orangeAccent,
        Colors.purpleAccent,
        Colors.blueAccent,
        Colors.pinkAccent,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(progress * 2 * math.pi),
    ).createShader(sweepRect);

    sweepPaint.shader = sweepGradient;

    if (glow) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7.0
        ..shader = sweepGradient
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(center, radius, glowPaint);
    }

    canvas.drawArc(
        sweepRect, -math.pi / 2, 2 * math.pi * progress, false, sweepPaint);

    // Central reels icon with elastic bounce morphing
    final iconPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double bounce = 0.85 + 0.15 * math.sin(progress * 4 * math.pi);
    final double iconSize = size.width * 0.35 * bounce;

    final iconRect = Rect.fromCenter(
        center: center, width: iconSize, height: iconSize * 0.8);
    final RRect rrect =
        RRect.fromRectAndRadius(iconRect, Radius.circular(iconSize * 0.15));
    canvas.drawRRect(rrect, iconPaint);

    // Camera lens cutouts
    final lensPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, iconSize * 0.18, lensPaint);

    lensPaint.color = Colors.white;
    canvas.drawCircle(center, iconSize * 0.08, lensPaint);
  }

  @override
  bool shouldRepaint(covariant _ReelsUploadPainter oldDelegate) => true;
}

/// Broadcasting signal bars emitting continuous pulsing broadcast waves.
class MotionLiveStreamLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionLiveStreamLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionLiveStreamLoader> createState() => _MotionLiveStreamLoaderState();
}

class _MotionLiveStreamLoaderState extends State<MotionLiveStreamLoader>
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
      duration: Duration(milliseconds: (1800 / speed).round()),
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
            painter: _LiveStreamPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _LiveStreamPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LiveStreamPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.35, size.height * 0.65);
    final w = size.width;
    final h = size.height;

    // Central dot representing source antenna
    final antennaPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, w * 0.08, antennaPaint);

    // Emit broadcasting waves flowing out towards top-right
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    const waveCount = 3;
    for (int i = 0; i < waveCount; i++) {
      final double waveProg = (progress + (i / waveCount)) % 1.0;
      final double radius = w * 0.15 + w * 0.45 * waveProg;
      final double opacity = 1.0 - waveProg;

      wavePaint.color = color.withValues(alpha: opacity);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 4 - 0.2,
        math.pi / 2 + 0.4,
        false,
        wavePaint,
      );
    }

    // Small glowing "LIVE" indicator box
    final liveBoxPaint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    final boxRect = Rect.fromLTWH(w * 0.55, h * 0.15, w * 0.35, h * 0.18);
    canvas.drawRRect(RRect.fromRectAndRadius(boxRect, const Radius.circular(4)),
        liveBoxPaint);
  }

  @override
  bool shouldRepaint(covariant _LiveStreamPainter oldDelegate) => true;
}

/// Smooth gradient story ring borders sweeping neon glows in sequential progress loops.
class MotionStoryRingLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionStoryRingLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionStoryRingLoader> createState() => _MotionStoryRingLoaderState();
}

class _MotionStoryRingLoaderState extends State<MotionStoryRingLoader>
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
            painter: _StoryRingPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _StoryRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _StoryRingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.44;

    // Segmented neon Instagram story-like ring
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final ringRect = Rect.fromCircle(center: center, radius: radius);

    final sweepGradient = SweepGradient(
      colors: const [
        Colors.orange,
        Colors.pinkAccent,
        Colors.purpleAccent,
        Colors.blue,
        Colors.orange,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(progress * 2 * math.pi),
    ).createShader(ringRect);

    borderPaint.shader = sweepGradient;

    // Draw 4 distinct segments matching typical custom stories
    const segmentsCount = 4;
    const spacing = 0.25;
    for (int i = 0; i < segmentsCount; i++) {
      final startAngle = i * (2 * math.pi / segmentsCount) + spacing / 2;
      const sweepAngle = (2 * math.pi / segmentsCount) - spacing;

      canvas.drawArc(
        ringRect,
        startAngle,
        sweepAngle,
        false,
        borderPaint,
      );
    }

    // Centered Avatar placeholder circle
    final avatarPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 6.0, avatarPaint);

    final outlinePaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - 6.0, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant _StoryRingPainter oldDelegate) => true;
}
