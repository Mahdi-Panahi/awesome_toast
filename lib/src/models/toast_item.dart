import 'package:awesome_toast/src/models/toast_action.dart';
import 'package:flutter/material.dart';

/// A builder function for creating the content of a toast.
///
/// It provides the [BuildContext] and an optional [ValueNotifier<double>]
/// that can be used to listen to the progress of the toast's duration.
typedef ToastContentBuilder = Widget Function(
    BuildContext context, ValueNotifier<double>? progress, VoidCallback? dismissToast);

/// Types of default toast messages
enum ToastType { success, error, warning, info, none }

/// Individual toast item
class ToastItem {
  /// Unique identifier
  final String key;

  /// Builder for the toast content
  final ToastContentBuilder contentBuilder;

  /// How long toast should remain visible (null = stays until manually dismissed)
  final Duration? duration;

  /// Callback when toast is dismissed
  final VoidCallback? onDismiss;

  /// Whether to show progress indicator
  final bool showProgress;

  /// Optional list of action buttons
  final List<ToastAction>? actions;

  /// Custom text style for the action buttons
  final TextStyle? buttonsActionStyle;

  /// Custom color for the progress indicator
  final Color? progressColor;

  /// Custom background color for the progress indicator
  final Color? progressBackgroundColor;

  /// Custom stroke width for the progress indicator
  final double? progressStrokeWidth;

  /// Used to externally control the progress of the toast.
  final ValueNotifier<double>? progressNotifier;

  ToastItem({
    required this.key,
    required this.contentBuilder,
    this.duration,
    this.onDismiss,
    this.showProgress = false,
    this.actions,
    this.buttonsActionStyle,
    this.progressColor,
    this.progressBackgroundColor,
    this.progressStrokeWidth,
    this.progressNotifier,
  });
}
