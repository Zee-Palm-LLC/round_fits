import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workout_app/data/app_typography.dart';

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double t = _controller.value;
        final double angle = t * 2 * math.pi;

        final double glowPulse = 0.5 + 0.5 * math.sin(angle);

        return InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                transform: GradientRotation(angle),
              ),
              borderRadius: BorderRadius.circular(30.r),
            ),
            height: widget.height ?? 46.h,
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: AppTypography.button.copyWith(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
