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
import 'cyberpunk/cyberpunk_category.dart';
import 'nature/nature_category.dart';
import 'luxury/luxury_category.dart';
import 'geometry/geometry_category.dart';
import 'social/social_category.dart';
import 'three_d/three_d_category.dart';
import 'audio/audio_category.dart';
import 'artistic/artistic_category.dart';
import 'experimental/experimental_category.dart';

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
          case MotionAiStyle.tokenPrediction:
            return MotionTokenPredictionLoader(
              color: activeColor,
              size: size,
            );
          case MotionAiStyle.neuralPulse:
            return MotionNeuralPulseLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionAiStyle.tensorFlow:
            return MotionTensorFlowLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionAiStyle.aiEye:
            return MotionAiEyeLoader(
              color: activeColor,
              size: size,
              glow: glow,
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
          case MotionPhysicsStyle.fluidParticle:
            return MotionFluidParticleLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionPhysicsStyle.sandSimulation:
            return MotionSandSimulationLoader(
              color: activeColor,
              size: size,
            );
          case MotionPhysicsStyle.magneticField:
            return MotionMagneticFieldLoader(
              color: activeColor,
              size: size,
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

  /// Cyberpunk Theme Category: console terminals, glitches, and scanners.
  factory MotionLoader.cyberpunk({
    Key? key,
    required MotionCyberpunkStyle style,
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
          case MotionCyberpunkStyle.terminalBoot:
            return MotionTerminalBootLoader(
              color: activeColor,
              size: size,
            );
          case MotionCyberpunkStyle.glitch:
            return MotionGlitchLoader(
              color: activeColor,
              size: size,
            );
          case MotionCyberpunkStyle.cyberRing:
            return MotionCyberRingLoader(
              color: activeColor,
              size: size,
            );
          case MotionCyberpunkStyle.dataStream:
            return MotionDataStreamLoader(
              color: activeColor,
              size: size,
            );
          case MotionCyberpunkStyle.firewallScanner:
            return MotionFirewallScannerLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Nature Theme Category: fireflies, tornadoes, volcanoes, sways & eclipses.
  factory MotionLoader.nature({
    Key? key,
    required MotionNatureStyle style,
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
          case MotionNatureStyle.firefly:
            return MotionFireflyLoader(
              color: activeColor,
              size: size,
            );
          case MotionNatureStyle.tornado:
            return MotionTornadoLoader(
              color: activeColor,
              size: size,
            );
          case MotionNatureStyle.volcano:
            return MotionVolcanoLoader(
              color: activeColor,
              size: size,
            );
          case MotionNatureStyle.leafWind:
            return MotionLeafWindLoader(
              color: activeColor,
              size: size,
            );
          case MotionNatureStyle.solarEclipse:
            return MotionSolarEclipseLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Luxury Theme Category: diamond sparks, silk curves, watch gear mechanical ticks.
  factory MotionLoader.luxury({
    Key? key,
    required MotionLuxuryStyle style,
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
          case MotionLuxuryStyle.diamondSpark:
            return MotionDiamondSparkLoader(
              color: activeColor,
              size: size,
            );
          case MotionLuxuryStyle.silkFlow:
            return MotionSilkFlowLoader(
              color: activeColor,
              size: size,
            );
          case MotionLuxuryStyle.goldSweep:
            return MotionGoldSweepLoader(
              color: activeColor,
              size: size,
            );
          case MotionLuxuryStyle.premiumWatch:
            return MotionPremiumWatchLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Geometry Theme Category: impossible cubes, honeycomb swarms, scaling branch fractals.
  factory MotionLoader.geometry({
    Key? key,
    required MotionGeometryStyle style,
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
          case MotionGeometryStyle.infiniteCube:
            return MotionInfiniteCubeLoader(
              color: activeColor,
              size: size,
            );
          case MotionGeometryStyle.hexagonSwarm:
            return MotionHexagonSwarmLoader(
              color: activeColor,
              size: size,
            );
          case MotionGeometryStyle.fractal:
            return MotionFractalLoader(
              color: activeColor,
              size: size,
            );
          case MotionGeometryStyle.polygonMorph:
            return MotionPolygonMorphLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Social Theme Category: Reels upload circles, streaming pulses & story sweeps.
  factory MotionLoader.social({
    Key? key,
    required MotionSocialStyle style,
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
          case MotionSocialStyle.reelsUpload:
            return MotionReelsUploadLoader(
              color: activeColor,
              size: size,
              glow: glow,
            );
          case MotionSocialStyle.liveStream:
            return MotionLiveStreamLoader(
              color: activeColor,
              size: size,
            );
          case MotionSocialStyle.storyRing:
            return MotionStoryRingLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// 3D Theme Category: floating parallax cubes, stacked isometrics, holographic wireframe spheres.
  factory MotionLoader.threeD({
    Key? key,
    required MotionThreeDStyle style,
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
          case MotionThreeDStyle.floatingCube:
            return MotionFloatingCubeLoader(
              color: activeColor,
              size: size,
            );
          case MotionThreeDStyle.isometric:
            return MotionIsometricLoader(
              color: activeColor,
              size: size,
            );
          case MotionThreeDStyle.holographicSphere:
            return MotionHolographicSphereLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Audio Theme Category: equalizer sound bars, spinning records & frequency curves.
  factory MotionLoader.audio({
    Key? key,
    required MotionAudioStyle style,
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
          case MotionAudioStyle.equalizer:
            return MotionEqualizerLoader(
              color: activeColor,
              size: size,
            );
          case MotionAudioStyle.vinyl:
            return MotionVinylLoader(
              color: activeColor,
              size: size,
            );
          case MotionAudioStyle.beatWave:
            return MotionBeatWaveLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Artistic Theme Category: calligraphy brush strokes, origami panels.
  factory MotionLoader.artistic({
    Key? key,
    required MotionArtisticStyle style,
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
          case MotionArtisticStyle.zenCircle:
            return MotionZenCircleLoader(
              color: activeColor,
              size: size,
            );
          case MotionArtisticStyle.origami:
            return MotionOrigamiLoader(
              color: activeColor,
              size: size,
            );
          case MotionArtisticStyle.calligraphyStroke:
            return MotionCalligraphyStrokeLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Experimental Theme Category: temporal warps, portals, dimensional rifts.
  factory MotionLoader.experimental({
    Key? key,
    required MotionExperimentalStyle style,
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
          case MotionExperimentalStyle.timeWarp:
            return MotionTimeWarpLoader(
              color: activeColor,
              size: size,
            );
          case MotionExperimentalStyle.portal:
            return MotionPortalLoader(
              color: activeColor,
              size: size,
            );
          case MotionExperimentalStyle.dimensionalRift:
            return MotionDimensionalRiftLoader(
              color: activeColor,
              size: size,
            );
          case MotionExperimentalStyle.wormhole:
            return MotionWormholeLoader(
              color: activeColor,
              size: size,
            );
        }
      },
    );
  }

  /// Configuration-based factory builder from a JSON map.
  factory MotionLoader.fromJson(Map<String, dynamic> json) {
    final String category = json['category'] ?? 'default';
    final String styleStr = json['style'] ?? '';
    final Color? color = json['color'] != null
        ? Color(int.parse(json['color'].toString()))
        : null;
    final double size = (json['size'] ?? 50.0).toDouble();
    final bool glow = json['glow'] ?? true;

    switch (category) {
      case 'ai':
        final style = MotionAiStyle.values.firstWhere((e) => e.name == styleStr,
            orElse: () => MotionAiStyle.neuralNetwork);
        return MotionLoader.ai(
            style: style, color: color, size: size, glow: glow);
      case 'liquid':
        final style = MotionLiquidStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionLiquidStyle.lavaLamp);
        return MotionLoader.liquid(style: style, color: color, size: size);
      case 'glass':
        final style = MotionGlassStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionGlassStyle.glassOrb);
        return MotionLoader.glass(
            style: style, color: color, size: size, glow: glow);
      case 'space':
        final style = MotionSpaceStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionSpaceStyle.blackHole);
        return MotionLoader.space(
            style: style, color: color, size: size, glow: glow);
      case 'gaming':
        final style = MotionGamingStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionGamingStyle.xpProgress);
        return MotionLoader.gaming(
            style: style, color: color, size: size, glow: glow);
      case 'physics':
        final style = MotionPhysicsStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionPhysicsStyle.pendulum);
        return MotionLoader.physics(
            style: style, color: color, size: size, glow: glow);
      case 'minimal':
        final style = MotionMinimalStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionMinimalStyle.lineDraw);
        return MotionLoader.minimal(style: style, color: color, size: size);
      case 'saas':
        final style = MotionSaasStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionSaasStyle.pulseGrid);
        return MotionLoader.saas(
            style: style, color: color, size: size, glow: glow);
      case 'cyberpunk':
        final style = MotionCyberpunkStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionCyberpunkStyle.terminalBoot);
        return MotionLoader.cyberpunk(style: style, color: color, size: size);
      case 'nature':
        final style = MotionNatureStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionNatureStyle.firefly);
        return MotionLoader.nature(style: style, color: color, size: size);
      case 'luxury':
        final style = MotionLuxuryStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionLuxuryStyle.diamondSpark);
        return MotionLoader.luxury(style: style, color: color, size: size);
      case 'geometry':
        final style = MotionGeometryStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionGeometryStyle.infiniteCube);
        return MotionLoader.geometry(style: style, color: color, size: size);
      case 'social':
        final style = MotionSocialStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionSocialStyle.reelsUpload);
        return MotionLoader.social(
            style: style, color: color, size: size, glow: glow);
      case 'threeD':
        final style = MotionThreeDStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionThreeDStyle.floatingCube);
        return MotionLoader.threeD(style: style, color: color, size: size);
      case 'audio':
        final style = MotionAudioStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionAudioStyle.equalizer);
        return MotionLoader.audio(style: style, color: color, size: size);
      case 'artistic':
        final style = MotionArtisticStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionArtisticStyle.zenCircle);
        return MotionLoader.artistic(style: style, color: color, size: size);
      case 'experimental':
        final style = MotionExperimentalStyle.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionExperimentalStyle.timeWarp);
        return MotionLoader.experimental(
            style: style, color: color, size: size);
      default:
        final type = MotionLoaderType.values.firstWhere(
            (e) => e.name == styleStr,
            orElse: () => MotionLoaderType.ai);
        return MotionLoader(type: type, color: color, size: size);
    }
  }

  /// Dynamic runtime custom builder/generator factory.
  static Widget generator({
    required String category,
    required String style,
    Color? color,
    double size = 50.0,
    bool glow = true,
  }) {
    return MotionLoader.fromJson({
      'category': category,
      'style': style,
      'color': color?.toARGB32(),
      'size': size,
      'glow': glow,
    });
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
