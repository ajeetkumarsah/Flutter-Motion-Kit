import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';
import '../../core/theme/motion_colors.dart';
import '../../core/theme/motion_theme.dart';

/// Cyberpunk Category styles & enums.
enum MotionCyberpunkStyle {
  /// Console booting command terminal screen flashing green logs.
  terminalBoot,

  /// Cyber-glitched UI elements executing RGB split offsets and frame jumps.
  glitch,

  /// Neon rotating segmented rings, energy sweep, and HUD pulse glow.
  cyberRing,

  /// Transmitting data packets floating along routed pipe connections.
  dataStream,

  /// High-security firewall scanner sweeps showing target highlights.
  firewallScanner,
}

/// Console booting command terminal screen flashing green logs.
class MotionTerminalBootLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionTerminalBootLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionTerminalBootLoader> createState() =>
      _MotionTerminalBootLoaderState();
}

class _MotionTerminalBootLoaderState extends State<MotionTerminalBootLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> _consoleLogs = [];
  final List<String> _staticCommands = [
    'root@cyber:~# init_handshake',
    'CONNECTING TO CORE_SERVER...',
    'SECURE PORT CODES RESOLVED.',
    'BYPASSING INTRUSION WALLS...',
    'root@cyber:~# load_neural_synapses',
    'ALLOCATING TENSOR CELLS...',
    'TENSORS ENGAGED [100% SUCCESS]',
    'root@cyber:~# stream_token_pipeline',
    'ESTABLISHING LLM TERMINAL...',
    'CYBER_PULSE PIPELINE DEPLOYED.'
  ];

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

    _controller.addListener(() {
      final index = (_controller.value * _staticCommands.length)
          .floor()
          .clamp(0, _staticCommands.length - 1);
      if (_consoleLogs.length <= index) {
        setState(() {
          _consoleLogs.add(_staticCommands[index]);
          if (_consoleLogs.length > 5) {
            _consoleLogs.removeAt(0);
          }
        });
      }
    });

    _consoleLogs.add(_staticCommands[0]);
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

    return Container(
      width: widget.size,
      height: widget.size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF020204),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: widget.color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          if (activeTheme.glowEffect && !isReduced)
            BoxShadow(
              color: widget.color.withValues(alpha: 0.15),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: SizedBox(
          width: 200.0,
          height: 200.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: widget.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'CONSOLE_BOOT',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                  const Text(
                    'SYS_OK',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                        fontFamily: 'monospace'),
                  ),
                ],
              ),
              const Divider(color: Colors.white10, height: 10, thickness: 1.0),
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _consoleLogs.length,
                  itemBuilder: (context, index) {
                    final log = _consoleLogs[index];
                    final isCommand = log.startsWith('root@');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              log,
                              style: TextStyle(
                                fontSize: 9.0,
                                color: isCommand
                                    ? widget.color
                                    : const Color(0xFF00FF66),
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              // Blinking hacker cursor
              Row(
                children: [
                  const Text(
                    'SYSTEM_RUNNING',
                    style: TextStyle(
                      fontSize: 9.0,
                      color: Colors.white24,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 6),
                  _BlinkingCursor(color: widget.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  final Color color;
  const _BlinkingCursor({required this.color});

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cursorController,
      builder: (context, child) {
        return Opacity(
          opacity: _cursorController.value > 0.5 ? 1.0 : 0.0,
          child: Container(width: 4, height: 8, color: widget.color),
        );
      },
    );
  }
}

/// Cyber-glitched UI elements executing RGB split offsets and frame jumps.
class MotionGlitchLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionGlitchLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionGlitchLoader> createState() => _MotionGlitchLoaderState();
}

class _MotionGlitchLoaderState extends State<MotionGlitchLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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
      duration: Duration(milliseconds: (1500 / speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReduced = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>().reducedMotion
        : false;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final glitchTrigger = !isReduced && (_random.nextDouble() < 0.15);
          final double offsetR =
              glitchTrigger ? (_random.nextDouble() * 6.0 - 3.0) : 0.0;
          final double offsetB =
              glitchTrigger ? (_random.nextDouble() * 6.0 - 3.0) : 0.0;
          final double frameSkew =
              glitchTrigger ? (_random.nextDouble() * 0.1 - 0.05) : 0.0;

          return Transform(
            transform: Matrix4.skewX(frameSkew),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Red Channel offset
                Transform.translate(
                  offset: Offset(offsetR, -offsetR * 0.5),
                  child: _buildGlitchTarget(Colors.redAccent),
                ),
                // Blue Channel offset
                Transform.translate(
                  offset: Offset(-offsetB, offsetB * 0.5),
                  child: _buildGlitchTarget(Colors.cyanAccent),
                ),
                // Primary Core
                _buildGlitchTarget(widget.color),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlitchTarget(Color activeColor) {
    return Container(
      width: widget.size * 0.7,
      height: widget.size * 0.7,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: activeColor, width: 3.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child:
            Icon(Icons.security, size: widget.size * 0.35, color: activeColor),
      ),
    );
  }
}

/// Neon rotating segmented rings, energy sweep, and HUD pulse glow.
class MotionCyberRingLoader extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionCyberRingLoader({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionCyberRingLoader> createState() => _MotionCyberRingLoaderState();
}

class _MotionCyberRingLoaderState extends State<MotionCyberRingLoader>
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
            painter: _CyberRingPainter(
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

class _CyberRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glow;

  _CyberRingPainter({
    required this.progress,
    required this.color,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.45;

    // Glowing core shadow
    if (glow) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(center, maxRadius, glowPaint);
    }

    // Paint configs for segmented arcs
    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // 1. Outer fast-spinning segmented ring
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * math.pi * 1.5);
    ringPaint.color = color;
    ringPaint.strokeWidth = 3.0;
    // Draw 3 segments of arcs
    for (int i = 0; i < 3; i++) {
      final startAngle = (i * 2 * math.pi / 3) + 0.2;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: maxRadius),
        startAngle,
        1.5,
        false,
        ringPaint,
      );
    }
    canvas.restore();

    // 2. Middle slow-reverse segmented ring
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-progress * 2 * math.pi * 0.8);
    ringPaint.color = MotionColors.secondaryNeon;
    ringPaint.strokeWidth = 2.0;
    // Draw 4 segments of arcs
    for (int i = 0; i < 4; i++) {
      final startAngle = (i * 2 * math.pi / 4) + 0.1;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: maxRadius * 0.75),
        startAngle,
        0.9,
        false,
        ringPaint,
      );
    }
    canvas.restore();

    // 3. Inner target crosshair dots
    final crossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Tiny concentric crosshair ticks in the center
    canvas.drawCircle(
        center,
        4.0,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
    canvas.drawLine(Offset(center.dx - 12, center.dy),
        Offset(center.dx - 6, center.dy), crossPaint);
    canvas.drawLine(Offset(center.dx + 6, center.dy),
        Offset(center.dx + 12, center.dy), crossPaint);
    canvas.drawLine(Offset(center.dx, center.dy - 12),
        Offset(center.dx, center.dy - 6), crossPaint);
    canvas.drawLine(Offset(center.dx, center.dy + 6),
        Offset(center.dx, center.dy + 12), crossPaint);
  }

  @override
  bool shouldRepaint(covariant _CyberRingPainter oldDelegate) => true;
}

