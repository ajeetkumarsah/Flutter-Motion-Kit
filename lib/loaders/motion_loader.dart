import 'package:flutter/material.dart';
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
/// Automatically routes, compiles, and renders any of the 11 premium loading presets
/// available under the [MotionLoaderType] enum. Respects global speed scales and
/// reduced motion accessibility profiles automatically.
class MotionLoader extends StatelessWidget {
  /// The specific [MotionLoaderType] layout preset profile to render.
  final MotionLoaderType type;

  /// The active primary color of the loading graphics.
  final Color? color;

  /// The bounding box dimensions (width and height constraints) of the loader.
  final double size;

  /// The stroke dimensions for line and outline-based graphic painters.
  final double strokeWidth;

  /// Creates a unified [MotionLoader] instance.
  const MotionLoader({
    super.key,
    this.type = MotionLoaderType.ai,
    this.color,
    this.size = 50.0,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? Theme.of(context).primaryColor;

    switch (type) {
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

