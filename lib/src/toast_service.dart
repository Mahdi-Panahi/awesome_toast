import 'package:awesome_toast/src/models/toast_action.dart';
import 'package:flutter/material.dart';

import 'models/toast_config.dart';
import 'models/toast_item.dart';
import 'widgets/default_toast.dart';

/// A singleton service for managing and displaying toast notifications globally.
///
/// This service provides methods to show, hide, and manage a queue of toasts.
/// It should be accessed via the `ToastService.instance` getter.
///
/// The service must be initialized by a [ToastProvider] widget in the widget tree.
class ToastService extends ChangeNotifier {
  static ToastService? _instance;
  ToastStackConfig? _config;

  final List<ToastItem> _items = [];
  int _counter = 0;

  ToastService._();

  /// Provides access to the singleton instance of [ToastService].
  static ToastService get instance {
    _instance ??= ToastService._();
    return _instance!;
  }

  /// Initializes the service with a global configuration.
  ///
  /// This is called by [ToastProvider] and should not be called directly.
  void initialize(ToastStackConfig config) {
    _config = config;
  }

  /// The current global toast configuration.
  ToastStackConfig? get config => _config;

  /// A read-only list of the currently active toast items.
  List<ToastItem> get items => List.unmodifiable(_items);

  /// Displays a toast with a custom widget as its content.
  ///
  /// This is the most flexible method for showing toasts.
  ///
  /// - [child]: The widget to display inside the toast.
  /// - [duration]: How long the toast should be visible. If null, it remains
  ///   until dismissed manually.
  /// - [showProgress]: Whether to show a progress indicator for the duration.
  /// - [actions]: A list of [ToastAction] buttons to display on the toast.
  /// - [onDismiss]: A callback triggered when the toast is dismissed.
  /// - [buttonsActionStyle]: Custom text style for the action buttons.
  /// - [progressColor]: Custom color for the progress indicator.
  /// - [progressBackgroundColor]: Custom background color for the progress indicator.
  /// - [progressStrokeWidth]: Custom stroke width for the progress indicator.
  void show({
    required ToastContentBuilder contentBuilder,
    Duration? duration,
    bool? showProgress,
    @Deprecated('Use actions instead') String? actionLabel,
    @Deprecated('Use actions instead') VoidCallback? onAction,
    VoidCallback? onDismiss,
    TextStyle? buttonsActionStyle,
    Color? progressColor,
    Color? progressBackgroundColor,
    double? progressStrokeWidth,
    List<ToastAction>? actions,
  }) {
    final key = 'toast_${_counter++}_${DateTime.now().millisecondsSinceEpoch}';

    final effectiveShowProgress =
        showProgress ?? _config?.showProgressByDefault ?? false;

    final allActions = <ToastAction>[];
    if (actions != null) {
      allActions.addAll(actions);
    }
    if (actionLabel != null && onAction != null) {
      allActions.add(ToastAction(label: actionLabel, onPressed: onAction));
    }

    final item = ToastItem(
      key: key,
      contentBuilder: contentBuilder,
      duration: duration,
      onDismiss: () {
        _removeToast(key);
        onDismiss?.call();
      },
      showProgress: effectiveShowProgress,
      actions: allActions.isNotEmpty ? allActions : null,
      buttonsActionStyle: buttonsActionStyle,
      progressColor: progressColor,
      progressBackgroundColor: progressBackgroundColor,
      progressStrokeWidth: progressStrokeWidth,
    );

    _items.insert(0, item);
    notifyListeners();
  }

  /// Shows a toast using the default styling provided by [DefaultToast].
  ///
  /// This is a convenience method that simplifies showing standard toasts.
  /// If a `toastBuilder` is provided in [ToastStackConfig], it will be used instead.
  void showDefault({
    required String title,
    required String message,
    ToastType type = ToastType.info,
    Duration? duration,
    bool? showProgress,
    @Deprecated('Use actions instead') String? actionLabel,
    @Deprecated('Use actions instead') VoidCallback? onAction,
    VoidCallback? onDismiss,
    TextStyle? buttonsActionStyle,
    Color? progressColor,
    Color? progressBackgroundColor,
    double? progressStrokeWidth,
    List<ToastAction>? actions,
  }) {
    final allActions = <ToastAction>[];
    if (actions != null) {
      allActions.addAll(actions);
    }
    if (actionLabel != null && onAction != null) {
      allActions.add(ToastAction(label: actionLabel, onPressed: onAction));
    }

    show(
      contentBuilder: (context, progress, dismissToast) {
        if (_config?.toastBuilder != null) {
          return _config!.toastBuilder!(
            context,
            title,
            message,
            type,
            progress,
            showProgress,
            dismissToast,
            allActions.isNotEmpty ? allActions : null,
          );
        } else {
          return DefaultToast(
            title: title,
            message: message,
            type: type,
            onDismiss: dismissToast,
            actions: allActions.isNotEmpty ? allActions : null,
          );
        }
      },
      duration: duration,
      showProgress: showProgress,
      onDismiss: onDismiss,
      buttonsActionStyle: buttonsActionStyle,
      progressColor: progressColor,
      progressBackgroundColor: progressBackgroundColor,
      progressStrokeWidth: progressStrokeWidth,
    );
  }

