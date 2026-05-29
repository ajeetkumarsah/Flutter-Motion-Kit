import 'package:flutter/material.dart';
import '../../core/utils/motion_curves.dart';

class MotionMorphContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final BoxDecoration decoration;
  final Duration duration;

  const MotionMorphContainer({
    super.key,
    required this.child,
    this.width = 150.0,
    this.height = 150.0,
    required this.decoration,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: MotionCurves.swiftOut,
      width: width,
      height: height,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: child,
      ),
    );
  }
}
