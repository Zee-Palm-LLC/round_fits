import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryBackground extends StatelessWidget {
  final Widget child;
  const PrimaryBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const Color gradStart = Color(0xFFC72CF7); 
    const Color gradEnd = Color(0xFF2EB3E5); 
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Transform.translate(
                offset: Offset(124.w, -124.h),
                child: _blurCircle(
                  diameter: 420.w,
                  start: gradStart,
                  end: gradEnd,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX:
                      (Theme.of(context).brightness == Brightness.dark)
                          ? 18
                          : 10,
                  sigmaY:
                      (Theme.of(context).brightness == Brightness.dark)
                          ? 18
                          : 10,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(
                          alpha:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? 0.06
                                  : 0.01,
                        ),
                        Colors.white.withValues(
                          alpha:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? 0.02
                                  : 0.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned.fill(child: child),
        ],
      ),
    );
  }

  Widget _blurCircle({
    required double diameter,
    required Color start,
    required Color end,
  }) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 130, sigmaY: 130),
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              start.withValues(alpha: 0.35),
              end.withValues(alpha: 0.2),
              Colors.transparent,
            ],
            radius: 0.8,
            center: Alignment.center,
          ),
        ),
      ),
    );
  }
}
