import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workout_app/firebase_options.dart';
import 'package:workout_app/modules/splash/splash_view.dart';
import 'package:workout_app/services/analytics_user_count.dart';

import 'controllers/theme_controller.dart';
import 'data/app_theme.dart';
import 'localization/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AnalyticsUserCounter.initialize(appKey: 'fitrounds-workout-app');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    Get.put(ThemeController(), permanent: true);
    final saved = box.read<String>('localeCode');
    final locale = saved != null ? _parseLocale(saved) : Get.deviceLocale;
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet =
            constraints.maxWidth >= 650 && constraints.maxWidth < 1100;
        final Size designSize =
            isTablet
                ? Size(constraints.maxWidth, constraints.maxHeight)
                : const Size(390, 844);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          builder: (context, child) {
            return GetBuilder<ThemeController>(
              builder: (c) {
                return GetMaterialApp(
                  title: 'app_title'.tr,
                  theme: c.lightTheme,
                  darkTheme: c.darkTheme,
                  themeMode: c.themeMode,
                  translations: AppTranslations(),
                  locale: locale,
                  fallbackLocale: const Locale('en', 'US'),
                  supportedLocales: AppTranslations.supportedLocales,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  home: SplashView(),
                  debugShowCheckedModeBanner: false,
                  builder: (context, widget) {
                    ScreenUtil.init(context);
                    return widget!;
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

Locale _parseLocale(String code) {
  final parts = code.split('_');
  if (parts.length == 2) return Locale(parts[0], parts[1]);
  return Locale(parts[0]);
}
