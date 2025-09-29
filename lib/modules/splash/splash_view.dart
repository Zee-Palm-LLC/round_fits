import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workout_app/data/app_typography.dart';
import 'package:workout_app/modules/home/setup_page.dart';
import 'package:workout_app/modules/splash/components/animated_text.dart';
import 'package:workout_app/modules/splash/components/primary_background.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => const SetupPage());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrimaryBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/qr.png'),
              SizedBox(height: 20.h),
              AnimatedGradientText(
                text: 'FitRounds',
                style: AppTypography.title),
              SizedBox(height: 5.h),
              Text('Workout Interval Timer',style: AppTypography.body),
            ],
          ),
        ),
      ),
    );
  }
}