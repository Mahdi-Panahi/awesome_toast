# awesome_toast

A beautiful, customizable toast notification system for Flutter with automatic stacking, smooth animations, and full navigation persistence.

## Features

*   **Customizable:** Easily customize the look and feel of your toasts.
*   **Stacking:** Toasts automatically stack to avoid cluttering the UI.
*   **Animations:** Smooth animations for a great user experience.
*   **Navigation Persistence:** Toasts persist across navigation events.
*   **Easy to Use:** Simple API for showing toasts.

## Getting Started

To use this package, add `awesome_toast` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  awesome_toast: ^0.0.1
```

Then, wrap your `MaterialApp` with a `ToastProvider`:

```dart
import 'package:awesome_toast/awesome_toast.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

Now you can show toasts from anywhere in your app:

```dart
ToastService.instance.success('Success', 'This is a success toast.');
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.