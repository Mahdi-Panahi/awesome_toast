import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/toast_config.dart';
import '../models/toast_item.dart';
import '../models/toast_position.dart';

/// Notifier for hover state management
class _HoverNotifier extends ChangeNotifier {
  bool _isHovered = false;

  bool get isHovered => _isHovered;

  void setHovered(bool value) {
    if (_isHovered != value) {
      _isHovered = value;
      notifyListeners();
    }
  }
}

/// Main widget that renders the toast stack
class ToastStackWidget extends StatefulWidget {
  final List<ToastItem> items;
  final ToastStackConfig config;

  const ToastStackWidget({
    super.key,
    required this.items,
    required this.config,
  });

  @override
  State<ToastStackWidget> createState() => _ToastStackWidgetState();
}

class _ToastStackWidgetState extends State<ToastStackWidget> {
  final Map<String, GlobalKey<_ToastItemWidgetState>> _itemKeys = {};
  final _HoverNotifier _hoverNotifier = _HoverNotifier();
  final Map<String, bool> _dismissing = {};

  @override
  void initState() {
    super.initState();
    _updateItemKeys();
  }

  @override
  void didUpdateWidget(ToastStackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateItemKeys();
  }

  @override
  void dispose() {
    _hoverNotifier.dispose();
    super.dispose();
  }

  void _updateItemKeys() {
    final oldKeys = Set<String>.from(_itemKeys.keys);
    final newKeys = widget.items.map((item) => item.key).toSet();

    for (final key in oldKeys.difference(newKeys)) {
      _itemKeys.remove(key);
    }

    for (final key in newKeys.difference(oldKeys)) {
      _itemKeys[key] = GlobalKey<_ToastItemWidgetState>();
    }
  }

  void _onHoverChange(bool hovering) {
    _hoverNotifier.setHovered(hovering);
    for (final key in _itemKeys.values) {
      key.currentState?.setTimerPaused(hovering);
    }
  }

  void _dismissItem(String key) {
    if (_dismissing[key] == true) return;
    setState(() => _dismissing[key] = true);

    final item = widget.items.firstWhere((item) => item.key == key);
    item.onDismiss?.call();
  }

