import 'package:flutter/animation.dart';

class MotionCurves {
  /// Custom Cubic Beziers inspired by Apple/Framer Motion
  static const Curve swiftOut = Cubic(0.25, 1.0, 0.5, 1.0);
  
  static const Curve magneticSpring = Cubic(0.175, 0.885, 0.32, 1.275);
  
  static const Curve fluidIn = Cubic(0.6, -0.28, 0.735, 0.045);
  
  static const Curve fluidOut = Cubic(0.175, 0.885, 0.32, 1.275);
  
  static const Curve auroraFlow = Cubic(0.445, 0.05, 0.55, 0.95);

  static const Curve springy = ElasticOutCurve(0.7);

  static const Curve bouncy = ElasticOutCurve(0.5);

  static const Curve extremeBouncy = ElasticOutCurve(0.3);
}
