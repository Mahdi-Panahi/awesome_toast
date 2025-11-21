import 'dart:ui';

import 'package:awesome_toast/awesome_toast.dart';
import 'package:awesome_toast/src/toast_service.dart';
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

  /// Border radius of the toast
  final BorderRadiusGeometry? borderRadius;

  /// Padding of the toast
  final EdgeInsetsGeometry? padding;

  const DefaultToast({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.actions,
    this.onDismiss,
    this.backgroundColor,
    this.icon,
    this.progress,
    this.showProgress,
    this.progressColor,
    this.progressBackgroundColor,
    this.progressStrokeWidth,
    this.borderRadius,
    this.padding,
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
          bgColor = Colors.green.shade700.withValues(alpha: opacity);
          break;
        case ToastType.error:
          bgColor = Colors.red.shade700.withValues(alpha: opacity);
          break;
        case ToastType.warning:
          bgColor = Colors.orange.shade700.withValues(alpha: opacity);
          break;
        case ToastType.info:
          bgColor = Colors.blue.shade700.withValues(alpha: opacity);
          break;
        case ToastType.none:
          bgColor = Colors.grey.withValues(alpha: opacity);
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

    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              bottom: -25,
              child: Icon(
                toastIcon,
                color: Colors.grey,
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
                  Icon(toastIcon, color: Colors.white, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: config?.titleTextStyle ??
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: config?.messageStyle ??
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
                                          style: config?.buttonsActionStyle ??
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
            if (showProgress == true && progress != null)
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
                          config?.progressBackgroundColor
                              ?.withValues(alpha: 0.5),
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
