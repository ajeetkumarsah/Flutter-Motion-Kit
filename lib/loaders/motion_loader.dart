import 'package:flutter/material.dart';

// Import existing loader types
import 'dots/dots_loader.dart';
import 'pulse/pulse_loader.dart';
import 'orbit/orbit_loader.dart';
import 'dna/dna_loader.dart';
import 'ai/ai_loader.dart';
import 'liquid/liquid_loader.dart';
import 'wave/wave_loader.dart';
import 'futuristic/futuristic_loader.dart';
import 'matrix/matrix_loader.dart';
import 'gradient/gradient_loader.dart';

// Import the new category loaders
import 'ai/ai_category.dart';
import 'liquid/liquid_category.dart';
import 'glass/glass_category.dart';
import 'space/space_category.dart';
import 'gaming/gaming_category.dart';
import 'physics/physics_category.dart';
import 'minimal/minimal_category.dart';
import 'saas/saas_category.dart';

/// Defines the available types of loaders in the flutter_motion_kit library.
enum MotionLoaderType {
  /// A horizontal sequence of three bouncing dots.
  dots,

  /// A messaging bubble scale-and-fade three-dot typing indicator.
  typing,

  /// Concentric circular rings expanding outwards in a radar pulse.
  pulse,

  /// A central core nucleus with orbiting planetary satellite nodes.
  orbit,

  /// A vertical double-helix strand oscillating with 3D depth perception.
  dna,

  /// A glowing neural network intelligence core pulsing and sparking synapse nodes.
  ai,

  /// A circular fluid container filled with moving sinusoidal canvas waves.
  liquid,

  /// A vertical Equalizer style soundwave bar oscillation graph.
  wave,

  /// A high-tech circular scifi radar grid sweep disc.
  futuristic,

  /// Monospace terminal drop-chain digital code rain cascading downwards.
  matrix,

  /// Dual counter-rotating sweeping sweep gradient neon rings.
  gradientRotating,
}

/// A centralized, production-grade loading dispatcher widget.
///
/// Automatically routes, compiles, and renders any of the 35+ premium loading presets
/// available under standard named category constructors or the default [MotionLoaderType] enums.
/// Respects global speed scales and reduced motion accessibility profiles automatically.
class MotionLoader extends StatelessWidget {
  /// The specific [MotionLoaderType] layout preset profile to render.
  final MotionLoaderType? type;

  /// The active primary color of the loading graphics.
  final Color? color;

  /// The bounding box dimensions (width and height constraints) of the loader.
  final double size;

  /// The stroke dimensions for line and outline-based graphic painters.
  final double strokeWidth;

  /// Private child builder callback for custom categories
  final Widget Function(BuildContext)? _builder;

  /// Creates a unified default [MotionLoader] instance.
  const MotionLoader({
    super.key,
    this.type = MotionLoaderType.ai,
    this.color,
    this.size = 50.0,
    this.strokeWidth = 3.0,
  }) : _builder = null;

  /// Internal constructor for factory-based category dispatching.
  const MotionLoader._internal({
    super.key,
    required Widget Function(BuildContext) builder,
    this.color,
    required this.size,
    this.strokeWidth = 3.0,
  })  : type = null,
        _builder = builder;

