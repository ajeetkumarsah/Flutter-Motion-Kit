import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controllers/motion_controller.dart';
import 'controllers/motion_refresh_controller.dart';
import 'indicators/cosmic_refresh_painters.dart';
import 'indicators/nature_refresh_painters.dart';
import 'indicators/tech_refresh_painters.dart';
import 'motion_refresh_types.dart';

/// Next-Generation Pull-To-Refresh widget exposing 20 premium visual animations.
class MotionPullToRefresh extends StatefulWidget {
  /// The scrollable child widget (e.g. [ListView], [SingleChildScrollView]).
  final Widget child;

  /// The asynchronous callback task triggered upon release.
  final Future<void> Function() onRefresh;

  /// The active [MotionRefreshAnimation] layout preset indicator to render.
  final MotionRefreshAnimation animation;

  /// Bounding size of the loader graphics (width & height).
  final double size;

  /// Primary color of the graphic indicators. Resolves to theme primary if null.
  final Color? color;

  /// Central cycle duration for active refreshing animations.
  final Duration duration;

  /// The minimum duration the refresh indicator remains visible before hiding.
  /// Defaults to 3 seconds to let the premium visual animations run fully.
  final Duration refreshDuration;

  /// The curve applied to the pull/snap transitions.
  final Curve curve;

  /// The duration taken to smoothly collapse the top header after refresh completes.
  /// Defaults to 800 milliseconds for a sleek, premium slide-up transition.
  final Duration collapseDuration;

  /// The curve applied when collapsing the header back to the top.
  /// Defaults to [Curves.easeInOutCubic] for a beautiful, organic easing profile.
  final Curve collapseCurve;

  /// Base opacity of the header canvas.
  final double opacity;

  /// Bounding count of particles/elements in physics models.
  final int particleCount;

  /// Glow filter blur strength.
  final double glowStrength;

  /// Scaling multiplier for active speeds (respects global speed overrides).
  final double animationSpeed;

  /// Height threshold in pixels representing the trigger point.
  final double triggerDistance;

  /// The height the header settles at during active refreshing.
  /// Defaults to 80.0 pixels.
  final double settleDistance;

  /// The visual layout style of the refresh indicator.
  /// Defaults to [MotionRefreshStyle.bouncing] for organic physics-based list shifting.
  final MotionRefreshStyle style;

  /// Toggles the rendering of dynamic status helper text (e.g. "Pull to refresh").
  final bool showStatusText;

  /// Status text displayed when pulling. Defaults to "PULL TO REFRESH".
  final String pullText;

  /// Status text displayed when threshold is reached. Defaults to "RELEASE TO REFRESH".
  final String readyText;

  /// Status text displayed during active refreshing. Defaults to "REFRESHING...".
  final String refreshingText;

  /// Custom text style for the status label.
  final TextStyle? statusTextStyle;

  /// Toggles system haptics feedback during progress milestones.
  final bool enableHaptics;

  /// Toggles auditive sound triggers.
  final bool enableSound;

  /// Toggles glowing dropshadow painters.
  final bool enableShadows;

  /// Toggles dark/light base adaptive layouts.
  final bool adaptiveTheme;

  /// Background color override of the overscroll header container.
  final Color? backgroundColor;

  /// Custom foreground indicator color override.
  final Color? foregroundColor;

  /// Scroll physics wrapper applied to the notifier.
  final ScrollPhysics physics;
  final ScrollController? scrollController;

  const MotionPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.animation = MotionRefreshAnimation.liquidMorph,
    this.size = 60.0,
    this.color,
    this.duration = const Duration(seconds: 2),
    this.refreshDuration = const Duration(seconds: 3),
    this.curve = Curves.easeOutBack,
    this.collapseDuration = const Duration(milliseconds: 800),
    this.collapseCurve = Curves.easeInOutCubic,
    this.opacity = 1.0,
    this.particleCount = 20,
    this.glowStrength = 6.0,
    this.animationSpeed = 1.0,
    this.triggerDistance = 100.0,
    this.settleDistance = 80.0,
    this.style = MotionRefreshStyle.bouncing,
    this.showStatusText = true,
    this.pullText = "PULL TO REFRESH",
    this.readyText = "RELEASE TO REFRESH",
    this.refreshingText = "REFRESHING...",
    this.statusTextStyle,
    this.enableHaptics = true,
    this.enableSound = false,
    this.enableShadows = true,
    this.adaptiveTheme = true,
    this.backgroundColor,
    this.foregroundColor,
    this.physics = const BouncingScrollPhysics(),
    this.scrollController,
  });

  @override
  State<MotionPullToRefresh> createState() => _MotionPullToRefreshState();
}

