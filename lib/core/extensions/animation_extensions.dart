import 'package:flutter/material.dart';
import '../../core/utils/motion_curves.dart';

extension MotionWidgetExtensions on Widget {
  /// Wraps a widget in an easy implicit animated scale effect
  Widget animateScale({
    Key? key,
    double scale = 1.0,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = MotionCurves.swiftOut,
  }) {
    return AnimatedScale(
      key: key,
      scale: scale,
      duration: duration,
      curve: curve,
      child: this,
    );
  }

  /// Wraps a widget in an easy implicit animated opacity/fade effect
  Widget animateFade({
    Key? key,
    double opacity = 1.0,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    return AnimatedOpacity(
      key: key,
      opacity: opacity,
      duration: duration,
      curve: curve,
      child: this,
    );
  }

  /// Wraps a widget in a slide-offset animated wrapper
  Widget animateSlide({
    Key? key,
    Offset offset = Offset.zero,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = MotionCurves.swiftOut,
  }) {
    return AnimatedSlide(
      key: key,
      offset: offset,
      duration: duration,
      curve: curve,
      child: this,
    );
  }

  /// Wraps a widget in a rotation effect
  Widget animateRotation({
    Key? key,
    double turns = 0.0,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = MotionCurves.swiftOut,
  }) {
    return AnimatedRotation(
      key: key,
      turns: turns,
      duration: duration,
      curve: curve,
      child: this,
    );
  }
}
