import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:workout_app/data/app_theme.dart';
import 'package:workout_app/modules/settings/settings_view.dart';
import 'package:workout_app/modules/splash/components/animated_text.dart';
import 'package:workout_app/modules/splash/components/primary_background.dart';
import 'package:workout_app/modules/timer/timer_page.dart';

import '../../controllers/timer_controller.dart';
import '../../data/app_typography.dart';
import '../../services/storage_service.dart';
import '../../utils/responsive.dart';
import 'components/app_button.dart';
import 'components/number_field.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> with SingleTickerProviderStateMixin {
  late final TimerController controller;
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TimerController(StorageService(GetStorage())));
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: systemUiOverlayStyle,
        surfaceTintColor: Colors.transparent,
        title: AnimatedGradientText(text: 'app_title'.tr,style: AppTypography.appBarTitle),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const SettingsPage()),
            icon: const Icon(Iconsax.setting),
            tooltip: 'settings'.tr,
          ),
        ],
      ),
      body: PrimaryBackground(
        child: SafeArea(
          child: ResponsiveContainer(
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  _FadeSlideIn(
                    animation: CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
                    child: Text('setup_hint'.tr, style: AppTypography.title.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                  ),
                    SizedBox(height: 16.h),
                    _FadeSlideIn(
                      animation: CurvedAnimation(parent: _entranceController, curve: const Interval(0.1, 0.6, curve: Curves.easeOut)),
                      child: NumberField(
                      label: '${'work'.tr} (${"seconds".tr})',
                      value: controller.workSeconds.value,
                      min: 1,
                      onChanged: (v) => controller.updateSettings(work: v),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _FadeSlideIn(
                      animation: CurvedAnimation(parent: _entranceController, curve: const Interval(0.2, 0.7, curve: Curves.easeOut)),
                      child: NumberField(
                      label: '${'rest'.tr} (${"seconds".tr})',
                      value: controller.restSeconds.value,
                      min: 0,
                      onChanged: (v) => controller.updateSettings(rest: v),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _FadeSlideIn(
                      animation: CurvedAnimation(parent: _entranceController, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
                      child: NumberField(
                      label: 'rounds'.tr,
                      value: controller.rounds.value,
                      min: 1,
                      onChanged: (v) => controller.updateSettings(totalRounds: v),
                      ),
                    ),
                    const Spacer(),
                    _FadeSlideIn(
                      animation: CurvedAnimation(parent: _entranceController, curve: const Interval(0.45, 1.0, curve: Curves.easeOut)),
                      child: AppButton(
                      label: 'start'.tr,
                      onPressed: () {
                        controller.start();
                        Get.to(() => const TimerPage());
                      },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
      );
    
  }
}

class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({required this.animation, required this.child});
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}


