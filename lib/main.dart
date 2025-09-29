import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workout_app/modules/splash/splash_view.dart';

import 'controllers/theme_controller.dart';
import 'data/app_theme.dart';
import 'localization/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    Get.put(ThemeController(), permanent: true);
    final saved = box.read<String>('localeCode');
    final locale = saved != null
        ? _parseLocale(saved)
        : Get.deviceLocale;
    return ScreenUtilInit(
      designSize: const Size(390, 844),
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
  }
}

Locale _parseLocale(String code) {
  final parts = code.split('_');
  if (parts.length == 2) return Locale(parts[0], parts[1]);
  return Locale(parts[0]);
}
