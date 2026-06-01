import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// Base abstract class for modular compound effects.
abstract class MotionEffect {
  const MotionEffect();

  /// Wraps the child widget with this specific visual effect.
  Widget wrap(BuildContext context, Widget child, double progress);
}

/// GlowEffect adds a pulsing colored outer shadow or neon halo under/around the widget.
class GlowEffect extends MotionEffect {
  final Color color;
  final double blurRadius;
  final double spreadRadius;

  const GlowEffect({
    required this.color,
    this.blurRadius = 12.0,
    this.spreadRadius = 1.0,
  });

  @override
  Widget wrap(BuildContext context, Widget child, double progress) {
    final double pulse = 0.75 + 0.25 * math.sin(progress * 2 * math.pi);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3 * pulse),
            blurRadius: blurRadius * pulse,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// OrbitEffect rotates the widget child itself or orbits planetary nodes around it.
class OrbitEffect extends MotionEffect {
  final double radius;
  final double speed;

  const OrbitEffect({
    this.radius = 40.0,
    this.speed = 1.0,
  });

  @override
  Widget wrap(BuildContext context, Widget child, double progress) {
    final angle = progress * 2 * math.pi * speed;
    return Transform.translate(
      offset: Offset(radius * math.cos(angle), radius * math.sin(angle)),
      child: child,
    );
  }
}

/// RippleEffect draws pulsing circular neon waves expanding outwards behind the child.
class RippleEffect extends MotionEffect {
  final Color color;
  final double maxRadius;

  const RippleEffect({
    required this.color,
    this.maxRadius = 60.0,
  });

  @override
  Widget wrap(BuildContext context, Widget child, double progress) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Backing ripple painter
        SizedBox(
          width: maxRadius * 2,
          height: maxRadius * 2,
          child: CustomPaint(
            painter: _RippleEffectPainter(
                progress: progress, color: color, maxRadius: maxRadius),
          ),
        ),
        child,
      ],
    );
  }
}

class _RippleEffectPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double maxRadius;

  _RippleEffectPainter({
    required this.progress,
    required this.color,
    required this.maxRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ripplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const waveCount = 3;
    for (int i = 0; i < waveCount; i++) {
      final double localProg = (progress + (i / waveCount)) % 1.0;
      final double r = maxRadius * localProg;
      final double opacity = 1.0 - localProg;

      ripplePaint.color = color.withValues(alpha: opacity * 0.45);
      canvas.drawCircle(center, r, ripplePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RippleEffectPainter oldDelegate) => true;
}

/// GlitchEffect executes broken RGB digital splits and skews over the child widget.
class GlitchEffect extends MotionEffect {
  final double intensity;

  const GlitchEffect({
    this.intensity = 5.0,
  });

  @override
  Widget wrap(BuildContext context, Widget child, double progress) {
    final random = math.Random((progress * 1000).toInt());
    final bool glitchTrigger = random.nextDouble() < 0.15;

    if (!glitchTrigger) return child;

    final double skewX = (random.nextDouble() * 0.08 - 0.04) * intensity;
    final double offsetX = (random.nextDouble() * 8.0 - 4.0) * intensity;
    final double offsetY = (random.nextDouble() * 8.0 - 4.0) * intensity;

    return Transform(
      transform: Matrix4.skewX(skewX)
        ..multiply(Matrix4.translationValues(offsetX, offsetY, 0.0)),
      child: child,
    );
  }
}

/// FloatEffect floats the child vertically up and down using a smooth sinusoidal timeline.
class FloatEffect extends MotionEffect {
  final double dy;

  const FloatEffect({
    this.dy = 12.0,
  });

  @override
  Widget wrap(BuildContext context, Widget child, double progress) {
    final double offset = math.sin(progress * 2 * math.pi) * dy;
    return Transform.translate(
      offset: Offset(0, offset),
      child: child,
    );
  }
}

/// A compounding modular visual stack.
///
/// Wraps any widget child and compounds multiple sequential visual effects
/// like [GlowEffect], [OrbitEffect], [RippleEffect], [GlitchEffect], [FloatEffect] dynamically!
class MotionBuilder extends StatefulWidget {
  /// The collection of sequential visual effects to overlay.
  final List<MotionEffect> effects;

  /// The child widget to apply visual animations upon.
  final Widget child;

  /// Animation duration limit.
  final Duration duration;

  /// Creates a unified [MotionBuilder] compound decorator.
  const MotionBuilder({
    super.key,
    required this.effects,
    required this.child,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<MotionBuilder> createState() => _MotionBuilderState();
}

class _MotionBuilderState extends State<MotionBuilder>
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
      duration: Duration(
          milliseconds: (widget.duration.inMilliseconds / speed).round()),
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

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget current = widget.child;
        final progress = isReduced ? 0.0 : _controller.value;

        // Accumulate and wrap all visual decorators
        for (final effect in widget.effects) {
          current = effect.wrap(context, current, progress);
        }
        return current;
      },
    );
  }
}
