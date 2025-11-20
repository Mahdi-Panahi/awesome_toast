import 'dart:ui';

import 'package:awesome_toast/awesome_toast.dart';
import 'package:flutter/material.dart';

// ============================================================================
// EXAMPLE APP
// ============================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastProvider(
      config: ToastStackConfig(
        position: ToastPosition.topCenter,
        stackThreshold: 3,
        width: null,
        defaultDuration: Duration(seconds: 5),
        showProgressByDefault: false,
        curve: Curves.easeInOutQuart,
        maxWidth: 340,
        titleTextStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        messageStyle: const TextStyle(fontSize: 14, color: Colors.black),
        buttonsActionStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
        progressColor: Colors.blue,
        progressBackgroundColor: Colors.grey,
        progressStrokeWidth: 2,
        toastBuilder: (context, title, message, type, progress, showProgress,
            dismissToast, actions) {
          Color bgColor;
          IconData icon;
          final double opacity = 0.5;

          switch (type) {
            case ToastType.success:
              bgColor = Colors.green.shade700.withValues(alpha: opacity);
              icon = Icons.check_circle_outline_rounded;
              break;
            case ToastType.error:
              bgColor = Colors.red.shade700.withValues(alpha: opacity);
              icon = Icons.error_outline_rounded;
              break;
            case ToastType.warning:
              bgColor = Colors.orange.shade700.withValues(alpha: opacity);
              icon = Icons.warning_amber_rounded;
              break;
            case ToastType.info:
              bgColor = Colors.blue.shade700.withValues(alpha: opacity);
              icon = Icons.info_outline_rounded;
              break;
            case ToastType.none:
              bgColor = Colors.black.withValues(alpha: opacity);
              icon = Icons.sentiment_dissatisfied;
              break;
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    bottom: -25,
                    child: Icon(
                      icon,
                      color: Colors.grey,
                      size: 130,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: bgColor,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: Colors.white, size: 28),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                message,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                ),
                              ),
                              if (actions?.isNotEmpty ?? false)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Wrap(
                                    runAlignment: WrapAlignment.end,
                                    alignment: WrapAlignment.end,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.end,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: actions!
                                        .map(
                                          (action) => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                action.onPressed();
                                                dismissToast?.call();
                                              },
                                              child: Text(
                                                action.label,
                                                style: TextStyle(
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
                        valueListenable: progress,
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            color: ToastService.instance.config?.progressColor,
                            backgroundColor: ToastService
                                .instance.config?.progressBackgroundColor
                                ?.withValues(alpha: 0.5),
                            minHeight: 4,
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
                      onPressed: dismissToast,
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
        },
      ),
      child: MaterialApp(
        title: 'Awesome Toast Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: DemoScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  bool _isDark = false;
  int _counter = 0;

  void _showRandomToast() {
    final types = [
      () => ToastService.instance.success(
            'Success',
            'Operation completed successfully!',
          ),
      () => ToastService.instance.error(
            'Error',
            'Something went wrong. Please try again.',
          ),
      () => ToastService.instance.warning(
            'Warning',
            'Please review your information carefully.',
          ),
      () => ToastService.instance.info(
            'Info',
            'Here is some useful information for you.',
          ),
    ];

    types[_counter % types.length]();
    _counter++;
  }

  void _showMultipleToasts(int count) {
    for (int i = 0; i < count; i++) {
      Future.delayed(Duration(milliseconds: i * 200), _showRandomToast);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Optimized Toast Stack Demo'),
          actions: [
            IconButton(
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() => _isDark = !_isDark),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection('Quick Actions', [
                ElevatedButton.icon(
                  onPressed: _showRandomToast,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Single Toast'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showMultipleToasts(3),
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Add 3 Toasts'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showMultipleToasts(5),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add 5 Toasts (Test Stack)'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: ToastService.instance.clear,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All'),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('Toast Types', [
                _buildToastButton(
                  'Success Toast',
                  Icons.check_circle,
                  Colors.green,
                  () => ToastService.instance.success(
                    'Success',
                    'Your changes have been saved successfully!',
                    showProgress: true,
                  ),
                ),
                _buildToastButton(
                  'Error Toast',
                  Icons.error,
                  Colors.red,
                  () => ToastService.instance.error(
                    'Error',
                    'Failed to save changes. Please try again.',
                    showProgress: true,
                  ),
                ),
                _buildToastButton(
                  'Warning Toast',
                  Icons.warning,
                  Colors.orange,
                  () => ToastService.instance.warning(
                    'Warning',
                    'You have unsaved changes that will be lost.',
                  ),
                ),
                _buildToastButton(
                  'Info Toast',
                  Icons.info,
                  Colors.blue,
                  () => ToastService.instance.info(
                    'Information',
                    'You can dismiss toasts by swiping or clicking close.',
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('Advanced Features', [
                OutlinedButton.icon(
                  onPressed: () {
                    ToastService.instance.show(
                        contentBuilder: (context, progress, dismissToast) =>
                            DefaultToast(
                              title: 'Custom Toast',
                              message: 'This toast uses DefaultToast widget',
                              type: ToastType.info,
                              backgroundColor: Colors.purple.shade100,
                              icon: Icons.star,
                              actions: [
                                ToastAction(
                                  label: 'Dismiss',
                                  onPressed: () {
                                    ToastService.instance.success(
                                      'Dismissed',
                                      'Toast has been dismissed.',
                                    );
                                  },
                                ),
                              ],
                              onDismiss: dismissToast,
                            ),
                        duration: const Duration(seconds: 5),
                        showProgress: true);
                  },
                  icon: const Icon(Icons.palette),
                  label: const Text('Custom Styled Toast'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ToastService.instance.info(
                      'Action Required',
                      'This toast will not be dismissed automatically.',
                      autoDismiss: false,
                      actions: [
                        ToastAction(
                          label: 'Do Something',
                          onPressed: () {
                            ToastService.instance.success(
                              'Done!',
                              'Action done.',
                            );
                          },
                        ),
                        ToastAction(
                          label: 'Cancel',
                          onPressed: () {
                            ToastService.instance.error(
                              'Cancelled',
                              'Action has been cancelled.',
                            );
                          },
                        ),
                      ],
                    );
                  },
                  icon: const Icon(Icons.undo),
                  label: const Text('Toast with Action (No Auto-Dismiss)'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ToastService.instance.warning(
                      'Confirm Action',
                      'Are you sure you want to proceed?',
                      duration: const Duration(seconds: 10),
                      showProgress: true,
                      actions: [
                        ToastAction(
                          label: 'Confirm',
                          onPressed: () {
                            ToastService.instance.success(
                              'Confirmed',
                              'Action has been completed.',
                            );
                          },
                        ),
                      ],
                    );
                  },
                  icon: const Icon(Icons.done_all),
                  label: const Text('Toast with Action & Progress'),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('Navigation Test', [
                ElevatedButton.icon(
                  onPressed: () {
                    ToastService.instance.info(
                      'Navigation Test',
                      'This toast will persist across navigation.',
                      duration: const Duration(seconds: 10),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondScreen(
                          isDark: _isDark,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.navigation),
                  label: const Text('Navigate with Toast'),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('Customization', [
                OutlinedButton.icon(
                  onPressed: () {
                    ToastService.instance.show(
                      contentBuilder: (context, progress, dismissToast) =>
                          DefaultToast(
                        title: 'Custom Style',
                        message: 'This toast has custom text styles.',
                        type: ToastType.info,
                        onDismiss: dismissToast,
                      ),
                      duration: const Duration(seconds: 5),
                      showProgress: true,
                    );
                  },
                  icon: const Icon(Icons.text_fields),
                  label: const Text('Custom Text Styles'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ToastService.instance.show(
                      contentBuilder: (context, progress, dismissToast) =>
                          DefaultToast(
                        title: 'Custom Action',
                        message: 'This toast has a custom action button style.',
                        type: ToastType.info,
                        actions: [
                          ToastAction(
                            label: 'Custom',
                            onPressed: () {},
                          ),
                        ],
                        onDismiss: dismissToast,
                      ),
                      duration: const Duration(seconds: 10),
                      showProgress: true,
                      buttonsActionStyle: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    );
                  },
                  icon: const Icon(Icons.touch_app),
                  label: const Text('Custom Action Button Style'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ToastService.instance.show(
                      contentBuilder: (context, progress, dismissToast) =>
                          DefaultToast(
                        title: 'Custom Progress',
                        message: 'This toast has a custom progress indicator.',
                        type: ToastType.info,
                        onDismiss: dismissToast,
                      ),
                      duration: const Duration(seconds: 5),
                      showProgress: true,
                      progressColor: Colors.red,
                      progressBackgroundColor: Colors.blue,
                      progressStrokeWidth: 10,
                    );
                  },
                  icon: const Icon(Icons.linear_scale),
                  label: const Text('Custom Progress Indicator'),
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Instructions', [
                _buildInstruction(
                  Icons.mouse,
                  'Hover over toasts to expand stack and pause timers',
                ),
                _buildInstruction(
                  Icons.swipe,
                  'Swipe left or right to dismiss (40% threshold)',
                ),
                _buildInstruction(Icons.close, 'Click close button to dismiss'),
                _buildInstruction(
                  Icons.layers,
                  'Stack appears when toast count exceeds threshold',
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Current State', [
                ListenableBuilder(
                  listenable: ToastService.instance,
                  builder: (context, child) {
                    return Text(
                        'Active Toasts: ${ToastService.instance.count}');
                  },
                ),
                Text('Theme: ${_isDark ? "Dark" : "Light"}'),
                Text(
                    'Position: ${ToastService.instance.config?.position.name}'),
                Text(
                    'Stack Threshold: ${ToastService.instance.config?.stackThreshold}'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildToastButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(label),
      ),
    );
  }

  Widget _buildInstruction(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Second Screen')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Notice the toast persists across navigation!'),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ToastService.instance.success(
                    'From Second Screen',
                    'This toast was shown from the second screen.',
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Show Toast from Here'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
