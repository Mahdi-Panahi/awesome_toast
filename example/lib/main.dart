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
        defaultDuration: const Duration(seconds: 5),
        showProgressByDefault: false,
        curve: Curves.easeInOutQuart,
        maxWidth: 340,
        titleTextStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        messageStyle: const TextStyle(fontSize: 14, color: Colors.white),
        buttonsActionStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        progressColor: Colors.black26.withValues(alpha: 0.3),
        progressBackgroundColor: Colors.white10,
        progressStrokeWidth: 3,
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
                        contentBuilder:
                            (context, progress, dismissToast, actions) {
                          return ValueListenableBuilder(
                              valueListenable: progress ?? ValueNotifier(0.0),
                              builder: (context, value, child) {
                                return Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 400 * value,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Container(
                                      height: 150,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent.withAlpha(200),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 200 * value),
                                          Transform.rotate(
                                            angle: value * 5,
                                            child: Transform.scale(
                                              scale: value * 5,
                                              child: FlutterLogo(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: (actions?.isNotEmpty ?? false)
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            action.onPressed();
                                                            dismissToast
                                                                ?.call();
                                                          },
                                                          child: Text(
                                                            action.label,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: IconButton(
                                        onPressed: dismissToast,
                                        icon: Icon(
                                          Icons.waving_hand,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        actions: [
                          ToastAction(
                            label: 'load',
                            onPressed: () {
                              ToastService.instance.success(
                                'Dismissed',
                                'Toast has been dismissed.',
                              );
                            },
                          ),
                        ],
                        duration: const Duration(seconds: 5));
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
              _buildSection('Progress value changes Test', [
                OutlinedButton.icon(
                  onPressed: () {
                    final progressNotifier = ValueNotifier<double>(0.0);
                    VoidCallback? action = () {};
                    ToastService.instance.show(
                      contentBuilder: (context, progress, dismissToast, _) {
                        action = dismissToast;
                        return DefaultToast(
                          title: 'Progress Test',
                          message: 'This toast has a progress indicator.',
                          type: ToastType.none,
                          showProgress: true,
                          progress: progressNotifier,
                          icon: Icons.download,
                          progressBackgroundColor: Colors.white10,
                          progressColor: Colors.green.withValues(alpha: 0.8),
                          actions: [
                            ToastAction(
                              label: 'Cancel',
                              onPressed: () {
                                ToastService.instance.error(
                                  'Cancelled',
                                  'Download has been cancelled.',
                                );
                                dismissToast?.call();
                                progressNotifier.dispose();
                              },
                            ),
                          ],
                        );
                      },
                    );

                    // Simulate a download
                    Future.doWhile(() async {
                      if (progressNotifier.value >= 1.0) {
                        return false;
                      }
                      await Future.delayed(const Duration(milliseconds: 50));
                      if (progressNotifier.value < 1.0) {
                        progressNotifier.value += 0.01;
                      }
                      if (progressNotifier.value >= 1.0) {
                        ToastService.instance.success(
                            'Downloaded', 'Your download is complete.');
                        action?.call();
                        progressNotifier.dispose();
                        return false;
                      }
                      return true;
                    });
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Simulate Download'),
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
                      contentBuilder:
                          (context, progress, dismissToast, actions) =>
                              DefaultToast(
                        title: 'Custom Style',
                        message: 'This toast has custom text styles.',
                        type: ToastType.info,
                        onDismiss: dismissToast,
                        showProgress: true,
                        progress: progress,
                        titleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        messageTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      duration: const Duration(seconds: 5),
                    );
                  },
                  icon: const Icon(Icons.text_fields),
                  label: const Text('Custom Text Styles'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ToastService.instance.show(
                      contentBuilder:
                          (context, progress, dismissToast, actions) =>
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
                        buttonsActionStyle: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        showProgress: true,
                        progress: progress,
                      ),
                      duration: const Duration(seconds: 10),
                    );
                  },
                  icon: const Icon(Icons.touch_app),
                  label: const Text('Custom Action Button Style'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ToastService.instance.show(
                      contentBuilder:
                          (context, progress, dismissToast, actions) =>
                              DefaultToast(
                        title: 'Custom Progress',
                        message: 'This toast has a custom progress indicator.',
                        type: ToastType.info,
                        onDismiss: dismissToast,
                        progressColor: Colors.green,
                        progressBackgroundColor:
                            Colors.grey.withAlpha((0.5 * 255).round()),
                        progressStrokeWidth: 10,
                        showProgress: true,
                        progress: progress,
                      ),
                      duration: const Duration(seconds: 5),
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
