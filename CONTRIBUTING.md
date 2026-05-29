# Contributing to flutter_motion_kit 🤝

Thank you for choosing to contribute! To ensure the codebase remains clean, extensible, and high-performance, please follow our standards below:

---

## Code Quality Standards

*   **SOLID & Clean Principles** — Build generic base widgets, separate canvas painter operations from gesture listeners, and ensure proper single responsibility limits.
*   **Accessibility First** — Every animation widget MUST listen to `MotionController` state. If `reducedMotion` is true, widgets must transition to simplified or static representations.
*   **Repaint Boundaries** — Wrap custom canvas painters and fast-rebuilding animated nodes inside a `RepaintBoundary` to avoid heavy CPU layout cycles.
*   **Constants** — Declare widgets and paddings as `const` where possible to minimize rebuilding cost.

---

## Folder Structure Conventions

Ensure new animations are added inside the modular folders:
*   `lib/loaders/` — Subfolders for loaders, containing a clean wrapper registration inside `motion_loader.dart`.
*   `lib/buttons/` — Buttons and responsive tap overlays.
*   `lib/transitions/` — Custom page transitions inside `motion_transitions.dart`.
*   `lib/core/` — Core colors, extension widgets, themes, and controllers.

---

## Pull Request Checklist

Before submitting a PR:
1.  **Format Code** — Ensure Dart code is formatted: `flutter format .`
2.  **Lint Check** — Run static analysis to verify zero errors or warnings: `flutter analyze`
3.  **Run Tests** — Verify all widget and unit tests compile and execute perfectly: `flutter test`
4.  **Showcase Verification** — Verify that the SaaS dashboard running in `lib/main.dart` compiles and displays your new contribution flawlessly!
