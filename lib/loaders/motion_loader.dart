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

enum MotionLoaderType {
  dots,
  typing,
  pulse,
  orbit,
  dna,
  ai,
  liquid,
  wave,
  futuristic,
  matrix,
  gradientRotating,
}

class MotionLoader extends StatelessWidget {
  final MotionLoaderType type;
  final Color? color;
  final double size;
  final double strokeWidth;

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

