import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AnalyticsUserCounter {
  static const _kFirstOpenFlagPrefix = 'auc_first_open_sent_';
  static Future<void> initialize({required String appKey}) async {
    try {
      await Firebase.initializeApp();
    } catch (_) {}
    final analytics = FirebaseAnalytics.instance;
    final box = GetStorage();
    final package = await PackageInfo.fromPlatform();
    // ---- Get stable Device ID ----
    final deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      deviceId = android.id; // Android hardware ID (may reset on factory reset)
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      deviceId = ios.identifierForVendor; // Unique per vendor per device
    } else {
      deviceId = 'unknown_device';
    }
    // Tag analytics user with deviceId and app key
    await analytics.setUserId(id: deviceId);
    await analytics.setUserProperty(name: 'app_key', value: appKey);
    // ---- Log once per install (proxy for total users) ----
    final firstOpenFlagKey = '$_kFirstOpenFlagPrefix$appKey';
    final alreadySent = box.read<bool>(firstOpenFlagKey) ?? false;
    if (!alreadySent) {
      await analytics.logEvent(
        name: 'fitrounds_workout_app_first_open',
        parameters: {
          'app_key': appKey,
          'device_id': deviceId ?? 'unknown_device',
          'platform': Platform.operatingSystem,
          'app_version': package.version,
        },
      );
      await box.write(firstOpenFlagKey, true);
    }
    // ---- Log every launch ----
    await analytics.logEvent(
      name: 'app_open_custom',
      parameters: {
        'app_key': appKey,
        'device_id': deviceId ?? 'unknown_device',
        'platform': Platform.operatingSystem,
        'app_version': package.version,
      },
    );
  }
}