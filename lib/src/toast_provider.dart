import 'package:flutter/material.dart';

import '../awesome_toast.dart';

/// A provider widget that sets up the toast notification system for its descendants.
///
/// This widget should be placed high in the widget tree, typically above `MaterialApp`
/// or `CupertinoApp`, so that toasts can be displayed on top of all other content.
///
/// It initializes the [ToastService] with a given [ToastStackConfig] and provides
/// the overlay for displaying toasts.
///
/// Example:
/// ```dart
/// ToastProvider(
///   config: ToastStackConfig(position: ToastPosition.topCenter),
///   child: MaterialApp(
///     home: MyApp(),
///   ),
/// )
/// ```
class ToastProvider extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// This is typically your main application widget, like `MaterialApp`.
  final Widget child;

  /// The global configuration for all toasts shown via this provider.
  ///
  /// This configuration can be overridden for individual toasts.
  final ToastStackConfig config;

  /// Creates a toast provider.
  ///
  /// The [child] parameter is required and is the root of your application.
  /// The [config] parameter allows you to customize the default toast behavior.
  const ToastProvider({
    super.key,
    required this.child,
    this.config = const ToastStackConfig(),
  });

  @override
  State<ToastProvider> createState() => _ToastProviderState();
}

class _ToastProviderState extends State<ToastProvider> {
  late ToastService _toastService;

  @override
  void initState() {
    super.initState();
    _toastService = ToastService.instance;
    _toastService.initialize(widget.config);
  }

  @override
  void didUpdateWidget(ToastProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != oldWidget.config) {
      _toastService.initialize(widget.config);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      fit: StackFit.expand,
      children: [
        widget.child,
        Positioned.fill(
          child: _ToastOverlay(
            toastService: _toastService,
            config: widget.config,
          ),
        ),
      ],
    );
  }
}

/// Internal overlay widget for rendering toasts
class _ToastOverlay extends StatelessWidget {
  final ToastService toastService;
  final ToastStackConfig config;

  const _ToastOverlay({required this.toastService, required this.config});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ListenableBuilder(
        listenable: toastService,
        builder: (context, _) {
          return ToastStackWidget(items: toastService.items, config: config);
        },
      ),
    );
  }
}
