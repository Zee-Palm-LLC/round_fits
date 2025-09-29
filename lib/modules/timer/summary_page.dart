import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workout_app/modules/home/components/app_button.dart';
import 'package:workout_app/services/review_service.dart';

import '../../data/app_colors.dart';
import '../../data/app_typography.dart';

class SummaryPage extends StatelessWidget {
  final Map<String, dynamic>? args;
  const SummaryPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    // Randomly trigger in-app review on entering summary
    Future.microtask(() async {
      final box = GetStorage();
      await ReviewService(box).maybeRequestReview();
    });
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('completed'.tr),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(
                  context,
                ).scaffoldBackgroundColor.withValues(alpha: 0.92),
                Theme.of(context).scaffoldBackgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [_SummaryCard(onSurface: onSurface, args: args)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Map<String, dynamic>? args;
  const _SummaryCard({required this.onSurface, this.args});
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    final int work = (args?['work'] as int?) ?? 30;
    final int rest = (args?['rest'] as int?) ?? 15;
    final int rounds = (args?['rounds'] as int?) ?? 8;
    final int totalSeconds = (work + rest) * rounds;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Iconsax.tick_circle, color: AppColors.neonCyan, size: 28.sp),
              SizedBox(width: 8.w),
              Text(
                'share_summary'.tr,
                style: AppTypography.title.copyWith(color: onSurface),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _kv('work'.tr, '$work ${'seconds'.tr}', onSurface),
          _kv('rest'.tr, '$rest ${'seconds'.tr}', onSurface),
          _kv('rounds'.tr, '$rounds', onSurface),
          _kv(
            'total_duration'.tr,
            '${totalSeconds ~/ 60}m ${totalSeconds % 60}s',
            onSurface,
          ),
          SizedBox(height: 16.h),
          AppButton(
            onPressed: () {
              final String header = '${'app_title'.tr} — ${'completed'.tr}';
              final String details = [
                '${'rounds'.tr}: $rounds',
                '${'work'.tr}: $work ${'seconds'.tr}',
                '${'rest'.tr}: $rest ${'seconds'.tr}',
                '${'total_duration'.tr}: ${totalSeconds ~/ 60}m ${totalSeconds % 60}s',
              ].join('\n');
              final String footer = '\n#FitRounds';
              final String text = '$header\n\n$details$footer';
              Share.share(
                text,
                subject: '${'share_summary'.tr} - ${'app_title'.tr}',
              );
            },
            height: 40.h,
            label: 'share_summary'.tr,
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, Color onSurface) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            k,
            style: AppTypography.label.copyWith(
              color: onSurface.withValues(alpha: 0.8),
            ),
          ),
          Text(v, style: AppTypography.body.copyWith(color: onSurface)),
        ],
      ),
    );
  }
}
