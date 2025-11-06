import 'package:flutter/material.dart';

import '../awesome_toast.dart';

/// Provider widget that manages toast overlay
class ToastProvider extends StatefulWidget {
  final Widget child;
  final ToastStackConfig config;

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
