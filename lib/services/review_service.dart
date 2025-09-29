import 'dart:math';

import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  ReviewService(this._box);
  final GetStorage _box;
  static const String _keyLastPrompt = 'lastReviewPromptAt';
  static const String _keyPromptCount = 'reviewPromptCount';

  Future<void> maybeRequestReview() async {
    final InAppReview review = InAppReview.instance;
    final bool available = await review.isAvailable();
    if (!available) return;

    final int now = DateTime.now().millisecondsSinceEpoch;
    final int last = _box.read(_keyLastPrompt) ?? 0;
    final int count = _box.read(_keyPromptCount) ?? 0;

    // Minimum 3 days between prompts
    const int minGapMs = 3 * 24 * 60 * 60 * 1000;
    final bool timeOk = now - last > minGapMs;

    // Randomize with 40% chance to reduce frequency
    final bool chanceOk = Random().nextDouble() < 0.4;

    // Cap total prompts to avoid nagging
    if (timeOk && chanceOk && count < 5) {
      await review.requestReview();
      await _box.write(_keyLastPrompt, now);
      await _box.write(_keyPromptCount, count + 1);
    }
  }
}


