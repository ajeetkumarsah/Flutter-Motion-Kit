import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_motion_kit/flutter_motion_kit.dart';

void main() {
  group('Widget Rendering & Tap Tests', () {
    setUp(() {
      Get.reset();
      Get.put(MotionController());
      Get.put(MotionThemeController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('MotionLoader Wave and Matrix Render Tests',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                MotionLoader(type: MotionLoaderType.wave, size: 50),
                MotionLoader(type: MotionLoaderType.matrix, size: 60),
                MotionLoader(type: MotionLoaderType.futuristic, size: 40),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(MotionLoader), findsNWidgets(3));
      expect(find.byType(MotionWaveLoader), findsOneWidget);
      expect(find.byType(MotionMatrixLoader), findsOneWidget);
      expect(find.byType(MotionFuturisticLoader), findsOneWidget);
    });

    testWidgets('MotionLoader Premium Category Render Tests',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // AI Styles
                  MotionLoader.ai(style: MotionAiStyle.neuralNetwork, size: 40),
                  MotionLoader.ai(style: MotionAiStyle.thinking, size: 40),
                  MotionLoader.ai(style: MotionAiStyle.quantum, size: 40),
                  MotionLoader.ai(style: MotionAiStyle.tokenStream, size: 40),

                  // Liquid Styles
                  MotionLoader.liquid(
                      style: MotionLiquidStyle.lavaLamp, size: 40),
                  MotionLoader.liquid(
                      style: MotionLiquidStyle.waterDrop, size: 40),
                  MotionLoader.liquid(
                      style: MotionLiquidStyle.inkSpread, size: 40),

                  // Glass Styles
                  MotionLoader.glass(
                      style: MotionGlassStyle.glassOrb, size: 40),
                  MotionLoader.glass(
                      style: MotionGlassStyle.prismCrystal, size: 40),
                  MotionLoader.glass(style: MotionGlassStyle.aurora, size: 40),

                  // Space Styles
                  MotionLoader.space(
                      style: MotionSpaceStyle.blackHole, size: 40),
                  MotionLoader.space(style: MotionSpaceStyle.galaxy, size: 40),
                  MotionLoader.space(
                      style: MotionSpaceStyle.warpSpeed, size: 40),

                  // Gaming Styles
                  MotionLoader.gaming(
                      style: MotionGamingStyle.xpProgress, size: 40),
                  MotionLoader.gaming(
                      style: MotionGamingStyle.bossFight, size: 40),
                  MotionLoader.gaming(style: MotionGamingStyle.pixel, size: 40),

                  // Physics Styles
                  MotionLoader.physics(
                      style: MotionPhysicsStyle.pendulum, size: 40),
                  MotionLoader.physics(
                      style: MotionPhysicsStyle.bounceChain, size: 40),
                  MotionLoader.physics(
                      style: MotionPhysicsStyle.gravityOrbit, size: 40),

                  // Minimal Styles
                  MotionLoader.minimal(
                      style: MotionMinimalStyle.lineDraw, size: 40),
                  MotionLoader.minimal(
                      style: MotionMinimalStyle.morphShape, size: 40),
                  MotionLoader.minimal(
                      style: MotionMinimalStyle.infiniteRibbon, size: 40),

                  // SaaS Styles
                  MotionLoader.saas(style: MotionSaasStyle.pulseGrid, size: 40),
                  MotionLoader.saas(style: MotionSaasStyle.analytics, size: 40),
                  MotionLoader.saas(style: MotionSaasStyle.cloudSync, size: 40),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify that all 25 premium category styles render successfully
      expect(find.byType(MotionLoader), findsNWidgets(25));
    });

    testWidgets('MotionButton Tap & Custom Ripple Render Tests',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MotionButton(
              effect: MotionButtonEffect.ripple,
              onTap: () {
                tapped = true;
              },
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      expect(find.text('Tap Me'), findsOneWidget);
      expect(tapped, isFalse);

      await tester.tap(find.byType(MotionButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('MotionGlassContainer & MotionSkeleton Render Tests',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MotionGlassContainer(
              borderRadius: 12.0,
              blur: 10.0,
              opacity: 0.1,
              child: MotionSkeleton.profile(),
            ),
          ),
        ),
      );

      expect(find.byType(MotionGlassContainer), findsOneWidget);
      expect(find.byType(MotionSkeleton),
          findsNWidgets(3)); // Avatar + 2 Rectangle lines
    });
  });
}
