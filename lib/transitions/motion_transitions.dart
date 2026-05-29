import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/utils/motion_curves.dart';

class MotionTransition {
  /// 1. Fade transition route
  static PageRouteBuilder fade({required Widget page, Duration duration = const Duration(milliseconds: 300)}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// 2. Slide transition route from right to left
  static PageRouteBuilder slideRight({required Widget page, Duration duration = const Duration(milliseconds: 350)}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: MotionCurves.swiftOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// 3. Zoom / Scale transition route
  static PageRouteBuilder zoom({required Widget page, Duration duration = const Duration(milliseconds: 350)}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<double>(begin: 0.85, end: 1.0)
            .chain(CurveTween(curve: MotionCurves.magneticSpring));
        return ScaleTransition(
          scale: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// 4. Cyber Glass overlay backdrop blur transition
  static PageRouteBuilder glassOverlay({required Widget page, Duration duration = const Duration(milliseconds: 400)}) {
    return PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black.withOpacity(0.4),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final blurVal = animation.value * 12.0;
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurVal, sigmaY: blurVal),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }

  /// 5. Shared Axis transition route (Horizontal or Vertical with crossfade)
  static PageRouteBuilder sharedAxis({
    required Widget page,
    bool vertical = false,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideTween = Tween<Offset>(
          begin: vertical ? const Offset(0.0, 0.12) : const Offset(0.12, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: MotionCurves.swiftOut));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// 6. Mesmerizing liquid wave sweep transition
  static PageRouteBuilder liquidSwipe({
    required Widget page,
    Duration duration = const Duration(milliseconds: 650),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return ClipPath(
              clipper: _LiquidClipper(progress: animation.value),
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}

/// Custom clipper to create the liquid wave page sweeps
class _LiquidClipper extends CustomClipper<Path> {
  final double progress;

  _LiquidClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (progress == 0.0) {
      return path; // fully clipped
    }
    if (progress == 1.0) {
      path.addRect(Offset.zero & size);
      return path; // fully visible
    }

    // Sweep from right to left
    final sweepX = size.width * (1.0 - progress);

    path.moveTo(size.width, 0);
    path.lineTo(sweepX, 0);

    // Draw wavy line from top to bottom
    // Dampen amplitude as progress approaches 0.0 and 1.0
    final waveAmplitude = size.width * 0.1 * math.sin(progress * math.pi);
    final wavePoints = 40;
    
    for (int i = 1; i <= wavePoints; i++) {
      final y = size.height * (i / wavePoints);
      final waveOffset = waveAmplitude * math.sin((y / size.height) * 2.5 * math.pi);
      path.lineTo(sweepX - waveOffset, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant _LiquidClipper oldClipper) => oldClipper.progress != progress;
}
