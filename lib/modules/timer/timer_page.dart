import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:workout_app/modules/splash/components/primary_background.dart';
import 'package:workout_app/modules/timer/components/active_timer_card.dart';
import 'package:workout_app/modules/timer/components/custom_icon_button.dart';
import 'package:workout_app/modules/timer/summary_page.dart';

import '../../controllers/timer_controller.dart';
import '../../data/app_typography.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TimerController>();
    return WillPopScope(
      onWillPop: () async {
        controller.stop();
        return true;
      },
      child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.stop();
            Get.back();
          },
        ),
        title: Obx(() {
          final p = controller.phase.value;
          final String title = p == Phase.work
              ? 'work'.tr
              : p == Phase.rest
                  ? 'rest'.tr
                  : 'completed'.tr;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(anim),
                child: child,
              ),
            ),
            child: Text(
              title,
              key: ValueKey(title),
              style: AppTypography.appBarTitle,
            ),
          );
        }),
      ),
      body: PrimaryBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Obx(() {
                  final p = controller.phase.value;
                  if (p == Phase.complete) {
                    Future.microtask(() {
                      Get.off(
                        () =>  SummaryPage(
                          args: {
                            'work': controller.workSeconds.value,
                            'rest': controller.restSeconds.value,
                            'rounds': controller.rounds.value,
                          },
                        ),
                      );
                    });
                    return const SizedBox.shrink();
                  }
                  return ActiveTimerCard(controller: controller);
                }),
              ),
              const Spacer(),
              _RhythmCue(controller: controller),
              Obx(() {
                final running = controller.isRunning.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      onTap: running ? controller.pause : controller.resume,
                      icon:
                          running ? Iconsax.pause_circle : Iconsax.play_circle,
                      label: running ? 'pause'.tr : 'resume'.tr,
                    ),
                    SizedBox(width: 15.w),
                    CustomIconButton(
                      onTap: controller.skip,
                      icon: Iconsax.forward_square,
                      label: 'skip'.tr,
                    ),

                    SizedBox(width: 15.w),
                    CustomIconButton(
                      onTap: controller.stop,
                      icon: Iconsax.stop,
                      label: 'stop'.tr,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      ),
    );
  }
}


class _RhythmCue extends StatelessWidget {
  const _RhythmCue({required this.controller});
  final TimerController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isWork = controller.phase.value == Phase.work;
      final int remaining = controller.secondsLeft.value;
      final String msg = isWork
          ? (remaining <= 3
              ? 'finish_strong'.tr
              : remaining <= 10
                  ? 'keep_pace'.tr
                  : 'push'.tr)
          : (remaining <= 3
              ? 'get_ready'.tr
              : 'breathe'.tr);
      final Alignment target = (remaining % 2 == 0)
          ? Alignment.centerLeft
          : Alignment.centerRight;
      final Color primary = Theme.of(context).colorScheme.primary;
      final Color onSurface = Theme.of(context).colorScheme.onSurface;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            msg,
            style: AppTypography.label.copyWith(
              color: onSurface.withValues(alpha: 0.75),
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 220.w,
            height: 16.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                AnimatedAlign(
                  alignment: target,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.45),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
      );
    });
  }
}
