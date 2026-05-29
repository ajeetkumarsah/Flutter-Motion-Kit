import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/motion_colors.dart';
import '../theme/motion_theme.dart';

class MotionThemeController extends GetxController {
  final Rx<MotionThemeData> _currentTheme = MotionThemeData.dark().obs;

  MotionThemeData get theme => _currentTheme.value;
  bool get isDark => _currentTheme.value.isDark;
  bool get glowEffect => _currentTheme.value.glowEffect;

  void toggleTheme() {
    if (isDark) {
      setTheme(MotionThemeData.light());
    } else {
      setTheme(MotionThemeData.dark());
    }
  }

  void setTheme(MotionThemeData newTheme) {
    _currentTheme.value = newTheme;
    Get.changeTheme(newTheme.toThemeData());
    update();
  }

  void setGlowEffect(bool enabled) {
    _currentTheme.value = _currentTheme.value.copyWith(glowEffect: enabled);
    update();
  }

  void changePrimaryColor(Color color) {
    _currentTheme.value = _currentTheme.value.copyWith(primaryColor: color);
    update();
  }

  void changeAccentGradient(LinearGradient gradient) {
    _currentTheme.value =
        _currentTheme.value.copyWith(accentGradient: gradient);
    update();
  }

  // Futuristic presets
  void applyCyberpunkPreset() {
    setTheme(MotionThemeData(
      isDark: true,
      primaryColor: MotionColors.primaryNeon,
      secondaryColor: MotionColors.secondaryNeon,
      backgroundColor: const Color(0xFF0C081C),
      surfaceColor: const Color(0xFF160E30),
      cardColor: const Color(0xFF221646),
      glowEffect: true,
      accentGradient: MotionColors.cyberGradient,
    ));
  }

  void applyMidnightPresets() {
    setTheme(MotionThemeData(
      isDark: true,
      primaryColor: Colors.amber,
      secondaryColor: MotionColors.electricBlue,
      backgroundColor: const Color(0xFF080D1A),
      surfaceColor: const Color(0xFF0F182E),
      cardColor: const Color(0xFF182647),
      glowEffect: true,
      accentGradient: const LinearGradient(
        colors: [Colors.amber, Colors.orangeAccent, MotionColors.electricBlue],
      ),
    ));
  }

  void applyNeonPurplePreset() {
    setTheme(MotionThemeData(
      isDark: true,
      primaryColor: const Color(0xFFD000FF),
      secondaryColor: const Color(0xFF00F5FF),
      backgroundColor: const Color(0xFF07020D),
      surfaceColor: const Color(0xFF130624),
      cardColor: const Color(0xFF210C3E),
      glowEffect: true,
      accentGradient: const LinearGradient(
        colors: [Color(0xFFD000FF), Color(0xFF00F5FF)],
      ),
    ));
  }
}
