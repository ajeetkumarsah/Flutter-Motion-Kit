import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_colors.dart';

class MotionShimmer extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final Duration duration;
  final ShimmerDirection direction;

  const MotionShimmer({
    super.key,
    required this.child,
    this.colors,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    // Access accessibility & performance controller safely
    final motionController = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Default premium gradients
    final baseColors = colors ??
        (isDark
            ? MotionColors.darkShimmerColors
            : MotionColors.lightShimmerColors);

    return Obx(() {
      final isReduced = motionController?.reducedMotion ?? false;
      if (isReduced) {
        // Render static representation when reduced motion is true
        return child;
      }

      final scaledDuration = motionController != null
          ? motionController.getScaledDuration(duration)
          : duration;

      return Shimmer(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: baseColors,
          stops: const [0.1, 0.5, 0.9],
        ),
        period: scaledDuration,
        direction: direction,
        child: child,
      );
    });
  }
}
