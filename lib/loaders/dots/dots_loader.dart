import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/motion_controller.dart';

/// A premium horizontal three-dot bouncing loader widget.
///
/// Bounces dots sequentially using a sinusoidal delay offset.
/// Scaled dynamically via FittedBox to fit securely in tight parents.
class MotionDotsLoader extends StatefulWidget {
  /// The active primary color of the bouncing dots.
  final Color color;

  /// The dimensional bounding size (width and height constraints) of the loader.
  final double size;

  /// Creates a [MotionDotsLoader] instance.
  const MotionDotsLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionDotsLoader> createState() => _MotionDotsLoaderState();
}

class _MotionDotsLoaderState extends State<MotionDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _dotsCount = 3;

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (1000 / speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size / 5.5;
    final spacing = widget.size / 18;

    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_dotsCount, (index) {
          final delay = index / _dotsCount;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Apply sinusoidal bounce delay offset
              final t = (_controller.value - delay) % 1.0;
              final yOffset = -12.0 * (t < 0.5 ? (1.0 - t * 2) * (t * 2) : 0.0);

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing),
                child: Transform.translate(
                  offset: Offset(0, yOffset),
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// A premium messaging bubble typing indicator.
///
/// Animates sequentially using scale and fade curves inside a FittedBox.
class MotionTypingIndicator extends StatefulWidget {
  /// The active primary color of the typing indicator dots.
  final Color color;

  /// The dimensional bounding size (width and height constraints) of the loader.
  final double size;

  /// Creates a [MotionTypingIndicator] instance.
  const MotionTypingIndicator({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionTypingIndicator> createState() => _MotionTypingIndicatorState();
}

class _MotionTypingIndicatorState extends State<MotionTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size / 6;
    final spacing = widget.size / 20;

    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Calculate scale animation offset for typing dots
              final delay = index * 0.2;
              final value = ((_controller.value - delay) % 1.0);
              final scale = 0.5 + (0.5 * (1.0 - (value - 0.5).abs() * 2));
              final opacity = 0.3 + (0.7 * (1.0 - (value - 0.5).abs() * 2));

              return Container(
                width: dotSize,
                height: dotSize,
                margin: EdgeInsets.symmetric(horizontal: spacing),
                transform: Matrix4.identity()..scale(scale),
                decoration: BoxDecoration(
                  color:
                      widget.color.withValues(alpha: opacity.clamp(0.2, 1.0)),
                  shape: BoxShape.circle,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
