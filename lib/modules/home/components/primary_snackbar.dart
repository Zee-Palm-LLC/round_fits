import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

void showPrimarySnackbar({required String title, required String message, IconData icon = Iconsax.tick_circle}) {
  final theme = Get.theme;
  final primary = theme.colorScheme.primary;
  final secondary = theme.colorScheme.secondary;

  Get.showSnackbar(GetSnackBar(
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(12),
    borderRadius: 14,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    duration: const Duration(seconds: 2),
    messageText: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary.withValues(alpha: 0.9), secondary.withValues(alpha: 0.9)]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: primary.withValues(alpha: 0.3), blurRadius: 16, spreadRadius: 1),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(message, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    ),
  ));
}