  Alignment _getAlignment() {
    switch (widget.config.position) {
      case ToastPosition.topLeft:
        return Alignment.topLeft;
      case ToastPosition.topCenter:
        return Alignment.topCenter;
      case ToastPosition.topRight:
        return Alignment.topRight;
      case ToastPosition.bottomLeft:
        return Alignment.bottomLeft;
      case ToastPosition.bottomCenter:
        return Alignment.bottomCenter;
      case ToastPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }

  bool _isTop() {
    return widget.config.position == ToastPosition.topLeft ||
        widget.config.position == ToastPosition.topCenter ||
        widget.config.position == ToastPosition.topRight;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final calculatedWidth =
        widget.config.width ??
        (screenWidth * 0.9).clamp(
          widget.config.minWidth,
          widget.config.maxWidth,
        );

    return Semantics(
      label: 'Toast notifications',
      container: true,
      liveRegion: true,
      child: Align(
        alignment: _getAlignment(),
        child: Padding(
          padding: widget.config.margin,
          child: MouseRegion(
            onEnter: (_) => _onHoverChange(true),
            onExit: (_) => _onHoverChange(false),
            child: TapRegion(
              onTapInside: (_) => _onHoverChange(true),
              onTapOutside: (_) => _onHoverChange(false),
              child: SizedBox(
                width: calculatedWidth,
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: _ToastStackLayout(
                    items: widget.items,
                    itemKeys: _itemKeys,
                    hoverNotifier: _hoverNotifier,
                    config: widget.config,
                    isTop: _isTop(),
                    onDismiss: _dismissItem,
                    dismissing: _dismissing,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Optimized layout widget using ValueListenableBuilder
class _ToastStackLayout extends StatefulWidget {
  final List<ToastItem> items;
  final Map<String, GlobalKey<_ToastItemWidgetState>> itemKeys;
  final _HoverNotifier hoverNotifier;
  final ToastStackConfig config;
  final bool isTop;
  final Function(String) onDismiss;
  final Map<String, bool> dismissing;

  const _ToastStackLayout({
    required this.items,
    required this.itemKeys,
    required this.hoverNotifier,
    required this.config,
    required this.isTop,
    required this.onDismiss,
    required this.dismissing,
  });

  @override
  State<_ToastStackLayout> createState() => _ToastStackLayoutState();
}

class _ToastStackLayoutState extends State<_ToastStackLayout> {
  final Map<String, double> _itemHeights = {};

  void _onHeightMeasured(String key, double height) {
    if (_itemHeights[key] != height) {
      setState(() {
        _itemHeights[key] = height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: widget.hoverNotifier,
      builder: (context, _) {
        final isStacked =
            widget.items.length > widget.config.stackThreshold &&
            !widget.hoverNotifier.isHovered;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: isStacked ? 1 : 0),
          duration: widget.config.stackDuration,
          curve: widget.config.curve,
          builder: (context, stackProgress, child) {
            final totalHeight = isStacked ? 100.0 : _calculateTotalHeight();

            return SizedBox(
              height: totalHeight,
              child: Stack(
                alignment: Alignment.topLeft,
                clipBehavior: Clip.none,
                children: [
                  for (int i = widget.items.length - 1; i >= 0; i--)
                    _buildItem(
                      context,
                      widget.items[i],
                      i,
                      stackProgress,
                      isStacked,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  double _calculateTotalHeight() {
    double total = 0;
    for (var item in widget.items) {
      total += (_itemHeights[item.key] ?? 80.0) + 8;
    }
    return total > 0 ? total : 100;
  }

  Widget _buildItem(
    BuildContext context,
    ToastItem item,
    int index,
    double stackProgress,
    bool isStacked,
  ) {
    final isDismissing = widget.dismissing[item.key] == true;
    final isVisible = !isStacked || index < 3;

    double scale = 1.0;
    double opacity = 1.0;
    bool showBlur = false;
    double positionOffset = 0;

    if (isStacked && !isDismissing) {
      if (index == 0) {
        scale = 1.0;
        opacity = 1.0;
        positionOffset = 0;
      } else if (index == 1) {
        scale = 1.0 - (0.05 * stackProgress);
        showBlur = true;
        opacity = 0.5;
        positionOffset = widget.config.stackOffset * stackProgress;
      } else if (index == 2) {
        scale = 1.0 - (0.1 * stackProgress);
        showBlur = true;
        opacity = 0.3;
        positionOffset = widget.config.stackOffset * 2 * stackProgress;
      } else {
        scale = 1.0 - (0.1 * stackProgress);
        showBlur = true;
        opacity = 0.0;
        positionOffset = widget.config.stackOffset * 2 * stackProgress;
      }
    } else {
      opacity = 1.0;
      positionOffset = _calculateExpandedOffset(index);
    }

    return AnimatedPositioned(
      key: ValueKey('positioned_${item.key}'),
      duration: widget.config.expandDuration,
      curve: widget.config.curve,
      top: widget.isTop ? positionOffset : null,
      bottom: widget.isTop ? null : positionOffset,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: isVisible ? 1 : 0,
        child: AnimatedOpacity(
          duration: widget.config.expandDuration,
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            alignment: widget.isTop
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (context, constraints) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final RenderBox? box =
                      context.findRenderObject() as RenderBox?;
                  if (box != null && box.hasSize) {
                    _onHeightMeasured(item.key, box.size.height);
                  }
                });

                return _ToastItemWidget(
                  key: widget.itemKeys[item.key],
                  item: item,
                  config: widget.config,
                  onDismiss: () => widget.onDismiss(item.key),
                  showBlur: showBlur,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double _calculateExpandedOffset(int index) {
    if (index == 0) return 0;

    double totalOffset = 0;
    for (int i = 0; i < index; i++) {
      final itemKey = widget.items[i].key;
      totalOffset += (_itemHeights[itemKey] ?? 80.0) + 8;
    }

    return totalOffset;
  }
}

/// Optimized toast item widget
class _ToastItemWidget extends StatefulWidget {
  final ToastItem item;
  final ToastStackConfig config;
  final VoidCallback onDismiss;
  final bool showBlur;

  const _ToastItemWidget({
    super.key,
    required this.item,
    required this.config,
    required this.onDismiss,
    required this.showBlur,
  });

  @override
  State<_ToastItemWidget> createState() => _ToastItemWidgetState();
}

class _ToastItemWidgetState extends State<_ToastItemWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _progressController;

  final ValueNotifier<double> _dragOffsetNotifier = ValueNotifier(0);
  bool _isDragging = false;
  bool _isTimerPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _slideAnimation = Tween<Offset>(begin: _getEntryOffset(), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart),
        );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.5)),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: widget.item.duration,
    );

    if (widget.item.duration != null) {
      _progressController.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted && !_isTimerPaused) {
          _dismiss();
        }
      });
    }

    _controller.forward();
    _startTimer();
  }

  Offset _getEntryOffset() {
    switch (widget.config.position) {
      case ToastPosition.topLeft:
      case ToastPosition.bottomLeft:
        return const Offset(-1, 0);
      case ToastPosition.topCenter:
        return const Offset(0, -1);
      case ToastPosition.bottomCenter:
        return const Offset(0, 1);
      case ToastPosition.topRight:
      case ToastPosition.bottomRight:
        return const Offset(1, 0);
    }
  }

  void _startTimer() {
    if (widget.item.duration != null && !_isTimerPaused) {
      _progressController.forward();
    }
  }

  void setTimerPaused(bool paused) {
    if (_isTimerPaused != paused) {
      _isTimerPaused = paused;
      if (widget.item.duration != null) {
        if (paused) {
          _progressController.stop();
        } else {
          _progressController.forward();
        }
      }
    }
  }

  void _dismiss() async {
    await _controller.reverse();
    if (mounted) {
      widget.onDismiss();
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragOffsetNotifier.value += details.delta.dx;
    if (!_isDragging) {
      _isDragging = true;
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final width = context.size?.width ?? 320;
    if (_dragOffsetNotifier.value.abs() > width * 0.4) {
      _dismiss();
    } else {
      _dragOffsetNotifier.value = 0;
      _isDragging = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressController.dispose();
    _dragOffsetNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Toast notification',
      button: true,
      onDismiss: _dismiss,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ValueListenableBuilder<double>(
            valueListenable: _dragOffsetNotifier,
            builder: (context, dragOffset, child) {
              final opacity = _getDragOpacity(dragOffset);

              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(dragOffset, 0),
                  child: GestureDetector(
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    child: _buildContent(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _getDragOpacity(double dragOffset) {
    if (!_isDragging || dragOffset == 0) return 1.0;

    final estimatedWidth = widget.config.width ?? 340.0;
    final dragProgress = (dragOffset.abs() / estimatedWidth).clamp(0.0, 1.0);
    return 1.0 - dragProgress;
  }

  Widget _buildContent() {
    Widget content = Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: Alignment.topLeft,
            clipBehavior: Clip.none,
            children: [
              widget.item.child,

              // if(widget.item.actionLabel != null)
              //   Container(
              //     width: 100,
              //     height: 200,
              //     color: Colors.red,
              //   ),
              if (widget.item.showProgress && widget.item.duration != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressController.value,
                        color:
                            widget.item.progressColor ??
                            widget.config.progressColor,
                        backgroundColor:
                            widget.item.progressBackgroundColor ??
                            widget.config.progressBackgroundColor,
                        minHeight:
                            widget.item.progressStrokeWidth ??
                            widget.config.progressStrokeWidth,
                      );
                    },
                  ),
                ),
              if (widget.item.actionLabel != null)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: TextButton(
                    onPressed: () {
                      if (widget.item.onAction != null) {
                        widget.item.onAction!();
                      }
                      _dismiss();
                    },
                    child: Text(
                      widget.item.actionLabel!,
                      style:
                          widget.item.actionLabelStyle ??
                          widget.config.actionLabelStyle,
                    ),
                  ),
                ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: _dismiss,
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
      ),
    );

    if (widget.showBlur) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: content,
        ),
      );
    }

    return content;
  }
}
