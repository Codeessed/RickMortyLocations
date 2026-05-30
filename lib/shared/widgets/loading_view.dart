import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A shimmer-animated loading skeleton that mimics the location list layout.
///
/// Shows pulsating placeholder cards while data is being fetched.
class LoadingView extends StatefulWidget {
  /// Number of skeleton cards to display.
  final int itemCount;

  const LoadingView({super.key, this.itemCount = 6});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: widget.itemCount,
          itemBuilder: (context, index) => _SkeletonCard(
            opacity: _animation.value,
          ),
        );
      },
    );
  }
}

/// A single shimmer card skeleton mimicking [LocationCard].
class _SkeletonCard extends StatelessWidget {
  final double opacity;

  const _SkeletonCard({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon placeholder
            _ShimmerBox(width: 48, height: 48, radius: 12, opacity: opacity),
            const SizedBox(width: 14),

            // Text placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    width: 160,
                    height: 14,
                    radius: 6,
                    opacity: opacity,
                  ),
                  const SizedBox(height: 8),
                  _ShimmerBox(
                    width: 100,
                    height: 11,
                    radius: 6,
                    opacity: opacity,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Type chip placeholder
            _ShimmerBox(width: 60, height: 24, radius: 20, opacity: opacity),
          ],
        ),
      ),
    );
  }
}

/// A single rounded rectangle that pulses with the shimmer animation.
class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final double opacity;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.divider.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
