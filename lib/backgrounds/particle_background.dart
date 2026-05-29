import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/controllers/motion_controller.dart';

class MotionParticleBackground extends StatefulWidget {
  final Color? particleColor;
  final Widget? child;

  const MotionParticleBackground({
    super.key,
    this.particleColor,
    this.child,
  });

  @override
  State<MotionParticleBackground> createState() => _MotionParticleBackgroundState();
}

class _MotionParticleBackgroundState extends State<MotionParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final _random = math.Random();
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeParticles(Size size, bool performanceMode) {
    if (_particles.isNotEmpty) return;
    
    // Scale count based on hardware performance mode
    final count = performanceMode ? 15 : 45;
    for (int i = 0; i < count; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        vx: (_random.nextDouble() - 0.5) * 0.8,
        vy: (_random.nextDouble() - 0.5) * 0.8,
        radius: _random.nextDouble() * 3 + 1.5,
        opacity: _random.nextDouble() * 0.5 + 0.15,
      ));
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
    // Add multiple splash particles at click position
    for (int i = 0; i < 8; i++) {
      final angle = _random.nextDouble() * 2 * math.pi;
      final speed = _random.nextDouble() * 2 + 1;
      _particles.add(_Particle(
        x: details.localPosition.dx,
        y: details.localPosition.dy,
        vx: math.cos(angle) * speed,
        vy: math.sin(angle) * speed,
        radius: _random.nextDouble() * 2 + 1,
        opacity: 0.8,
        isSplash: true,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final motionController = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;

    final color = widget.particleColor ?? Theme.of(context).primaryColor.withOpacity(0.5);

    return Obx(() {
      final isReduced = motionController?.reducedMotion ?? false;
      final performanceMode = motionController?.performanceMode ?? false;

      if (isReduced) {
        return widget.child ?? const SizedBox.expand();
      }

      return SizedBox.expand(
        child: GestureDetector(
          onTapDown: _onTapDown,
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _ParticlePainter(
                        particles: _particles,
                        particleColor: color,
                        random: _random,
                        tapPosition: _tapPosition,
                        onInit: (size) => _initializeParticles(size, performanceMode),
                      ),
                    );
                  },
                ),
              ),
              if (widget.child != null) Positioned.fill(child: widget.child!),
            ],
          ),
        ),
      );
    });
  }
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;
  double opacity;
  bool isSplash;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.opacity,
    this.isSplash = false,
  });

  void update(Size size, Offset? tapPos) {
    x += vx;
    y += vy;

    // Bounce off walls
    if (x < 0 || x > size.width) vx = -vx;
    if (y < 0 || y > size.height) vy = -vy;

    // React to tap push/attract force
    if (tapPos != null && !isSplash) {
      final dx = x - tapPos.dx;
      final dy = y - tapPos.dy;
      final dist = math.sqrt(dx * dx + dy * dy);
      if (dist < 100) {
        // Push particles away softly
        x += (dx / dist) * 2;
        y += (dy / dist) * 2;
      }
    }

    // Fade splash particles
    if (isSplash) {
      opacity -= 0.02;
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color particleColor;
  final math.Random random;
  final Offset? tapPosition;
  final Function(Size) onInit;

  _ParticlePainter({
    required this.particles,
    required this.particleColor,
    required this.random,
    required this.tapPosition,
    required this.onInit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    onInit(size);

    final paint = Paint()..style = PaintingStyle.fill;

    // Update and draw each particle
    for (int i = particles.length - 1; i >= 0; i--) {
      final p = particles[i];
      p.update(size, tapPosition);

      // Clean up faded splash particles
      if (p.isSplash && p.opacity <= 0) {
        particles.removeAt(i);
        continue;
      }

      paint.color = particleColor.withOpacity(p.opacity.clamp(0.0, 1.0));
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
