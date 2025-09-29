import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:workout_app/data/app_typography.dart';
import 'package:workout_app/utils/color_utils.dart';

class NumberField extends StatefulWidget {
  const NumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(_scaleController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scaleController.reverse();
      }
    });
  }

  @override
  void didUpdateWidget(covariant NumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _scaleController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  void _startHold(bool increment) {
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      final int current = widget.value;
      final int next = increment ? current + 1 : current - 1;
      if (next < widget.min || next > widget.max) return;
      _scaleController.forward(from: 0);
      widget.onChanged(next);
    });
  }

  void _stopHold() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTypography.label.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9))),
        const SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: widget.value > widget.min
                  ? () {
                      _scaleController.forward(from: 0);
                      widget.onChanged(widget.value - 1);
                    }
                  : null,
              onLongPressStart: (_) {
                if (widget.value > widget.min) _startHold(false);
              },
              onLongPressEnd: (_) => _stopHold(),
              onLongPressUp: _stopHold,
              child: Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(
                  Iconsax.minus,
                  color: iconOnColor(Theme.of(context).primaryColor),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Text(
                    '${widget.value}',
                    style: AppTypography.inputNumber.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: widget.value < widget.max
                  ? () {
                      _scaleController.forward(from: 0);
                      widget.onChanged(widget.value + 1);
                    }
                  : null,
              onLongPressStart: (_) {
                if (widget.value < widget.max) _startHold(true);
              },
              onLongPressEnd: (_) => _stopHold(),
              onLongPressUp: _stopHold,
              child: Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(
                  Iconsax.add,
                  color: iconOnColor(Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
