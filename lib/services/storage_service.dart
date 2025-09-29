import 'package:get_storage/get_storage.dart';

class StorageKeys {
  static const workSeconds = 'workSeconds';
  static const restSeconds = 'restSeconds';
  static const rounds = 'rounds';
  static const soundEnabled = 'soundEnabled';
  static const vibrateEnabled = 'vibrateEnabled';
}

class StorageService {
  StorageService(this._box);

  final GetStorage _box;

  int readInt(String key, {required int defaultValue}) {
    final value = _box.read(key);
    if (value is int) return value;
    return defaultValue;
  }

  bool readBool(String key, {required bool defaultValue}) {
    final value = _box.read(key);
    if (value is bool) return value;
    return defaultValue;
  }

  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }
}


