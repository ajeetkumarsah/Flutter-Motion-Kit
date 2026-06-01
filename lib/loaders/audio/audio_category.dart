import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// Audio Theme Category styles & enums.
enum MotionAudioStyle {
  /// Frequency music equalizer bars bouncing to simulated beat frequencies.
  equalizer,

  /// Spinning retro vinyl record with sweeping metallic reflections and needle traces.
  vinyl,

  /// Bass-pulsing audio-reactive frequency curves transitioning smoothly.
  beatWave,
}

/// Frequency music equalizer bars bouncing to simulated beat frequencies.
class MotionEqualizerLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionEqualizerLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionEqualizerLoader> createState() => _MotionEqualizerLoaderState();
}

class _MotionEqualizerLoaderState extends State<MotionEqualizerLoader>
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
      duration: Duration(milliseconds: (1200 / speed).round()),
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
            painter: _EqualizerPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _EqualizerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _EqualizerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final Paint barPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 5 Equalizer frequency bars bouncing staggered
    const barsCount = 5;
    final double barSpacing = w * 0.05;
    final double barWidth = (w - (barSpacing * (barsCount - 1))) / barsCount;

    for (int i = 0; i < barsCount; i++) {
      final double x = i * (barWidth + barSpacing);

      // Map staggered bouncing frequency values using multi-sine waves
      final delay = i * 0.15;
      final localProg = (progress - delay) % 1.0;
      final double bounce = 0.2 + 0.8 * math.sin(localProg * math.pi);

      final double barHeight = h * bounce;
      final double y = h - barHeight;

      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      final activeColor =
          Color.lerp(color, Colors.cyanAccent, i / (barsCount - 1))!;
      barPaint.color = activeColor;

      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(3)), barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EqualizerPainter oldDelegate) => true;
}

/// Spinning retro vinyl record with sweeping metallic reflections and needle traces.
class MotionVinylLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionVinylLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionVinylLoader> createState() => _MotionVinylLoaderState();
}

class _MotionVinylLoaderState extends State<MotionVinylLoader>
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
      duration: Duration(milliseconds: (2500 / speed).round()),
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
            painter: _VinylPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _VinylPainter extends CustomPainter {
  final double progress;
  final Color color;

  _VinylPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.44;

    // Draw main black vinyl record disc
    final Paint vinylPaint = Paint()
      ..color = const Color(0xFF0F0F12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, vinylPaint);

    // Draw concentric groove lines
    final Paint groovePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius * 0.85, groovePaint);
    canvas.drawCircle(center, radius * 0.7, groovePaint);
    canvas.drawCircle(center, radius * 0.55, groovePaint);

    // Draw central music label paper
    final Paint labelPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.35, labelPaint);

    // Label inner circle
    labelPaint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.08, labelPaint);

    // Metallic rotating reflections (sweep gradient highlights)
    final reflectionPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = SweepGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        transform: GradientRotation(progress * 2 * math.pi),
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, reflectionPaint);

    // Needle arm trace tracing vinyl
    final needlePaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double needleAngle =
        math.pi / 6 + 0.05 * math.sin(progress * 4 * math.pi);
    final needleStart =
        Offset(center.dx + radius * 0.85, center.dy - radius * 0.85);
    final needlePivot =
        Offset(center.dx + radius * 0.6, center.dy - radius * 0.3);
    final needleTip = Offset(
      center.dx + radius * 0.45 * math.cos(needleAngle),
      center.dy + radius * 0.45 * math.sin(needleAngle),
    );

    canvas.drawLine(needleStart, needlePivot, needlePaint);
    canvas.drawLine(needlePivot, needleTip, needlePaint..strokeWidth = 1.0);
  }

  @override
  bool shouldRepaint(covariant _VinylPainter oldDelegate) => true;
}

/// Bass-pulsing audio-reactive frequency curves transitioning smoothly.
class MotionBeatWaveLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionBeatWaveLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionBeatWaveLoader> createState() => _MotionBeatWaveLoaderState();
}

class _MotionBeatWaveLoaderState extends State<MotionBeatWaveLoader>
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
            painter: _BeatWavePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _BeatWavePainter extends CustomPainter {
  final double progress;
  final Color color;

  _BeatWavePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;
    final h = size.height;

    // Pulse factor representing central bass kicks
    final double pulse = 0.85 + 0.15 * math.sin(progress * 4 * math.pi);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Draw 3 horizontal waving lines representing different frequencies (bass, mid, treble)
    for (int wave = 0; wave < 3; wave++) {
      path.reset();

      final activeColor = Color.lerp(color, Colors.pinkAccent, wave / 3)!;
      linePaint.color =
          activeColor.withValues(alpha: 0.2 + (1.0 - wave / 3) * 0.8);
      linePaint.strokeWidth = (2.5 - wave * 0.8).clamp(1.0, 3.0);

      final double phase = progress * 2 * math.pi + wave * math.pi / 3;
      final double amplitude = h * 0.25 * pulse * (1.0 - wave * 0.25);

      for (double x = 0.0; x <= w; x += 4.0) {
        final double normalizedX = x / w;
        // Central bell multiplier (Hanning window) to anchor boundaries at both ends
        final double window = math.sin(normalizedX * math.pi);

        final double y = center.dy +
            math.sin(normalizedX * 4 * math.pi + phase) * amplitude * window;

        if (x == 0.0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BeatWavePainter oldDelegate) => true;
}
