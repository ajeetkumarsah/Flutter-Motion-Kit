import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_theme.dart';

/// Neural Network Loader styles & enums.
enum MotionAiStyle {
  /// Pulsing synaptic nodes connecting dynamically with traveling energy packets.
  neuralNetwork,

  /// ChatGPT/Gemini style breathing wave and rotating glow rings.
  thinking,

  /// Holographic particles quantum teleporting and reconnecting.
  quantum,

  /// Mono-terminal token characters simulated streaming in real-time.
  tokenStream,

  /// AI text token generation typing text streams with glowing cursors.
  tokenPrediction,

  /// Neuron branches flashing electric pulses and synapse network signals.
  neuralPulse,

  /// 3D-perspective floating data cube matrices translating along streams.
  tensorFlow,

  /// Robotic sci-fi iris eye focusing, dilating, and sweeping scanlines.
  aiEye,
}

/// Renders premium AI-themed interactive loaders.
class MotionNeuralNetworkLoader extends StatefulWidget {
  /// The base accent color of the synapse nodes.
  final Color color;

  /// The dimensional bounding size.
  final double size;

  /// Enables/disables glowing shader shadows.
  final bool glow;

  /// Total active node synapses.
  final int particleCount;

  /// Creates a [MotionNeuralNetworkLoader] instance.
  const MotionNeuralNetworkLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
    this.particleCount = 8,
  });

  @override
  State<MotionNeuralNetworkLoader> createState() =>
      _MotionNeuralNetworkLoaderState();
}

