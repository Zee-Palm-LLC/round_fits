import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workout_app/controllers/timer_controller.dart';
import 'package:workout_app/data/app_typography.dart';

class ActiveTimerCard extends StatelessWidget {
  final TimerController controller;
  const ActiveTimerCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => Text(
            '${'round'.tr} ${controller.currentRound}/${controller.rounds}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: 260.w,
          height: 260.w,
          child: Obx(() {
            final bool isWork = controller.phase.value == Phase.work;
            final bool isComplete = controller.phase.value == Phase.complete;
            final int total =
                isWork
                    ? controller.workSeconds.value
                    : (controller.restSeconds.value == 0
                        ? 1
                        : controller.restSeconds.value);
            final int remaining = controller.secondsLeft.value;
            final double computed =
                total <= 0 ? 0 : ((total - remaining).clamp(0, total)) / total;
            final double progress = isComplete ? 0.0 : computed;

            return Stack(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.linear,
                  builder: (context, animatedProgress, _) {
                    return CustomPaint(
                      size: Size.square(250.w),
                      painter: _GradientCircularProgressPainter(
                        progress: animatedProgress,
                        strokeWidth: 20.w,
                        colors: [
                        Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  ],
                      ),
                    );
                  },
                ),
                Center(
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 1.0,
                      end: 0.9,
                    ).animate(controller.numberScaleController),
                    child: Text(
                      '${controller.secondsLeft.value}',
                      style: AppTypography.countdown.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;

  _GradientCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Duplicate the first color at the end to avoid harsh transition
    final gradient = SweepGradient(
      startAngle: -pi / 2, // start at top
      endAngle: 2 * pi - pi / 2, // full circle
      colors: [...colors, colors.first],
      tileMode: TileMode.clamp,
      transform: GradientRotation(-pi / 2), // rotate so seam is at top
    );

    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Background circle
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      2 * pi,
      false,
      backgroundPaint,
    );

    // Foreground arc (progress)
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      2 * pi * progress,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

