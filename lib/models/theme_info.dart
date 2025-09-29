import 'package:workout_app/data/app_enums.dart';

class ThemeInfo {
  final String name;
  final String description;
  final ThemeCategory category;
  final bool isDark;
  const ThemeInfo({
    required this.name,
    required this.description,
    required this.category,
    required this.isDark,
  });
}