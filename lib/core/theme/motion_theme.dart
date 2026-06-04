import 'package:flutter/material.dart';
import 'motion_colors.dart';

class MotionThemeData {
  final bool isDark;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color cardColor;
  final bool glowEffect;
  final double borderRadius;
  final LinearGradient accentGradient;

  Color get textColor => isDark ? Colors.white : const Color(0xFF090A0F);

  MotionThemeData({
    required this.isDark,
    this.primaryColor = MotionColors.primaryNeon,
    this.secondaryColor = MotionColors.secondaryNeon,
    this.backgroundColor = MotionColors.darkBackground,
    this.surfaceColor = MotionColors.darkSurface,
    this.cardColor = MotionColors.darkSurfaceCard,
    this.glowEffect = true,
    this.borderRadius = 16.0,
    this.accentGradient = MotionColors.cyberGradient,
  });

  factory MotionThemeData.dark() {
    return MotionThemeData(
      isDark: true,
      primaryColor: MotionColors.primaryNeon,
      secondaryColor: MotionColors.secondaryNeon,
      backgroundColor: MotionColors.darkBackground,
      surfaceColor: MotionColors.darkSurface,
      cardColor: MotionColors.darkSurfaceCard,
      glowEffect: true,
      accentGradient: MotionColors.cyberGradient,
    );
  }

  factory MotionThemeData.light() {
    return MotionThemeData(
      isDark: false,
      primaryColor: MotionColors.electricBlue,
      secondaryColor: MotionColors.secondaryNeon,
      backgroundColor: MotionColors.lightBackground,
      surfaceColor: MotionColors.lightSurface,
      cardColor: MotionColors.lightSurfaceCard,
      glowEffect: false,
      accentGradient: MotionColors.auroraGradient,
    );
  }

  ThemeData toThemeData() {
    final base = isDark ? ThemeData.dark() : ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      primaryColor: primaryColor,
      colorScheme: base.colorScheme.copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
      ),
    );
  }

  MotionThemeData copyWith({
    bool? isDark,
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? cardColor,
    bool? glowEffect,
    double? borderRadius,
    LinearGradient? accentGradient,
  }) {
    return MotionThemeData(
      isDark: isDark ?? this.isDark,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      cardColor: cardColor ?? this.cardColor,
      glowEffect: glowEffect ?? this.glowEffect,
      borderRadius: borderRadius ?? this.borderRadius,
      accentGradient: accentGradient ?? this.accentGradient,
    );
  }
}

class MotionTheme extends InheritedWidget {
  final MotionThemeData data;

  const MotionTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static MotionThemeData of(BuildContext context) {
    final MotionTheme? result =
        context.dependOnInheritedWidgetOfExactType<MotionTheme>();
    return result?.data ?? MotionThemeData.dark();
  }

  @override
  bool updateShouldNotify(MotionTheme oldWidget) => data != oldWidget.data;
}
