import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/controllers/motion_controller.dart';
import '../core/theme/motion_colors.dart';

class MotionAuroraBackground extends StatefulWidget {
  final Widget? child;

  const MotionAuroraBackground({
    super.key,
    this.child,
  });

  @override
  State<MotionAuroraBackground> createState() => _MotionAuroraBackgroundState();
}

class _MotionAuroraBackgroundState extends State<MotionAuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motionController = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;

    return Obx(() {
      final isReduced = motionController?.reducedMotion ?? false;
      final performanceMode = motionController?.performanceMode ?? false;

      if (isReduced) {
        return Container(
          color: MotionColors.darkBackground,
          child: widget.child,
        );
      }

      return SizedBox.expand(
        child: Stack(
          children: [
            // Dark night background base
            Container(color: MotionColors.darkBackground),
            
            // Dynamic fluid blur blobs
            if (!performanceMode)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final phase = _controller.value * 2 * math.pi;

                  // Fluid organic displacements
                  final xOffset1 = 40 * math.sin(phase);
                  final yOffset1 = 30 * math.cos(phase);

                  final xOffset2 = 50 * math.cos(phase + math.pi / 2);
                  final yOffset2 = 40 * math.sin(phase + math.pi / 2);

                  return Stack(
                    children: [
                      // Blob 1: Cyber Pink/Rose
                      Positioned(
                        top: -50 + yOffset1,
                        left: -50 + xOffset1,
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                MotionColors.secondaryNeon.withOpacity(0.35),
                                MotionColors.secondaryNeon.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Blob 2: Cyber Blue/Cyan
                      Positioned(
                        bottom: -70 + yOffset2,
                        right: -30 + xOffset2,
                        child: Container(
                          width: 380,
                          height: 380,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                MotionColors.primaryNeon.withOpacity(0.35),
                                MotionColors.primaryNeon.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Blob 3: Deep Space Purple
                      Positioned(
                        top: 200 + yOffset2,
                        right: 100 + xOffset1,
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                MotionColors.accentNeon.withOpacity(0.25),
                                MotionColors.accentNeon.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            else
              // Simplified aurora gradient for performance scaling
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0x1F00FFCC),
                        Color(0x00090A0F),
                      ],
                      center: Alignment.topLeft,
                      radius: 1.2,
                    ),
                  ),
                ),
              ),

            // Top screen child overlay
            if (widget.child != null) Positioned.fill(child: widget.child!),
          ],
        ),
      );
    });
  }
}
