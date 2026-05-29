import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/motion_controller.dart';

/// A premium horizontal Equalizer soundwave bar loader.
///
/// Five vertical graphic chart bars oscillate up and down dynamically.
/// Scales seamlessly inside a FittedBox to support tiny boundaries.
class MotionWaveLoader extends StatefulWidget {
  /// The active primary color of the Equalizer bars.
  final Color color;

  /// The dimensional bounding size (width and height constraints) of the loader.
  final double size;

  /// Creates a [MotionWaveLoader] instance.
  const MotionWaveLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionWaveLoader> createState() => _MotionWaveLoaderState();
}

class _MotionWaveLoaderState extends State<MotionWaveLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _barCount = 5;

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
    final barWidth = widget.size / 7;
    final barMaxHeight = widget.size;

    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_barCount, (index) {
          final delay = index * 0.15;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Sinusoidal bounce wave height calculations
              final value = (_controller.value - delay) % 1.0;
              final scale = 0.3 + 0.7 * math.sin(value * math.pi);
              final barHeight = barMaxHeight * scale;

              return Container(
                width: barWidth,
                height: barHeight,
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(barWidth / 2),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.35),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
