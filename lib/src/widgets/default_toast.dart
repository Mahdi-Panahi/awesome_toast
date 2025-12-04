import 'dart:ui';

import 'package:awesome_toast/awesome_toast.dart';
import 'package:flutter/material.dart';

/// Default toast widget
class DefaultToast extends StatelessWidget {
  /// Toast title
  final String title;

  /// Toast message
  final String message;

  /// Toast type
  final ToastType type;

  /// Toast actions
  final List<ToastAction>? actions;

  /// Callback when toast is dismissed
  final VoidCallback? onDismiss;

  /// Background color of the toast
  final Color? backgroundColor;

  /// Icon to be displayed
  final IconData? icon;

  /// Icon color
  final Color? iconColor;

  /// Progress indicator value notifier
  final ValueNotifier<double>? progress;

  /// Show progress indicator
  final bool? showProgress;

  /// Progress indicator color
  final Color? progressColor;

  /// Progress indicator background color
  final Color? progressBackgroundColor;

  /// Progress indicator stroke width
  final double? progressStrokeWidth;

  /// Progress expand type
  final bool? expandProgress;

  /// Border radius of the toast
  final BorderRadiusGeometry? borderRadius;

  /// Blur value
  final double? blur;

  /// Padding of the toast
  final EdgeInsetsGeometry? padding;

  /// Custom text style for the action buttons
  final TextStyle? buttonsActionStyle;

  /// Custom text style for the title
  final TextStyle? titleTextStyle;

  /// Custom text style for the message
  final TextStyle? messageTextStyle;

  const DefaultToast({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.actions,
    this.onDismiss,
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.progress,
    this.showProgress,
    this.progressColor,
    this.progressBackgroundColor,
    this.progressStrokeWidth,
    this.expandProgress,
    this.borderRadius,
    this.blur,
    this.padding,
    this.buttonsActionStyle,
    this.titleTextStyle,
    this.messageTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final config = ToastService.instance.config;
    final double opacity = 0.5;

    Color bgColor;
    IconData toastIcon;

    if (backgroundColor != null) {
      bgColor = backgroundColor!;
    } else {
      switch (type) {
        case ToastType.success:
          bgColor = Colors.green.shade700.withAlpha((opacity * 255).round());
          break;
        case ToastType.error:
          bgColor = Colors.red.shade700.withAlpha((opacity * 255).round());
          break;
        case ToastType.warning:
          bgColor = Colors.orange.shade700.withAlpha((opacity * 255).round());
          break;
        case ToastType.info:
          bgColor = Colors.blue.shade700.withAlpha((opacity * 255).round());
          break;
        case ToastType.none:
          bgColor = Colors.grey.withAlpha((opacity * 100).round());
          break;
      }
    }

    if (icon != null) {
      toastIcon = icon!;
    } else {
      switch (type) {
        case ToastType.success:
          toastIcon = Icons.check_circle_outline_rounded;
          break;
        case ToastType.error:
          toastIcon = Icons.error_outline_rounded;
          break;
        case ToastType.warning:
          toastIcon = Icons.warning_amber_rounded;
          break;
        case ToastType.info:
          toastIcon = Icons.info_outline_rounded;
          break;
        case ToastType.none:
          toastIcon = Icons.sentiment_dissatisfied;
          break;
      }
    }

    final br = borderRadius ?? BorderRadius.circular(16);
    final effectiveShowProgress = showProgress ??
        ToastService.instance.config?.showProgressByDefault ??
        false;
    final effectiveExpandProgress =
        expandProgress ?? config?.expandProgress ?? true;

    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: blur ?? config?.blur ?? 3,
            sigmaY: blur ?? config?.blur ?? 3),
        child: Stack(
          children: [
            if (effectiveShowProgress == true &&
                progress != null &&
                effectiveExpandProgress)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: 0,
                child: ValueListenableBuilder<double>(
                  valueListenable: progress!,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      color: progressColor ?? config?.progressColor,
                      backgroundColor: progressBackgroundColor ??
                          config?.progressBackgroundColor,
                      minHeight:
                          progressStrokeWidth ?? config?.progressStrokeWidth,
                    );
                  },
                ),
              ),
            Positioned(
              right: -40,
              bottom: -25,
              child: Icon(
                toastIcon,
                color: iconColor ?? config?.iconColor ?? Colors.grey,
                size: 130,
              ),
            ),
            Container(
              padding: padding ??
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: br,
                color: bgColor,
                boxShadow: [
                  BoxShadow(
                    color: bgColor,
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(toastIcon,
                      color: iconColor ?? config?.iconColor ?? Colors.white,
                      size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: titleTextStyle ??
                              config?.titleTextStyle ??
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: messageTextStyle ??
                              config?.messageStyle ??
                              TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                        ),
                        if (actions?.isNotEmpty ?? false)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Wrap(
                              runAlignment: WrapAlignment.end,
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              spacing: 8,
                              runSpacing: 8,
                              children: actions!
                                  .map(
                                    (action) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          action.onPressed();
                                          onDismiss?.call();
                                        },
                                        child: Text(
                                          action.label,
                                          style: buttonsActionStyle ??
                                              config?.buttonsActionStyle ??
                                              const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (effectiveShowProgress == true &&
                progress != null &&
                !effectiveExpandProgress)
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ValueListenableBuilder<double>(
                  valueListenable: progress!,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      color: progressColor ?? config?.progressColor,
                      backgroundColor: progressBackgroundColor ??
                          config?.progressBackgroundColor,
                      minHeight:
                          progressStrokeWidth ?? config?.progressStrokeWidth,
                    );
                  },
                ),
              ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
