# Changelog

All notable changes to this project will be documented in this file.

## [1.0.4] - 2026-06-04

### Added
- **MotionPullToRefresh Indicator Ecosystem**: Engineered an advanced, high-performance scroll wrapper featuring **20 high-fidelity custom-painted animations** divided into fluid/natural, cosmic/gravitational, and mechanical/flagship styles (Liquid Morph, Rocket Launch, Black Hole, DNA Helix, Jelly Bounce, Magnetic Orb, Infinity Symbol, Tornado, Phoenix Rebirth, Neural Network, Portal, Clockwork, Origami Bird, Lightning Charge, Planet Orbit, Crystal Growth, Fireworks, Ink Spread, Hologram, and Signature).
- **Customization Controls & API**: Exposed parameters for particle count, glow strength, animation speed, adaptive themes, and custom background/foreground color.
- **Interactive Playground Dashboard**: Integrated a new dedicated tab inside the playground showcase dashboards (both `lib/main.dart` and `example/lib/main.dart`) to test all 20 indicator animations with real-time speed, particle, and glow sliders.
- **Unit and Widget Tests**: Mounted and tested full gestures drag scrolling and snapping transitions covering the complete indicator collection in `test/widget_test.dart`.
- **Animated Previews for All 20 Indicators**: Converted indicator recordings inside `assets/refresh/` from `.mov` to `.gif` and added comprehensive visual preview grids to `README.md` for all 20 pull-to-refresh styles.

### Changed
- **MVC Architecture Separation**: Refactored the file layout by extracting `MotionRefreshController` from `lib/refresh/motion_pull_to_refresh.dart` into its own file at `lib/refresh/controllers/motion_refresh_controller.dart` to strictly separate the Controller and View layers.
- **Legacy Code Cleanups**: Removed the legacy and unwanted `MotionRefreshIndicator` (`lib/refresh/motion_refresh.dart`) and cleaned up all transitive exports in `lib/flutter_motion_kit.dart`.

## [1.0.3] - 2026-05-29

### Added
- **Interactive Visual Preview Catalog**: Integrated comprehensive visual GridView tables in `README.md` showcasing all 11 standard and all 60+ advanced vector loader styles. Enabled responsive loop-autoplaying `.mov` previews using native `<video>` tags.
- **Robust Missing-Asset Fallbacks**: Structured preview slots gracefully for all existing styles; any style without an animated preview displays its exact constructor/enum entry alongside a clean `*No Preview (Asset Missing)*` slot.
- Expanded the vector loader library with **32+ advanced premium styles** spanning new innovative categories:
  - **AI Category**: `MotionTokenPredictionLoader` (real-time prediction typing with live vertical probability charts), `MotionNeuralPulseLoader` (electric synapse nodes), `MotionTensorFlowLoader`, and `MotionAiEyeLoader`.
  - **Physics Category**: `MotionFluidParticleLoader` (viscous cohesion metaballs), `MotionSandSimulationLoader` (hourglass gravity particles), and `MotionMagneticFieldLoader` (flux vector filings).
  - **Social Category**: `MotionReelsUploadLoader` (progressive neon gradient border sweeps), `MotionLiveStreamLoader` (signal antennas with live indicators), and `MotionStoryRingLoader` (avatar borders).
  - **3D Category**: `MotionFloatingCubeLoader` (overlapping parallax cubes), `MotionIsometricLoader` (assembling building blocks), and `MotionHolographicSphereLoader` (latitude/longitude wireframes).
  - **Audio Category**: `MotionEqualizerLoader` (staggered frequency bouncing bars), `MotionVinylLoader` (spinning retro disc metallic reflections), and `MotionBeatWaveLoader` (bass-pulsing wave curves).
  - **Artistic Category**: `MotionZenCircleLoader` (ink wash brush strokes), `MotionOrigamiLoader` (paper-folding facets), and `MotionCalligraphyStrokeLoader` (SVG drawing paths).
  - **Experimental Category**: `MotionTimeWarpLoader` (melting warped clocks), `MotionPortalLoader` (spiral particle vortexes), `MotionDimensionalRiftLoader` (neon leaking cracks), and `MotionWormholeLoader` (cosmic zooming tunnels).
- Created `MotionBuilder` compound decorator system that stacks multiple GPU-optimized visual effects like `GlowEffect`, `OrbitEffect`, `RippleEffect`, `GlitchEffect`, and `FloatEffect` dynamically.
- Upgraded the automated Unit and Widget testing suite to cover all 77+ premium vector loaders.

### Fixed
- **Bulletproof Constrained Layouts**: Refactored `MotionTerminalBootLoader` and `MotionTokenPredictionLoader` to use highly robust, scale-independent internal layout canvases wrapped in `FittedBox(fit: BoxFit.contain)`. Replaced hardcoded dimensions with fluid `AnimatedFractionallySizedBox` transitions to guarantee perfect layouts and zero horizontal or vertical `RenderFlex` overflows in narrow environments (like 21x21 constraints in test engines).
- **Static Analysis Perfect Score**: Cleaned up all remaining warnings, lints, and deprecations across the entire package codebase, including modern `toARGB32()` color conversions, Matrix4 `.multiply` transforms, unused imports, and optimal `const` constructor allocations.

## [1.0.2] - 2026-05-29

### Added
- Expanded the loader ecosystem with **8 premium categories hosting 24 advanced vector styles**:
  - **Glassmorphism Category**: Frosted glass orbs, spinning 3D refracting prism crystals, and multi-layered wavy northern lights Aurora mesh ribbons.
  - **Space & Sci-Fi Category**: Accreting event horizon Black Holes, Keplerian rotating Galaxies, and exponential 3D Warp Speed perspectives.
  - **Gaming Category**: Gold XP Progress shield arcs, counter-rotating magical Boss Fight pentagram runic circles with flare explosions, and CRT retro scanline Pixels.
  - **Physics Category**: Physical momentum Pendulums (Newton's Cradle), elastic-easing spring Bounce Chains, and Kepler eccentric Gravity Orbits.
  - **Minimalist Category**: Lemniscate of Bernoulli infinity self-drawing lines, point-by-point vector Morphing shapes, and wavy 3D silk ribbons.
  - **SaaS Category**: Staggered matrix Pulse skeleton screens, auto-drawing Analytics line graphs with traveling indicators, and Cloud Sync sync upload arrow bubbles.
- Introduced Named Category Factory constructors on `MotionLoader` (`MotionLoader.ai`, `MotionLoader.liquid`, `MotionLoader.glass`, `MotionLoader.space`, `MotionLoader.gaming`, `MotionLoader.physics`, `MotionLoader.minimal`, `MotionLoader.saas`).
- Exposed all new styles, enums, and components in the master library exports.
- Integrated standard and advanced category selector panels inside the interactive SaaS dashboard playgrounds.
- Upgraded live integration code generators to dynamically output exact constructor code snippets reflecting active customizations.
- Mapped and verified 100% correct compile-times and widget trees for all 35+ loaders in automated tests.

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
