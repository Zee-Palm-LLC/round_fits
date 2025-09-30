import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_app/modules/settings/language_page.dart';

import '../../controllers/theme_controller.dart';
import '../../data/app_typography.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String _privacyUrl =
      'https://www.zeepalm.com/app-privacy-policy';
  static const String _termsUrl =
      'https://www.zeepalm.com/app-terms-and-conditions';

  static Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(_normalizeUrl(url));
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static String _normalizeUrl(String url) {
    final String trimmed = url.trim();
    if (trimmed.startsWith('http://') ||
        trimmed.startsWith('https://') ||
        trimmed.contains(':')) {
      return trimmed;
    }
    return 'https://$trimmed';
  }

  void _toggleTheme(bool value, ThemeController themeController) {
    themeController.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void _pickScheme(BuildContext context, ThemeController themeController) async {
    final schemes = FlexScheme.values;
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (ctx) {
        return ListView.separated(
          padding: EdgeInsets.all(12.w),
          itemCount: schemes.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final s = schemes[i];
            final theme = FlexThemeData.light(scheme: s, useMaterial3: true);
            final selected = themeController.scheme == s;
            return ListTile(
              leading: CircleAvatar(backgroundColor: theme.colorScheme.primary),
              title: Text(s.name),
              trailing: selected ? const Icon(Icons.check) : null,
              onTap: () {
                themeController.setScheme(s);
                Navigator.of(ctx).pop();
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final bool isSystemDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
        final bool isDarkEffective =
            themeController.themeMode == ThemeMode.dark ||
            (themeController.themeMode == ThemeMode.system && isSystemDark);
        
        return Scaffold(
          appBar: AppBar(
            title: Text('settings'.tr, style: AppTypography.appBarTitle),
            centerTitle: true,
          ),
          body: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              _TileIn(
                delayMs: 0,
                child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Iconsax.moon),
                title: Text('dark_mode'.tr),
                trailing: Switch(
                  value: isDarkEffective, 
                  onChanged: (value) => _toggleTheme(value, themeController)
                ),
                ),
              ),
              const Divider(height: 1, thickness: 0.25),
              _TileIn(
                delayMs: 60,
                child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Iconsax.brush_4),
                title: Text('color_scheme'.tr),
                subtitle: Text(themeController.scheme.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _pickScheme(context, themeController),
                ),
              ),
              const Divider(height: 1, thickness: 0.25),
              _TileIn(
                delayMs: 120,
                child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Iconsax.language_square),
                title: Text('language'.tr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Get.to(() => const LanguagePage());
                },
                ),
              ),
              const Divider(height: 1, thickness: 0.25),
              _TileIn(
                delayMs: 180,
                child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Iconsax.shield_tick),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openUrl(_privacyUrl),
                ),
              ),
              const Divider(height: 1, thickness: 0.25),
              _TileIn(
                delayMs: 240,
                child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Iconsax.document_text),
                title: const Text('Terms & Conditions'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openUrl(_termsUrl),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TileIn extends StatefulWidget {
  const _TileIn({required this.child, this.delayMs = 0});
  final Widget child;
  final int delayMs;

  @override
  State<_TileIn> createState() => _TileInState();
}

class _TileInState extends State<_TileIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs)).then((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: widget.child,
      ),
    );
  }
}
