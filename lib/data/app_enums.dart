import 'package:flutter/material.dart';

enum ThemeCategory {
  material,
  blue,
  red,
  green,
  purple,
  dark,
  special,
}
extension ThemeCategoryExtension on ThemeCategory {
  String get displayName {
    switch (this) {
      case ThemeCategory.material:
        return 'Material';
      case ThemeCategory.blue:
        return 'Blue';
      case ThemeCategory.red:
        return 'Red & Pink';
      case ThemeCategory.green:
        return 'Green & Orange';
      case ThemeCategory.purple:
        return 'Purple';
      case ThemeCategory.dark:
        return 'Dark';
      case ThemeCategory.special:
        return 'Special';
    }
  }
  Color get color {
    switch (this) {
      case ThemeCategory.material:
        return Colors.grey;
      case ThemeCategory.blue:
        return Colors.blue;
      case ThemeCategory.red:
        return Colors.red;
      case ThemeCategory.green:
        return Colors.green;
      case ThemeCategory.purple:
        return Colors.purple;
      case ThemeCategory.dark:
        return Colors.grey.shade800;
      case ThemeCategory.special:
        return Colors.amber;
    }
  }
}