/// Transmitting data packets floating along routed pipe connections.
class MotionDataStreamLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionDataStreamLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionDataStreamLoader> createState() => _MotionDataStreamLoaderState();
}

class _MotionDataStreamLoaderState extends State<MotionDataStreamLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_DataPacket> _packets = [];
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
      duration: Duration(milliseconds: (2400 / speed).round()),
    )..repeat();

    // Spawn data packets with stagger delays
    for (int i = 0; i < 5; i++) {
      _packets.add(_DataPacket(
        pathIndex: i % 2,
        speedOffset: 0.7 + _random.nextDouble() * 0.6,
        phase: _random.nextDouble() * math.pi,
        size: 2.0 + _random.nextDouble() * 2.5,
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
            painter: _DataStreamPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              packets: _packets,
            ),
          );
        },
      ),
    );
  }
}

class _DataPacket {
  final int pathIndex;
  final double speedOffset;
  final double phase;
  final double size;

  _DataPacket({
    required this.pathIndex,
    required this.speedOffset,
    required this.phase,
    required this.size,
  });
}

class _DataStreamPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_DataPacket> packets;

  _DataStreamPainter({
    required this.progress,
    required this.color,
    required this.packets,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define two structured routing pipes path coordinates
    // Path 1: Sine routing curve
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    path1.cubicTo(size.width * 0.35, size.height * 0.05, size.width * 0.65,
        size.height * 0.95, size.width, size.height * 0.7);

    // Path 2: Inverted Cosine routing curve
    final path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    path2.cubicTo(size.width * 0.35, size.height * 0.95, size.width * 0.65,
        size.height * 0.05, size.width, size.height * 0.3);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    // Draw backing pipe streams
    canvas.drawPath(path1, linePaint);
    canvas.drawPath(path2, linePaint);

    // Render traveling packets along mapped Bezier curves
    final packetPaint = Paint()..style = PaintingStyle.fill;
    final blurPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (var packet in packets) {
      final localProg = (progress * packet.speedOffset + packet.phase) % 1.0;
      final double x = size.width * localProg;

      // Calculate Bezier heights matching the backing path channels
      double y = 0.0;
      if (packet.pathIndex == 0) {
        // Cubic Bezier exact height curve calculations
        final t = localProg;
        y = (1 - t) * (1 - t) * (1 - t) * (size.height * 0.3) +
            3 * (1 - t) * (1 - t) * t * (size.height * 0.05) +
            3 * (1 - t) * t * t * (size.height * 0.95) +
            t * t * t * (size.height * 0.7);
      } else {
        final t = localProg;
        y = (1 - t) * (1 - t) * (1 - t) * (size.height * 0.7) +
            3 * (1 - t) * (1 - t) * t * (size.height * 0.95) +
            3 * (1 - t) * t * t * (size.height * 0.05) +
            t * t * t * (size.height * 0.3);
      }

      final pos = Offset(x, y);
      final opacity = math.sin(localProg * math.pi).clamp(0.0, 1.0);

      // Packet colors
      final activeColor =
          packet.pathIndex == 0 ? color : MotionColors.secondaryNeon;

      // Glow behind packet
      blurPaint.color = activeColor.withValues(alpha: opacity * 0.45);
      canvas.drawCircle(pos, packet.size + 2, blurPaint);

      // Inner solid packet core
      packetPaint.color = Color.lerp(Colors.white, activeColor, 0.25)!
          .withValues(alpha: opacity);
      canvas.drawCircle(pos, packet.size, packetPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DataStreamPainter oldDelegate) => true;
}

/// High-security firewall scanner sweeps showing target highlights.
class MotionFirewallScannerLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionFirewallScannerLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionFirewallScannerLoader> createState() =>
      _MotionFirewallScannerLoaderState();
}

class _MotionFirewallScannerLoaderState
    extends State<MotionFirewallScannerLoader>
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
            painter: _FirewallScannerPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _FirewallScannerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _FirewallScannerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.46;

    // 1. Draw scanner grid background
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Circular bounds
    canvas.drawCircle(center, maxRadius, gridPaint);
    canvas.drawCircle(center, maxRadius * 0.65, gridPaint);
    canvas.drawCircle(center, maxRadius * 0.3, gridPaint);

    // Cross grid line helper
    canvas.drawLine(Offset(center.dx - maxRadius, center.dy),
        Offset(center.dx + maxRadius, center.dy), gridPaint);
    canvas.drawLine(Offset(center.dx, center.dy - maxRadius),
        Offset(center.dx, center.dy + maxRadius), gridPaint);

    // 2. Draw sweeping radar fan (rotating overlay)
    final sweepPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.25),
          color.withValues(alpha: 0.5),
        ],
        stops: const [0.0, 0.75, 1.0],
        transform: GradientRotation(progress * 2 * math.pi),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    canvas.drawCircle(center, maxRadius, sweepPaint);

    // 3. Draw active detected target highlights (pinging dots)
    final pingPaint = Paint()..style = PaintingStyle.fill;
    final double pingPhase1 = (progress - 0.2) % 1.0;
    final double pingPhase2 = (progress - 0.6) % 1.0;

    // Target 1
    final pos1 =
        Offset(center.dx + maxRadius * 0.45, center.dy - maxRadius * 0.45);
    final opacity1 = (1.0 - pingPhase1).clamp(0.0, 1.0);
    pingPaint.color = Colors.redAccent.withValues(alpha: opacity1);
    canvas.drawCircle(pos1, 4.0 * (1.0 + pingPhase1), pingPaint);
    canvas.drawRect(
        Rect.fromCenter(center: pos1, width: 8, height: 8),
        Paint()
          ..color = Colors.redAccent.withValues(alpha: opacity1 * 0.3)
          ..style = PaintingStyle.stroke);

    // Target 2
    final pos2 =
        Offset(center.dx - maxRadius * 0.5, center.dy + maxRadius * 0.25);
    final opacity2 = (1.0 - pingPhase2).clamp(0.0, 1.0);
    pingPaint.color = MotionColors.secondaryNeon.withValues(alpha: opacity2);
    canvas.drawCircle(pos2, 4.0 * (1.0 + pingPhase2), pingPaint);
    canvas.drawRect(
        Rect.fromCenter(center: pos2, width: 8, height: 8),
        Paint()
          ..color = MotionColors.secondaryNeon.withValues(alpha: opacity2 * 0.3)
          ..style = PaintingStyle.stroke);

    // Sweeping line edge highlight
    final edgePaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final angle = progress * 2 * math.pi;
    final edgeX = center.dx + maxRadius * math.cos(angle);
    final edgeY = center.dy + maxRadius * math.sin(angle);
    canvas.drawLine(center, Offset(edgeX, edgeY), edgePaint);
  }

  @override
  bool shouldRepaint(covariant _FirewallScannerPainter oldDelegate) => true;
}
