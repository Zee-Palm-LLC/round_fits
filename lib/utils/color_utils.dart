import 'package:flutter/material.dart';

/// Returns a high-contrast icon color (black or white) for the given background color.
/// Uses Flutter's brightness estimation to determine appropriate foreground.
Color iconOnColor(Color backgroundColor) {
  final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
  return brightness == Brightness.dark ? Colors.white : Colors.black;
}


