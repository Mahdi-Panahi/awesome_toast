import 'package:awesome_toast/src/models/toast_action.dart';
import 'package:flutter/material.dart';

import '../models/toast_item.dart';
import 'toast_position.dart';

/// Global configuration for the toast stack
class ToastStackConfig {
  /// Position of toast stack on screen
  final ToastPosition position;

  /// Number of toasts before stacking begins
  final int stackThreshold;

  /// Duration for stack collapse/expand animation
  final Duration stackDuration;

  /// Duration for individual toast expand animation
  final Duration expandDuration;

  /// Duration toasts remain visible (can be overridden per toast)
  final Duration defaultDuration;

  /// Animation curve for stack animations
  final Curve curve;

  /// Offset between stacked items in pixels
  final double stackOffset;

  /// Scale factor for stacked items (0.0 - 1.0)
  final double stackScale;

  /// Width of toast container (null for responsive width)
  final double? width;

  /// Minimum width for responsive toasts
  final double minWidth;

  /// Maximum width for responsive toasts
  final double maxWidth;

  /// Margin around toast stack
  final EdgeInsets margin;

  /// Whether to show progress indicator by default
  final bool showProgressByDefault;

  /// Custom toast builder (if null, uses DefaultToast)
  final Widget Function(
    BuildContext context,
    String title,
    String message,
    ToastType type,
    ValueNotifier<double>? progress,
    VoidCallback? dismissToast,
    List<ToastAction>? actions,
  )? toastBuilder;

  /// Default title text style
  final TextStyle? titleTextStyle;

  /// Default message text style
  final TextStyle? messageStyle;

  /// Default action buttons text style
  final TextStyle? buttonsActionStyle;

  /// Default progress indicator color
  final Color? progressColor;

  /// Default progress indicator background color
  final Color? progressBackgroundColor;

  /// Default progress indicator stroke width
  final double? progressStrokeWidth;

  /// Default icon color
  final Color? iconColor;

  /// Whether the progress bar should expand to fill the background
  final bool? expandProgress;

  /// Blur intensity for the glass effect
  final double? blur;

  const ToastStackConfig({
    this.position = ToastPosition.topCenter,
    this.stackThreshold = 3,
    this.stackDuration = const Duration(milliseconds: 300),
    this.expandDuration = const Duration(milliseconds: 200),
    this.defaultDuration = const Duration(seconds: 5),
    this.curve = Curves.easeInOutQuart,
    this.stackOffset = 8.0,
    this.stackScale = 0.95,
    this.width,
    this.minWidth = 280,
    this.maxWidth = 420,
    this.margin = const EdgeInsets.all(16),
    this.showProgressByDefault = false,
    this.toastBuilder,
    this.titleTextStyle,
    this.messageStyle,
    this.buttonsActionStyle,
    this.progressColor,
    this.progressBackgroundColor = Colors.white10,
    this.progressStrokeWidth = 4,
    this.iconColor = Colors.white,
    this.expandProgress = true,
    this.blur = 3,
  })  : assert(stackThreshold > 0, 'stackThreshold must be greater than 0'),
        assert(stackOffset >= 0, 'stackOffset must be non-negative'),
        assert(
          stackScale > 0 && stackScale <= 1,
          'stackScale must be between 0 and 1',
        ),
        assert(width == null || width > 0, 'width must be positive or null'),
        assert(minWidth > 0, 'minWidth must be positive'),
        assert(maxWidth >= minWidth, 'maxWidth must be >= minWidth');

  /// Create a copy with modified values
  ToastStackConfig copyWith({
    ToastPosition? position,
    int? stackThreshold,
    Duration? stackDuration,
    Duration? expandDuration,
    Duration? defaultDuration,
    Curve? curve,
    double? stackOffset,
    double? stackScale,
    double? width,
    double? minWidth,
    double? maxWidth,
    EdgeInsets? margin,
    bool? showProgressByDefault,
    Widget Function(
      BuildContext context,
      String title,
      String message,
      ToastType type,
      ValueNotifier<double>? progress,
      VoidCallback? dismissToast,
      List<ToastAction>? actions,
    )? toastBuilder,
    TextStyle? titleTextStyle,
    TextStyle? messageStyle,
    TextStyle? buttonsActionStyle,
    Color? progressColor,
    Color? progressBackgroundColor,
    double? progressStrokeWidth,
    Color? iconColor,
    bool? expandProgress,
    double? blur,
  }) {
    return ToastStackConfig(
      position: position ?? this.position,
      stackThreshold: stackThreshold ?? this.stackThreshold,
      stackDuration: stackDuration ?? this.stackDuration,
      expandDuration: expandDuration ?? this.expandDuration,
      defaultDuration: defaultDuration ?? this.defaultDuration,
      curve: curve ?? this.curve,
      stackOffset: stackOffset ?? this.stackOffset,
      stackScale: stackScale ?? this.stackScale,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      margin: margin ?? this.margin,
      showProgressByDefault:
          showProgressByDefault ?? this.showProgressByDefault,
      toastBuilder: toastBuilder ?? this.toastBuilder,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      messageStyle: messageStyle ?? this.messageStyle,
      buttonsActionStyle: buttonsActionStyle ?? this.buttonsActionStyle,
      progressColor: progressColor ?? this.progressColor,
      progressBackgroundColor:
          progressBackgroundColor ?? this.progressBackgroundColor,
      progressStrokeWidth: progressStrokeWidth ?? this.progressStrokeWidth,
      iconColor: iconColor ?? this.iconColor,
      expandProgress: expandProgress ?? this.expandProgress,
      blur: blur ?? this.blur,
    );
  }
}
