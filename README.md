<div align="center">

<h1 align="center">🍞 Awesome Toast</h1>

<p align="center">
  <strong>A beautiful, customizable toast notification system for Flutter with automatic stacking, smooth animations, glassmorphism support, and full navigation persistence.</strong>
</p>

<p align="center">
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
  </a>
  <a href="https://github.com/Mahdi-Panahi/awesome_toast">
    <img src="https://img.shields.io/badge/GitHub-Repository-black" alt="GitHub">
  </a>
  <a href="https://www.linkedin.com/in/mahdi-panahi/">
    <img src="https://img.shields.io/badge/LinkedIn-Mahdi_Panahi-blue" alt="LinkedIn">
  </a>
</p>

<img src="https://raw.githubusercontent.com/Mahdi-Panahi/awesome_toast/main/screenshots/Awesome%20Toast%20Demo%20gif.gif" width="300" alt="Awesome Toast Demo">
<img src="https://raw.githubusercontent.com/Mahdi-Panahi/awesome_toast/main/screenshots/small_screen.gif" width="300" alt="Awesome Toast Demo">
<img src="https://raw.githubusercontent.com/Mahdi-Panahi/awesome_toast/main/screenshots/wide_screen.gif" width="604" alt="Awesome Toast Demo">


</div>

---

## ✨ Features

- **🎨 Customizable:** Extensive styling options including colors, text styles, icons, and border radius.
- **📚 Stacking:** Smart automatic stacking behavior to keep your UI clean.
- **🌫️ Glassmorphism:** Built-in blur support for beautiful, modern UIs.
- **⚡ Performance:** Highly optimized rendering and layout logic.
- **🎬 Animations:** Smooth entrance, exit, and stacking animations.
- **🧭 Navigation Persistence:** Toasts remain visible and interactive across navigation events.
- **👆 Interactive:** Support for action buttons and swipe-to-dismiss (with configurable resistance).
- **📱 Positioning:** Adjust toast positions based on screen size or orientation.

---

## 🚀 Getting Started

Add `awesome_toast` to your `pubspec.yaml`:

```yaml
dependencies:
  awesome_toast: ^2.0.1
```

Wrap your app with `ToastProvider`:

```dart
import 'package:awesome_toast/awesome_toast.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastProvider(
      child: MaterialApp(
        title: 'Awesome Toast Demo',
        home: DemoScreen(),
      ),
    );
  }
}
```

---

## 📖 Usage

### Basic Toasts

Use the convenience methods on `ToastService.instance` for standard success, error, warning, and info toasts.

```dart
// Success
ToastService.instance.success(
'Success',
'Your changes have been saved!',
);

// Error
ToastService.instance.error(
'Error',
'Something went wrong. Please try again.',
);

// Warning
ToastService.instance.warning(
'Warning',
'You have unsaved changes.',
);

// Info
ToastService.instance.info(
'Info',
'New update available.',
);
```

### Advanced Configuration

You can configure the global behavior of the toast stack via `ToastStackConfig`.

```dart
ToastProvider(
config: ToastStackConfig(
position: ToastPosition.topRight,
stackThreshold: 3,
animationCurve: Curves.easeInOutBack,
defaultDuration: const Duration(seconds: 4),
blur: 5.0, // Enable glassmorphism
iconColor: Colors.white,
expandProgress: true, // Progress bar fills the background
),
child: // ...
)
```

### Custom Toasts (`toastBuilder` & `contentBuilder`)

You can fully customize the appearance of toasts.

**Global Customization via `toastBuilder`:**

Override the default look for all standard toasts in your app.

```dart
ToastProvider(
config: ToastStackConfig(
toastBuilder: (context, title, message, type, progress, dismiss, actions, dismissable, showProgress) {
return Container(
padding: const EdgeInsets.all(16),
color: Colors.black87,
child: Column(
children: [
Text(title, style: const TextStyle(color: Colors.amber)),
Text(message, style: const TextStyle(color: Colors.white)),
],
),
);
},
),
child: // ...
)
```

**One-off Customization via `show`:**

Use `ToastService.instance.show` for completely custom widgets.

```dart
ToastService.instance.show(
contentBuilder: (context, progress, dismiss, actions) {
// 'progress' is a ValueNotifier<double> that goes from 0.0 to 1.0
return Container(
height: 100,
color: Colors.deepPurple,
child: Center(
child: ElevatedButton(
onPressed: dismiss,
child: const Text('Close Custom Toast'),
),
),
);
},
duration: const Duration(seconds: 5),
);
```

### Non-Dismissable Toasts

You can make a toast persistent and resistant to swipe gestures.

```dart
ToastService.instance.warning(
'Critical Alert',
'This action cannot be undone.',
dismissable: false, // Disables swipe-to-dismiss and auto-dismiss
);
```

---

## 📚 API Reference

See the [API Reference](API_REFERENCE.md) for detailed documentation on all classes and methods.

---

## ☕ Support the development

<div align="center">
  <p>Love this package? Support the development!</p>
  <table>
    <tr>
      <td align="center">
        <b>TRON</b><br>
        <img src="https://raw.githubusercontent.com/Mahdi-Panahi/me/main/tron-qr.png" width="200" alt="TRON QR"><br>
        <code>TQyWG43yJ9MQFDLWMhkNKAwRXxhwseodvS</code>
      </td>
      <td align="center">
        <b>TON</b><br>
        <img src="https://raw.githubusercontent.com/Mahdi-Panahi/me/main/ton-qr.png" width="200" alt="TON QR"><br>
        <code>UQCR241RbOai5OYdOnIAGpwTqMNcln6pQl4f7Xg_MLUStG1n</code>
      </td>
    </tr>
  </table>
</div>

---

<div align="center">
  <p>MIT License - see the <a href="LICENSE">LICENSE</a> file for details.</p>
</div>