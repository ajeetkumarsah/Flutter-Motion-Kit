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
                  // AI Styles (8)
                  MotionLoader.ai(style: MotionAiStyle.neuralNetwork, size: 40),
                  MotionLoader.ai(style: MotionAiStyle.thinking, size: 40),
                  MotionLoader.ai(style: MotionAiStyle.quantum, size: 40),
                  MotionLoader.ai(style: MotionAiStyle.tokenStream, size: 40),
                  MotionLoader.ai(
                      style: MotionAiStyle.tokenPrediction, size: 40),
                  MotionLoader.ai(style: MotionAiStyle.neuralPulse, size: 40),
                  MotionLoader.ai(style: MotionAiStyle.tensorFlow, size: 40),
                  MotionLoader.ai(style: MotionAiStyle.aiEye, size: 40),

                  // Liquid Styles (3)
                  MotionLoader.liquid(
                      style: MotionLiquidStyle.lavaLamp, size: 40),
                  MotionLoader.liquid(
                      style: MotionLiquidStyle.waterDrop, size: 40),
                  MotionLoader.liquid(
                      style: MotionLiquidStyle.inkSpread, size: 40),

                  // Glass Styles (3)
                  MotionLoader.glass(
                      style: MotionGlassStyle.glassOrb, size: 40),
                  MotionLoader.glass(
                      style: MotionGlassStyle.prismCrystal, size: 40),
                  MotionLoader.glass(style: MotionGlassStyle.aurora, size: 40),

                  // Space Styles (3)
                  MotionLoader.space(
                      style: MotionSpaceStyle.blackHole, size: 40),
                  MotionLoader.space(style: MotionSpaceStyle.galaxy, size: 40),
                  MotionLoader.space(
                      style: MotionSpaceStyle.warpSpeed, size: 40),

                  // Gaming Styles (3)
                  MotionLoader.gaming(
                      style: MotionGamingStyle.xpProgress, size: 40),
                  MotionLoader.gaming(
                      style: MotionGamingStyle.bossFight, size: 40),
                  MotionLoader.gaming(style: MotionGamingStyle.pixel, size: 40),

                  // Physics Styles (6)
                  MotionLoader.physics(
                      style: MotionPhysicsStyle.pendulum, size: 40),
                  MotionLoader.physics(
                      style: MotionPhysicsStyle.bounceChain, size: 40),
                  MotionLoader.physics(
                      style: MotionPhysicsStyle.gravityOrbit, size: 40),
                  MotionLoader.physics(
                      style: MotionPhysicsStyle.fluidParticle, size: 40),
                  MotionLoader.physics(
                      style: MotionPhysicsStyle.sandSimulation, size: 40),
                  MotionLoader.physics(
                      style: MotionPhysicsStyle.magneticField, size: 40),

                  // Minimal Styles (3)
                  MotionLoader.minimal(
                      style: MotionMinimalStyle.lineDraw, size: 40),
                  MotionLoader.minimal(
                      style: MotionMinimalStyle.morphShape, size: 40),
                  MotionLoader.minimal(
                      style: MotionMinimalStyle.infiniteRibbon, size: 40),

                  // SaaS Styles (3)
                  MotionLoader.saas(style: MotionSaasStyle.pulseGrid, size: 40),
                  MotionLoader.saas(style: MotionSaasStyle.analytics, size: 40),
                  MotionLoader.saas(style: MotionSaasStyle.cloudSync, size: 40),

                  // Cyberpunk Styles (5)
                  MotionLoader.cyberpunk(
                      style: MotionCyberpunkStyle.terminalBoot, size: 40),
                  MotionLoader.cyberpunk(
                      style: MotionCyberpunkStyle.glitch, size: 40),
                  MotionLoader.cyberpunk(
                      style: MotionCyberpunkStyle.cyberRing, size: 40),
                  MotionLoader.cyberpunk(
                      style: MotionCyberpunkStyle.dataStream, size: 40),
                  MotionLoader.cyberpunk(
                      style: MotionCyberpunkStyle.firewallScanner, size: 40),

                  // Nature Styles (5)
                  MotionLoader.nature(
                      style: MotionNatureStyle.firefly, size: 40),
                  MotionLoader.nature(
                      style: MotionNatureStyle.tornado, size: 40),
                  MotionLoader.nature(
                      style: MotionNatureStyle.volcano, size: 40),
                  MotionLoader.nature(
                      style: MotionNatureStyle.leafWind, size: 40),
                  MotionLoader.nature(
                      style: MotionNatureStyle.solarEclipse, size: 40),

                  // Luxury Styles (4)
                  MotionLoader.luxury(
                      style: MotionLuxuryStyle.diamondSpark, size: 40),
                  MotionLoader.luxury(
                      style: MotionLuxuryStyle.silkFlow, size: 40),
                  MotionLoader.luxury(
                      style: MotionLuxuryStyle.goldSweep, size: 40),
                  MotionLoader.luxury(
                      style: MotionLuxuryStyle.premiumWatch, size: 40),

                  // Geometry Styles (4)
                  MotionLoader.geometry(
                      style: MotionGeometryStyle.infiniteCube, size: 40),
                  MotionLoader.geometry(
                      style: MotionGeometryStyle.hexagonSwarm, size: 40),
                  MotionLoader.geometry(
                      style: MotionGeometryStyle.fractal, size: 40),
                  MotionLoader.geometry(
                      style: MotionGeometryStyle.polygonMorph, size: 40),

                  // Social Styles (3)
                  MotionLoader.social(
                      style: MotionSocialStyle.reelsUpload, size: 40),
                  MotionLoader.social(
                      style: MotionSocialStyle.liveStream, size: 40),
                  MotionLoader.social(
                      style: MotionSocialStyle.storyRing, size: 40),

                  // 3D Styles (3)
                  MotionLoader.threeD(
                      style: MotionThreeDStyle.floatingCube, size: 40),
                  MotionLoader.threeD(
                      style: MotionThreeDStyle.isometric, size: 40),
                  MotionLoader.threeD(
                      style: MotionThreeDStyle.holographicSphere, size: 40),

                  // Audio Styles (3)
                  MotionLoader.audio(
                      style: MotionAudioStyle.equalizer, size: 40),
                  MotionLoader.audio(style: MotionAudioStyle.vinyl, size: 40),
                  MotionLoader.audio(
                      style: MotionAudioStyle.beatWave, size: 40),

                  // Artistic Styles (3)
                  MotionLoader.artistic(
                      style: MotionArtisticStyle.zenCircle, size: 40),
                  MotionLoader.artistic(
                      style: MotionArtisticStyle.origami, size: 40),
                  MotionLoader.artistic(
                      style: MotionArtisticStyle.calligraphyStroke, size: 40),

                  // Experimental Styles (4)
                  MotionLoader.experimental(
                      style: MotionExperimentalStyle.timeWarp, size: 40),
                  MotionLoader.experimental(
                      style: MotionExperimentalStyle.portal, size: 40),
                  MotionLoader.experimental(
                      style: MotionExperimentalStyle.dimensionalRift, size: 40),
                  MotionLoader.experimental(
                      style: MotionExperimentalStyle.wormhole, size: 40),

                  // MotionBuilder stack (1)
                  const MotionBuilder(
                    effects: [
                      GlowEffect(color: Colors.blue),
                      FloatEffect(dy: 8.0),
                    ],
                    child: Text('Compound Effect Stack'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify that all 66 premium category styles render successfully
      expect(find.byType(MotionLoader), findsNWidgets(66));
      expect(find.byType(MotionBuilder), findsOneWidget);
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