  /// AI Theme Category: Contains 4 advanced futuristic AI styles.
  factory MotionLoader.ai({
    Key? key,
    required MotionAiStyle style,
    Color? color,
    double size = 50.0,
    bool glow = true,
    int particleCount = 8,
  }) {
    return MotionLoader._internal(
      key: key,
      color: color,
      size: size,
      builder: (context) {
        final activeColor = color ?? Theme.of(context).primaryColor;
        switch (style) {
          case MotionAiStyle.neuralNetwork:
            return MotionNeuralNetworkLoader(
              color: activeColor,
              size: size,
              glow: glow,
              particleCount: particleCount,
            );
          case MotionAiStyle.thinking:
            return MotionAiThinkingLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionAiStyle.quantum:
            return MotionQuantumLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionAiStyle.tokenStream:
            return MotionAiTokenStream(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Liquid Theme Category: Contains 3 advanced fluid dynamics simulation styles.
  factory MotionLoader.liquid({
    Key? key,
    required MotionLiquidStyle style,
    Color? color,
    double size = 50.0,
  }) {
    return MotionLoader._internal(
      key: key,
      color: color,
      size: size,
      builder: (context) {
        final activeColor = color ?? Theme.of(context).primaryColor;
        switch (style) {
          case MotionLiquidStyle.lavaLamp:
            return MotionLavaLampLoader(
              color: activeColor,
              size: size,
            );
          case MotionLiquidStyle.waterDrop:
            return MotionWaterRippleLoader(
              color: activeColor,
              size: size,
            );
          case MotionLiquidStyle.inkSpread:
            return MotionInkSpreadLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Glassmorphism Theme Category: Translucent frosted elements & meshes.
  factory MotionLoader.glass({
    Key? key,
    required MotionGlassStyle style,
    Color? color,
    double size = 50.0,
    bool glow = true,
  }) {
    return MotionLoader._internal(
      key: key,
      color: color,
      size: size,
      builder: (context) {
        final activeColor = color ?? Theme.of(context).primaryColor;
        switch (style) {
          case MotionGlassStyle.glassOrb:
            return MotionGlassOrbLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionGlassStyle.prismCrystal:
            return MotionPrismCrystalLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionGlassStyle.aurora:
            return MotionAuroraLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Space/Sci-Fi Theme Category: Gravity vortexes and speedways.
  factory MotionLoader.space({
    Key? key,
    required MotionSpaceStyle style,
    Color? color,
    double size = 50.0,
    bool glow = true,
  }) {
    return MotionLoader._internal(
      key: key,
      color: color,
      size: size,
      builder: (context) {
        final activeColor = color ?? Theme.of(context).primaryColor;
        switch (style) {
          case MotionSpaceStyle.blackHole:
            return MotionBlackHoleLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionSpaceStyle.galaxy:
            return MotionGalaxyLoader(
              color: activeColor,
              size: size,
            );
          case MotionSpaceStyle.warpSpeed:
            return MotionWarpSpeedLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Gaming Theme Category: RPG runic fires, pixel scanlines, XP arcs.
  factory MotionLoader.gaming({
    Key? key,
    required MotionGamingStyle style,
    Color? color,
    double size = 50.0,
    bool glow = true,
  }) {
    return MotionLoader._internal(
      key: key,
      color: color,
      size: size,
      builder: (context) {
        final activeColor = color ?? Theme.of(context).primaryColor;
        switch (style) {
          case MotionGamingStyle.xpProgress:
            return MotionXpProgressLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionGamingStyle.bossFight:
            return MotionBossFightLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionGamingStyle.pixel:
            return MotionPixelLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Physics Theme Category: Collision dynamics and orbital attractions.
  factory MotionLoader.physics({
    Key? key,
    required MotionPhysicsStyle style,
    Color? color,
    double size = 50.0,
    bool glow = true,
  }) {
    return MotionLoader._internal(
      key: key,
      color: color,
      size: size,
      builder: (context) {
        final activeColor = color ?? Theme.of(context).primaryColor;
        switch (style) {
          case MotionPhysicsStyle.pendulum:
            return MotionPendulumLoader(
              color: activeColor,
              size: size,
            );
          case MotionPhysicsStyle.bounceChain:
            return MotionBounceChainLoader(
              color: activeColor,
              size: size,
            );
          case MotionPhysicsStyle.gravityOrbit:
            return MotionGravityOrbitLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
        }
      },
    );
  }

  /// Minimal Theme Category: Lemniscate drawing paths, vectors & morphing layers.
  factory MotionLoader.minimal({
    Key? key,
    required MotionMinimalStyle style,
    Color? color,
    double size = 50.0,
    double strokeWidth = 3.0,
  }) {
    return MotionLoader._internal(
      key: key,
      color: color,
      size: size,
      strokeWidth: strokeWidth,
      builder: (context) {
        final activeColor = color ?? Theme.of(context).primaryColor;
        switch (style) {
          case MotionMinimalStyle.lineDraw:
            return MotionLineDrawLoader(
              color: activeColor,
              size: size,
              strokeWidth: strokeWidth,
            );
          case MotionMinimalStyle.morphShape:
            return MotionMorphShapeLoader(
              color: activeColor,
              size: size,
            );
          case MotionMinimalStyle.infiniteRibbon:
            return MotionInfiniteRibbonLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// SaaS Theme Category: pulse skeletons, syncing clouds & analytics.
  factory MotionLoader.saas({
    Key? key,
    required MotionSaasStyle style,
    Color? color,
    double size = 50.0,
    bool glow = true,
  }) {
    return MotionLoader._internal(
      key: key,
      color: color,
      size: size,
      builder: (context) {
        final activeColor = color ?? Theme.of(context).primaryColor;
        switch (style) {
          case MotionSaasStyle.pulseGrid:
            return MotionSaasPulseGrid(
              color: activeColor,
              size: size,
            );
          case MotionSaasStyle.analytics:
            return MotionSaasAnalyticsLoader(
              color: activeColor,
              size: size,
            );
          case MotionSaasStyle.cloudSync:
            return MotionSaasCloudSync(
              color: activeColor,
              size: size,
              glow: glow,
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_builder != null) {
      return _builder!(context);
    }

    final activeColor = color ?? Theme.of(context).primaryColor;

    switch (type!) {
      case MotionLoaderType.dots:
        return MotionDotsLoader(color: activeColor, size: size);
      case MotionLoaderType.typing:
        return MotionTypingIndicator(color: activeColor, size: size);
      case MotionLoaderType.pulse:
        return MotionPulseLoader(color: activeColor, size: size);
      case MotionLoaderType.orbit:
        return MotionOrbitLoader(color: activeColor, size: size);
      case MotionLoaderType.dna:
        return MotionDnaLoader(color: activeColor, size: size);
      case MotionLoaderType.ai:
        return MotionAiLoader(color: activeColor, size: size);
      case MotionLoaderType.liquid:
        return MotionLiquidLoader(color: activeColor, size: size);
      case MotionLoaderType.wave:
        return MotionWaveLoader(color: activeColor, size: size);
      case MotionLoaderType.futuristic:
        return MotionFuturisticLoader(color: activeColor, size: size);
      case MotionLoaderType.matrix:
        return MotionMatrixLoader(color: activeColor, size: size);
      case MotionLoaderType.gradientRotating:
        return MotionGradientRotatingLoader(color: activeColor, size: size);
    }
  }
}