class _MotionPullToRefreshState extends State<MotionPullToRefresh> {
  late final String _tag;
  late final MotionRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _tag = identityHashCode(this).toString();
    _controller = Get.put(
      MotionRefreshController(
        triggerDistance: widget.triggerDistance,
        settleDistance: widget.settleDistance,
        duration: widget.duration,
        refreshDuration: widget.refreshDuration,
        collapseDuration: widget.collapseDuration,
        collapseCurve: widget.collapseCurve,
        animationSpeed: widget.animationSpeed,
        enableHaptics: widget.enableHaptics,
        scrollController: widget.scrollController,
      ),
      tag: _tag,
    );
  }

  @override
  void didUpdateWidget(MotionPullToRefresh oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.updateParameters(
      triggerDistance: widget.triggerDistance,
      settleDistance: widget.settleDistance,
      duration: widget.duration,
      refreshDuration: widget.refreshDuration,
      collapseDuration: widget.collapseDuration,
      collapseCurve: widget.collapseCurve,
      animationSpeed: widget.animationSpeed,
      enableHaptics: widget.enableHaptics,
      scrollController: widget.scrollController,
    );
  }

  @override
  void dispose() {
    Get.delete<MotionRefreshController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final isReduced = motion?.reducedMotion ?? false;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = widget.color ?? Theme.of(context).primaryColor;

    final bg = widget.backgroundColor ??
        (widget.adaptiveTheme
            ? (isDark ? const Color(0xFF0D0D19) : const Color(0xFFF5F5FA))
            : Colors.transparent);

    final fg = widget.foregroundColor ?? primaryColor;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _controller.onScrollNotification(notification, widget.onRefresh);
        return false;
      },
      child: Obx(() {
        final pullOffset = _controller.pullOffset.value;
        final isRefreshing = _controller.isRefreshing.value;
        final isCollapsing = _controller.isCollapsing.value;
        // While actively refreshing (and not yet collapsing), keep the header
        // pinned at [settleDistance] so every indicator stays fully visible.
        final headerExtent = (isRefreshing && !isCollapsing)
            ? pullOffset.clamp(
                widget.settleDistance, widget.triggerDistance * 1.5)
            : pullOffset;
        final pullProgress =
            (headerExtent / widget.triggerDistance).clamp(0.0, 1.5);
        final indicatorOpacity = (isRefreshing && !isCollapsing)
            ? widget.opacity.clamp(0.0, 1.0)
            : (widget.opacity.clamp(0.0, 1.0) *
                (headerExtent / widget.settleDistance).clamp(0.0, 1.0));

        return Stack(
          children: [
            Transform.translate(
              offset: widget.style == MotionRefreshStyle.bouncing
                  ? Offset(0.0, headerExtent)
                  : Offset.zero,
              child: widget.child,
            ),
            if (headerExtent > 0 || isRefreshing)
              Positioned(
                top: widget.style == MotionRefreshStyle.bouncing
                    ? 0.0
                    : (-widget.settleDistance + headerExtent)
                        .clamp(-widget.settleDistance, 20.0),
                left: 0,
                right: 0,
                child: RepaintBoundary(
                  child: Container(
                    height: widget.style == MotionRefreshStyle.bouncing
                        ? headerExtent
                        : widget.settleDistance,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.style == MotionRefreshStyle.bouncing
                          ? bg
                          : Colors.transparent,
                    ),
                    child: ClipRect(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (widget.style == MotionRefreshStyle.clamping)
                            Positioned(
                              child: Container(
                                width: widget.size * 1.5 +
                                    (widget.showStatusText ? 50.0 : 0.0),
                                height: widget.settleDistance * 0.85,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xE0131520)
                                      : const Color(0xE0FFFFFF),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: primaryColor.withValues(alpha: 0.15),
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 10.0,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Opacity(
                            opacity: indicatorOpacity,
                            child: OverflowBox(
                              minHeight: widget.settleDistance,
                              maxHeight: widget.settleDistance,
                              minWidth: 0.0,
                              maxWidth: double.infinity,
                              alignment: Alignment.center,
                              child: Semantics(
                                label: isRefreshing
                                    ? 'Refreshing content'
                                    : 'Pull to refresh indicator',
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: widget.size,
                                      height: widget.size,
                                      child: AnimatedBuilder(
                                        animation: _controller.tickerController,
                                        builder: (context, _) => CustomPaint(
                                          painter: _resolvePainter(
                                            fg: fg,
                                            pullProgress: pullProgress,
                                            refreshProgress: isReduced
                                                ? 0.0
                                                : _controller
                                                    .tickerController.value,
                                            isRefreshing: isRefreshing,
                                            isDark: isDark,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (widget.showStatusText &&
                                        headerExtent > 45) ...[
                                      const SizedBox(height: 6),
                                      AnimatedDefaultTextStyle(
                                        duration:
                                            const Duration(milliseconds: 150),
                                        style: widget.statusTextStyle ??
                                            TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: fg.withValues(alpha: 0.8),
                                              letterSpacing: 1.0,
                                            ),
                                        child: Text(_getStatusText(
                                            pullProgress, isRefreshing)),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  CustomPainter _resolvePainter({
    required Color fg,
    required double pullProgress,
    required double refreshProgress,
    required bool isRefreshing,
    required bool isDark,
  }) {
    switch (widget.animation) {
      case MotionRefreshAnimation.liquidMorph:
        return MotionLiquidMorphPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          rippleCount: 3,
          waveHeight: 12.0,
        );
      case MotionRefreshAnimation.tornado:
        return MotionTornadoPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          particleCount: widget.particleCount,
          windStrength: 1.0,
        );
      case MotionRefreshAnimation.inkSpread:
        return MotionInkSpreadPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          viscosity: 0.35,
        );
      case MotionRefreshAnimation.crystalGrowth:
        return MotionCrystalGrowthPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          branchCount: 5,
          glowStrength: widget.glowStrength,
        );
      case MotionRefreshAnimation.phoenixRebirth:
        return MotionPhoenixRebirthPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          particleCount: widget.particleCount,
          wingSpan: 1.0,
        );
      case MotionRefreshAnimation.blackHole:
        return MotionBlackHolePainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          particleCount: widget.particleCount,
          eventHorizonSize: 22.0,
          gravityStrength: 1.0,
          rotationSpeed: 1.0,
        );
      case MotionRefreshAnimation.planetOrbit:
        return MotionPlanetOrbitPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          planetCount: 4,
          planetSize: 6.0,
          orbitSpeed: 1.0,
        );
      case MotionRefreshAnimation.magneticOrb:
        return MotionMagneticOrbPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          particleCount: widget.particleCount,
          orbRadius: 10.0,
          magneticForce: 1.0,
        );
      case MotionRefreshAnimation.portal:
        return MotionPortalPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          particleCount: widget.particleCount,
          portalRadius: 20.0,
          swirlSpeed: 1.0,
        );
      case MotionRefreshAnimation.rocketLaunch:
        return MotionRocketLaunchPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          rocketSize: 26.0,
          flameIntensity: 1.0,
          particleCount: widget.particleCount,
        );
      case MotionRefreshAnimation.dnaHelix:
        return MotionDnaHelixPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          strandColorB: Colors.cyanAccent,
          nodeCount: widget.particleCount,
          rotationSpeed: 1.0,
        );
      case MotionRefreshAnimation.jellyBounce:
        return MotionJellyBouncePainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          elasticity: 1.0,
          bounceCount: 4,
        );
      case MotionRefreshAnimation.infinitySymbol:
        return MotionInfinitySymbolPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          strokeWidth: 2.0,
          glowEnabled: widget.enableShadows,
        );
      case MotionRefreshAnimation.neuralNetwork:
        return MotionNeuralNetworkPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          nodeCount: widget.particleCount,
          glowRadius: widget.glowStrength,
        );
      case MotionRefreshAnimation.clockwork:
        return MotionClockworkPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          gearCount: 3,
          gearSize: 18.0,
        );
      case MotionRefreshAnimation.origamiBird:
        return MotionOrigamiBirdPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          birdScale: 16.0,
        );
      case MotionRefreshAnimation.lightningCharge:
        return MotionLightningChargePainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          boltCount: 3,
          chargeLevel: 1.0,
        );
      case MotionRefreshAnimation.fireworks:
        return MotionFireworksPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          explosionCount: 2,
          particleCount: widget.particleCount,
        );
      case MotionRefreshAnimation.hologram:
        return MotionHologramPainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          scanSpeed: 2.0,
          glitchAmount: 1.0,
        );
      case MotionRefreshAnimation.signature:
        return MotionSignaturePainter(
          pullProgress: pullProgress,
          refreshProgress: refreshProgress,
          isRefreshing: isRefreshing,
          color: fg,
          particleCount: widget.particleCount,
          glowStrength: widget.glowStrength,
        );
    }
  }

  String _getStatusText(double pullProgress, bool isRefreshing) {
    if (isRefreshing) {
      return widget.refreshingText;
    } else if (pullProgress >= 1.0) {
      return widget.readyText;
    } else {
      return widget.pullText;
    }
  }
}
