import 'package:flutter/material.dart';
import '../shimmer/shimmer_effect.dart';

class MotionSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shape;

  const MotionSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  });

  const MotionSkeleton.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        shape = const CircleBorder();

  const MotionSkeleton.rectangle({
    super.key,
    required this.width,
    required this.height,
    double borderRadius = 8.0,
  }) : shape = const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;

    return MotionShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: baseColor,
          shape: shape,
        ),
      ),
    );
  }

  // Preset Layouts
  static Widget profile({double avatarSize = 60.0}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          MotionSkeleton.circular(size: avatarSize),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const MotionSkeleton.rectangle(width: 140, height: 16),
                const SizedBox(height: 8),
                MotionSkeleton.rectangle(width: double.infinity, height: 12),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget card() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const MotionSkeleton.rectangle(width: double.infinity, height: 180, borderRadius: 12),
          const SizedBox(height: 12),
          const MotionSkeleton.rectangle(width: 200, height: 20),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              MotionSkeleton.rectangle(width: 100, height: 12),
              MotionSkeleton.rectangle(width: 60, height: 12),
            ],
          )
        ],
      ),
    );
  }

  static Widget list({int itemCount = 3}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => profile(),
    );
  }

  static Widget chat() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const MotionSkeleton.circular(size: 40),
              const SizedBox(width: 12),
              const MotionSkeleton.rectangle(width: 180, height: 40, borderRadius: 16),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const MotionSkeleton.rectangle(width: 150, height: 40, borderRadius: 16),
              const SizedBox(width: 12),
              const MotionSkeleton.circular(size: 40),
            ],
          ),
        ],
      ),
    );
  }
}
