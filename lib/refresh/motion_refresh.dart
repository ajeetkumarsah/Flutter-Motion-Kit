import 'package:flutter/material.dart';

import '../loaders/motion_loader.dart';

class MotionRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;

  const MotionRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
  });

  @override
  State<MotionRefreshIndicator> createState() => _MotionRefreshIndicatorState();
}

class _MotionRefreshIndicatorState extends State<MotionRefreshIndicator> {
  double _pullOffset = 0.0;
  bool _isRefreshing = false;

  void _onScrollNotification(ScrollNotification notification) {
    if (_isRefreshing) return;

    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels < 0) {
        setState(() {
          // Track overscroll distance
          _pullOffset = (-metrics.pixels).clamp(0.0, 110.0);
        });
      } else if (_pullOffset > 0) {
        setState(() {
          _pullOffset = 0.0;
        });
      }
    } else if (notification is ScrollEndNotification) {
      if (_pullOffset >= 80.0) {
        _triggerRefresh();
      } else {
        setState(() {
          _pullOffset = 0.0;
        });
      }
    }
  }

  Future<void> _triggerRefresh() async {
    setState(() {
      _isRefreshing = true;
      _pullOffset = 60.0;
    });

    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
          _pullOffset = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? Theme.of(context).primaryColor;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _onScrollNotification(notification);
        return false;
      },
      child: Stack(
        children: [
          // Background content
          widget.child,

          // Pull indicator panel
          if (_pullOffset > 0 || _isRefreshing)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: _pullOffset,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                ),
                child: Opacity(
                  opacity: (_pullOffset / 60.0).clamp(0.0, 1.0),
                  child: _isRefreshing
                      ? MotionLoader(
                          type: MotionLoaderType.liquid,
                          color: activeColor,
                          size: 36)
                      : MotionLoader(
                          type: MotionLoaderType.orbit,
                          color: activeColor,
                          size: 30),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
