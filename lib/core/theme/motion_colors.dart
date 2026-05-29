import 'package:flutter/material.dart';

class MotionColors {
  // Theme Backgrounds
  static const Color darkBackground = Color(0xFF090A0F);
  static const Color darkSurface = Color(0xFF131520);
  static const Color darkSurfaceCard = Color(0xFF1E2132);

  static const Color lightBackground = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceCard = Color(0xFFF1F3F9);

  // Futuristic Neon Palettes
  static const Color primaryNeon = Color(0xFF00FFCC); // Cyan
  static const Color secondaryNeon = Color(0xFFFF007F); // Pink/Rose
  static const Color accentNeon = Color(0xFF7B2CBF); // Purple
  static const Color electricBlue = Color(0xFF007BFF);
  static const Color deepSpace = Color(0xFF120E2E);

  // Status Colors
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF1744);
  static const Color warning = Color(0xFFFFD600);
  static const Color info = Color(0xFF29B6F6);

  // Shimmer Gradients
  static const List<Color> darkShimmerColors = [
    Color(0xFF1E2132),
    Color(0xFF2D314C),
    Color(0xFF1E2132),
  ];

  static const List<Color> lightShimmerColors = [
    Color(0xFFE1E5EE),
    Color(0xFFF1F3F9),
    Color(0xFFE1E5EE),
  ];

  // Neon gradients
  static const LinearGradient cyberGradient = LinearGradient(
    colors: [primaryNeon, secondaryNeon],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient auroraGradient = LinearGradient(
    colors: [accentNeon, electricBlue, primaryNeon],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient royalGradient = LinearGradient(
    colors: [Color(0xFF1A2A6C), Color(0xFFB21F1F), Color(0xFFFDBB2D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
