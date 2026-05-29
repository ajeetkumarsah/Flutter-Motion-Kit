import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_motion_kit/flutter_motion_kit.dart';

void main() {
  group('GetX Controller Unit Tests', () {
    late MotionController motionController;
    late MotionThemeController themeController;

    setUp(() {
      // Clear GetX instance registry and re-inject controllers
      Get.reset();
      motionController = Get.put(MotionController());
      themeController = Get.put(MotionThemeController());
    });

    tearDown(() {
      Get.reset();
    });

    test('MotionController Default State & Speed Calculations', () {
      expect(motionController.reducedMotion, isFalse);
      expect(motionController.performanceMode, isFalse);
      expect(motionController.speedMultiplier, equals(1.0));

      // Scaling normal speed
      const baseDuration = Duration(milliseconds: 1000);
      expect(motionController.getScaledDuration(baseDuration),
          equals(baseDuration));

      // Speeding up (2.0x) makes duration shorter (500ms)
      motionController.setSpeedMultiplier(2.0);
      expect(motionController.speedMultiplier, equals(2.0));
      expect(motionController.getScaledDuration(baseDuration).inMilliseconds,
          equals(500));

      // Slowing down (0.5x) makes duration longer (2000ms)
      motionController.setSpeedMultiplier(0.5);
      expect(motionController.getScaledDuration(baseDuration).inMilliseconds,
          equals(2000));
    });

    test('MotionController Reduced Motion Override', () {
      expect(motionController.reducedMotion, isFalse);

      motionController.toggleReducedMotion();
      expect(motionController.reducedMotion, isTrue);

      // Reduced motion forces scaled duration to zero for accessibility compliance
      const baseDuration = Duration(milliseconds: 800);
      expect(motionController.getScaledDuration(baseDuration),
          equals(Duration.zero));
    });

    test('MotionThemeController Preset Selection', () {
      expect(themeController.isDark, isTrue);
      expect(themeController.glowEffect, isTrue);

      // Toggle Theme
      themeController.toggleTheme();
      expect(themeController.isDark, isFalse);
      expect(themeController.theme.primaryColor,
          equals(MotionColors.electricBlue));

      // Apply Cyberpunk Presets
      themeController.applyCyberpunkPreset();
      expect(themeController.isDark, isTrue);
      expect(
          themeController.theme.primaryColor, equals(MotionColors.primaryNeon));
      expect(themeController.theme.accentGradient,
          equals(MotionColors.cyberGradient));
    });
  });
}
