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
        actionLabelStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
        progressColor: Colors.blue,
        progressBackgroundColor: Colors.grey,
        progressStrokeWidth: 2,
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
                        child: DefaultToast(
                          title: 'Custom Toast',
                          message: 'This toast uses DefaultToast widget',
                          type: ToastType.info,
                          backgroundColor: Colors.purple.shade100,
                          icon: Icons.star,
                          hasActionLabel: true,
                        ),
                        duration: const Duration(seconds: 5),
                        showProgress: true,
                        actionLabel: 'Dismiss',
                        onAction: () {
                          ToastService.instance.success(
                            'Dismissed',
                            'Toast has been dismissed.',
                          );
                        });
                  },
                  icon: const Icon(Icons.palette),
                  label: const Text('Custom Styled Toast'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ToastService.instance.info(
                      'Action Required',
                      'This toast will not be dismissed lkm;lkm;lkm;lkm;lkm;lkm;lkm;lkml;mautomatically.',
                      autoDismiss: false,
                      actionLabel: 'Undoooooo',
                      onAction: () {
                        ToastService.instance.success(
                          'Restored',
                          'Item has been restored.',
                        );
                      },
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
                      actionLabel: 'Confirm',
                      onAction: () {
                        ToastService.instance.success(
                          'Confirmed',
                          'Action has been completed.',
                        );
                      },
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
                        builder: (context) => const SecondScreen(),
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
                      child: DefaultToast(
                        title: 'Custom Style',
                        message: 'This toast has custom text styles.',
                        type: ToastType.info,
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
                      child: DefaultToast(
                        title: 'Custom Action',
                        message: 'This toast has a custom action button style.',
                        type: ToastType.info,
                      ),
                      duration: const Duration(seconds: 10),
                      showProgress: true,
                      actionLabel: 'Custom',
                      onAction: () {},
                      actionLabelStyle: const TextStyle(
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
                      child: DefaultToast(
                        title: 'Custom Progress',
                        message: 'This toast has a custom progress indicator.',
                        type: ToastType.info,
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
              const SizedBox(height: 24),
              _buildSection('Performance Info', [
                _buildInstruction(
                  Icons.speed,
                  'Uses ValueNotifier for drag offset (no setState)',
                ),
                _buildInstruction(
                  Icons.memory,
                  'LayoutBuilder replaces custom height measurer',
                ),
                _buildInstruction(
                  Icons.animation,
                  'Optimized rebuild scopes with ListenableBuilder',
                ),
                _buildInstruction(
                  Icons.lightbulb,
                  'Hover state managed with dedicated ChangeNotifier',
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
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current State',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Active Toasts: ${ToastService.instance.count}'),
                      Text('Theme: ${_isDark ? "Dark" : "Light"}'),
                      const Text('Position: Top Center'),
                      const Text('Stack Threshold: 3'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
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
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
