import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class StatusChip extends StatelessWidget {
  final String text;

  const StatusChip(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final value = text.toLowerCase();

    Color color;

    if (value.contains('đã thanh toán') ||
        value.contains('hoàn thành') ||
        value.contains('hoạt động')) {
      color = AppColors.success;
    } else if (value.contains('đang') ||
        value.contains('một phần') ||
        value.contains('chờ')) {
      color = AppColors.warning;
    } else if (value.contains('quá hạn') ||
        value.contains('chưa thanh toán') ||
        value.contains('vi phạm')) {
      color = AppColors.danger;
    } else if (value.contains('trống')) {
      color = AppColors.primary;
    } else {
      color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}