import 'package:awesome_toast/awesome_toast.dart';
import 'package:flutter/material.dart';

/// A default toast widget that provides a standard layout with an icon, title, and message.
///
/// This widget is used by [ToastService.showDefault] and can also be used directly
/// with [ToastService.show] for custom toast content. It offers extensive

/// customization options for colors, styles, and layout.
///
/// When used, it automatically adapts its colors to the current theme (light/dark)
/// based on the [type], but all properties can be overridden.
class DefaultToast extends StatelessWidget {
  /// The main title of the toast.
  final String title;

  /// The detailed message of the toast.
  final String message;

  /// The type of toast, which determines the default icon and background color.
  ///
  /// Defaults to [ToastType.info].
  final ToastType type;

  /// Overrides the default background color.
  final Color? backgroundColor;

  /// Overrides the default icon.
  final IconData? icon;

  /// Custom text style for the title.
  ///
  /// If null, it falls back to [ToastStackConfig.titleTextStyle].
  final TextStyle? titleStyle;

  /// Custom text style for the message.
  ///
  /// If null, it falls back to [ToastStackConfig.messageStyle].
  final TextStyle? messageStyle;

  /// The padding around the toast content.
  final EdgeInsets? padding;

  /// The border radius of the toast container.
  final BorderRadius? borderRadius;

  /// Callback when the toast is dismissed.
  final VoidCallback? onDismiss;

  /// A list of [ToastAction] buttons to display on the toast.
  final List<ToastAction>? actions;

  /// Creates a default toast widget.
  ///
  /// The [title] and [message] are required. Other parameters are optional
  /// and allow for detailed customization.
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
    this.onDismiss,
    this.actions,
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
          effectiveBackgroundColor = backgroundColor ??
              (isDark ? Colors.green.shade900 : Colors.green.shade100);
          effectiveIcon = icon ?? Icons.check_circle;
          break;
        case ToastType.error:
          effectiveBackgroundColor = backgroundColor ??
              (isDark ? Colors.red.shade900 : Colors.red.shade100);
          effectiveIcon = icon ?? Icons.error;
          break;
        case ToastType.warning:
          effectiveBackgroundColor = backgroundColor ??
              (isDark ? Colors.orange.shade900 : Colors.orange.shade100);
          effectiveIcon = icon ?? Icons.warning;
          break;
        case ToastType.info:
          effectiveBackgroundColor = backgroundColor ??
              (isDark ? Colors.blue.shade900 : Colors.blue.shade100);
          effectiveIcon = icon ?? Icons.info;
          break;
        case ToastType.none:
          effectiveBackgroundColor =
              backgroundColor ?? (isDark ? Colors.white70 : Colors.black87);
          effectiveIcon = icon ?? Icons.sentiment_dissatisfied;
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
                  style: titleStyle ??
                      ToastService.instance.config?.titleTextStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: messageStyle ??
                      ToastService.instance.config?.messageStyle ??
                      const TextStyle(fontSize: 14),
                ),
                if (actions?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!
                        .map(
                          (action) => TextButton(
                            onPressed: () {
                              action.onPressed();
                              onDismiss?.call();
                            },
                            child: Text(
                              action.label,
                              style: ToastService
                                  .instance.config?.buttonsActionStyle,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
