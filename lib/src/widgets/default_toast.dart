import 'package:flutter/material.dart';

import '../models/toast_item.dart';
import '../toast_service.dart';

/// Default toast widget with customizable styling
class DefaultToast extends StatelessWidget {
  final String title;
  final String message;
  final ToastType type;
  final Color? backgroundColor;
  final IconData? icon;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final bool hasActionLabel;

  const DefaultToast({
    super.key,
    required this.title,
    required this.message,
    this.type = ToastType.info,
    this.backgroundColor,
    this.icon,
    this.titleStyle,
    this.messageStyle,
    this.padding,
    this.borderRadius,
    this.hasActionLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color effectiveBackgroundColor;
    IconData effectiveIcon;

    if (backgroundColor != null && icon != null) {
      effectiveBackgroundColor = backgroundColor!;
      effectiveIcon = icon!;
    } else {
      switch (type) {
        case ToastType.success:
          effectiveBackgroundColor =
              backgroundColor ??
              (isDark ? Colors.green.shade900 : Colors.green.shade100);
          effectiveIcon = icon ?? Icons.check_circle;
          break;
        case ToastType.error:
          effectiveBackgroundColor =
              backgroundColor ??
              (isDark ? Colors.red.shade900 : Colors.red.shade100);
          effectiveIcon = icon ?? Icons.error;
          break;
        case ToastType.warning:
          effectiveBackgroundColor =
              backgroundColor ??
              (isDark ? Colors.orange.shade900 : Colors.orange.shade100);
          effectiveIcon = icon ?? Icons.warning;
          break;
        case ToastType.info:
          effectiveBackgroundColor =
              backgroundColor ??
              (isDark ? Colors.blue.shade900 : Colors.blue.shade100);
          effectiveIcon = icon ?? Icons.info;
          break;
      }
    }

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(effectiveIcon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style:
                      titleStyle ??
                      ToastService.instance.config?.titleTextStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style:
                      messageStyle ??
                      ToastService.instance.config?.messageStyle ??
                      const TextStyle(fontSize: 14),
                ),
                if (hasActionLabel) SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
