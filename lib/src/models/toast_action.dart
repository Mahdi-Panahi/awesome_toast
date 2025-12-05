import 'package:flutter/material.dart';

/// Represents a single action button on a toast.
class ToastAction {
  /// The text to display on the button.
  final String label;

  /// The callback to execute when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a toast action.
  const ToastAction({
    required this.label,
    required this.onPressed,
  });
}
