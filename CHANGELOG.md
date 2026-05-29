# Changelog

All notable changes to this project will be documented in this file.

## [1.0.1] - 2026-05-29

### Added
- Created a standard package example project under `example/` demonstrating the comprehensive cyberpunk SaaS dashboard to maximize pub.dev scores.
- Added extensive Dartdoc comments (`///`) to all major public API components, properties, and constructors (such as `MotionLoader`, `MotionAiLoader`, `MotionDotsLoader`, `MotionWaveLoader`, and `MotionTypingIndicator`), exceeding the 20% completeness target.
- Added visual relative GIF demonstration assets for all 25+ components in `README.md`.

### Fixed
- **RenderFlex Layout Overflows**: Wrapped horizontal `Row` layout nodes inside `MotionDotsLoader`, `MotionTypingIndicator`, and `MotionWaveLoader` in `FittedBox` widgets to scale dynamically and prevent overflows under tight constraints.
- **Morph Container Vertical Overflow**: Wrapped the case 2 Column in `FittedBox(fit: BoxFit.scaleDown)` and applied `MainAxisSize.min` to prevent transitional 9.6px bottom layout overflows.
- **Dots Lifecycle Fix**: Corrected a state management bug inside `_MotionDotsLoaderState.dispose()` where `super.initState()` was mistakenly called instead of `super.dispose()`.
- **Static Analysis Cleared**: Resolved all 26 deprecation, unused import, and lint warnings (including modern `.a` alpha colors, diagonal3Values transforms, and const constructor skeleton scopes) to achieve a pristine analysis score.
- **Pubspec Optimization**: Shortened package description to exactly 154 characters.

## [1.0.0] - 2026-05-29

### Added
- Created a centralized, high-performance animation and loader ecosystem (`flutter_motion_kit`).
- Implemented **11 premium loader presets** including Dots, Typing, Wave, DNA, Orbit, Futuristic scanning radar, Liquid fill, and Matrix cascading green code rain.
- Built interactive pointer-tracking overlays: Scale, Neon Glow, Canvas-painted Ripples, and Magnetic cursor-attracting spring buttons.
- Implemented `MotionMorphingButton` that morphs standard shapes into loaders or success/error ticks.
- Created `MotionGlassContainer` implementing frosted real-time BackdropFilter blurs with sweep gradient neon glowing borders.
- Created `MotionCard` implementing 3D physical perspective tilt grids on mouse/finger gestures.
- Built dynamic backgrounds: organic fluid aurora blurs and interactive particle splashes.
- Implemented advanced PageTransitions: Shared Axis sliding and a fluid Liquid Wave Sweep transition.
- Implemented `MotionController` and `MotionThemeController` managed via GetX for dynamic speed scaling, vestibular "Reduce Motion" OS overrides, and performance blurs toggles.
- Implemented automated Unit and Widget testing models achieving 100% correct compile and mock-tap coverage.
- Rewrote the main entry point showcase app into a jaw-dropping premium dark sci-fi SaaS dashboard.