class _MotionNeuralNetworkLoaderState extends State<MotionNeuralNetworkLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_NetworkNode> _nodes = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (4000 / speed).round()),
    )..repeat();

    // Initialize network nodes inside canvas
    for (int i = 0; i < widget.particleCount; i++) {
      _nodes.add(_NetworkNode(
        offset: Offset(_random.nextDouble(), _random.nextDouble()),
        radius: 3.0 + _random.nextDouble() * 4.0,
        speedOffset: _random.nextDouble() * 2 * math.pi,
        pulseOffset: _random.nextDouble() * math.pi,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _NeuralNetworkPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              nodes: _nodes,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _NetworkNode {
  final Offset offset;
  final double radius;
  final double speedOffset;
  final double pulseOffset;

  _NetworkNode({
    required this.offset,
    required this.radius,
    required this.speedOffset,
    required this.pulseOffset,
  });
}

class _NeuralNetworkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_NetworkNode> nodes;
  final bool glow;

  _NeuralNetworkPainter({
    required this.progress,
    required this.color,
    required this.nodes,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxDistance = size.width * 0.45;

    // Calculate actual coordinate positions
    final List<Offset> points = [];
    for (var node in nodes) {
      final angle = (progress * 2 * math.pi) + node.speedOffset;
      final x = center.dx + maxDistance * node.offset.dx * math.cos(angle);
      final y = center.dy + maxDistance * node.offset.dy * math.sin(angle);
      points.add(Offset(x, y));
    }

    // 1. Draw connection lines
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final dist = (points[i] - points[j]).distance;
        if (dist < size.width * 0.65) {
          linePaint.color = color.withValues(
              alpha: (1.0 - (dist / (size.width * 0.65))).clamp(0.0, 0.4));
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }

    // 2. Draw traveling energy packets
    final packetPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final nextIdx = (i + 1) % points.length;
      final t = (progress + (i / points.length)) % 1.0;
      final packetPos = Offset.lerp(points[i], points[nextIdx], t)!;
      canvas.drawCircle(packetPos, 2.0, packetPaint);
    }

    // 3. Draw nodes with pulsing glows
    final nodePaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    for (int i = 0; i < points.length; i++) {
      final node = nodes[i];
      final pulse =
          0.75 + 0.25 * math.sin(progress * 4 * math.pi + node.pulseOffset);
      final nodeRadius = node.radius * pulse;

      if (glow) {
        glowPaint.color = color.withValues(alpha: 0.3 * pulse);
        canvas.drawCircle(points[i], nodeRadius + 3, glowPaint);
      }

      nodePaint.color =
          Color.lerp(color, Colors.white, 0.25 * (1.0 - pulse)) ?? color;
      canvas.drawCircle(points[i], nodeRadius, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeuralNetworkPainter oldDelegate) => true;
}

/// Siri / ChatGPT style dynamic breathing wave and rotating gradient ring.
class MotionAiThinkingLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionAiThinkingLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionAiThinkingLoader> createState() => _MotionAiThinkingLoaderState();
}

class _MotionAiThinkingLoaderState extends State<MotionAiThinkingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (2000 / speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _AiThinkingPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _AiThinkingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glow;

  _AiThinkingPainter({
    required this.progress,
    required this.color,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Draw rotating sweep gradient ring
    final ringRect = Rect.fromCircle(center: center, radius: radius - 6);
    final ringPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.15),
          Color.lerp(color, Colors.cyan, 0.5)!,
          color,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
        transform: GradientRotation(progress * 2 * math.pi),
      ).createShader(ringRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(ringRect, 0, 2 * math.pi, false, ringPaint);

    // 2. Draw breathing dynamic morphing waves in center
    final wavePath = Path();
    final wavePaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    const waveCount = 3;
    final amplitude = radius * 0.25;

    for (int w = 0; w < waveCount; w++) {
      wavePath.reset();
      final phase = progress * 2 * math.pi + (w * math.pi / waveCount);
      final breathingScale = 0.8 + 0.2 * math.sin(progress * 2 * math.pi + w);

      wavePaint.color = Color.lerp(color, Colors.purpleAccent, w / waveCount)!
          .withValues(alpha: 0.12 * breathingScale);

      // Plot multi-frequency sine wave path within a circle
      final waveRadius = radius * 0.5 * breathingScale;
      for (double i = 0.0; i <= 360.0; i += 5.0) {
        final angleRad = i * math.pi / 180.0;
        final sineVal = math.sin(angleRad * 3.0 + phase) * amplitude * 0.3;
        final currentRadius = waveRadius + sineVal;

        final x = center.dx + currentRadius * math.cos(angleRad);
        final y = center.dy + currentRadius * math.sin(angleRad);

        if (i == 0.0) {
          wavePath.moveTo(x, y);
        } else {
          wavePath.lineTo(x, y);
        }
      }
      wavePath.close();
      canvas.drawPath(wavePath, wavePaint);
    }

    // 3. Draw central pulsing breathing dots
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final dotCount = 3;
    final dotSpacing = radius * 0.25;

    for (int i = 0; i < dotCount; i++) {
      final delay = i * 0.2;
      final value = (progress - delay) % 1.0;
      final scale = 0.5 + (0.5 * (1.0 - (value - 0.5).abs() * 2));
      final dotPos = Offset(
        center.dx + (i - 1) * dotSpacing,
        center.dy,
      );

      dotPaint.color =
          color.withValues(alpha: (0.3 + 0.7 * scale).clamp(0.0, 1.0));
      canvas.drawCircle(dotPos, radius * 0.07 * scale, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AiThinkingPainter oldDelegate) => true;
}

/// Quantum teleporting reconnecting particle loader.
class MotionQuantumLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionQuantumLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionQuantumLoader> createState() => _MotionQuantumLoaderState();
}

class _MotionQuantumLoaderState extends State<MotionQuantumLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_QuantumParticle> _particles = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (2500 / speed).round()),
    )..repeat();

    for (int i = 0; i < 15; i++) {
      _particles.add(_QuantumParticle(
        offset: Offset(_random.nextDouble() - 0.5, _random.nextDouble() - 0.5),
        target: Offset(_random.nextDouble() - 0.5, _random.nextDouble() - 0.5),
        speed: 0.5 + _random.nextDouble() * 0.5,
        alphaOffset: _random.nextDouble(),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _QuantumPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              particles: _particles,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _QuantumParticle {
  Offset offset;
  Offset target;
  final double speed;
  final double alphaOffset;

  _QuantumParticle({
    required this.offset,
    required this.target,
    required this.speed,
    required this.alphaOffset,
  });

  void updateRandom(math.Random random) {
    offset = target;
    target = Offset(random.nextDouble() - 0.5, random.nextDouble() - 0.5);
  }
}

class _QuantumPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_QuantumParticle> particles;
  final bool glow;
  final _random = math.Random(12345);

  _QuantumPainter({
    required this.progress,
    required this.color,
    required this.particles,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxDistance = size.width * 0.45;

    // Draw backing holographic grid lines
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final step = size.width / 6;
    for (double i = step; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // 1. Update and Draw connecting lines
    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final List<Offset> points = [];
    for (var particle in particles) {
      // Periodic particle teleport warp triggers
      final localProg =
          (progress * particle.speed + particle.alphaOffset) % 1.0;
      if (localProg < 0.05) {
        particle.updateRandom(_random);
      }

      final currentOffset =
          Offset.lerp(particle.offset, particle.target, localProg)!;
      final x = center.dx + currentOffset.dx * 2.0 * maxDistance;
      final y = center.dy + currentOffset.dy * 2.0 * maxDistance;
      points.add(Offset(x, y));
    }

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final dist = (points[i] - points[j]).distance;
        if (dist < size.width * 0.3) {
          final intensity = 1.0 - (dist / (size.width * 0.3));
          linePaint.color = color.withValues(alpha: 0.15 * intensity);
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }

    // 2. Draw teleport quantum sparks
    final sparkPaint = Paint()..style = PaintingStyle.fill;
    final blurPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (int i = 0; i < points.length; i++) {
      final particle = particles[i];
      final localProg =
          (progress * particle.speed + particle.alphaOffset) % 1.0;
      final scale = math.sin(localProg * math.pi); // Fades in and out

      if (glow) {
        blurPaint.color = color.withValues(alpha: 0.35 * scale);
        canvas.drawCircle(points[i], 5.0 * scale, blurPaint);
      }

      sparkPaint.color = Color.lerp(color, Colors.white, 0.4 * scale)!;
      canvas.drawCircle(points[i], 3.0 * scale, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _QuantumPainter oldDelegate) => true;
}

/// Simulated LLM Token Streaming character terminal loader.
class MotionAiTokenStream extends StatefulWidget {
  final Color color;
  final double size;

  const MotionAiTokenStream({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionAiTokenStream> createState() => _MotionAiTokenStreamState();
}

class _MotionAiTokenStreamState extends State<MotionAiTokenStream>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> _tokens = [
    'AI',
    'Neural',
    'Deep',
    'Data',
    'Web',
    'GPU',
    'Sync',
    'Warp',
    'Code',
    'Loop'
  ];
  final List<String> _stream = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (3000 / speed).round()),
    )..repeat();

    _controller.addListener(() {
      final int step = (_controller.value * 12).floor();
      if (_stream.length < step) {
        setState(() {
          _stream.add(_tokens[_random.nextInt(_tokens.length)]);
          if (_stream.length > 5) {
            _stream.removeAt(0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = MotionTheme.of(context);
    final textStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: (widget.size / 7).clamp(9, 14),
      fontWeight: FontWeight.bold,
      color: widget.color,
      letterSpacing: 0.5,
      shadows: [
        if (activeTheme.glowEffect)
          Shadow(
            color: widget.color.withValues(alpha: 0.6),
            blurRadius: 6,
          )
      ],
    );

    return Container(
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.terminal, color: Colors.white60, size: 10),
                SizedBox(width: 4),
                Text('STREAMING_TOKENS...',
                    style: TextStyle(fontSize: 7, color: Colors.white60)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                _stream.join(' ➔ '),
                style: textStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// AI text token generation typing text streams with glowing cursors.
class MotionTokenPredictionLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionTokenPredictionLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionTokenPredictionLoader> createState() =>
      _MotionTokenPredictionLoaderState();
}

class _MotionTokenPredictionLoaderState
    extends State<MotionTokenPredictionLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> _words = [
    'Intelligence',
    'Synergy',
    'Quantum',
    'Synthesizer',
    'Cognitive',
    'Neural',
    'DeepMind',
    'Vector',
    'Transformer'
  ];
  String _currentWord = '';
  List<double> _probabilities = [0.92, 0.05, 0.02, 0.01];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (3000 / speed).round()),
    )..repeat();

    _controller.addListener(() {
      final step = (_controller.value * 3).floor();
      if (step == 0 && _currentWord.isEmpty) {
        setState(() {
          _currentWord = _words[_random.nextInt(_words.length)];
          _probabilities = List.generate(4, (_) => _random.nextDouble())
            ..sort((a, b) => b.compareTo(a));
          final sum = _probabilities.reduce((a, b) => a + b);
          _probabilities = _probabilities.map((e) => e / sum).toList();
        });
      } else if (step == 2 && _currentWord.isNotEmpty) {
        setState(() {
          _currentWord = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = MotionTheme.of(context);
    final isReduced = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>().reducedMotion
        : false;
    final progress = isReduced ? 0.0 : _controller.value;
    final charCount = _currentWord.isEmpty
        ? 0
        : (progress * 3 % 1.0 * _currentWord.length * 1.5)
            .clamp(0.0, _currentWord.length.toDouble())
            .toInt();
    final typedText = _currentWord.substring(0, charCount);

    return Container(
      width: widget.size,
      height: widget.size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF07070F),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: widget.color.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          if (activeTheme.glowEffect && !isReduced)
            BoxShadow(
              color: widget.color.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: SizedBox(
          width: 300.0,
          height: 200.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOKEN_PREDICT',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: widget.color,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'AI_GEN',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.cyan,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          typedText,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (progress * 8 % 1.0 > 0.5)
                          Container(width: 8, height: 18, color: widget.color),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(3, (idx) {
                      final prob = _probabilities[idx];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text(
                              'p($idx): ',
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: Colors.grey,
                                fontFamily: 'monospace',
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  AnimatedFractionallySizedBox(
                                    duration: const Duration(milliseconds: 200),
                                    widthFactor: prob.clamp(0.0, 1.0),
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          widget.color,
                                          Colors.cyan
                                        ]),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(prob * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: Colors.cyan,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Neuron branches flashing electric pulses and synapse network signals.
class MotionNeuralPulseLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionNeuralPulseLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionNeuralPulseLoader> createState() =>
      _MotionNeuralPulseLoaderState();
}

class _MotionNeuralPulseLoaderState extends State<MotionNeuralPulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (2000 / speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _NeuralPulsePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _NeuralPulsePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glow;

  _NeuralPulsePainter({
    required this.progress,
    required this.color,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.4;

    final outerNodes = <Offset>[];
    const nodeCount = 5;
    for (int i = 0; i < nodeCount; i++) {
      final angle = (i * 2 * math.pi / nodeCount) + (progress * 0.2);
      outerNodes.add(Offset(
        center.dx + maxRadius * math.cos(angle),
        center.dy + maxRadius * math.sin(angle),
      ));
    }

    final branchPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final node in outerNodes) {
      canvas.drawLine(center, node, branchPaint);
    }

    final pulsePaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    for (int i = 0; i < nodeCount; i++) {
      final localProg = (progress + (i / nodeCount)) % 1.0;
      final node = outerNodes[i];
      final pulsePos = Offset.lerp(center, node, localProg)!;
      final pulseOpacity = math.sin(localProg * math.pi);

      final pulseColor = Color.lerp(color, Colors.cyanAccent, localProg)!;

      if (glow) {
        glowPaint.color = pulseColor.withValues(alpha: pulseOpacity * 0.4);
        canvas.drawCircle(pulsePos, 5.0, glowPaint);
      }

      pulsePaint.color = pulseColor.withValues(alpha: pulseOpacity);
      canvas.drawCircle(pulsePos, 3.0, pulsePaint);
    }

    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerPulse = 0.85 + 0.15 * math.sin(progress * 4 * math.pi);
    if (glow) {
      glowPaint.color = color.withValues(alpha: 0.3 * centerPulse);
      canvas.drawCircle(center, 12.0 * centerPulse, glowPaint);
    }
    corePaint.color = Color.lerp(color, Colors.white, 0.1)!;
    canvas.drawCircle(center, 7.0 * centerPulse, corePaint);

    final nodePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final node in outerNodes) {
      final nodePulse =
          0.9 + 0.1 * math.sin(progress * 3 * math.pi + node.hashCode % 5);
      nodePaint.color = Color.lerp(color, Colors.black, 0.15)!;
      canvas.drawCircle(node, 4.5 * nodePulse, nodePaint);

      nodePaint.color = Colors.cyanAccent;
      canvas.drawCircle(node, 2.5 * nodePulse, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeuralPulsePainter oldDelegate) => true;
}

/// 3D-perspective floating data cube matrices translating along streams.
class MotionTensorFlowLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionTensorFlowLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionTensorFlowLoader> createState() => _MotionTensorFlowLoaderState();
}

class _MotionTensorFlowLoaderState extends State<MotionTensorFlowLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (2500 / speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _TensorFlowPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _TensorFlowPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glow;

  _TensorFlowPainter({
    required this.progress,
    required this.color,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;
    final h = size.height;

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cellPaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    const layersCount = 3;
    for (int l = 0; l < layersCount; l++) {
      final layerProg = (progress + (l / layersCount)) % 1.0;
      final verticalOffset = h * 0.25 * (l - 1.0) - (layerProg * h * 0.1);
      final opacity = math.sin(layerProg * math.pi).clamp(0.0, 1.0);

      canvas.save();
      canvas.translate(center.dx, center.dy + verticalOffset);

      final layerColor = Color.lerp(color, Colors.blueAccent, l / layersCount)!;
      gridPaint.color = layerColor.withValues(alpha: opacity * 0.35);

      final side = w * 0.22;

      for (int i = -1; i <= 2; i++) {
        final pt1Start = _isoProject(Offset(-side, i * side / 2));
        final pt1End = _isoProject(Offset(side, i * side / 2));
        canvas.drawLine(pt1Start, pt1End, gridPaint);

        final pt2Start = _isoProject(Offset(i * side / 2, -side));
        final pt2End = _isoProject(Offset(i * side / 2, side));
        canvas.drawLine(pt2Start, pt2End, gridPaint);
      }

      final cellX = (((layerProg * 3).floor() - 1) % 3) - 1;
      final cellY = (((layerProg * 5).floor() - 1) % 3) - 1;

      final cellCenter = _isoProject(
          Offset(cellX * side / 2 + side / 4, cellY * side / 2 + side / 4));
      final cellRadius = side * 0.2;

      if (glow) {
        glowPaint.color = layerColor.withValues(alpha: opacity * 0.45);
        canvas.drawCircle(cellCenter, cellRadius + 2, glowPaint);
      }

      cellPaint.color =
          Color.lerp(layerColor, Colors.white, 0.4)!.withValues(alpha: opacity);
      canvas.drawCircle(cellCenter, cellRadius, cellPaint);

      canvas.restore();
    }
  }

  Offset _isoProject(Offset pt) {
    final xIso = (pt.dx - pt.dy) * 1.0;
    final yIso = (pt.dx + pt.dy) * 0.5;
    return Offset(xIso, yIso);
  }

  @override
  bool shouldRepaint(covariant _TensorFlowPainter oldDelegate) => true;
}

/// Robotic sci-fi iris eye focusing, dilating, and sweeping scanlines.
class MotionAiEyeLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionAiEyeLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionAiEyeLoader> createState() => _MotionAiEyeLoaderState();
}

class _MotionAiEyeLoaderState extends State<MotionAiEyeLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (3000 / speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _AiEyePainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _AiEyePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glow;

  _AiEyePainter({
    required this.progress,
    required this.color,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.45;

    final framePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, maxRadius, framePaint);
    canvas.drawCircle(center, maxRadius * 0.8,
        framePaint..color = color.withValues(alpha: 0.15));

    final notchPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * math.pi);
    for (int i = 0; i < 4; i++) {
      final startAngle = i * math.pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: maxRadius),
        startAngle,
        0.3,
        false,
        notchPaint,
      );
    }
    canvas.restore();

    final dilation = 0.5 + 0.25 * math.sin(progress * 2 * math.pi);
    final irisRadius = maxRadius * 0.5 * dilation;

    final irisPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, irisRadius, irisPaint);

    final bladePaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-progress * 2 * math.pi * 0.5);
    const bladeCount = 8;
    for (int i = 0; i < bladeCount; i++) {
      final angle = i * 2 * math.pi / bladeCount;
      final start = Offset(irisRadius * 0.4 * math.cos(angle),
          irisRadius * 0.4 * math.sin(angle));
      final end = Offset(irisRadius * math.cos(angle + 0.5),
          irisRadius * math.sin(angle + 0.5));
      canvas.drawLine(start, end, bladePaint);
    }
    canvas.restore();

    final pupilPaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final pupilRadius = maxRadius * 0.18;
    final pupilPulse = 0.95 + 0.05 * math.sin(progress * 6 * math.pi);

    if (glow) {
      glowPaint.color = Colors.redAccent.withValues(alpha: 0.45);
      canvas.drawCircle(center, pupilRadius * pupilPulse + 4, glowPaint);
    }
    pupilPaint.color = Colors.redAccent;
    canvas.drawCircle(center, pupilRadius * pupilPulse, pupilPaint);

    pupilPaint.color = Colors.white.withValues(alpha: 0.7);
    canvas.drawCircle(
        Offset(center.dx - pupilRadius * 0.3, center.dy - pupilRadius * 0.3),
        pupilRadius * 0.25,
        pupilPaint);

    final scanPaint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.8)
      ..strokeWidth = 1.0;
    final scanY =
        center.dy + maxRadius * 0.7 * math.sin(progress * 2 * math.pi);
    final scanWidth = maxRadius *
        math.sqrt(1.0 - math.pow(math.sin(progress * 2 * math.pi), 2));
    canvas.drawLine(Offset(center.dx - scanWidth, scanY),
        Offset(center.dx + scanWidth, scanY), scanPaint);
  }

  @override
  bool shouldRepaint(covariant _AiEyePainter oldDelegate) => true;
}
