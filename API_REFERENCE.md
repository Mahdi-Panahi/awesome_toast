# API Reference

Complete API documentation for flutter_toast_stack package.

## Table of Contents

- [ToastService](#toastservice)
- [ToastProvider](#toastprovider)
- [ToastStackConfig](#toaststackconfig)
- [ToastItem](#toastitem)
- [ToastPosition](#toastposition)
- [ToastType](#toasttype)
- [DefaultToast](#defaulttoast)

---

## ToastService

Singleton service for managing toast notifications globally.

### Access

```dart
ToastService.instance
```

### Methods

#### success

```dart
void success(
  String title,
  String message, {
  Duration? duration,
  bool? showProgress,
  String? actionLabel,
  VoidCallback? onAction,
})
```

Shows a success toast with green styling.

**Parameters:**
- `title` (required) - Toast title
- `message` (required) - Toast message
- `duration` - How long to display (null = manual dismiss only)
- `showProgress` - Whether to show progress bar
- `actionLabel` - Label for action button
- `onAction` - Callback when action button is pressed

**Example:**
```dart
ToastService.instance.success(
  'Saved',
  'Your changes have been saved',
  duration: Duration(seconds: 3),
);
```

---

#### error

```dart
void error(
  String title,
  String message, {
  Duration? duration,
  bool? showProgress,
  String? actionLabel,
  VoidCallback? onAction,
})
```

Shows an error toast with red styling.

**Parameters:** Same as `success()`

**Example:**
```dart
ToastService.instance.error(
  'Failed',
  'Unable to save your changes',
);
```

---

#### warning

```dart
void warning(
  String title,
  String message, {
  Duration? duration,
  bool? showProgress,
  String? actionLabel,
  VoidCallback? onAction,
})
```

Shows a warning toast with orange styling.

**Parameters:** Same as `success()`

**Example:**
```dart
ToastService.instance.warning(
  'Unsaved Changes',
  'Your changes will be lost',
);
```

---

#### info

```dart
void info(
  String title,
  String message, {
  Duration? duration,
  bool? showProgress,
  String? actionLabel,
  VoidCallback? onAction,
})
```

Shows an info toast with blue styling.

**Parameters:** Same as `success()`

**Example:**
```dart
ToastService.instance.info(
  'Tip',
  'You can swipe to dismiss toasts',
);
```

---

#### show

```dart
void show({
  required Widget child,
  Duration? duration,
  bool? showProgress,
  String? actionLabel,
  VoidCallback? onAction,
  VoidCallback? onDismiss,
})
```

Shows a custom toast with your own widget.

**Parameters:**
- `child` (required) - Custom widget to display
- `duration` - How long to display
- `showProgress` - Whether to show progress bar
- `actionLabel` - Label for action button
- `onAction` - Action button callback
- `onDismiss` - Called when toast is dismissed

**Example:**
```dart
ToastService.instance.show(
  child: Container(
    padding: EdgeInsets.all(16),
    color: Colors.purple,
    child: Text('Custom toast'),
  ),
  duration: Duration(seconds: 4),
);
```

---

#### showDefault

```dart
void showDefault({
  required String title,
  required String message,
  ToastType type = ToastType.info,
  Duration? duration,
  bool? showProgress,
  String? actionLabel,
  VoidCallback? onAction,
  VoidCallback? onDismiss,
})
```

Shows a toast with default styling. Uses `toastBuilder` from config if provided.

**Parameters:**
- `title` (required) - Toast title
- `message` (required) - Toast message
- `type` - Toast type (success, error, warning, info)
- Other parameters same as `show()`

**Example:**
```dart
ToastService.instance.showDefault(
  title: 'Custom',
  message: 'Using default styling',
  type: ToastType.success,
);
```

---

#### clear

```dart
void clear()
```

Removes all active toasts immediately.

**Example:**
```dart
ToastService.instance.clear();
```

---

### Properties

#### count

```dart
int get count
```

Returns the number of currently active toasts.

**Example:**
```dart
int activeToasts = ToastService.instance.count;
```

---

#### items

```dart
List<ToastItem> get items
```

Returns an unmodifiable list of active toast items.

**Example:**
```dart
List<ToastItem> toasts = ToastService.instance.items;
```

---

#### config

```dart
ToastStackConfig? get config
```

Returns the current configuration, or null if not initialized.

**Example:**
```dart
ToastStackConfig? currentConfig = ToastService.instance.config;
```

---

## ToastProvider

Provider widget that manages the toast overlay. Must wrap your MaterialApp.

### Constructor

```dart
ToastProvider({
  Key? key,
  required Widget child,
  ToastStackConfig config = const ToastStackConfig(),
})
```

**Parameters:**
- `child` (required) - Your MaterialApp or root widget
- `config` - Toast configuration

**Example:**
```dart
ToastProvider(
  config: ToastStackConfig(
    position: ToastPosition.topRight,
    stackThreshold: 3,
  ),
  child: MaterialApp(
    home: HomeScreen(),
  ),
)
```

---

## ToastStackConfig

Configuration class for toast behavior and appearance.

### Constructor

```dart
const ToastStackConfig({
  ToastPosition position = ToastPosition.topRight,
  int stackThreshold = 3,
  Duration stackDuration = const Duration(milliseconds: 300),
  Duration expandDuration = const Duration(milliseconds: 200),
  Duration defaultDuration = const Duration(seconds: 3),
  Curve curve = Curves.easeInOut,
  double stackOffset = 8.0,
  double stackScale = 0.95,
  double width = 340,
  EdgeInsets margin = const EdgeInsets.all(16),
  bool showProgressByDefault = false,
  Widget Function(BuildContext, String, String, ToastType)? toastBuilder,
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `position` | `ToastPosition` | `topRight` | Position on screen |
| `stackThreshold` | `int` | `3` | Toasts before stacking |
| `stackDuration` | `Duration` | `300ms` | Stack animation duration |
| `expandDuration` | `Duration` | `200ms` | Toast expand duration |
| `defaultDuration` | `Duration` | `3s` | Default auto-dismiss time |
| `curve` | `Curve` | `easeInOut` | Animation curve |
| `stackOffset` | `double` | `8.0` | Space between stacked items |
| `stackScale` | `double` | `0.95` | Scale for stacked items |
| `width` | `double` | `340` | Toast container width |
| `margin` | `EdgeInsets` | `all(16)` | Margin around stack |
| `showProgressByDefault` | `bool` | `false` | Default progress visibility |
| `toastBuilder` | `Function?` | `null` | Custom toast builder |

### Methods

#### copyWith

```dart
ToastStackConfig copyWith({...})
```

Creates a copy with modified values.

**Example:**
```dart
final newConfig = oldConfig.copyWith(
  position: ToastPosition.bottomLeft,
  stackThreshold: 5,
);
```

---

## ToastItem

Represents an individual toast notification.

### Constructor

```dart
ToastItem({
  required String key,
  required Widget child,
  Duration? duration,
  VoidCallback? onDismiss,
  bool showProgress = false,
  String? actionLabel,
  VoidCallback? onAction,
})
```

### Properties

- `key` - Unique identifier
- `child` - Toast content widget
- `duration` - Display duration (null = manual dismiss)
- `onDismiss` - Dismiss callback
- `showProgress` - Show progress indicator
- `actionLabel` - Action button text
- `onAction` - Action button callback

**Note:** Typically you don't create ToastItem directly. Use `ToastService` methods instead.

---

## ToastPosition

Enum defining toast stack position on screen.

### Values

```dart
enum ToastPosition {
  topLeft,      // Top left corner
  topCenter,    // Top center
  topRight,     // Top right corner
  bottomLeft,   // Bottom left corner
  bottomCenter, // Bottom center
  bottomRight,  // Bottom right corner
}
```

**Example:**
```dart
ToastStackConfig(
  position: ToastPosition.bottomCenter,
)
```

---

## ToastType

Enum defining default toast types.

### Values

```dart
enum ToastType {
  success,  // Green styling, check icon
  error,    // Red styling, error icon
  warning,  // Orange styling, warning icon
  info,     // Blue styling, info icon
}
```

**Example:**
```dart
ToastService.instance.showDefault(
  title: 'Title',
  message: 'Message',
  type: ToastType.warning,
);
```

---

## DefaultToast

Pre-built toast widget with customization options.

### Constructor

```dart
const DefaultToast({
  Key? key,
  required String title,
  required String message,
  ToastType type = ToastType.info,
  Color? backgroundColor,
  IconData? icon,
  TextStyle? titleStyle,
  TextStyle? messageStyle,
  EdgeInsets? padding,
  BorderRadius? borderRadius,
})
```

### Properties

- `title` (required) - Toast title
- `message` (required) - Toast message
- `type` - Toast type (for default styling)
- `backgroundColor` - Custom background color
- `icon` - Custom icon
- `titleStyle` - Custom title text style
- `messageStyle` - Custom message text style
- `padding` - Custom padding
- `borderRadius` - Custom border radius

### Example

```dart
ToastService.instance.show(
  child: DefaultToast(
    title: 'Custom Toast',
    message: 'With custom styling',
    type: ToastType.success,
    backgroundColor: Colors.teal.shade100,
    icon: Icons.star,
    titleStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.teal,
    ),
    messageStyle: TextStyle(
      fontSize: 16,
      color: Colors.teal.shade700,
    ),
    padding: EdgeInsets.all(20),
    borderRadius: BorderRadius.circular(12),
  ),
  duration: Duration(seconds: 5),
);
```

---

## Custom Toast Builder

You can provide a custom builder function in `ToastStackConfig`:

```dart
ToastStackConfig(
  toastBuilder: (BuildContext context, String title, String message, ToastType type) {
    // Return your custom widget
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getColorForType(type),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(message),
        ],
      ),
    );
  },
)
```

This builder will be used for all `success()`, `error()`, `warning()`, and `info()` methods.

---

## Events and Callbacks

### onDismiss

Called when a toast is dismissed (auto or manual).

```dart
ToastService.instance.show(
  child: MyWidget(),
  onDismiss: () {
    print('Toast was dismissed');
  },
);
```

### onAction

Called when the action button is pressed.

```dart
ToastService.instance.info(
  'Delete Item',
  'Item will be deleted',
  actionLabel: 'Undo',
  onAction: () {
    print('Undo was pressed');
    // Handle undo logic
  },
);
```

---

## Best Practices

### 1. Configuration
Set up configuration once in your app's root:

```dart
void main() {
  runApp(
    ToastProvider(
      config: ToastStackConfig(
        // Your configuration
      ),
      child: MyApp(),
    ),
  );
}
```

### 2. Toast Duration
- Quick actions: 2-3 seconds
- Important info: 4-5 seconds
- Actions required: null (manual dismiss)

### 3. Action Buttons
Use only when there's a clear, immediate action:

```dart
// Good
ToastService.instance.info(
  'Item Deleted',
  'Tap undo to restore',
  actionLabel: 'Undo',
  onAction: () => restore(),
);

// Not recommended
ToastService.instance.info(
  'New Feature',
  'Check out our new feature',
  actionLabel: 'OK', // What does OK do?
);
```

### 4. Custom Toasts
For consistent branding, use `toastBuilder`:

```dart
ToastStackConfig(
  toastBuilder: (context, title, message, type) {
    return BrandedToastWidget(
      title: title,
      message: message,
      type: type,
    );
  },
)
```

---

## Migration Guide

### From other toast packages

If you're migrating from other packages:

```dart
// Old package
showToast(context, 'Message');

// flutter_toast_stack
ToastService.instance.info('Title', 'Message');
```

Key advantages:
- ✅ No context required
- ✅ Persists across navigation
- ✅ Automatic stacking