import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../services/storage_service.dart';

enum Phase { work, rest, complete }

class TimerController extends GetxController with GetTickerProviderStateMixin {
  TimerController(this._storage);

  final StorageService _storage;

  final RxInt workSeconds = 30.obs;
  final RxInt restSeconds = 15.obs;
  final RxInt rounds = 8.obs;

  final Rx<Phase> phase = Phase.work.obs;
  final RxInt secondsLeft = 0.obs;
  final RxInt currentRound = 1.obs;
  final RxBool isRunning = false.obs;

  Timer? _timer;

  late final AnimationController ringController;
  late final AnimationController numberScaleController;

  bool soundEnabled = true;
  bool vibrateEnabled = true;

  @override
  void onInit() {
    super.onInit();
    workSeconds.value = _storage.readInt(StorageKeys.workSeconds, defaultValue: 30);
    restSeconds.value = _storage.readInt(StorageKeys.restSeconds, defaultValue: 15);
    rounds.value = _storage.readInt(StorageKeys.rounds, defaultValue: 8);
    soundEnabled = _storage.readBool(StorageKeys.soundEnabled, defaultValue: true);
    vibrateEnabled = _storage.readBool(StorageKeys.vibrateEnabled, defaultValue: true);

    ringController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    numberScaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    secondsLeft.value = workSeconds.value;
  }

  @override
  void onClose() {
    _timer?.cancel();
    ringController.dispose();
    numberScaleController.dispose();
    super.onClose();
  }

  void updateSettings({int? work, int? rest, int? totalRounds}) {
    if (work != null) {
      workSeconds.value = work;
      _storage.write(StorageKeys.workSeconds, work);
    }
    if (rest != null) {
      restSeconds.value = rest;
      _storage.write(StorageKeys.restSeconds, rest);
    }
    if (totalRounds != null) {
      rounds.value = totalRounds;
      _storage.write(StorageKeys.rounds, totalRounds);
    }
  }

  Future<void> setSound(bool enabled) async {
    soundEnabled = enabled;
    await _storage.write(StorageKeys.soundEnabled, enabled);
  }

  Future<void> setVibrate(bool enabled) async {
    vibrateEnabled = enabled;
    await _storage.write(StorageKeys.vibrateEnabled, enabled);
  }

  void start() {
    if (isRunning.value) return;
    currentRound.value = 1;
    phase.value = Phase.work;
    secondsLeft.value = workSeconds.value;
    _startTicker();
  }

  void _startTicker() {
    isRunning.value = true;
    WakelockPlus.enable();
    _timer?.cancel();
    ringController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
        numberScaleController.forward(from: 0);
      } else {
        _nextPhase();
      }
    });
  }

  void pause() {
    if (!isRunning.value) return;
    _timer?.cancel();
    isRunning.value = false;
    ringController.stop();
    WakelockPlus.disable();
  }

  void resume() {
    if (isRunning.value) return;
    _startTicker();
  }

  void skip() {
    _nextPhase(forceSkip: true);
  }

  void stop() {
    _timer?.cancel();
    isRunning.value = false;
    ringController.stop();
    WakelockPlus.disable();
    phase.value = Phase.work;
    secondsLeft.value = workSeconds.value;
    currentRound.value = 1;
  }

  Future<void> _haptic() async {
    if (!vibrateEnabled) return;
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator) {
      Vibration.vibrate(duration: 120);
    }
  }

  void _nextPhase({bool forceSkip = false}) {
    _haptic();
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    if (phase.value == Phase.work) {
      if (forceSkip) {
        // Skip to rest end and then into next round
        _enterRest();
        secondsLeft.value = 0;
      } else {
        _enterRest();
      }
    } else if (phase.value == Phase.rest) {
      if (currentRound.value >= rounds.value) {
        _complete();
      } else {
        currentRound.value++;
        _enterWork();
      }
    }
  }

  void _enterWork() {
    phase.value = Phase.work;
    secondsLeft.value = workSeconds.value;
  }

  void _enterRest() {
    phase.value = Phase.rest;
    secondsLeft.value = restSeconds.value;
  }

  void _complete() {
    phase.value = Phase.complete;
    _timer?.cancel();
    ringController.stop();
    isRunning.value = false;
    WakelockPlus.disable();
  }

  Duration get totalDuration =>
      Duration(seconds: (workSeconds.value + restSeconds.value) * rounds.value);
}


