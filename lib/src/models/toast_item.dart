import 'package:awesome_toast/src/models/toast_action.dart';
import 'package:flutter/material.dart';

/// A builder function for creating the content of a toast.
///
/// It provides the [BuildContext] and an optional [ValueNotifier<double>]
/// that can be used to listen to the progress of the toast's duration.
typedef ToastContentBuilder = Widget Function(BuildContext context,
    ValueNotifier<double>? progress, VoidCallback? dismissToast, List<ToastAction>? actions);

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

  /// Optional list of action buttons
  final List<ToastAction>? actions;

  /// Used to externally control the progress of the toast.
  final ValueNotifier<double>? progressNotifier;

  /// Whether this specific toast is dismissable
  final bool? dismissable;

  ToastItem({
    required this.key,
    required this.contentBuilder,
    this.duration,
    this.onDismiss,
    this.actions,
    this.progressNotifier,
    this.dismissable,
  });
}
