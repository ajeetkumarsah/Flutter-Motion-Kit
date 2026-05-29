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

      // Verify widget structures are created in the tree
      expect(find.byType(MotionLoader), findsNWidgets(3));
      expect(find.byType(MotionWaveLoader), findsOneWidget);
      expect(find.byType(MotionMatrixLoader), findsOneWidget);
      expect(find.byType(MotionFuturisticLoader), findsOneWidget);
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

      // Trigger standard tap down/up cycles
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
