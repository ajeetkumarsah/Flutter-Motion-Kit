import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controllers/motion_controller.dart';
import '../core/extensions/animation_extensions.dart';
import '../core/theme/motion_colors.dart';
import '../core/theme/motion_theme.dart';
import '../loaders/motion_loader.dart';

enum MotionButtonEffect {
  scale,
  glow,
  ripple,
  magnetic,
}

class MotionButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final MotionButtonEffect effect;
  final Color? color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const MotionButton({
    super.key,
    required this.child,
    required this.onTap,
    this.effect = MotionButtonEffect.scale,
    this.color,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
  });

  @override
  State<MotionButton> createState() => _MotionButtonState();
}

class _MotionButtonState extends State<MotionButton>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  Offset _magneticOffset = Offset.zero;
  Offset? _rippleTapOffset;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.effect == MotionButtonEffect.ripple) {
      setState(() {
        _rippleTapOffset = details.localPosition;
      });
      _rippleController.forward(from: 0.0);
    }
    _animController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _animController.reverse();
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (widget.effect == MotionButtonEffect.magnetic) {
      final center = Offset(size.width / 2, size.height / 2);
      final delta = details.localPosition - center;
      setState(() {
        // Pulled toward pointer by max 12 pixels
        _magneticOffset = Offset(
          (delta.dx / size.width).clamp(-1.0, 1.0) * 12,
          (delta.dy / size.height).clamp(-1.0, 1.0) * 12,
        );
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.effect == MotionButtonEffect.magnetic) {
      setState(() {
        _magneticOffset = Offset.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = MotionTheme.of(context);
    final motionController = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;

    final btnColor = widget.color ?? activeTheme.primaryColor;

    return Obx(() {
      final isReduced = motionController?.reducedMotion ?? false;

      // Base decoration with conditional glow
      final decoration = BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          if (widget.effect == MotionButtonEffect.glow &&
              activeTheme.glowEffect &&
              !isReduced)
            BoxShadow(
              color: btnColor.withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
        ],
      );

      Widget buttonWidget = Container(
        decoration: decoration,
        padding: widget.padding,
        child: widget.child,
      );

      // Render interactions
      if (!isReduced) {
        if (widget.effect == MotionButtonEffect.magnetic) {
          final size = MediaQuery.of(context).size;
          buttonWidget = GestureDetector(
            onPanUpdate: (d) => _onPanUpdate(d, size),
            onPanEnd: _onPanEnd,
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(
                _magneticOffset.dx,
                _magneticOffset.dy,
                0,
              ),
              child: buttonWidget,
            ),
          );
        } else {
          // If ripple, paint the canvas ripple overlay
          if (widget.effect == MotionButtonEffect.ripple &&
              _rippleTapOffset != null) {
            buttonWidget = ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: CustomPaint(
                foregroundPainter: _RipplePainter(
                  offset: _rippleTapOffset!,
                  progress: _rippleController,
                  color: Colors.white.withValues(alpha: 0.28),
                ),
                child: buttonWidget,
              ),
            );
          }

          buttonWidget = GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: buttonWidget,
            ),
          );
        }
      } else {
        // Simplified click without heavy visual scaling for accessibility
        buttonWidget = InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: buttonWidget,
        );
      }

      return RepaintBoundary(child: buttonWidget);
    });
  }
}

class MotionExpandableFab extends StatefulWidget {
  final double distance;
  final List<Widget> children;
  final Widget? icon;

  const MotionExpandableFab({
    super.key,
    required this.distance,
    required this.children,
    this.icon,
  });

  @override
  State<MotionExpandableFab> createState() => _MotionExpandableFabState();
}

