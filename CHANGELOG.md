# 2.0.2

*   **Fix:** Added default `Material` widget wrapper to toasts to prevent "yellow text" styling issues (missing Material ancestor).

# 2.0.1

*   **Update:** `toastBuilder` in `ToastStackConfig` now accepts `dismissable` and `showProgress` parameters: `(context, title, message, type, progress, dismissToast, actions, dismissable, showProgress)`.

# 2.0.0

*   **Breaking Change:** `contentBuilder` in `show` method now accepts `actions` as a parameter: `(context, progress, dismissToast, actions)`.
*   **New Feature:** Added `dismissable` property to `ToastStackConfig`, `ToastItem`, and `DefaultToast`.
    *   Controls whether a toast can be dismissed by drag/swipe.
    *   If `false`, the toast resists dragging, snaps back, and auto-dismissal is disabled by default.
*   **New Feature:** Added `blur` property to glassmorphism effect.
*   **New Feature:** Added `iconColor` customization.
*   **New Feature:** Added `expandProgress` property to control progress bar appearance (fill background vs bottom line).
*   **Optimization:** Significant performance improvements in rendering and layout calculation.
    *   Conditional `BackdropFilter` usage.
    *   O(N) layout offset calculation.
*   **Refactor:** `ToastStackConfig` structure updated.

# 1.0.0

* Initial release of the `awesome_toast` package.