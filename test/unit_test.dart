import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_motion_kit/flutter_motion_kit.dart';

void main() {
  group('GetX Controller Unit Tests', () {
    late MotionController motionController;
    late MotionThemeController themeController;

    setUp(() {
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

      const baseDuration = Duration(milliseconds: 1000);
      expect(motionController.getScaledDuration(baseDuration),
          equals(baseDuration));

      motionController.setSpeedMultiplier(2.0);
      expect(motionController.speedMultiplier, equals(2.0));
      expect(motionController.getScaledDuration(baseDuration).inMilliseconds,
          equals(500));

      motionController.setSpeedMultiplier(0.5);
      expect(motionController.speedMultiplier, equals(0.5));
      expect(motionController.getScaledDuration(baseDuration).inMilliseconds,
          equals(2000));
    });

    test('MotionController Reduced Motion Override', () {
      expect(motionController.reducedMotion, isFalse);

      motionController.toggleReducedMotion();
      expect(motionController.reducedMotion, isTrue);

      const baseDuration = Duration(milliseconds: 800);
      expect(motionController.getScaledDuration(baseDuration),
          equals(Duration.zero));
    });

    test('MotionThemeController Preset Selection', () {
      expect(themeController.isDark, isTrue);
      expect(themeController.glowEffect, isTrue);

      themeController.toggleTheme();
      expect(themeController.isDark, isFalse);
      expect(themeController.theme.primaryColor,
          equals(MotionColors.electricBlue));

      themeController.applyCyberpunkPreset();
      expect(themeController.isDark, isTrue);
      expect(
          themeController.theme.primaryColor, equals(MotionColors.primaryNeon));
      expect(themeController.theme.accentGradient,
          equals(MotionColors.cyberGradient));
    });

    test('Category Style Enums Initialization Tests', () {
      // Validate all category enum entries are compile-safe and exist
      expect(MotionAiStyle.values.length, equals(8));
      expect(MotionLiquidStyle.values.length, equals(3));
      expect(MotionGlassStyle.values.length, equals(3));
      expect(MotionSpaceStyle.values.length, equals(3));
      expect(MotionGamingStyle.values.length, equals(3));
      expect(MotionPhysicsStyle.values.length, equals(6));
      expect(MotionMinimalStyle.values.length, equals(3));
      expect(MotionSaasStyle.values.length, equals(3));
      expect(MotionCyberpunkStyle.values.length, equals(5));
      expect(MotionNatureStyle.values.length, equals(5));
      expect(MotionLuxuryStyle.values.length, equals(4));
      expect(MotionGeometryStyle.values.length, equals(4));
      expect(MotionSocialStyle.values.length, equals(3));
      expect(MotionThreeDStyle.values.length, equals(3));
      expect(MotionAudioStyle.values.length, equals(3));
      expect(MotionArtisticStyle.values.length, equals(3));
      expect(MotionExperimentalStyle.values.length, equals(4));
    });

    test('MotionLoader.fromJson and generator parsing tests', () {
      final jsonLoader = MotionLoader.fromJson(const {
        'category': 'cyberpunk',
        'style': 'terminalBoot',
        'size': 60.0,
      });
      expect(jsonLoader, isA<MotionLoader>());

      final genWidget = MotionLoader.generator(
        category: 'nature',
        style: 'firefly',
        size: 80.0,
      );
      expect(genWidget, isA<MotionLoader>());
    });
  });
}
