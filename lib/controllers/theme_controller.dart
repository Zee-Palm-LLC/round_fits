import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static const String _keyThemeMode = 'themeMode';
  static const String _keyFlexScheme = 'flexScheme';

  final GetStorage _box = GetStorage();

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  final Rx<FlexScheme> _scheme = FlexScheme.jungle.obs;

  ThemeMode get themeMode => _themeMode.value;
  FlexScheme get scheme => _scheme.value;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final String? savedMode = _box.read<String>(_keyThemeMode);
    if (savedMode == 'dark') {
      _themeMode.value = ThemeMode.dark;
    } else if (savedMode == 'light') {
      _themeMode.value = ThemeMode.light;
    } else if (savedMode == 'system') {
      _themeMode.value = ThemeMode.system;
    } else {
      // No saved value on first launch: follow system and persist it
      _themeMode.value = ThemeMode.system;
      _box.write(_keyThemeMode, ThemeMode.system.name);
    }

    final String? savedScheme = _box.read<String>(_keyFlexScheme);
    if (savedScheme != null) {
      final FlexScheme? match = FlexScheme.values.firstWhereOrNull((e) => e.name == savedScheme);
      if (match != null) {
        _scheme.value = match;
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    await _box.write(_keyThemeMode, mode.name);
    update();
  }

  Future<void> toggleDarkLight() async {
    final ThemeMode next = _themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }

  Future<void> setScheme(FlexScheme scheme) async {
    _scheme.value = scheme;
    await _box.write(_keyFlexScheme, scheme.name);
    update();
  }

  ThemeData get lightTheme => FlexThemeData.light(
        scheme: _scheme.value,
        useMaterial3: true,
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
          },
        ),
      );

  ThemeData get darkTheme => FlexThemeData.dark(
        scheme: _scheme.value,
        useMaterial3: true,
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
          },
        ),
      );
}