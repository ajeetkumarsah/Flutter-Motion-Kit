import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_colors.dart';

class MotionGlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final BoxBorder? border;
  final Color? color;
  final List<Color>? borderColors;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const MotionGlassContainer({
    super.key,
    required this.child,
    this.blur = 12.0,
    this.opacity = 0.1,
    this.borderRadius = 20.0,
    this.border,
    this.color,
    this.borderColors,
    this.borderWidth = 1.5,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final motionController = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;

    final baseColor = color ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black);

    final resolvedBorderColors = borderColors ??
        [
          MotionColors.primaryNeon.withValues(alpha: 0.5),
          MotionColors.secondaryNeon.withValues(alpha: 0.2),
        ];

    return Obx(() {
      final isPerformanceMode = motionController?.performanceMode ?? false;

      // Performance fallback: if performanceMode or reducedMotion is on, disable expensive BackdropFilter blur
      final activeBlur = isPerformanceMode ? 0.0 : blur;
      final activeOpacity = isPerformanceMode
          ? opacity * 2.5
          : opacity; // increase opacity to compensate for lack of blur

      Widget container = Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: baseColor.withValues(alpha: activeOpacity),
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ??
              Border.all(
                color: baseColor.withValues(alpha: 0.15),
                width: borderWidth,
              ),
          boxShadow: [
            if (activeBlur > 0)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                spreadRadius: -8,
              ),
          ],
        ),
        child: child,
      );

      // Render actual Frosted Glass blur only if activeBlur > 0
      if (activeBlur > 0) {
        container = ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: activeBlur, sigmaY: activeBlur),
            child: container,
          ),
        );
      }

      // Add modern neon gradient border glowing overlay if custom borderColors are defined
      if (borderColors != null || border == null) {
        container = CustomPaint(
          painter: _GlassBorderPainter(
            borderRadius: borderRadius,
            borderColors: resolvedBorderColors,
            strokeWidth: borderWidth,
          ),
          child: container,
        );
      }

      return RepaintBoundary(child: container);
    });
  }
}

class _GlassBorderPainter extends CustomPainter {
  final double borderRadius;
  final List<Color> borderColors;
  final double strokeWidth;

  _GlassBorderPainter({
    required this.borderRadius,
    required this.borderColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(
        colors: borderColors,
        startAngle: 0.0,
        endAngle: 3.14 * 2,
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GlassBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderColors != borderColors;
  }
}
