import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/motion_controller.dart';

/// SaaS Category styles & enums.
enum MotionSaasStyle {
  /// 3x3 Staggered matrix grid cards pulsing opacity like a dashboard placeholder.
  pulseGrid,

  /// Auto-drawing line chart graph showing active analytic metrics data points.
  analytics,

  /// Floating sync bubbles entering a bezier cloud while arrows spin.
  cloudSync,
}

/// 3x3 Staggered matrix grid cards pulsing opacity like a dashboard skeleton screen.
class MotionSaasPulseGrid extends StatefulWidget {
  final Color color;
  final double size;

  const MotionSaasPulseGrid({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionSaasPulseGrid> createState() => _MotionSaasPulseGridState();
}

class _MotionSaasPulseGridState extends State<MotionSaasPulseGrid>
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
            painter: _PulseGridPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _PulseGridPainter extends CustomPainter {
  final double progress;
  final Color color;

  _PulseGridPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final int gridCount = 3; // 3x3 grid
    final double padding = 4.0;
    final double cellSize =
        (size.width - (padding * (gridCount - 1))) / gridCount;

    final cellPaint = Paint()..style = PaintingStyle.fill;

    for (int y = 0; y < gridCount; y++) {
      for (int x = 0; x < gridCount; x++) {
        // Stagger grid cards based on Manhattan distance from center
        final dist = (x - 1).abs() + (y - 1).abs();
        final delay = dist * 0.18;

        final localProg = (progress - delay) % 1.0;
        final opacity = 0.2 + 0.65 * math.sin(localProg * math.pi);
        final scale = 0.9 + 0.1 * math.sin(localProg * math.pi);

        final cellX = x * (cellSize + padding);
        final cellY = y * (cellSize + padding);

        final centerCellX = cellX + cellSize / 2;
        final centerCellY = cellY + cellSize / 2;

        final scaledCellSize = cellSize * scale;

        cellPaint.color = color.withValues(alpha: opacity);

        final rrect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerCellX, centerCellY),
            width: scaledCellSize,
            height: scaledCellSize,
          ),
          const Radius.circular(6.0),
        );

        canvas.drawRRect(rrect, cellPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PulseGridPainter oldDelegate) => true;
}

/// Auto-drawing line chart graph showing active analytic metrics data points.
class MotionSaasAnalyticsLoader extends StatefulWidget {
  final Color color;
  final double size;

  const MotionSaasAnalyticsLoader({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<MotionSaasAnalyticsLoader> createState() =>
      _MotionSaasAnalyticsLoaderState();
}

class _MotionSaasAnalyticsLoaderState extends State<MotionSaasAnalyticsLoader>
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
      duration: Duration(milliseconds: (2600 / speed).round()),
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
            painter: _AnalyticsPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _AnalyticsPainter extends CustomPainter {
  final double progress;
  final Color color;

  _AnalyticsPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 6 static analytic chart metric points
    final List<Offset> chartPoints = [
      Offset(0.0, size.height * 0.75),
      Offset(size.width * 0.2, size.height * 0.65),
      Offset(size.width * 0.4, size.height * 0.35),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.8, size.height * 0.18),
      Offset(size.width, size.height * 0.3),
    ];

    final double sweep = progress; // Sweep loader from left to right

    final chartPath = Path();
    final fillPath = Path();

    chartPath.moveTo(chartPoints[0].dx, chartPoints[0].dy);
    fillPath.moveTo(chartPoints[0].dx, size.height);
    fillPath.lineTo(chartPoints[0].dx, chartPoints[0].dy);

    Offset activeIndicatorPos = chartPoints[0];

    for (int i = 1; i < chartPoints.length; i++) {
      final double ratio = chartPoints[i].dx / size.width;
      if (sweep >= ratio) {
        chartPath.lineTo(chartPoints[i].dx, chartPoints[i].dy);
        fillPath.lineTo(chartPoints[i].dx, chartPoints[i].dy);
        activeIndicatorPos = chartPoints[i];
      } else {
        // Interpolate current segment drawing tip
        final double segmentStartRatio = chartPoints[i - 1].dx / size.width;
        final double segmentT =
            (sweep - segmentStartRatio) / (ratio - segmentStartRatio);

        if (segmentT > 0.0 && segmentT < 1.0) {
          final Offset currentTip =
              Offset.lerp(chartPoints[i - 1], chartPoints[i], segmentT)!;
          chartPath.lineTo(currentTip.dx, currentTip.dy);
          fillPath.lineTo(currentTip.dx, currentTip.dy);
          activeIndicatorPos = currentTip;
        }
        break;
      }
    }

    fillPath.lineTo(activeIndicatorPos.dx, size.height);
    fillPath.close();

    // 1. Draw chart gradient translucent fill
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.22),
          color.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // 2. Draw chart line stroke
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(chartPath, linePaint);

    // 3. Draw grid helper lines
    final helperPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(0, size.height * 0.33),
        Offset(size.width, size.height * 0.33), helperPaint);
    canvas.drawLine(Offset(0, size.height * 0.66),
        Offset(size.width, size.height * 0.66), helperPaint);

    // 4. Draw glowing analytics indicator node dot
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(activeIndicatorPos, 4.0, dotPaint);

