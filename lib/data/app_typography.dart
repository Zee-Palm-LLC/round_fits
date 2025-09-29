import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme poppinsTextTheme(Brightness brightness) {
    final base = GoogleFonts.poppinsTextTheme();
    if (brightness == Brightness.dark) {
      return base.apply(bodyColor: Colors.white, displayColor: Colors.white);
    }
    return base;
  }

  static const TextStyle displayNumeric = TextStyle(
    fontFeatures: [FontFeature.tabularFigures()],
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
  );

  static TextStyle button = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Common app tokens
  static TextStyle title = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
  );

  static TextStyle appBarTitle = GoogleFonts.poppins(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.0,
  );

  static TextStyle label = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle inputNumber = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static TextStyle countdown = GoogleFonts.poppins(
    fontSize: 88.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
  ).merge(const TextStyle(fontFeatures: [FontFeature.tabularFigures()]));
}
