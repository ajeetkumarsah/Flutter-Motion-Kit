import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/utils/motion_curves.dart';

class MotionLikeButton extends StatefulWidget {
  final bool initialLiked;
  final ValueChanged<bool>? onChanged;
  final double size;

  const MotionLikeButton({
    super.key,
    this.initialLiked = false,
    this.onChanged,
    this.size = 28.0,
  });

  @override
  State<MotionLikeButton> createState() => _MotionLikeButtonState();
}

class _MotionLikeButtonState extends State<MotionLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _burstAnimation;
  late bool _liked;

  @override
  void initState() {
    super.initState();
    _liked = widget.initialLiked;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.8), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _burstAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      _liked = !_liked;
    });
    if (_liked) {
      _controller.reset();
      _controller.forward();
    } else {
      _controller.reverse();
    }
    widget.onChanged?.call(_liked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _LikeBurstPainter(
              burst: _burstAnimation.value,
              liked: _liked,
              color: Colors.redAccent,
            ),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(
                _liked ? Icons.favorite : Icons.favorite_border,
                color: _liked ? Colors.redAccent : Colors.grey[600],
                size: widget.size,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LikeBurstPainter extends CustomPainter {
  final double burst;
  final bool liked;
  final Color color;

  _LikeBurstPainter({
    required this.burst,
    required this.liked,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (burst == 0.0 || !liked) return;

    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw little burst sparks revolving outwards
    final sparkCount = 7;
    final maxDistance = size.width * 0.9;
    final currentDistance = maxDistance * burst;
    final opacity = 1.0 - burst;

    for (int i = 0; i < sparkCount; i++) {
      final angle = (i * 2 * math.pi / sparkCount) - (math.pi / 2);
      final sparkCenter = Offset(
        center.dx + currentDistance * math.cos(angle),
        center.dy + currentDistance * math.sin(angle),
      );

      paint.color = color.withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawCircle(sparkCenter, 3.0 * (1.0 - burst), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LikeBurstPainter oldDelegate) {
    return oldDelegate.burst != burst || oldDelegate.liked != liked;
  }
}

class MotionAnimatedCheckmark extends StatefulWidget {
  final bool checked;
  final double size;
  final Color? color;

  const MotionAnimatedCheckmark({
    super.key,
    required this.checked,
    this.size = 32.0,
    this.color,
  });

  @override
  State<MotionAnimatedCheckmark> createState() =>
      _MotionAnimatedCheckmarkState();
}

class _MotionAnimatedCheckmarkState extends State<MotionAnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _checkAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.checked) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant MotionAnimatedCheckmark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.checked != oldWidget.checked) {
      if (widget.checked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _checkAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: _CheckmarkPainter(
              progress: _checkAnimation.value,
              color: activeColor,
            ),
          );
        },
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckmarkPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final circlePaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle container
    canvas.drawCircle(center, radius, circlePaint);

    final path = Path();
    // Custom Checkmark shape path coordinates
    final startX = size.width * 0.28;
    final startY = size.height * 0.5;
    final midX = size.width * 0.44;
    final midY = size.height * 0.65;
    final endX = size.width * 0.72;
    final endY = size.height * 0.32;

    path.moveTo(startX, startY);
    path.lineTo(midX, midY);
    path.lineTo(endX, endY);

    // Compute animated path metrics manually
    final totalLength =
        (midX - startX) + (endX - midX); // Simple scale approximation
    final currentPath = Path();

    if (progress > 0) {
      currentPath.moveTo(startX, startY);
      final checkPart = (midX - startX) / totalLength;

      if (progress <= checkPart) {
        final ratio = progress / checkPart;
        final currentMidX = startX + (midX - startX) * ratio;
        final currentMidY = startY + (midY - startY) * ratio;
        currentPath.lineTo(currentMidX, currentMidY);
      } else {
        currentPath.lineTo(midX, midY);
        final ratio = (progress - checkPart) / (1 - checkPart);
        final currentEndX = midX + (endX - midX) * ratio;
        final currentEndY = midY + (endY - midY) * ratio;
        currentPath.lineTo(currentEndX, currentEndY);
      }
      canvas.drawPath(currentPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class MotionLiquidToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  const MotionLiquidToggle({
    super.key,
    this.initialValue = false,
    this.onChanged,
    this.activeColor,
  });

  @override
  State<MotionLiquidToggle> createState() => _MotionLiquidToggleState();
}

class _MotionLiquidToggleState extends State<MotionLiquidToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: MotionCurves.magneticSpring),
    );

    if (_value) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onToggle() {
    setState(() {
      _value = !_value;
    });
    if (_value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    final themeActive = widget.activeColor ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: _onToggle,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          final t = _slideAnimation.value;
          final bgColor = Color.lerp(Colors.grey[700], themeActive, t);

          return Container(
            width: 60.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 2.0 + t * 28.0,
                  top: 2.0,
                  child: Container(
                    width: 28.0,
                    height: 28.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class MotionBookmarkButton extends StatefulWidget {
  final bool initialBookmarked;
  final ValueChanged<bool>? onChanged;
  final double size;

  const MotionBookmarkButton({
    super.key,
    this.initialBookmarked = false,
    this.onChanged,
    this.size = 28.0,
  });

  @override
  State<MotionBookmarkButton> createState() => _MotionBookmarkButtonState();
}

class _MotionBookmarkButtonState extends State<MotionBookmarkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late bool _bookmarked;

  @override
  void initState() {
    super.initState();
    _bookmarked = widget.initialBookmarked;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      _bookmarked = !_bookmarked;
    });
    _controller.reset();
    _controller.forward();
    widget.onChanged?.call(_bookmarked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Icon(
              _bookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _bookmarked ? Colors.amber : Colors.grey[600],
              size: widget.size,
            ),
          );
        },
      ),
    );
  }
}
