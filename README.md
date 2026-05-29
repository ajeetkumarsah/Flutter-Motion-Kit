# flutter_motion_kit 🚀

[![pub package](https://img.shields.io/pub/v/flutter_motion_kit.svg?logo=dart&logoColor=00C2FF&style=flat-square)](https://pub.dev/packages/flutter_motion_kit)
[![Platform Support](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20macos%20%7C%20windows-blue.svg?style=flat-square)](https://pub.dev/packages/flutter_motion_kit)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square)](/LICENSE)

A centralized, production-grade Flutter animation and loader library powered by GetX. Exposes premium loaders, custom-painted skeletons, frosted glassmorphism containers, 3D pointer-tracking cards, liquid-swipe page transitions, and interactive particle background effects under a single unified API.

Designed for high-performance (smooth 60fps/120fps), complete accessibility compliance (vestibular reduce-motion triggers), and absolute ease-of-use.

---

## 🌟 Key Features

*   🎯 **One-Stop Animation Library** — Install **ONLY ONE** package to fulfill all animation, loader, and visual effect needs.
*   ⚡ **60fps Production Performance** — Highly optimized rendering utilizing `RepaintBoundary` wrappers and strict ticker management.
*   ♿ **Full Accessibility Compliance** — Integrated dynamic fallbacks supporting device-level "Reduce Motion" system configurations.
*   🎨 **Dynamic Theme Presets** — Fluid switching between Cyberpunk, Midnight Gold, Light/Dark Modes, and customized neon gradient borders.
*   🌊 **Advanced Custom Page Transitions** — Build highly custom routes including Shared Axis slides and fluid Liquid Swipes.
*   📦 **Zero Boilerplate API** — Simple, developer-friendly interfaces designed for maximum customization.

---

## 🛠️ Installation

Add `flutter_motion_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_motion_kit: ^1.0.0
```

---

## 🚀 Quickstart

1.  **Initialize the Engine** — Initialize the centralized state managers inside your `main.dart` entry point:

    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_motion_kit/flutter_motion_kit.dart';

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      
      // Auto-registers accessibility, performance, and theme controllers
      await MotionConfigService.init();
      
      runApp(const MyApp());
    }
    ```

2.  **Mount the App** — Wrap your `MaterialApp` in an `Obx` container to enjoy real-time neon dynamic theme switches:

    ```dart
    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        final themeController = Get.find<MotionThemeController>();

        return Obx(() {
          return MaterialApp(
            title: 'Motion App',
            theme: themeController.theme.toThemeData(),
            home: const MyDashboard(),
          );
        });
      }
    }
    ```

---

## 📐 API Showcase & Component Dictionary

Here is the complete reference dictionary covering **each and every widget** available in `flutter_motion_kit` along with their key parameters, descriptions, and clean copy-pasteable usage examples.

---

### 📂 Table of Contents
1. [App-wide Services & Custom Themes](#1-app-wide-services--custom-themes)
2. [Interactive Background Shaders](#2-interactive-background-shaders)
3. [Ecosystem Loaders](#3-ecosystem-loaders)
4. [Interactive Action Controls](#4-interactive-action-controls)
5. [Micro-Interactions](#5-micro-interactions)
6. [Cards, Morphings, Glass & Placeholders](#6-cards-morphings-glass--placeholders)
7. [Custom Route Transitions](#7-custom-route-transitions)

---

### 1. App-wide Services & Custom Themes

#### `MotionConfigService`
*   **Description**: Static engine initialization service. Registers global `MotionController` and `MotionThemeController` to handle user-toggled settings like Speed Multipliers, Reduced Motion overrides, Performance Mode blurs, and presets.
*   **Usage**:
    ```dart
    await MotionConfigService.init();
    ```

#### `MotionTheme`
*   **Description**: Scope injector for retrieving the active cyberpunk or midnight gold neon themes. Provides dynamic colors and Typography definitions inside the widget tree.
*   **Usage**:
    ```dart
    final activeTheme = MotionTheme.of(context);
    Color neonColor = activeTheme.primaryColor;
    ```

---

### 2. Interactive Background Shaders

#### `MotionAuroraBackground`
*   **Description**: A high-end background layer that renders floating, multi-colored liquid aurora gaseous meshes. Animates dynamically utilizing high-performance sinus shaders with low CPU load.
*   **Usage**:
    ```dart
    MotionAuroraBackground(
      child: Center(
        child: Text('Floating on gaseous lights'),
      ),
    )
    ```
*   **Parameters**:
    *   `child`: Nested overlay content widgets (optional).

#### `MotionParticleBackground`
*   **Description**: A live particle physics field. Particles float, bounce, and drift randomly. Interactive tap inputs act as gravity points, drawing particles in before dispersing them outward.
*   **Usage**:
    ```dart
    MotionParticleBackground(
      particleColor: Colors.cyanAccent.withOpacity(0.4),
      child: const Text('Interactive particle field'),
    )
    ```
*   **Parameters**:
    *   `particleColor`: Color override for drifting particles (default: `primaryNeon`).
    *   `child`: Nested overlay content widgets.

---

### 3. Ecosystem Loaders

All 11 loaders can be resolved dynamically via the unified `MotionLoader` router or instantiated individually. They automatically adapt sizes and margins to prevent layout overflows and respect global speed settings.

#### `MotionLoader` (Unified Router)
*   **Description**: Centralized loading dispatcher. Resolves and returns any of the 11 loader types based on the `MotionLoaderType` enum.
*   **Usage**:
    ```dart
    MotionLoader(
      type: MotionLoaderType.ai,
      color: Colors.purpleAccent,
      size: 48.0,
    )
    ```
*   **Parameters**:
    *   `type`: Preset loader to use (`dots`, `typing`, `pulse`, `orbit`, `dna`, `ai`, `liquid`, `wave`, `futuristic`, `matrix`, `gradientRotating`).
    *   `color`: Loading graphic color.
    *   `size`: Bounding box dimensions (width & height).
    *   `strokeWidth`: Line stroke dimensions where applicable.

#### `MotionDotsLoader`
*   **Description**: A horizontal three-dot loading widget. Dots bounce vertically in a sinusoidal wave sequence. Fully wrapped inside a `FittedBox` to guarantee zero layout overflows on tight button bounds.
*   **Usage**:
    ```dart
    MotionDotsLoader(
      color: Colors.cyan,
      size: 32.0,
    )
    ```

#### `MotionTypingIndicator`
*   **Description**: A messaging-style bubble typing indicator. Dots scale up/down and fade in/out sequentially, mirroring modern chat activity screens.
*   **Usage**:
    ```dart
    MotionTypingIndicator(
      color: Colors.grey,
      size: 28.0,
    )
    ```

#### `MotionPulseLoader`
*   **Description**: Concentric circular rings expanding outwards from a central point. Implements custom opacity fades mimicking radar pings.
*   **Usage**:
    ```dart
    MotionPulseLoader(
      color: Colors.tealAccent,
      size: 50.0,
    )
    ```

#### `MotionOrbitLoader`
*   **Description**: A central core nucleus with orbiting planetary satellite nodes revolving in circular patterns. Calculates coordinates dynamically via trigonometry.
*   **Usage**:
    ```dart
    MotionOrbitLoader(
      color: Colors.pink,
      size: 40.0,
    )
    ```

#### `MotionDnaLoader`
*   **Description**: Renders a vertical double-helix strand model. Helix nodes oscillate along sine and cosine curves to project realistic 3D depth perception.
*   **Usage**:
    ```dart
    MotionDnaLoader(
      color: Colors.indigoAccent,
      size: 55.0,
    )
    ```

#### `MotionAiLoader`
*   **Description**: Represents a glowing neural intelligence core. Radiant light pulses from the center and sparks secondary brain synapse node connections.
*   **Usage**:
    ```dart
    MotionAiLoader(
      color: Colors.cyanAccent,
      size: 60.0,
    )
    ```

#### `MotionLiquidLoader`
*   **Description**: A circular container filled with liquid fluid waves. Waves crest, fill, and slide dynamically using canvas paint curves.
*   **Usage**:
    ```dart
    MotionLiquidLoader(
      color: Colors.blueAccent,
      size: 48.0,
    )
    ```

#### `MotionWaveLoader`
*   **Description**: Five vertical sound-bar graphs oscillating up/down in a clean equalizer pattern. Fully fitted to scale safely on micro-columns.
*   **Usage**:
    ```dart
    MotionWaveLoader(
      color: Colors.amber,
      size: 36.0,
    )
    ```

#### `MotionFuturisticLoader`
*   **Description**: Renders a circular scifi radar scanning grid. A linear gradient sector sweeps 360 degrees, leaving a fading tracking glow.
*   **Usage**:
    ```dart
    MotionFuturisticLoader(
      color: Colors.greenAccent,
      size: 50.0,
    )
    ```

#### `MotionMatrixLoader`
*   **Description**: Cascading green terminal monospace code characters drifting downwards. Translates string drops on individual streams to render high-performance cyber-rain.
*   **Usage**:
    ```dart
    MotionMatrixLoader(
      color: Colors.emerald,
      size: 70.0,
    )
    ```

#### `MotionGradientRotatingLoader`
*   **Description**: Dual neon arc rings spinning in opposite directions, painted with harmonic sweep gradients.
*   **Usage**:
    ```dart
    MotionGradientRotatingLoader(
      color: Colors.deepOrangeAccent,
      size: 45.0,
    )
    ```

---

### 4. Interactive Action Controls

#### `MotionButton`
*   **Description**: A tactile, feedback-rich click action control. Supports magnetic physical pulls, pointer displacement springs, neon glowing blurs, scale bounces, or touch-expanding canvas custom ripples.
*   **Usage**:
    ```dart
    MotionButton(
      effect: MotionButtonEffect.ripple,
      color: Colors.cyanAccent,
      onTap: () => print('Button pressed!'),
      child: const Text('Neon Ripple Button'),
    )
    ```
*   **Parameters**:
    *   `effect`: Bouncing, glowing, or ripple action profile (`MotionButtonEffect`).
    *   `color`: Neon glow or ripple accent paint.
    *   `onTap`: Callback action triggered upon tap.
    *   `child`: Button label text or icons.

#### `MotionExpandableFab`
*   **Description**: Premium Speed Dial Floating Action Button. When tapped, it rolls out a modular fan list of child action options in radial orbits.
*   **Usage**:
    ```dart
    MotionExpandableFab(
      distance: 90.0,
      icon: const Icon(Icons.menu),
      children: [
        IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        IconButton(icon: const Icon(Icons.email), onPressed: () {}),
      ],
    )
    ```
*   **Parameters**:
    *   `distance`: Radial distance (offset radius) for child buttons.
    *   `icon`: Center anchor floating button icon.
    *   `children`: Stack of action buttons to expand/reveal.

#### `MotionMorphingButton`
*   **Description**: An advanced material-state action button. Takes an asynchronous operation, shrinks boundaries, and morphs from a standard button shape into a progress liquid-loader, and subsequently transitions into a success checkmark or error cross.
*   **Usage**:
    ```dart
    MotionMorphingButton(
      width: 180,
      height: 48,
      borderRadius: 12,
      onTap: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      child: const Text('SUBMIT DISPATCH'),
    )
    ```
*   **Parameters**:
    *   `width`/`height`: Idle dimensions.
    *   `onTap`: Async callback to resolve.
    *   `child`: Center label when idle.

#### `MotionRefreshIndicator`
*   **Description**: A customized pull-to-refresh list layout. As you pull, it fills up a liquid wave container; when refreshing, it rotates dynamic sci-fi orbits until the async function completes.
*   **Usage**:
    ```dart
    MotionRefreshIndicator(
      onRefresh: () async => await fetchNetworkData(),
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (c, i) => ListTile(title: Text('Row $i')),
      ),
    )
    ```
*   **Parameters**:
    *   `onRefresh`: Async method representing the network loading action.
    *   `child`: Scrollable list view content container.

---

### 5. Micro-Interactions

#### `MotionLikeButton`
*   **Description**: Popping interaction button. Tapping scale-bounces the heart icon and shoots dynamic paint droplets outwards in a circular splash burst.
*   **Usage**:
    ```dart
    MotionLikeButton(
      initialLiked: false,
      size: 32.0,
      onChanged: (liked) => print('Liked status: $liked'),
    )
    ```
*   **Parameters**:
    *   `initialLiked`: Initial state boolean.
    *   `size`: Graphic width and height bounds.
    *   `onChanged`: Callback reporting new state value.

#### `MotionAnimatedCheckmark`
*   **Description**: Smooth vector checkmark draw interaction. Tapping paints a circular baseline and animates the completion of the vector check icon stroke dynamically.
*   **Usage**:
    ```dart
    MotionAnimatedCheckmark(
      size: 40.0,
      color: Colors.greenAccent,
    )
    ```
*   **Parameters**:
    *   `size`: Width/height dimensions.
    *   `color`: Stroke outline color.

#### `MotionLiquidToggle`
*   **Description**: An organic toggle switch. Sliding changes background colors and applies gaseous liquid distortion filters to boundary shapes as they drag.
*   **Usage**:
    ```dart
    MotionLiquidToggle(
      value: false,
      onChanged: (val) => print('Toggle value: $val'),
    )
    ```
*   **Parameters**:
    *   `value`: True/false state.
    *   `onChanged`: Callback reporting updated boolean.

#### `MotionBookmarkButton`
*   **Description**: An elastic ribbon selector interaction. Tapping slides the ribbon down and morphs its geometry from an outline flag to a filled block.
*   **Usage**:
    ```dart
    MotionBookmarkButton(
      initialBookmarked: false,
      size: 26.0,
    )
    ```

---

### 6. Cards, Morphings, Glass & Placeholders

#### `MotionCard`
*   **Description**: A 3D pointer-tracking perspective card. Listens to drag gestures (on mobile) or hover movements (on web/desktop) and tilts boundaries in three-dimensional space, projecting a glowing sweeping light reflection.
*   **Usage**:
    ```dart
    MotionCard(
      maxTiltAngleX: 12.0,
      maxTiltAngleY: 12.0,
      shadowColor: Colors.purple.withOpacity(0.2),
      child: const CustomCardView(),
    )
    ```
*   **Parameters**:
    *   `maxTiltAngleX`/`Y`: Maximum tilt threshold limits in degrees.
    *   `shadowColor`: Directional backing shadow color.

#### `MotionMorphContainer`
*   **Description**: Interactive geometric container. Animates its boundary sizes, border radii, linear gradients, and back shadows cleanly when layout structures change.
*   **Usage**:
    ```dart
    MotionMorphContainer(
      width: isExpanded ? 240.0 : 100.0,
      height: isExpanded ? 140.0 : 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isExpanded ? 16 : 50),
        color: Colors.indigo,
      ),
      child: widget,
    )
    ```
*   **Parameters**:
    *   `width`/`height`: Layout targets to morph.
    *   `decoration`: Backing border decoration targets.
    *   `child`: Internal child node to swap.

#### `MotionGlassContainer`
*   **Description**: A high-end glassmorphic panel. Implements a frosted backdrop filter and paints dynamic sweeping neon borders. Automatically turns off frosted blurs on low-performance devices to guarantee high refresh rates.
*   **Usage**:
    ```dart
    MotionGlassContainer(
      borderRadius: 16.0,
      blur: 12.0,
      opacity: 0.1,
      borderColors: const [Colors.cyanAccent, Colors.purpleAccent],
      child: const Text('Frosted panel'),
    )
    ```
*   **Parameters**:
    *   `borderRadius`: Rounded boundary radius.
    *   `blur`: Frosted backdrop blur filter intensity.
    *   `opacity`: Backing background opacity scale.
    *   `borderColors`: Neon sweeping border gradient array.

#### `MotionSkeleton`
*   **Description**: Place-holder loading block designed for skeletons. Pulses high-performance neon highlights smoothly.
*   **Usage**:
    ```dart
    // Circular profile
    const MotionSkeleton.circular(size: 40)

    // Rounded rectangle profile
    const MotionSkeleton.rectangle(width: 200, height: 16)
    ```

#### `MotionShimmer`
*   **Description**: Slide sweeping shimmer light. Casts linear sliding highlights from left to right over any widget tree child.
*   **Usage**:
    ```dart
    MotionShimmer(
      child: Container(color: Colors.white, width: 80, height: 12),
    )
    ```

---

### 7. Custom Route Transitions

#### `MotionTransition`
*   **Description**: Helper containing static custom routing transition methods. Swaps scaffolding routes smoothly.
*   **Usage**:
    ```dart
    // 1. Sinusoidal liquid sweeping page transition
    Navigator.push(context, MotionTransition.liquidSwipe(page: const TargetPage()));

    // 2. Sliding Shared Axis page transition
    Navigator.push(context, MotionTransition.sharedAxis(page: const TargetPage(), vertical: true));

    // 3. Frosted glass page overlay transition
    Navigator.push(context, MotionTransition.glassOverlay(page: const TargetPage()));
    ```

---

## ⚙️ Core Controllers & Accessibility

`flutter_motion_kit` manages global settings dynamically through highly performant services:

*   **`MotionController`**
    *   `reducedMotion`: Listens to OS level indicators or manual toggles to reduce physics complexity.
    *   `performanceMode`: Disables expensive blurs or high-density particles to maintain high refresh rates on low-end hardware.
    *   `speedMultiplier`: Multiplies durations dynamically (e.g. `0.5x` slow-mo or `2.0x` rapid speed).
*   **`MotionThemeController`**
    *   `toggleTheme()`: Swaps between dark/light states.
    *   Preset applicators for Cyberpunk, Midnight Gold, and Ultra Violet neon modes.

---

## 🤝 Contributing

We welcome contributions! Please review our [Contributing Guidelines](file:///CONTRIBUTING.md) to maintain standard naming conventions, architecture layouts, and complete verification checklists.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](file:///LICENSE) file for details.
# Flutter-Motion-Kit
# Flutter-Motion-Kit
