# flutter_motion_kit 🚀

[![pub package](https://img.shields.io/pub/v/flutter_motion_kit.svg?logo=dart&logoColor=00C2FF&style=flat-square)](https://pub.dev/packages/flutter_motion_kit)
[![Platform Support](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20macos%20%7C%20windows-blue.svg?style=flat-square)](https://pub.dev/packages/flutter_motion_kit)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square)](LICENSE)

A centralized, production-grade Flutter animation and loader library powered by GetX. Exposes premium loaders, custom-painted skeletons, frosted glassmorphism containers, 3D pointer-tracking cards, liquid-swipe page transitions, and interactive particle background effects under a single unified API.

Designed for high-performance (smooth 60fps/120fps), complete accessibility compliance (vestibular reduce-motion triggers), and absolute ease-of-use.

---

## 🌟 Key Features

- 🎯 **One-Stop Animation Library** — Install **ONLY ONE** package to fulfill all animation, loader, and visual effect needs.
- ⚡ **60fps Production Performance** — Highly optimized rendering utilizing `RepaintBoundary` wrappers and strict ticker management.
- ♿ **Full Accessibility Compliance** — Integrated dynamic fallbacks supporting device-level "Reduce Motion" system configurations.
- 🎨 **Dynamic Theme Presets** — Fluid switching between Cyberpunk, Midnight Gold, Light/Dark Modes, and customized neon gradient borders.
- 🌊 **Advanced Custom Page Transitions** — Build highly custom routes including Shared Axis slides and fluid Liquid Swipes.
- 📦 **Zero Boilerplate API** — Simple, developer-friendly interfaces designed for maximum customization.

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

Here is the complete reference dictionary covering **each and every widget** available in `flutter_motion_kit` along with their key parameters, descriptions, copy-pasteable usage examples, and their visual GIF asset paths.

> [!NOTE]
> All GIF references utilize relative repository paths (`assets/gifs/[widget_name].gif`). When you commit recorded preview GIFs from your emulator into your repository's `assets/gifs/` directory, both GitHub and pub.dev will automatically resolve and display the animated widgets!

---

### 📂 Table of Contents

1. [App-wide Services & Custom Themes](#1-app-wide-services--custom-themes)
2. [Interactive Background Shaders](#2-interactive-background-shaders)
3. [Ecosystem Loaders](#3-ecosystem-loaders) (Standard & Advanced Categories)
4. [Interactive Action Controls](#4-interactive-action-controls)
5. [Micro-Interactions](#5-micro-interactions)
6. [Cards, Morphings, Glass & Placeholders](#6-cards-morphings-glass--placeholders)
7. [Custom Route Transitions](#7-custom-route-transitions)

---

### 1. App-wide Services & Custom Themes

#### `MotionConfigService`

- **Description**: Static engine initialization service. Registers global `MotionController` and `MotionThemeController` to handle user-toggled settings like Speed Multipliers, Reduced Motion overrides, Performance Mode blurs, and presets.
- **Usage**:
  ```dart
  await MotionConfigService.init();
  ```

#### `MotionTheme`

- **Description**: Scope injector for retrieving the active cyberpunk or midnight gold neon themes. Provides dynamic colors and Typography definitions inside the widget tree.
- **Usage**:
  ```dart
  final activeTheme = MotionTheme.of(context);
  Color neonColor = activeTheme.primaryColor;
  ```

---

### 2. Interactive Background Shaders

#### `MotionAuroraBackground`

- **Visual Preview**:
  ![Motion Aurora Background](assets/gifs/motion_aurora_background.gif)
- **Description**: A high-end background layer that renders floating, multi-colored liquid aurora gaseous meshes. Animates dynamically utilizing high-performance sinus shaders with low CPU load.
- **Usage**:
  ```dart
  MotionAuroraBackground(
    child: Center(
      child: Text('Floating on gaseous lights'),
    ),
  )
  ```
- **Parameters**:
  - `child`: Nested overlay content widgets (optional).

#### `MotionParticleBackground`

- **Visual Preview**:
  ![Motion Particle Background](assets/gifs/motion_particle_background.gif)
- **Description**: A live particle physics field. Particles float, bounce, and drift randomly. Interactive tap inputs act as gravity points, drawing particles in before dispersing them outward.
- **Usage**:
  ```dart
  MotionParticleBackground(
    particleColor: Colors.cyanAccent.withValues(alpha:0.4),
    child: const Text('Interactive particle field'),
  )
  ```
- **Parameters**:
  - `particleColor`: Color override for drifting particles (default: `primaryNeon`).
  - `child`: Nested overlay content widgets.

---

### 3. Ecosystem Loaders

All 11 loaders can be resolved dynamically via the unified `MotionLoader` router or instantiated individually. They automatically adapt sizes and margins to prevent layout overflows and respect global speed settings.

#### `MotionLoader` (Unified Router)

- **Visual Preview**:
  ![Unified Motion Loader](assets/gifs/motion_loader.gif)
- **Description**: Centralized loading dispatcher. Resolves and returns any of the 11 loader types based on the `MotionLoaderType` enum.
- **Usage**:
  ```dart
  MotionLoader(
    type: MotionLoaderType.ai,
    color: Colors.purpleAccent,
    size: 48.0,
  )
  ```
- **Parameters**:
  - `type`: Preset loader to use (`dots`, `typing`, `pulse`, `orbit`, `dna`, `ai`, `liquid`, `wave`, `futuristic`, `matrix`, `gradientRotating`).
  - `color`: Loading graphic color.
  - `size`: Bounding box dimensions (width & height).
  - `strokeWidth`: Line stroke dimensions where applicable.

#### `MotionDotsLoader`

- **Visual Preview**:
  ![Motion Dots Loader](assets/gifs/motion_dots_loader.gif)
- **Description**: A horizontal three-dot loading widget. Dots bounce vertically in a sinusoidal wave sequence. Fully wrapped inside a `FittedBox` to guarantee zero layout overflows on tight button bounds.
- **Usage**:
  ```dart
  MotionDotsLoader(
    color: Colors.cyan,
    size: 32.0,
  )
  ```

#### `MotionTypingIndicator`

- **Visual Preview**:
  ![Motion Typing Indicator](assets/gifs/motion_typing_indicator.gif)
- **Description**: A messaging-style bubble typing indicator. Dots scale up/down and fade in/out sequentially, mirroring modern chat activity screens.
- **Usage**:
  ```dart
  MotionTypingIndicator(
    color: Colors.grey,
    size: 28.0,
  )
  ```

#### `MotionPulseLoader`

- **Visual Preview**:
  ![Motion Pulse Loader](assets/gifs/motion_pulse_loader.gif)
- **Description**: Concentric circular rings expanding outwards from a central point. Implements custom opacity fades mimicking radar pings.
- **Usage**:
  ```dart
  MotionPulseLoader(
    color: Colors.tealAccent,
    size: 50.0,
  )
  ```

#### `MotionOrbitLoader`

- **Visual Preview**:
  ![Motion Orbit Loader](assets/gifs/motion_orbit_loader.gif)
- **Description**: A central core nucleus with orbiting planetary satellite nodes revolving in circular patterns. Calculates coordinates dynamically via trigonometry.
- **Usage**:
  ```dart
  MotionOrbitLoader(
    color: Colors.pink,
    size: 40.0,
  )
  ```

#### `MotionDnaLoader`

- **Visual Preview**:
  ![Motion DNA Loader](assets/gifs/motion_dna_loader.gif)
- **Description**: Renders a vertical double-helix strand model. Helix nodes oscillate along sine and cosine curves to project realistic 3D depth perception.
- **Usage**:
  ```dart
  MotionDnaLoader(
    color: Colors.indigoAccent,
    size: 55.0,
  )
  ```

#### `MotionAiLoader`

- **Visual Preview**:
  ![Motion AI Loader](assets/gifs/motion_ai_loader.gif)
- **Description**: Represents a glowing neural intelligence core. Radiant light pulses from the center and sparks secondary brain synapse node connections.
- **Usage**:
  ```dart
  MotionAiLoader(
    color: Colors.cyanAccent,
    size: 60.0,
  )
  ```

#### `MotionLiquidLoader`

- **Visual Preview**:
  ![Motion Liquid Loader](assets/gifs/motion_liquid_loader.gif)
- **Description**: A circular container filled with liquid fluid waves. Waves crest, fill, and slide dynamically using canvas paint curves.
- **Usage**:
  ```dart
  MotionLiquidLoader(
    color: Colors.blueAccent,
    size: 48.0,
  )
  ```

#### `MotionWaveLoader`

- **Visual Preview**:
  ![Motion Wave Loader](assets/gifs/motion_wave_loader.gif)
- **Description**: Five vertical sound-bar graphs oscillating up/down in a clean equalizer pattern. Fully fitted to scale safely on micro-columns.
- **Usage**:
  ```dart
  MotionWaveLoader(
    color: Colors.amber,
    size: 36.0,
  )
  ```

#### `MotionFuturisticLoader`

- **Visual Preview**:
  ![Motion Futuristic Loader](assets/gifs/motion_futuristic_loader.gif)
- **Description**: Renders a circular scifi radar scanning grid. A linear gradient sector sweeps 360 degrees, leaving a fading tracking glow.
- **Usage**:
  ```dart
  MotionFuturisticLoader(
    color: Colors.greenAccent,
    size: 50.0,
  )
  ```

#### `MotionMatrixLoader`

- **Visual Preview**:
  ![Motion Matrix Loader](assets/gifs/motion_matrix_loader.gif)
- **Description**: Cascading green terminal monospace code characters drifting downwards. Translates string drops on individual streams to render high-performance cyber-rain.
- **Usage**:
  ```dart
  MotionMatrixLoader(
    color: Colors.emerald,
    size: 70.0,
  )
  ```

#### `MotionGradientRotatingLoader`

- **Visual Preview**:
  ![Motion Gradient Rotating Loader](assets/gifs/motion_gradient_rotating_loader.gif)
- **Description**: Dual neon arc rings spinning in opposite directions, painted with harmonic sweep gradients.
- **Usage**:
  ```dart
  MotionGradientRotatingLoader(
    color: Colors.deepOrangeAccent,
    size: 45.0,
  )
  ```

---

### Advanced Category Loaders (35+ Premium Presets)

Exposes named category factory constructors on `MotionLoader` allowing direct and beautifully clean initialization of specialized category families.

#### 🧠 AI Category (`MotionLoader.ai`)

- **Visual Preview**:
  ![Motion AI Category Loader](assets/gifs/motion_ai_category.gif)
- **Description**: Sci-fi and machine learning inspired intelligence loaders rendering synaptic networks, Siri/Gemini-style waves, teleporting warp meshes, and real-time terminal token streams.
- **Usage**:
  ```dart
  MotionLoader.ai(
    style: MotionAiStyle.thinking,
    color: MotionColors.primaryNeon,
    size: 60.0,
    glow: true,
  )
  ```
- **Styles (`MotionAiStyle`)**:
  - `neuralNetwork` — Synaptic node linking with moving glowing paths.
  - `thinking` — Morphing siri-style waveforms with breathing tracking dots.
  - `quantum` — Warp particles teleporting in grid formations.
  - `tokenStream` — Monospace terminal character streams simulating LLM tokens.
- **Parameters**:
  - `style`: The active [MotionAiStyle] preset style to render.
  - `color`: Primary color.
  - `size`: Width and height constraints (default: `50.0`).
  - `glow`: Toggles glowing shader borders.
  - `particleCount`: Total synapses (for `neuralNetwork`).

#### 🌊 Liquid Category (`MotionLoader.liquid`)

- **Visual Preview**:
  ![Motion Liquid Category Loader](assets/gifs/motion_liquid_category.gif)
- **Description**: High-end fluid dynamics, organic droplet ripples, and expanding ink diffusion paint structures.
- **Usage**:
  ```dart
  MotionLoader.liquid(
    style: MotionLiquidStyle.lavaLamp,
    color: Colors.pink,
    size: 65.0,
  )
  ```
- **Styles (`MotionLiquidStyle`)**:
  - `lavaLamp` — Floating gooey metaballs morphing and merging together via radial gradient layers.
  - `waterDrop` — Concentric drops landing on surfaces generating expanding refraction waves.
  - `inkSpread` — Radial organic ink splats bleeding and diffusing over backdrops.
- **Parameters**:
  - `style`: The active [MotionLiquidStyle] preset style to render.
  - `color`: Primary fluid color.
  - `size`: Bounding box dimension size (default: `50.0`).

#### 💎 Glassmorphism Category (`MotionLoader.glass`)

- **Visual Preview**:
  ![Motion Glass Category Loader](assets/gifs/motion_glass_category.gif)
- **Description**: Translucent frosted containers, mesh ribbons, and rotating crystal facets with neon border highlights.
- **Usage**:
  ```dart
  MotionLoader.glass(
    style: MotionGlassStyle.prismCrystal,
    color: Colors.cyanAccent,
    size: 60.0,
    glow: true,
  )
  ```
- **Styles (`MotionGlassStyle`)**:
  - `glassOrb` — Frosted glass spheres bouncing and sliding softly inside container boundaries.
  - `prismCrystal` — Rotating 3D octahedron refracting rainbow gradients.
  - `aurora` — Wavy multi-layered smooth northern lights mesh gradients.
- **Parameters**:
  - `style`: The active [MotionGlassStyle] preset style to render.
  - `color`: Frosted highlight overlay color.
  - `size`: Bounding box size (default: `50.0`).
  - `glow`: Enables/disables back-glow shadows.

#### 🌌 Space / Sci-Fi Category (`MotionLoader.space`)

- **Visual Preview**:
  ![Motion Space Category Loader](assets/gifs/motion_space_category.gif)
- **Description**: Gravity vortices, logarithmic rotating galaxies, and star hyperspace speeds.
- **Usage**:
  ```dart
  MotionLoader.space(
    style: MotionSpaceStyle.blackHole,
    color: Colors.amber,
    size: 70.0,
  )
  ```
- **Styles (`MotionSpaceStyle`)**:
  - `blackHole` — Star particles accelerating in a high-gravity spiral vortex into a central dark singularity event horizon.
  - `galaxy` — Kepler speed rotating 3-arm spirals with nebula core gradients and parallax depth.
  - `warpSpeed` — Hyperspace starfields stretching perspective lines outwards exponentially.
- **Parameters**:
  - `style`: The active [MotionSpaceStyle] preset style to render.
  - `color`: Accretion and trail color.
  - `size`: Bounding box dimensions (default: `50.0`).
  - `glow`: Toggles high-intensity core glowing shadows.

#### ⚔️ Gaming Category (`MotionLoader.gaming`)

- **Visual Preview**:
  ![Motion Gaming Category Loader](assets/gifs/motion_gaming_category.gif)
- **Description**: RPG xp gauges, counter-rotating runic spell wheels, and sequence CRT retro pixels.
- **Usage**:
  ```dart
  MotionLoader.gaming(
    style: MotionGamingStyle.bossFight,
    color: Colors.redAccent,
    size: 60.0,
    glow: true,
  )
  ```
- **Styles (`MotionGamingStyle`)**:
  - `xpProgress` — Sweeping circular progress shields with gold sparks and level-up bounce pulses.
  - `bossFight` — Counter-rotating runic circles executing radial shockwave fire particles.
  - `pixel` — Retro CRT scanline grids scaling sequences of glitched 8-bit blocks.
- **Parameters**:
  - `style`: The active [MotionGamingStyle] preset style to render.
  - `color`: Fire energy or grid color.
  - `size`: Bounding box size (default: `50.0`).
  - `glow`: Runic/fire glowing boundary switch.

#### 🧬 Physics Category (`MotionLoader.physics`)

- **Visual Preview**:
  ![Motion Physics Category Loader](assets/gifs/motion_physics_category.gif)
- **Description**: Conservation of momentum swing models, interlocking spring chains, and gravitational orbits.
- **Usage**:
  ```dart
  MotionLoader.physics(
    style: MotionPhysicsStyle.pendulum,
    color: Colors.purple,
    size: 60.0,
  )
  ```
- **Styles (`MotionPhysicsStyle`)**:
  - `pendulum` — Physics-based Newton's Cradle swinging collision momentum.
  - `bounceChain` — Interlocking spring nodes transferring wave pulses.
  - `gravityOrbit` — Planets accelerating eccentric orbits around a high-mass sun core.
- **Parameters**:
  - `style`: The active [MotionPhysicsStyle] preset style to render.
  - `color`: Metal orb or core color.
  - `size`: Bounding box dimension size (default: `50.0`).
  - `glow`: Core/trail orbit glow toggle.

#### ✏️ Minimalist Category (`MotionLoader.minimal`)

- **Visual Preview**:
  ![Motion Minimal Category Loader](assets/gifs/motion_minimal_category.gif)
- **Description**: Infinity line drawings, seamless shape morphings, and waving silk ribbons.
- **Usage**:
  ```dart
  MotionLoader.minimal(
    style: MotionMinimalStyle.lineDraw,
    color: Colors.teal,
    size: 55.0,
    strokeWidth: 4.0,
  )
  ```
- **Styles (`MotionMinimalStyle`)**:
  - `lineDraw` — Self-drawing Lemniscate of Bernoulli infinity loop paths.
  - `morphShape` — Smooth point-by-point vector morphing (Circle ➔ Square ➔ Triangle ➔ Circle).
  - `infiniteRibbon` — Waving curved 3D silk ribbons utilizing phase-shifted sines.
- **Parameters**:
  - `style`: The active [MotionMinimalStyle] preset style to render.
  - `color`: Vector stroke/fill color.
  - `size`: Bounding box size (default: `50.0`).
  - `strokeWidth`: Vector outline thickness (Lemniscate).

#### 📊 SaaS Category (`MotionLoader.saas`)

- **Visual Preview**:
  ![Motion SaaS Category Loader](assets/gifs/motion_saas_category.gif)
- **Description**: Staggered matrix grid skeletons, active analytics charts, and sync arrows inside bezier clouds.
- **Usage**:
  ```dart
  MotionLoader.saas(
    style: MotionSaasStyle.analytics,
    color: Colors.blueAccent,
    size: 60.0,
  )
  ```
- **Styles (`MotionSaasStyle`)**:
  - `pulseGrid` — 3x3 staggered grid skeletons pulsing placeholder opacities.
  - `analytics` — Auto-drawing line chart graphs with traveling active coordinate nodes.
  - `cloudSync` — Cloud contours syncing upload bubbles into central spinning arrows.
- **Parameters**:
  - `style`: The active [MotionSaasStyle] preset style to render.
  - `color`: Accent theme color.
  - `size`: Width and height constraints (default: `50.0`).
  - `glow`: Sync/arrow core glow toggle.

---

### 4. Interactive Action Controls

#### `MotionButton`

- **Visual Preview**:
  ![Motion Button Actions](assets/gifs/motion_button.gif)
- **Description**: A tactile, feedback-rich click action control. Supports magnetic physical pulls, pointer displacement springs, neon glowing blurs, scale bounces, or touch-expanding canvas custom ripples.
- **Usage**:
  ```dart
  MotionButton(
    effect: MotionButtonEffect.ripple,
    color: Colors.cyanAccent,
    onTap: () => print('Button pressed!'),
    child: const Text('Neon Ripple Button'),
  )
  ```
- **Parameters**:
  - `effect`: Bouncing, glowing, or ripple action profile (`MotionButtonEffect`).
  - `color`: Neon glow or ripple accent paint.
  - `onTap`: Callback action triggered upon tap.
  - `child`: Button label text or icons.

#### `MotionExpandableFab`

- **Visual Preview**:
  ![Motion Expandable FAB](assets/gifs/motion_expandable_fab.gif)
- **Description**: Premium Speed Dial Floating Action Button. When tapped, it rolls out a modular fan list of child action options in radial orbits.
- **Usage**:
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
- **Parameters**:
  - `distance`: Radial distance (offset radius) for child buttons.
  - `icon`: Center anchor floating button icon.
  - `children`: Stack of action buttons to expand/reveal.

#### `MotionMorphingButton`

- **Visual Preview**:
  ![Motion Morphing Button](assets/gifs/motion_morphing_button.gif)
- **Description**: An advanced material-state action button. Takes an asynchronous operation, shrinks boundaries, and morphs from a standard button shape into a progress liquid-loader, and subsequently transitions into a success checkmark or error cross.
- **Usage**:
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
- **Parameters**:
  - `width`/`height`: Idle dimensions.
  - `onTap`: Async callback to resolve.
  - `child`: Center label when idle.

#### `MotionRefreshIndicator`

- **Visual Preview**:
  ![Motion Refresh Indicator](assets/gifs/motion_refresh_indicator.gif)
- **Description**: A customized pull-to-refresh list layout. As you pull, it fills up a liquid wave container; when refreshing, it rotates dynamic sci-fi orbits until the async function completes.
- **Usage**:
  ```dart
  MotionRefreshIndicator(
    onRefresh: () async => await fetchNetworkData(),
    child: ListView.builder(
      itemCount: 20,
      itemBuilder: (c, i) => ListTile(title: Text('Row $i')),
    ),
  )
  ```
- **Parameters**:
  - `onRefresh`: Async method representing the network loading action.
  - `child`: Scrollable list view content container.

---

### 5. Micro-Interactions

#### `MotionLikeButton`

- **Visual Preview**:
  ![Motion Like Button](assets/gifs/motion_like_button.gif)
- **Description**: Popping interaction button. Tapping scale-bounces the heart icon and shoots dynamic paint droplets outwards in a circular splash burst.
- **Usage**:
  ```dart
  MotionLikeButton(
    initialLiked: false,
    size: 32.0,
    onChanged: (liked) => print('Liked status: $liked'),
  )
  ```
- **Parameters**:
  - `initialLiked`: Initial state boolean.
  - `size`: Graphic width and height bounds.
  - `onChanged`: Callback reporting new state value.

#### `MotionAnimatedCheckmark`

- **Visual Preview**:
  ![Motion Animated Checkmark](assets/gifs/motion_animated_checkmark.gif)
- **Description**: Smooth vector checkmark draw interaction. Tapping paints a circular baseline and animates the completion of the vector check icon stroke dynamically.
- **Usage**:
  ```dart
  MotionAnimatedCheckmark(
    size: 40.0,
    color: Colors.greenAccent,
  )
  ```
- **Parameters**:
  - `size`: Width/height dimensions.
  - `color`: Stroke outline color.

#### `MotionLiquidToggle`

- **Visual Preview**:
  ![Motion Liquid Toggle](assets/gifs/motion_liquid_toggle.gif)
- **Description**: An organic toggle switch. Sliding changes background colors and applies gaseous liquid distortion filters to boundary shapes as they drag.
- **Usage**:
  ```dart
  MotionLiquidToggle(
    value: false,
    onChanged: (val) => print('Toggle value: $val'),
  )
  ```
- **Parameters**:
  - `value`: True/false state.
  - `onChanged`: Callback reporting updated boolean.

#### `MotionBookmarkButton`

- **Visual Preview**:
  ![Motion Bookmark Button](assets/gifs/motion_bookmark_button.gif)
- **Description**: An elastic ribbon selector interaction. Tapping slides the ribbon down and morphs its geometry from an outline flag to a filled block.
- **Usage**:
  ```dart
  MotionBookmarkButton(
    initialBookmarked: false,
    size: 26.0,
  )
  ```

---

### 6. Cards, Morphings, Glass & Placeholders

#### `MotionCard`

- **Visual Preview**:
  ![Motion Card 3D Tilt](assets/gifs/motion_card.gif)
- **Description**: A 3D pointer-tracking perspective card. Listens to drag gestures (on mobile) or hover movements (on web/desktop) and tilts boundaries in three-dimensional space, projecting a glowing sweeping light reflection.
- **Usage**:
  ```dart
  MotionCard(
    maxTiltAngleX: 12.0,
    maxTiltAngleY: 12.0,
    shadowColor: Colors.purple.withValues(alpha:0.2),
    child: const CustomCardView(),
  )
  ```
- **Parameters**:
  - `maxTiltAngleX`/`Y`: Maximum tilt threshold limits in degrees.
  - `shadowColor`: Directional backing shadow color.

#### `MotionMorphContainer`

- **Visual Preview**:
  ![Motion Morph Container](assets/gifs/motion_morph_container.gif)
- **Description**: Interactive geometric container. Animates its boundary sizes, border radii, linear gradients, and back shadows cleanly when layout structures change.
- **Usage**:
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
- **Parameters**:
  - `width`/`height`: Layout targets to morph.
  - `decoration`: Backing border decoration targets.
  - `child`: Internal child node to swap.

#### `MotionGlassContainer`

- **Visual Preview**:
  ![Motion Glass Container](assets/gifs/motion_glass_container.gif)
- **Description**: A high-end glassmorphic panel. Implements a frosted backdrop filter and paints dynamic sweeping neon borders. Automatically turns off frosted blurs on low-performance devices to guarantee high refresh rates.
- **Usage**:
  ```dart
  MotionGlassContainer(
    borderRadius: 16.0,
    blur: 12.0,
    opacity: 0.1,
    borderColors: const [Colors.cyanAccent, Colors.purpleAccent],
    child: const Text('Frosted panel'),
  )
  ```
- **Parameters**:
  - `borderRadius`: Rounded boundary radius.
  - `blur`: Frosted backdrop blur filter intensity.
  - `opacity`: Backing background opacity scale.
  - `borderColors`: Neon sweeping border gradient array.

#### `MotionSkeleton`

- **Visual Preview**:
  ![Motion Skeleton Glow](assets/gifs/motion_skeleton.gif)
- **Description**: Place-holder loading block designed for skeletons. Pulses high-performance neon highlights smoothly.
- **Usage**:

  ```dart
  // Circular profile
  const MotionSkeleton.circular(size: 40)

  // Rounded rectangle profile
  const MotionSkeleton.rectangle(width: 200, height: 16)
  ```

#### `MotionShimmer`

- **Visual Preview**:
  ![Motion Shimmer Effect](assets/gifs/motion_shimmer.gif)
- **Description**: Slide sweeping shimmer light. Casts linear sliding highlights from left to right over any widget tree child.
- **Usage**:
  ```dart
  MotionShimmer(
    child: Container(color: Colors.white, width: 80, height: 12),
  )
  ```

---

### 7. Custom Route Transitions

#### `MotionTransition`

- **Visual Preview**:
  ![Motion Transition Routes](assets/gifs/motion_transition.gif)
- **Description**: Helper containing static custom routing transition methods. Swaps scaffolding routes smoothly.
- **Usage**:

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

- **`MotionController`**
  - `reducedMotion`: Listens to OS level indicators or manual toggles to reduce physics complexity.
  - `performanceMode`: Disables expensive blurs or high-density particles to maintain high refresh rates on low-end hardware.
  - `speedMultiplier`: Multiplies durations dynamically (e.g. `0.5x` slow-mo or `2.0x` rapid speed).
- **`MotionThemeController`**
  - `toggleTheme()`: Swaps between dark/light states.
  - Preset applicators for Cyberpunk, Midnight Gold, and Ultra Violet neon modes.

---

## 🤝 Contributing

We welcome contributions! Please review our [Contributing Guidelines](CONTRIBUTING.md) to maintain standard naming conventions, architecture layouts, and complete verification checklists.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Ajeet Kumar Sah**
- GitHub: [@ajeetkumarsah](https://github.com/ajeetkumarsah)

---

## ☕ Support the Project

If you love this package and find it helpful, consider supporting the developer:

* **Buy me a Chai or Coffee** ☕
* **UPI ID**: `7761826600@kotak811`

Every cup helps keep the screen bright and the code clean!

