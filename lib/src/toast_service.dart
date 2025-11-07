import 'package:flutter/material.dart';

import 'models/toast_config.dart';
import 'models/toast_item.dart';

/// Singleton service for managing toasts globally
class ToastService extends ChangeNotifier {
  static ToastService? _instance;
  ToastStackConfig? _config;

  final List<ToastItem> _items = [];
  int _counter = 0;

  ToastService._();

  /// Get the singleton instance
  static ToastService get instance {
    _instance ??= ToastService._();
    return _instance!;
  }

  /// Initialize with configuration (called by ToastProvider)
  void initialize(ToastStackConfig config) {
    _config = config;
  }

  /// Get current configuration
  ToastStackConfig? get config => _config;

  /// Get list of active toasts
  List<ToastItem> get items => List.unmodifiable(_items);

  /// Show a toast with custom widget
  void show({
    required Widget child,
    Duration? duration,
    bool? showProgress,
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onDismiss,
    TextStyle? actionLabelStyle,
    Color? progressColor,
    Color? progressBackgroundColor,
    double? progressStrokeWidth,
  }) {
    final key = 'toast_${_counter++}_${DateTime.now().millisecondsSinceEpoch}';

    final effectiveShowProgress =
        showProgress ?? _config?.showProgressByDefault ?? false;

    final item = ToastItem(
      key: key,
      child: child,
      duration: duration,
      onDismiss: () {
        _removeToast(key);
        onDismiss?.call();
      },
      showProgress: effectiveShowProgress,
      actionLabel: actionLabel,
      onAction: onAction,
      actionLabelStyle: actionLabelStyle,
      progressColor: progressColor,
      progressBackgroundColor: progressBackgroundColor,
      progressStrokeWidth: progressStrokeWidth,
    );

    _items.insert(0, item);
    notifyListeners();
  }

  /// Show a toast with default styling
  void showDefault({
    required String title,
    required String message,
    ToastType type = ToastType.info,
    Duration? duration,
    bool? showProgress,
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onDismiss,
    TextStyle? actionLabelStyle,
    Color? progressColor,
    Color? progressBackgroundColor,
    double? progressStrokeWidth,
  }) {
    if (_config?.toastBuilder != null) {
      show(
        child: Builder(
          builder: (context) =>
              _config!.toastBuilder!(context, title, message, type),
        ),
        duration: duration,
        showProgress: showProgress,
        actionLabel: actionLabel,
        onAction: onAction,
        onDismiss: onDismiss,
        actionLabelStyle: actionLabelStyle,
        progressColor: progressColor,
        progressBackgroundColor: progressBackgroundColor,
        progressStrokeWidth: progressStrokeWidth,
      );
    } else {
      show(
        child: Builder(
          builder: (context) => _DefaultToastInternal(
            title: title,
            message: message,
            type: type,
            config: _config,
            actionLabel: actionLabel,
          ),
        ),
        duration: duration,
        showProgress: showProgress,
        actionLabel: actionLabel,
        onAction: onAction,
        onDismiss: onDismiss,
        actionLabelStyle: actionLabelStyle,
        progressColor: progressColor,
        progressBackgroundColor: progressBackgroundColor,
        progressStrokeWidth: progressStrokeWidth,
      );
    }
  }

  /// Show success toast
  void success(
    String title,
    String message, {
    Duration? duration,
    bool? showProgress,
    String? actionLabel,
    VoidCallback? onAction,
    bool autoDismiss = true,
  }) {
    showDefault(
      title: title,
      message: message,
      type: ToastType.success,
      duration: autoDismiss ? (duration ?? _config?.defaultDuration) : null,
      showProgress: showProgress,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show error toast
  void error(
    String title,
    String message, {
    Duration? duration,
    bool? showProgress,
    String? actionLabel,
    VoidCallback? onAction,
    bool autoDismiss = true,
  }) {
    showDefault(
      title: title,
      message: message,
      type: ToastType.error,
      duration: autoDismiss ? (duration ?? _config?.defaultDuration) : null,
      showProgress: showProgress,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show warning toast
  void warning(
    String title,
    String message, {
    Duration? duration,
    bool? showProgress,
    String? actionLabel,
    VoidCallback? onAction,
    bool autoDismiss = true,
  }) {
    showDefault(
      title: title,
      message: message,
      type: ToastType.warning,
      duration: autoDismiss ? (duration ?? _config?.defaultDuration) : null,
      showProgress: showProgress,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show info toast
  void info(
    String title,
    String message, {
    Duration? duration,
    bool? showProgress,
    String? actionLabel,
    VoidCallback? onAction,
    bool autoDismiss = true,
  }) {
    showDefault(
      title: title,
      message: message,
      type: ToastType.info,
      duration: autoDismiss ? (duration ?? _config?.defaultDuration) : null,
      showProgress: showProgress,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void _removeToast(String key) {
    _items.removeWhere((item) => item.key == key);
    notifyListeners();
  }

  /// Clear all active toasts
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Get count of active toasts
  int get count => _items.length;

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }
}

// Internal default toast widget
class _DefaultToastInternal extends StatelessWidget {
  final String title;
  final String message;
  final ToastType type;
  final ToastStackConfig? config;
  final String? actionLabel;

  const _DefaultToastInternal({
    required this.title,
    required this.message,
    required this.type,
    this.config,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        backgroundColor = isDark
            ? Colors.green.shade900
            : Colors.green.shade100;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = isDark ? Colors.red.shade900 : Colors.red.shade100;
        icon = Icons.error;
        break;
      case ToastType.warning:
        backgroundColor = isDark
            ? Colors.orange.shade900
            : Colors.orange.shade100;
        icon = Icons.warning;
        break;
      case ToastType.info:
        backgroundColor = isDark ? Colors.blue.shade900 : Colors.blue.shade100;
        icon = Icons.info;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style:
                      config?.titleTextStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: config?.messageStyle ?? const TextStyle(fontSize: 14),
                ),
                if (actionLabel != null) SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