  /// Shows a success-themed toast.
  ///
  /// A shortcut for `showDefault` with `type = ToastType.success`.
  void success(
    String title,
    String message, {
    Duration? duration,
    bool? showProgress,
    @Deprecated('Use actions instead') String? actionLabel,
    @Deprecated('Use actions instead') VoidCallback? onAction,
    VoidCallback? onDismiss,
    bool autoDismiss = true,
    List<ToastAction>? actions,
  }) {
    final allActions = <ToastAction>[];
    if (actions != null) {
      allActions.addAll(actions);
    }
    if (actionLabel != null && onAction != null) {
      allActions.add(ToastAction(label: actionLabel, onPressed: onAction));
    }

    showDefault(
      title: title,
      message: message,
      type: ToastType.success,
      duration: autoDismiss ? (duration ?? _config?.defaultDuration) : null,
      showProgress: showProgress,
      onDismiss: onDismiss,
      actions: allActions.isNotEmpty ? allActions : null,
    );
  }

  /// Shows an error-themed toast.
  ///
  /// A shortcut for `showDefault` with `type = ToastType.error`.
  void error(
    String title,
    String message, {
    Duration? duration,
    bool? showProgress,
    @Deprecated('Use actions instead') String? actionLabel,
    @Deprecated('Use actions instead') VoidCallback? onAction,
    VoidCallback? onDismiss,
    bool autoDismiss = true,
    List<ToastAction>? actions,
  }) {
    final allActions = <ToastAction>[];
    if (actions != null) {
      allActions.addAll(actions);
    }
    if (actionLabel != null && onAction != null) {
      allActions.add(ToastAction(label: actionLabel, onPressed: onAction));
    }

    showDefault(
      title: title,
      message: message,
      type: ToastType.error,
      duration: autoDismiss ? (duration ?? _config?.defaultDuration) : null,
      showProgress: showProgress,
      onDismiss: onDismiss,
      actions: allActions.isNotEmpty ? allActions : null,
    );
  }

  /// Shows a warning-themed toast.
  ///
  /// A shortcut for `showDefault` with `type = ToastType.warning`.
  void warning(
    String title,
    String message, {
    Duration? duration,
    bool? showProgress,
    @Deprecated('Use actions instead') String? actionLabel,
    @Deprecated('Use actions instead') VoidCallback? onAction,
    VoidCallback? onDismiss,
    bool autoDismiss = true,
    List<ToastAction>? actions,
  }) {
    final allActions = <ToastAction>[];
    if (actions != null) {
      allActions.addAll(actions);
    }
    if (actionLabel != null && onAction != null) {
      allActions.add(ToastAction(label: actionLabel, onPressed: onAction));
    }

    showDefault(
      title: title,
      message: message,
      type: ToastType.warning,
      duration: autoDismiss ? (duration ?? _config?.defaultDuration) : null,
      showProgress: showProgress,
      onDismiss: onDismiss,
      actions: allActions.isNotEmpty ? allActions : null,
    );
  }

  /// Shows an info-themed toast.
  ///
  /// A shortcut for `showDefault` with `type = ToastType.info`.
  void info(
    String title,
    String message, {
    Duration? duration,
    bool? showProgress,
    @Deprecated('Use actions instead') String? actionLabel,
    @Deprecated('Use actions instead') VoidCallback? onAction,
    VoidCallback? onDismiss,
    bool autoDismiss = true,
    List<ToastAction>? actions,
  }) {
    final allActions = <ToastAction>[];
    if (actions != null) {
      allActions.addAll(actions);
    }
    if (actionLabel != null && onAction != null) {
      allActions.add(ToastAction(label: actionLabel, onPressed: onAction));
    }

    showDefault(
      title: title,
      message: message,
      type: ToastType.info,
      duration: autoDismiss ? (duration ?? _config?.defaultDuration) : null,
      showProgress: showProgress,
      onDismiss: onDismiss,
      actions: allActions.isNotEmpty ? allActions : null,
    );
  }

  void _removeToast(String key) {
    _items.removeWhere((item) => item.key == key);
    notifyListeners();
  }

  /// Removes all currently visible toasts from the screen.
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// The number of toasts currently on screen.
  int get count => _items.length;

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }
}