    final dotGlow = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(activeIndicatorPos, 7.0, dotGlow);
  }

  @override
  bool shouldRepaint(covariant _AnalyticsPainter oldDelegate) => true;
}

/// Floating sync bubbles entering a bezier cloud while arrows spin.
class MotionSaasCloudSync extends StatefulWidget {
  final Color color;
  final double size;
  final bool glow;

  const MotionSaasCloudSync({
    super.key,
    required this.color,
    required this.size,
    this.glow = true,
  });

  @override
  State<MotionSaasCloudSync> createState() => _MotionSaasCloudSyncState();
}

class _MotionSaasCloudSyncState extends State<MotionSaasCloudSync>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_SyncBubble> _bubbles = [];
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

    // Spawn upload bubbles moving upwards into cloud base
    for (int i = 0; i < 6; i++) {
      _bubbles.add(_SyncBubble(
        startXOffset: _random.nextDouble() * 0.4 - 0.2, // Offset centered
        speed: 0.8 + _random.nextDouble() * 0.6,
        size: 2.0 + _random.nextDouble() * 2.0,
        phase: _random.nextDouble() * math.pi,
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
            painter: _CloudSyncPainter(
              progress: isReduced ? 0.0 : _controller.value,
              color: widget.color,
              bubbles: _bubbles,
              glow: widget.glow && !(motion?.performanceMode ?? false),
            ),
          );
        },
      ),
    );
  }
}

class _SyncBubble {
  final double startXOffset;
  final double speed;
  final double size;
  final double phase;

  _SyncBubble({
    required this.startXOffset,
    required this.speed,
    required this.size,
    required this.phase,
  });
}

class _CloudSyncPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_SyncBubble> bubbles;
  final bool glow;

  _CloudSyncPainter({
    required this.progress,
    required this.color,
    required this.bubbles,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Draw SaaS Cloud outline using precise Bezier vectors
    final cloudPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final cloudBorder = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final cloudPath = Path();
    final double cx = center.dx;
    final double cy = center.dy - size.height * 0.05;
    final double w = size.width * 0.72;
    final double h = size.height * 0.44;

    // Draw high-quality rounded cloud segments
    cloudPath.moveTo(cx - w * 0.25, cy + h * 0.35);
    cloudPath.cubicTo(cx - w * 0.55, cy + h * 0.35, cx - w * 0.55,
        cy - h * 0.15, cx - w * 0.25, cy - h * 0.15);
    cloudPath.cubicTo(cx - w * 0.25, cy - h * 0.65, cx + w * 0.25,
        cy - h * 0.65, cx + w * 0.25, cy - h * 0.15);
    cloudPath.cubicTo(cx + w * 0.55, cy - h * 0.15, cx + w * 0.55,
        cy + h * 0.35, cx + w * 0.25, cy + h * 0.35);
    cloudPath.close();

    canvas.drawPath(cloudPath, cloudPaint);
    canvas.drawPath(cloudPath, cloudBorder);

    // 2. Draw rising uploading data bubbles
    final bubblePaint = Paint()..style = PaintingStyle.fill;
    for (var bubble in bubbles) {
      final localProg = (progress * bubble.speed) % 1.0;

      // Rising upwards from bottom center up into the cloud core
      final x = cx +
          w * bubble.startXOffset +
          (5.0 * math.sin(progress * 2 * math.pi + bubble.phase));
      final y = cy + h * 0.75 - (h * 1.0 * localProg);

      // Skip drawing if outside bounds
      if (y < cy - h * 0.4) continue;

      final opacity = math.sin(localProg * math.pi).clamp(0.0, 1.0);
      bubblePaint.color = color.withValues(alpha: opacity * 0.85);
      canvas.drawCircle(Offset(x, y), bubble.size, bubblePaint);
    }

    // 3. Draw rotating sync arrows in cloud center
    canvas.save();
    canvas.translate(cx, cy - h * 0.12);
    canvas.rotate(progress * 2 * math.pi * 1.2); // Spin arrow

    final arrowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double arrowR = w * 0.14;
    // Draw sweeping dynamic syncing loop arrow segment
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: arrowR),
      0.15,
      math.pi * 0.75,
      false,
      arrowPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: arrowR),
      math.pi + 0.15,
      math.pi * 0.75,
      false,
      arrowPaint,
    );

    // Draw little arrowheads at the ends of loop arcs
    final arrowhead = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Top-right arrowhead
    canvas.save();
    canvas.rotate(0.15 + math.pi * 0.75);
    final arrowHeadPath1 = Path()
      ..moveTo(arrowR, 0)
      ..lineTo(arrowR - 3, -4)
      ..lineTo(arrowR + 3, -4)
      ..close();
    canvas.drawPath(arrowHeadPath1, arrowhead);
    canvas.restore();

    // Bottom-left arrowhead
    canvas.save();
    canvas.rotate(math.pi + 0.15 + math.pi * 0.75);
    final arrowHeadPath2 = Path()
      ..moveTo(arrowR, 0)
      ..lineTo(arrowR - 3, -4)
      ..lineTo(arrowR + 3, -4)
      ..close();
    canvas.drawPath(arrowHeadPath2, arrowhead);
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CloudSyncPainter oldDelegate) => true;
}
