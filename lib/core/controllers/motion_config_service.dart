import 'package:get/get.dart';
import 'motion_controller.dart';
import 'motion_theme_controller.dart';

/// Central configuration service for flutter_motion_kit.
/// Manages the dependency injection of all necessary controllers.
class MotionConfigService extends GetxService {
  /// Initializes the centralized animation and theme controllers.
  /// This should be called in the main entry point of the app (e.g. `main()`).
  static Future<void> init() async {
    // Inject Motion Controller (handles Speed scaling, Reduced Motion, Performance Mode)
    Get.put<MotionController>(MotionController(), permanent: true);

    // Inject Theme Controller (handles dynamic theme toggles, neon gradients, and cyberpunk presets)
    Get.put<MotionThemeController>(MotionThemeController(), permanent: true);
  }
}
