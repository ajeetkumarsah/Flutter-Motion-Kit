import 'package:get/get.dart';

class MotionController extends GetxController {
  // Accessibility: Reduce Motion
  final RxBool _reducedMotion = false.obs;
  bool get reducedMotion => _reducedMotion.value;

  // Performance Mode: turn off heavy effects (real-time glass blurs, high density particle backgrounds)
  final RxBool _performanceMode = false.obs;
  bool get performanceMode => _performanceMode.value;

  // Global Animation Speed Adjuster
  final RxDouble _speedMultiplier = 1.0.obs;
  double get speedMultiplier => _speedMultiplier.value;

  void toggleReducedMotion() {
    _reducedMotion.value = !_reducedMotion.value;
    update();
  }

  void setReducedMotion(bool value) {
    _reducedMotion.value = value;
    update();
  }

  void togglePerformanceMode() {
    _performanceMode.value = !_performanceMode.value;
    update();
  }

  void setPerformanceMode(bool value) {
    _performanceMode.value = value;
    update();
  }

  void setSpeedMultiplier(double multiplier) {
    _speedMultiplier.value = multiplier.clamp(0.1, 3.0);
    update();
  }

  // Helper duration generator
  Duration getScaledDuration(Duration baseDuration) {
    if (reducedMotion) {
      return Duration.zero; // Or highly minimized crossfade timing
    }
    return Duration(milliseconds: (baseDuration.inMilliseconds * (1 / _speedMultiplier.value)).round());
  }
}
