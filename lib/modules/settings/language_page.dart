import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

import '../home/components/primary_snackbar.dart';

class LanguageOption {
  const LanguageOption({required this.locale, required this.englishLabel, required this.nativeLabel});
  final Locale locale;
  final String englishLabel;
  final String nativeLabel;
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const String _storageKey = 'localeCode';

  List<LanguageOption> get _options => const [
        LanguageOption(locale: Locale('en', 'US'), englishLabel: 'English (US)', nativeLabel: 'English (US)'),
        LanguageOption(locale: Locale('es', 'ES'), englishLabel: 'Spanish (Spain)', nativeLabel: 'Español (España)'),
        LanguageOption(locale: Locale('fr', 'FR'), englishLabel: 'French', nativeLabel: 'Français'),
        LanguageOption(locale: Locale('de', 'DE'), englishLabel: 'German', nativeLabel: 'Deutsch'),
        LanguageOption(locale: Locale('it', 'IT'), englishLabel: 'Italian', nativeLabel: 'Italiano'),
        LanguageOption(locale: Locale('pt', 'PT'), englishLabel: 'Portuguese (Portugal)', nativeLabel: 'Português (Portugal)'),
        LanguageOption(locale: Locale('pt', 'BR'), englishLabel: 'Portuguese (Brazil)', nativeLabel: 'Português (Brasil)'),
        LanguageOption(locale: Locale('ru', 'RU'), englishLabel: 'Russian', nativeLabel: 'Русский'),
        LanguageOption(locale: Locale('ja', 'JP'), englishLabel: 'Japanese', nativeLabel: '日本語'),
        LanguageOption(locale: Locale('ko', 'KR'), englishLabel: 'Korean', nativeLabel: '한국어'),
        LanguageOption(locale: Locale('zh', 'CN'), englishLabel: 'Chinese (Simplified)', nativeLabel: '简体中文'),
        LanguageOption(locale: Locale('zh', 'TW'), englishLabel: 'Chinese (Traditional)', nativeLabel: '繁體中文'),
        LanguageOption(locale: Locale('ar', 'SA'), englishLabel: 'Arabic', nativeLabel: 'العربية'),
        LanguageOption(locale: Locale('hi', 'IN'), englishLabel: 'Hindi', nativeLabel: 'हिन्दी'),
        LanguageOption(locale: Locale('bn', 'BD'), englishLabel: 'Bengali', nativeLabel: 'বাংলা'),
        LanguageOption(locale: Locale('ur', 'PK'), englishLabel: 'Urdu', nativeLabel: 'اردو'),
        LanguageOption(locale: Locale('tr', 'TR'), englishLabel: 'Turkish', nativeLabel: 'Türkçe'),
        LanguageOption(locale: Locale('id', 'ID'), englishLabel: 'Indonesian', nativeLabel: 'Bahasa Indonesia'),
        LanguageOption(locale: Locale('vi', 'VN'), englishLabel: 'Vietnamese', nativeLabel: 'Tiếng Việt'),
        LanguageOption(locale: Locale('th', 'TH'), englishLabel: 'Thai', nativeLabel: 'ไทย'),
        LanguageOption(locale: Locale('pl', 'PL'), englishLabel: 'Polish', nativeLabel: 'Polski'),
        LanguageOption(locale: Locale('nl', 'NL'), englishLabel: 'Dutch', nativeLabel: 'Nederlands'),
        LanguageOption(locale: Locale('sv', 'SE'), englishLabel: 'Swedish', nativeLabel: 'Svenska'),
        LanguageOption(locale: Locale('nb', 'NO'), englishLabel: 'Norwegian', nativeLabel: 'Norsk Bokmål'),
        LanguageOption(locale: Locale('da', 'DK'), englishLabel: 'Danish', nativeLabel: 'Dansk'),
        LanguageOption(locale: Locale('fi', 'FI'), englishLabel: 'Finnish', nativeLabel: 'Suomi'),
        LanguageOption(locale: Locale('el', 'GR'), englishLabel: 'Greek', nativeLabel: 'Ελληνικά'),
        LanguageOption(locale: Locale('cs', 'CZ'), englishLabel: 'Czech', nativeLabel: 'Čeština'),
        LanguageOption(locale: Locale('hu', 'HU'), englishLabel: 'Hungarian', nativeLabel: 'Magyar'),
        LanguageOption(locale: Locale('ro', 'RO'), englishLabel: 'Romanian', nativeLabel: 'Română'),
      ];

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final saved = box.read<String>(_storageKey);
    final current = Get.locale ?? (saved != null ? _parseLocale(saved) : Get.deviceLocale) ?? const Locale('en', 'US');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final item = _options[index];
          final isSelected = item.locale.languageCode == current.languageCode && (item.locale.countryCode ?? '') == (current.countryCode ?? '');
          final country = _countryCodeFor(item.locale);
          return Container(
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12) : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CountryFlag.fromCountryCode(
                      country,
                      height: 36,
                      width: 36,
                    ),
                  ),
                ),
              ),
              title: Text(item.nativeLabel, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(item.englishLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
              trailing: isSelected ? Icon(Iconsax.tick_circle, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () async {
                Get.updateLocale(item.locale);
                await box.write(_storageKey, _encodeLocale(item.locale));
                Get.back();
                showPrimarySnackbar(title: 'OK', message: 'Language updated');
              },
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: _options.length,
      ),
    );
  }

  String _encodeLocale(Locale l) => l.countryCode == null || l.countryCode!.isEmpty ? l.languageCode : '${l.languageCode}_${l.countryCode}';
  Locale _parseLocale(String code) {
    final parts = code.split('_');
    if (parts.length == 2) return Locale(parts[0], parts[1]);
    return Locale(parts[0]);
  }

  String _countryCodeFor(Locale locale) {
    // Use the country code if available; fallback by language
    final cc = (locale.countryCode ?? '').toUpperCase();
    if (cc.isNotEmpty) return cc;
    switch (locale.languageCode) {
      case 'en':
        return 'US';
      case 'es':
        return 'ES';
      case 'fr':
        return 'FR';
      case 'de':
        return 'DE';
      case 'it':
        return 'IT';
      case 'pt':
        return 'PT';
      case 'ru':
        return 'RU';
      case 'ja':
        return 'JP';
      case 'ko':
        return 'KR';
      case 'zh':
        return 'CN';
      case 'ar':
        return 'SA';
      case 'hi':
        return 'IN';
      case 'bn':
        return 'BD';
      case 'ur':
        return 'PK';
      case 'tr':
        return 'TR';
      case 'id':
        return 'ID';
      case 'vi':
        return 'VN';
      case 'th':
        return 'TH';
      case 'pl':
        return 'PL';
      case 'nl':
        return 'NL';
      case 'sv':
        return 'SE';
      case 'nb':
        return 'NO';
      case 'da':
        return 'DK';
      case 'fi':
        return 'FI';
      case 'el':
        return 'GR';
      case 'cs':
        return 'CZ';
      case 'hu':
        return 'HU';
      case 'ro':
        return 'RO';
      default:
        return 'US';
    }
  }
}


