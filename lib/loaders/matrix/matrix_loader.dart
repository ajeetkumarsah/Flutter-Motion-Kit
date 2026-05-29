import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/motion_controller.dart';

class MotionMatrixLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionMatrixLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionMatrixLoader> createState() => _MotionMatrixLoaderState();
}

class _MotionMatrixLoaderState extends State<MotionMatrixLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _random = math.Random();
  late List<_MatrixStream> _streams;
  final int _streamCount = 5;

  @override
  void initState() {
    super.initState();
    final motion = Get.isRegistered<MotionController>() ? Get.find<MotionController>() : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (2000 / speed).round()),
    )..repeat();

    _initializeStreams();
  }

  void _initializeStreams() {
    _streams = List.generate(_streamCount, (index) {
      return _MatrixStream(
        columnRatio: (index + 0.5) / _streamCount,
        speed: 0.6 + _random.nextDouble() * 0.5,
        delay: _random.nextDouble() * 0.8,
        chars: List.generate(6, (_) => _getRandomChar()),
      );
    });
  }

  String _getRandomChar() {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ\$@#&%*';
    return chars[_random.nextInt(chars.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Periodically change characters for authentic digital rain effect
          if (_controller.value % 0.15 < 0.02) {
            for (var stream in _streams) {
              if (_random.nextDouble() < 0.3) {
                stream.chars[_random.nextInt(stream.chars.length)] = _getRandomChar();
              }
            }
          }

          return CustomPaint(
            painter: _MatrixPainter(
              progress: _controller.value,
              streams: _streams,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _MatrixStream {
  final double columnRatio;
  final double speed;
  final double delay;
  final List<String> chars;

  _MatrixStream({
    required this.columnRatio,
    required this.speed,
    required this.delay,
    required this.chars,
  });
}

class _MatrixPainter extends CustomPainter {
  final double progress;
  final List<_MatrixStream> streams;
  final Color color;

  _MatrixPainter({
    required this.progress,
    required this.streams,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var stream in streams) {
      final x = size.width * stream.columnRatio;

      // Compute cascading offset based on progress + stream specifics
      final t = (progress * stream.speed - stream.delay) % 1.0;
      final startY = -size.height * 0.2 + (size.height * 1.4) * t;

      for (int i = 0; i < stream.chars.length; i++) {
        final charY = startY - (i * (size.height / 7));
        if (charY < 0 || charY > size.height) continue;

        // Fading opacity along the tail
        final ratio = i / stream.chars.length;
        final opacity = (1.0 - ratio) * (1.0 - (charY / size.height).clamp(0.0, 1.0));
        
        // Leading character is extra bright/white
        final charColor = i == 0
            ? Colors.white
            : color.withOpacity(opacity.clamp(0.05, 1.0));

        final textPainter = TextPainter(
          text: TextSpan(
            text: stream.chars[i],
            style: TextStyle(
              color: charColor,
              fontSize: size.width / 7,
              fontWeight: i == 0 ? FontWeight.bold : FontWeight.w500,
              fontFamily: 'monospace',
              shadows: [
                Shadow(
                  color: color.withOpacity(0.8),
                  blurRadius: i == 0 ? 8 : 2,
                )
              ]
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, charY - textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixPainter oldDelegate) => true;
}
