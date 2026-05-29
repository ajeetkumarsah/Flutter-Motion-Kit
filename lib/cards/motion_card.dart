import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controllers/motion_controller.dart';

class MotionCard extends StatefulWidget {
  final Widget child;
  final double maxTiltAngleX;
  final double maxTiltAngleY;
  final double elevation;
  final double borderRadius;
  final Color? shadowColor;

  const MotionCard({
    super.key,
    required this.child,
    this.maxTiltAngleX = 12.0,
    this.maxTiltAngleY = 12.0,
    this.elevation = 6.0,
    this.borderRadius = 16.0,
    this.shadowColor,
  });

  @override
  State<MotionCard> createState() => _MotionCardState();
}

class _MotionCardState extends State<MotionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _resetController;
  late Animation<Offset> _tiltAnimation;
  Offset _tiltOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _resetController.addListener(() {
      setState(() {
        _tiltOffset = _tiltAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    _resetController.stop();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Normalized coordinates (-1.0 to 1.0)
    final dx = (details.localPosition.dx - centerX) / centerX;
    final dy = (details.localPosition.dy - centerY) / centerY;

    setState(() {
      _tiltOffset = Offset(
        dx.clamp(-1.0, 1.0),
        dy.clamp(-1.0, 1.0),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _tiltAnimation = Tween<Offset>(
      begin: _tiltOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _resetController,
      curve: Curves.easeOutCubic,
    ));
    _resetController.reset();
    _resetController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final motionController = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;

    return Obx(() {
      final isReduced = motionController?.reducedMotion ?? false;

      // 3D Matrix perspective transformation based on cursor
      final transformMatrix = Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(isReduced
            ? 0.0
            : -_tiltOffset.dy * widget.maxTiltAngleX * 3.14 / 180)
        ..rotateY(isReduced
            ? 0.0
            : _tiltOffset.dx * widget.maxTiltAngleY * 3.14 / 180);

      final baseCard = PhysicalModel(
        color: Colors.transparent,
        elevation: widget.elevation,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        shadowColor: widget.shadowColor ?? Colors.black.withValues(alpha: 0.3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: widget.child,
        ),
      );

      Widget cardWidget = baseCard;

      if (!isReduced) {
        cardWidget = LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return GestureDetector(
              onPanUpdate: (details) => _onPanUpdate(details, size),
              onPanEnd: _onPanEnd,
              child: AnimatedBuilder(
                animation: _resetController,
                builder: (context, child) {
                  return Transform(
                    transform: transformMatrix,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                child: baseCard,
              ),
            );
          },
        );
      }

      return RepaintBoundary(child: cardWidget);
    });
  }
}
