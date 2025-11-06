import 'package:flutter/material.dart';

/// Types of default toast messages
enum ToastType { success, error, warning, info }

/// Individual toast item
class ToastItem {
  /// Unique identifier
  final String key;

  /// Toast content widget
  final Widget child;

  /// How long toast should remain visible (null = stays until manually dismissed)
  final Duration? duration;

  /// Callback when toast is dismissed
  final VoidCallback? onDismiss;

  /// Whether to show progress indicator
  final bool showProgress;

  /// Optional action button label
  final String? actionLabel;

  /// Action button callback
  final VoidCallback? onAction;

  /// Custom text style for the action button
  final TextStyle? actionLabelStyle;

  /// Custom color for the progress indicator
  final Color? progressColor;

  /// Custom background color for the progress indicator
  final Color? progressBackgroundColor;

  /// Custom stroke width for the progress indicator
  final double? progressStrokeWidth;

  ToastItem({
    required this.key,
    required this.child,
    this.duration,
    this.onDismiss,
    this.showProgress = false,
    this.actionLabel,
    this.onAction,
    this.actionLabelStyle,
    this.progressColor,
    this.progressBackgroundColor,
    this.progressStrokeWidth,
  });
}