class _MotionExpandableFabState extends State<MotionExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = MotionTheme.of(context);

    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(activeTheme),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    ).animateFade(opacity: _open ? 1.0 : 0.0);
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);

    for (var i = 0, angle = 0.0; i < count; i++, angle += step) {
      children.add(
        _ExpandingActionButton(
          directionDegrees: angle,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab(MotionThemeData activeTheme) {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: FloatingActionButton(
          backgroundColor: activeTheme.primaryColor,
          onPressed: _toggle,
          child: widget.icon ?? const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}

class _ExpandingActionButton extends StatelessWidget {
  final double directionDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  const _ExpandingActionButton({
    required this.directionDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

/// Custom painter to draw expanding ripple circle on top of the button.
class _RipplePainter extends CustomPainter {
  final Offset offset;
  final Animation<double> progress;
  final Color color;

  _RipplePainter({
    required this.offset,
    required this.progress,
    required this.color,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t == 0.0 || t == 1.0) return;

    final maxRadius =
        math.sqrt(size.width * size.width + size.height * size.height);
    final currentRadius = maxRadius * t;
    final opacity = (1.0 - t).clamp(0.0, 1.0);

    final paint = Paint()
      ..color = color.withValues(alpha: opacity * color.a)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(offset, currentRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) => true;
}

enum MotionMorphState { idle, loading, success, error }

/// A premium button that morphs into a loader, success, or error state.
class MotionMorphingButton extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onTap;
  final Color? color;
  final double borderRadius;
  final double width;
  final double height;
  final Duration duration;

  const MotionMorphingButton({
    super.key,
    required this.child,
    required this.onTap,
    this.color,
    this.borderRadius = 12.0,
    this.width = 180.0,
    this.height = 50.0,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  State<MotionMorphingButton> createState() => _MotionMorphingButtonState();
}

class _MotionMorphingButtonState extends State<MotionMorphingButton> {
  MotionMorphState _state = MotionMorphState.idle;

  Future<void> _handleTap() async {
    if (_state != MotionMorphState.idle) return;

    setState(() {
      _state = MotionMorphState.loading;
    });

    try {
      await widget.onTap();
      if (mounted) {
        setState(() {
          _state = MotionMorphState.success;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _state = MotionMorphState.error;
        });
      }
    } finally {
      // Return to standard state after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _state = MotionMorphState.idle;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = MotionTheme.of(context);
    final btnColor = widget.color ?? activeTheme.primaryColor;

    final isIdle = _state == MotionMorphState.idle;
    final isSuccess = _state == MotionMorphState.success;
    final isError = _state == MotionMorphState.error;

    // Collapses to a perfect circle when animating or displaying status
    final targetWidth = isIdle ? widget.width : widget.height;
    final targetRadius = isIdle ? widget.borderRadius : widget.height / 2;

    Color stateColor = btnColor;
    if (isSuccess) stateColor = MotionColors.success;
    if (isError) stateColor = MotionColors.error;

    return Center(
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.fastOutSlowIn,
          width: targetWidth,
          height: widget.height,
          decoration: BoxDecoration(
            color: stateColor,
            borderRadius: BorderRadius.circular(targetRadius),
            boxShadow: [
              if (activeTheme.glowEffect)
                BoxShadow(
                  color: stateColor.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
            ],
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildInnerChild(),
          ),
        ),
      ),
    );
  }

  Widget _buildInnerChild() {
    switch (_state) {
      case MotionMorphState.idle:
        return KeyedSubtree(
          key: const ValueKey('idle'),
          child: widget.child,
        );
      case MotionMorphState.loading:
        return const SizedBox(
          width: 22,
          height: 22,
          child: MotionLoader(
            type: MotionLoaderType.liquid,
            color: Colors.white,
            size: 22,
          ),
        );
      case MotionMorphState.success:
        return const Icon(
          Icons.check_rounded,
          key: ValueKey('success'),
          color: Colors.white,
          size: 26,
        );
      case MotionMorphState.error:
        return const Icon(
          Icons.close_rounded,
          key: ValueKey('error'),
          color: Colors.white,
          size: 26,
        );
    }
  }
}
