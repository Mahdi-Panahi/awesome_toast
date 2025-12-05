# Quick Start Guide

Get started with awesome_toast in 5 minutes!

## 1. Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  awesome_toast: ^2.0.0
```

Run:
```bash
flutter pub get
```

## 2. Setup

Wrap your MaterialApp with ToastProvider:

```dart
import 'package:flutter/material.dart';
import 'package:awesome_toast/awesome_toast.dart';

void main() {
  runApp(
    ToastProvider(
      config: ToastStackConfig(
        position: ToastPosition.topRight,
        stackThreshold: 3,
      ),
      child: MaterialApp(
        title: 'My App',
        home: HomeScreen(),
      ),
    ),
  );
}
```

## 3. Show Toasts

Use anywhere in your app - no context needed!

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show a success toast
            ToastService.instance.success(
              'Success!',
              'Operation completed successfully',
            );
          },
          child: Text('Show Toast'),
        ),
      ),
    );
  }
}
```

## 4. Toast Types

```dart
// Success (green)
ToastService.instance.success('Done', 'Task completed');

// Error (red)
ToastService.instance.error('Failed', 'Something went wrong');

// Warning (orange)
ToastService.instance.warning('Caution', 'Please verify your input');

// Info (blue)
ToastService.instance.info('FYI', 'Here is some information');
```

## 5. Advanced Features

### With Progress Bar

```dart
ToastService.instance.success(
  'Uploading',
  'Your file is being uploaded',
  showProgress: true,
  duration: Duration(seconds: 5),
  expandProgress: true, // Progress bar fills the background
);
```

### With Action Button

```dart
ToastService.instance.info(
  'Item Deleted',
  'The item has been removed',
  duration: null, // Manual dismiss
  actions: [
    ToastAction(
      label: 'Undo',
      onPressed: () {
        print('Undo clicked!');
      },
    ),
  ],
);
```

### Custom Toast Content

Use the `contentBuilder` to create a completely custom toast layout.

```dart
ToastService.instance.show(
  contentBuilder: (context, progress, dismiss, actions) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.white),
          SizedBox(width: 12),
          Text('Custom toast!', style: TextStyle(color: Colors.white)),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: dismiss,
          )
        ],
      ),
    );
  },
  duration: Duration(seconds: 3),
);
```

### Non-Dismissable Toast

Prevent users from dismissing critical alerts.

```dart
ToastService.instance.error(
  'Critical Error',
  'This message cannot be dismissed.',
  dismissable: false, // Disable drag-to-dismiss and auto-dismiss
);
```

## Configuration Options

Customize toast behavior:

```dart
ToastStackConfig(
  position: ToastPosition.bottomCenter,     // Where to show
  stackThreshold: 5,                        // When to stack
  defaultDuration: Duration(seconds: 4),    // How long to show
  width: 400,                               // Toast width
  showProgressByDefault: true,              // Always show progress
  blur: 5.0,                                // Glassmorphism blur
  iconColor: Colors.white,                  // Default icon color
)
```

## Common Use Cases

### Save Confirmation

```dart
void saveData() async {
  try {
    await api.save();
    ToastService.instance.success('Saved', 'Your changes are saved');
  } catch (e) {
    ToastService.instance.error('Error', 'Failed to save');
  }
}
```

### Delete with Undo

```dart
void deleteItem() {
  ToastService.instance.warning(
    'Deleted',
    'Item removed',
    duration: Duration(seconds: 5),
    actions: [
      ToastAction(
        label: 'Undo',
        onPressed: () => restoreItem(),
      ),
    ],
  );
}
```

### Loading Indicator

```dart
void uploadFile() {
  ToastService.instance.info(
    'Uploading',
    'Please wait...',
    showProgress: true,
    dismissable: false, // Prevent dismissal during upload
  );
  
  // Later, after upload completes:
  ToastService.instance.clear();
  ToastService.instance.success('Done', 'Upload complete');
}
```

## Interactive Features

- **Swipe** left/right to dismiss (if `dismissable` is true)
- **Hover** over toasts to pause timers
- **Click** close button to dismiss
- **Tap** action button for actions

## That's It!

You're ready to use awesome_toast in your app!

### Need Help?

- 📖 [README](README.md) - Complete guide
- 🔧 [API Reference](API_REFERENCE.md) - Detailed API docs
- 🐛 [Issues](https://github.com/Mahdi-Panahi/awesome_toast/issues) - Report bugs

---

Happy coding! 🎉