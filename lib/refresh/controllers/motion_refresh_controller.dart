import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/controllers/motion_controller.dart';

class MotionRefreshController extends GetxController
    with GetTickerProviderStateMixin {
  double triggerDistance;
  double settleDistance;
  Duration duration;
  Duration refreshDuration;
  Duration collapseDuration;
  Curve collapseCurve;
  double animationSpeed;
  bool enableHaptics;
  ScrollController? scrollController;

  MotionRefreshController({
    required this.triggerDistance,
    required this.settleDistance,
    required this.duration,
    required this.refreshDuration,
    required this.collapseDuration,
    required this.collapseCurve,
    required this.animationSpeed,
    required this.enableHaptics,
    this.scrollController,
  });

  final RxDouble pullOffset = 0.0.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isCollapsing = false.obs;
  final RxBool hasThresholdBeenReached = false.obs;
  final RxBool hasSelectionHapticFired = false.obs;

  late AnimationController resetController;
  late AnimationController tickerController;
  late Animatable<double> activeTween;

  @override
  void onInit() {
    super.onInit();
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    resetController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (300 / speed).round()),
    );

    activeTween = Tween<double>(begin: 0.0, end: 0.0);
    resetController.addListener(() {
      pullOffset.value = activeTween.evaluate(resetController);
    });

    tickerController = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds:
              (duration.inMilliseconds / (speed * animationSpeed)).round()),
    );
  }

  @override
  void onClose() {
    resetController.dispose();
    tickerController.dispose();
    super.onClose();
  }

  void updateParameters({
    required double triggerDistance,
    required double settleDistance,
    required Duration duration,
    required Duration refreshDuration,
    required Duration collapseDuration,
    required Curve collapseCurve,
    required double animationSpeed,
    required bool enableHaptics,
    ScrollController? scrollController,
  }) {
    this.triggerDistance = triggerDistance;
    this.settleDistance = settleDistance;
    this.duration = duration;
    this.refreshDuration = refreshDuration;
    this.collapseDuration = collapseDuration;
    this.collapseCurve = collapseCurve;
    this.animationSpeed = animationSpeed;
    this.enableHaptics = enableHaptics;
    this.scrollController = scrollController;

    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    resetController.duration = Duration(milliseconds: (300 / speed).round());
    tickerController.duration = Duration(
        milliseconds:
            (duration.inMilliseconds / (speed * animationSpeed)).round());
  }

  void onScrollNotification(
      ScrollNotification notification, Future<void> Function() onRefresh) {
    if (isRefreshing.value || isCollapsing.value) return;

    final metrics = notification.metrics;

    if (notification is ScrollUpdateNotification) {
      // [dragDetails] is non-null only while the user's finger is actively
      // driving the scroll. When it is null, the update is physics-driven
      // (the ballistic bounce-back after release). We must NOT let that
      // bounce-back shrink the pull or cancel a committed refresh, otherwise
      // the loader vanishes and the list snaps to the top instantly.
      final bool isUserDrag = notification.dragDetails != null;

      if (metrics.pixels < 0) {
        // Bouncing overscroll (iOS style or bouncing physics).
        if (!isUserDrag) {
          // Physics settling the overscroll — leave the pull/threshold alone.
          return;
        }
        final rawOffset = -metrics.pixels;
        final dampedOffset = rawOffset * 0.85;
        pullOffset.value = dampedOffset.clamp(0.0, triggerDistance * 1.5);
        if (pullOffset.value >= triggerDistance) {
          hasThresholdBeenReached.value = true;
          if (enableHaptics && !hasSelectionHapticFired.value) {
            HapticFeedback.selectionClick();
            hasSelectionHapticFired.value = true;
          }
        } else if (pullOffset.value < triggerDistance * 0.5) {
          // Only reset the threshold flag if they drag all the way back up (cancel gesture)
          hasThresholdBeenReached.value = false;
          hasSelectionHapticFired.value = false;
        }
      } else {
        // Scroll position is >= 0 (normal list scrolling or clamping top)
        if (pullOffset.value > 0) {
          if (isUserDrag) {
            // The user is actively dragging the content back up to cancel.
            final delta = notification.scrollDelta ?? 0.0;
            if (delta > 0) {
              pullOffset.value =
                  (pullOffset.value - delta).clamp(0.0, triggerDistance * 1.5);
              if (pullOffset.value < triggerDistance * 0.5) {
                hasThresholdBeenReached.value = false;
                hasSelectionHapticFired.value = false;
              }
            } else if (metrics.pixels > 0) {
              pullOffset.value = 0.0;
              hasThresholdBeenReached.value = false;
              hasSelectionHapticFired.value = false;
            }
          } else if (!hasThresholdBeenReached.value) {
            // Physics settling without a committed refresh — release the header.
            pullOffset.value = 0.0;
          }
        } else if (pullOffset.value != 0.0) {
          pullOffset.value = 0.0;
        }
      }
    } else if (notification is OverscrollNotification) {
      // Clamping overscroll physics (Android defaults).
      final bool isUserDrag = notification.dragDetails != null;
      if (notification.overscroll < 0 && isUserDrag) {
        final double delta = -notification.overscroll * 0.85;
        pullOffset.value =
            (pullOffset.value + delta).clamp(0.0, triggerDistance * 1.5);
        if (pullOffset.value >= triggerDistance) {
          hasThresholdBeenReached.value = true;
          if (enableHaptics && !hasSelectionHapticFired.value) {
            HapticFeedback.selectionClick();
            hasSelectionHapticFired.value = true;
          }
        }
      }
    } else if (notification is ScrollEndNotification ||
        (notification is UserScrollNotification &&
            notification.direction == ScrollDirection.idle)) {
      // Release gesture — decide based on the committed threshold.
      if (hasThresholdBeenReached.value && pullOffset.value > 0) {
        triggerRefresh(onRefresh);
      } else if (pullOffset.value > 0) {
        snapBack(0.0);
      }
    }
  }

  Future<void> triggerRefresh(Future<void> Function() onRefresh) async {
    if (isRefreshing.value) return;

    if (enableHaptics) {
      HapticFeedback.mediumImpact();
    }

    hasThresholdBeenReached.value = false;
    isRefreshing.value = true;

    // Lock the header to a stable, visible height so the loader is always
    // shown regardless of how the underlying physics settle.
    await animateToOffset(settleDistance);
    tickerController.repeat();

    final DateTime started = DateTime.now();
    try {
      await onRefresh();
    } finally {
      // Keep the indicator visible for at least [refreshDuration] (3-5s) so the
      // premium animation runs fully, accounting for time already spent.
      final Duration elapsed = DateTime.now().difference(started);
      if (elapsed < refreshDuration) {
        await Future.delayed(refreshDuration - elapsed);
      }

      tickerController.stop();
      tickerController.reset();

      // Collapse the header up smoothly (loader slides away).
      await snapBack(0.0);

      // Then bring the list content to the very top.
      if (scrollController != null &&
          scrollController!.hasClients &&
          scrollController!.offset > 0) {
        await scrollController!.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }

      isRefreshing.value = false;
      hasSelectionHapticFired.value = false;
    }
  }

  Future<void> animateToOffset(double target) async {
    final double start = pullOffset.value;
    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    activeTween = Tween<double>(
      begin: start,
      end: target,
    ).chain(CurveTween(curve: Curves.easeOutCubic));

    resetController.duration = Duration(
      milliseconds: (300 / speed).round(),
    );
    resetController.reset();

    await resetController.forward();
  }

  Future<void> snapBack(double target) async {
    final double start = pullOffset.value;
    if ((start - target).abs() < 0.5) {
      pullOffset.value = target;
      hasThresholdBeenReached.value = false;
      return;
    }

    final motion = Get.isRegistered<MotionController>()
        ? Get.find<MotionController>()
        : null;
    final speed = motion?.speedMultiplier ?? 1.0;

    isCollapsing.value = true;

    activeTween = Tween<double>(
      begin: start,
      end: target,
    ).chain(CurveTween(curve: collapseCurve));

    resetController.duration = Duration(
      milliseconds: (collapseDuration.inMilliseconds / speed).round(),
    );
    resetController.reset();

    await resetController.forward();

    isCollapsing.value = false;
    hasThresholdBeenReached.value = false;
  }
}
