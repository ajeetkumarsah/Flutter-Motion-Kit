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


#### 📦 Standard Loaders Grid

Exposes 11 standard high-performance loader presets. You can instantiate them directly (e.g. `MotionDotsLoader(...)`) or through the unified `MotionLoader(type: MotionLoaderType.dots, ...)` constructor.

| standard/dots.mov | standard/typing.mov | standard/pulse.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/standard/dots.mov" width="160" autoplay loop muted playsinline></video><br>**Dots**<br>`MotionDotsLoader` | <video src="assets/loaders/standard/typing.mov" width="160" autoplay loop muted playsinline></video><br>**Typing**<br>`MotionTypingIndicator` | <video src="assets/loaders/standard/pulse.mov" width="160" autoplay loop muted playsinline></video><br>**Pulse**<br>`MotionPulseLoader` |
| **standard/orbit.mov** | **standard/DNA.mov** | **standard/AI.mov** |
| <video src="assets/loaders/standard/orbit.mov" width="160" autoplay loop muted playsinline></video><br>**Orbit**<br>`MotionOrbitLoader` | <video src="assets/loaders/standard/DNA.mov" width="160" autoplay loop muted playsinline></video><br>**DNA**<br>`MotionDnaLoader` | <video src="assets/loaders/standard/AI.mov" width="160" autoplay loop muted playsinline></video><br>**AI**<br>`MotionAiLoader` |
| **standard/liquid.mov** | **standard/wave.mov** | **standard/futuristic.mov** |
| <video src="assets/loaders/standard/liquid.mov" width="160" autoplay loop muted playsinline></video><br>**Liquid**<br>`MotionLiquidLoader` | <video src="assets/loaders/standard/wave.mov" width="160" autoplay loop muted playsinline></video><br>**Wave**<br>`MotionWaveLoader` | <video src="assets/loaders/standard/futuristic.mov" width="160" autoplay loop muted playsinline></video><br>**Futuristic**<br>`MotionFuturisticLoader` |
| **standard/matrix.mov** | **standard/gradient_rotating.mov** | |
| <video src="assets/loaders/standard/matrix.mov" width="160" autoplay loop muted playsinline></video><br>**Matrix**<br>`MotionMatrixLoader` | <video src="assets/loaders/standard/gradient_rotating.mov" width="160" autoplay loop muted playsinline></video><br>**Gradient Rotating**<br>`MotionGradientRotatingLoader` | |

---

### Advanced Category Loaders (60+ Premium Presets)

Exposes named category factory constructors on `MotionLoader` allowing direct, beautifully clean initialization of specialized category families. Below are the grids showcasing all advanced vector loaders, grouped by category.

#### 🧠 AI Category (`MotionLoader.ai`)

| advanced/neural_network.mov | advanced/AI_thinking.mov | advanced/quantum_warp.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/neural_network.mov" width="160" autoplay loop muted playsinline></video><br>**Neural Network**<br>`MotionAiStyle.neuralNetwork` | <video src="assets/loaders/advanced/AI_thinking.mov" width="160" autoplay loop muted playsinline></video><br>**AI Thinking**<br>`MotionAiStyle.thinking` | <video src="assets/loaders/advanced/quantum_warp.mov" width="160" autoplay loop muted playsinline></video><br>**Quantum Warp**<br>`MotionAiStyle.quantum` |
| **advanced/token_stream.mov** | **advanced/token_predictor.mov** | **advanced/neural_pulse.mov** |
| <video src="assets/loaders/advanced/token_stream.mov" width="160" autoplay loop muted playsinline></video><br>**Token Stream**<br>`MotionAiStyle.tokenStream` | <video src="assets/loaders/advanced/token_predictor.mov" width="160" autoplay loop muted playsinline></video><br>**Token Predictor**<br>`MotionAiStyle.tokenPrediction` | <video src="assets/loaders/advanced/neural_pulse.mov" width="160" autoplay loop muted playsinline></video><br>**Neural Pulse**<br>`MotionAiStyle.neuralPulse` |
| **advanced/tensor_data_matrix.mov** | **advanced/scifi_cyber_eye.mov** | |
| <video src="assets/loaders/advanced/tensor_data_matrix.mov" width="160" autoplay loop muted playsinline></video><br>**TensorFlow**<br>`MotionAiStyle.tensorFlow` | <video src="assets/loaders/advanced/scifi_cyber_eye.mov" width="160" autoplay loop muted playsinline></video><br>**AI Cyber Eye**<br>`MotionAiStyle.aiEye` | |

#### 🦾 Cyberpunk Category (`MotionLoader.cyberpunk`)

| advanced/console_boot_terminal.mov | advanced/cyber_spatial_rift.mov | advanced/hud_concentric_ring.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/console_boot_terminal.mov" width="160" autoplay loop muted playsinline></video><br>**Terminal Boot**<br>`MotionCyberpunkStyle.terminalBoot` | <video src="assets/loaders/advanced/cyber_spatial_rift.mov" width="160" autoplay loop muted playsinline></video><br>**Glitch**<br>`MotionCyberpunkStyle.glitch` | <video src="assets/loaders/advanced/hud_concentric_ring.mov" width="160" autoplay loop muted playsinline></video><br>**Cyber Ring HUD**<br>`MotionCyberpunkStyle.cyberRing` |
| **advanced/data_stream_pipes.mov** | **advanced/firewall_scanner_radar.mov** | |
| <video src="assets/loaders/advanced/data_stream_pipes.mov" width="160" autoplay loop muted playsinline></video><br>**Data Stream**<br>`MotionCyberpunkStyle.dataStream` | <video src="assets/loaders/advanced/firewall_scanner_radar.mov" width="160" autoplay loop muted playsinline></video><br>**Firewall Scanner**<br>`MotionCyberpunkStyle.firewallScanner` | |

#### 🧲 Physics Category (`MotionLoader.physics`)

| advanced/newton_pendulum.mov | advanced/bounce_chain.mov | advanced/gravity_orbit.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/newton_pendulum.mov" width="160" autoplay loop muted playsinline></video><br>**Pendulum**<br>`MotionPhysicsStyle.pendulum` | <video src="assets/loaders/advanced/bounce_chain.mov" width="160" autoplay loop muted playsinline></video><br>**Bounce Chain**<br>`MotionPhysicsStyle.bounceChain` | <video src="assets/loaders/advanced/gravity_orbit.mov" width="160" autoplay loop muted playsinline></video><br>**Gravity Orbit**<br>`MotionPhysicsStyle.gravityOrbit` |
| **advanced/falling_hourglass_sand.mov** | **advanced/magnetic_filings.mov** | *No Preview (Asset Missing)* |
| <video src="assets/loaders/advanced/falling_hourglass_sand.mov" width="160" autoplay loop muted playsinline></video><br>**Sand Simulation**<br>`MotionPhysicsStyle.sandSimulation` | <video src="assets/loaders/advanced/magnetic_filings.mov" width="160" autoplay loop muted playsinline></video><br>**Magnetic Field**<br>`MotionPhysicsStyle.magneticField` | **Fluid Particle**<br>`MotionPhysicsStyle.fluidParticle` |

#### 📐 Geometry Category (`MotionLoader.geometry`)

| advanced/impossible_infinity_cube.mov | advanced/honeycomb_radial_wave.mov | advanced/recursive_fractal_tree.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/impossible_infinity_cube.mov" width="160" autoplay loop muted playsinline></video><br>**Infinite Cube**<br>`MotionGeometryStyle.infiniteCube` | <video src="assets/loaders/advanced/honeycomb_radial_wave.mov" width="160" autoplay loop muted playsinline></video><br>**Hexagon Swarm**<br>`MotionGeometryStyle.hexagonSwarm` | <video src="assets/loaders/advanced/recursive_fractal_tree.mov" width="160" autoplay loop muted playsinline></video><br>**Fractal Tree**<br>`MotionGeometryStyle.fractal` |
| **advanced/smooth_polygon_morph.mov** | | |
| <video src="assets/loaders/advanced/smooth_polygon_morph.mov" width="160" autoplay loop muted playsinline></video><br>**Polygon Morph**<br>`MotionGeometryStyle.polygonMorph` | | |

#### 💬 Social Category (`MotionLoader.social`)

| advanced/reels_neon_progress.mov | advanced/live_broadcast_signl.mov | advanced/story_gradient_ring.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/reels_neon_progress.mov" width="160" autoplay loop muted playsinline></video><br>**Reels Upload**<br>`MotionSocialStyle.reelsUpload` | <video src="assets/loaders/advanced/live_broadcast_signl.mov" width="160" autoplay loop muted playsinline></video><br>**Live Stream**<br>`MotionSocialStyle.liveStream` | <video src="assets/loaders/advanced/story_gradient_ring.mov" width="160" autoplay loop muted playsinline></video><br>**Story Ring**<br>`MotionSocialStyle.storyRing` |

#### 📦 3D Category (`MotionLoader.threeD`)

| advanced/3d_parallax_cubes.mov | advanced/stacked_isometric_block.mov | advanced/wire_sphere_landscape.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/3d_parallax_cubes.mov" width="160" autoplay loop muted playsinline></video><br>**Floating Cube**<br>`MotionThreeDStyle.floatingCube` | <video src="assets/loaders/advanced/stacked_isometric_block.mov" width="160" autoplay loop muted playsinline></video><br>**Isometric Blocks**<br>`MotionThreeDStyle.isometric` | <video src="assets/loaders/advanced/wire_sphere_landscape.mov" width="160" autoplay loop muted playsinline></video><br>**Holographic Sphere**<br>`MotionThreeDStyle.holographicSphere` |

#### 🎵 Audio Category (`MotionLoader.audio`)

| advanced/equalizer_sound_freq.mov | advanced/spinning_retro_record.mov | advanced/bass_reactive_curve.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/equalizer_sound_freq.mov" width="160" autoplay loop muted playsinline></video><br>**Equalizer**<br>`MotionAudioStyle.equalizer` | <video src="assets/loaders/advanced/spinning_retro_record.mov" width="160" autoplay loop muted playsinline></video><br>**Retro Vinyl**<br>`MotionAudioStyle.vinyl` | <video src="assets/loaders/advanced/bass_reactive_curve.mov" width="160" autoplay loop muted playsinline></video><br>**Beat Wave**<br>`MotionAudioStyle.beatWave` |

#### 🎨 Artistic Category (`MotionLoader.artistic`)

| advanced/origami_paper_crane.mov | advanced/calligraphy_infinity.mov | *No Preview (Asset Missing)* |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/origami_paper_crane.mov" width="160" autoplay loop muted playsinline></video><br>**Origami**<br>`MotionArtisticStyle.origami` | <video src="assets/loaders/advanced/calligraphy_infinity.mov" width="160" autoplay loop muted playsinline></video><br>**Calligraphy Stroke**<br>`MotionArtisticStyle.calligraphyStroke` | **Zen Circle**<br>`MotionArtisticStyle.zenCircle` |

#### 🌌 Experimental Category (`MotionLoader.experimental`)

| advanced/melting_time_wraop_clock.mov | advanced/sci_fi_energy_portal.mov | advanced/cyber_spatial_rift.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/melting_time_wraop_clock.mov" width="160" autoplay loop muted playsinline></video><br>**Time Warp**<br>`MotionExperimentalStyle.timeWarp` | <video src="assets/loaders/advanced/sci_fi_energy_portal.mov" width="160" autoplay loop muted playsinline></video><br>**Energy Portal**<br>`MotionExperimentalStyle.portal` | <video src="assets/loaders/advanced/cyber_spatial_rift.mov" width="160" autoplay loop muted playsinline></video><br>**Dimensional Rift**<br>`MotionExperimentalStyle.dimensionalRift` |
| **advanced/cosmic_tunnel_stars.mov** | | |
| <video src="assets/loaders/advanced/cosmic_tunnel_stars.mov" width="160" autoplay loop muted playsinline></video><br>**Wormhole**<br>`MotionExperimentalStyle.wormhole` | | |

#### 🌊 Liquid Category (`MotionLoader.liquid`)

| advanced/fluid_attraction.mov | advanced/water_drop_pulse.mov | advanced/ink_spread.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/fluid_attraction.mov" width="160" autoplay loop muted playsinline></video><br>**Lava Lamp**<br>`MotionLiquidStyle.lavaLamp` | <video src="assets/loaders/advanced/water_drop_pulse.mov" width="160" autoplay loop muted playsinline></video><br>**Water Drop**<br>`MotionLiquidStyle.waterDrop` | <video src="assets/loaders/advanced/ink_spread.mov" width="160" autoplay loop muted playsinline></video><br>**Ink Spread**<br>`MotionLiquidStyle.inkSpread` |

#### 🔮 Glass Category (`MotionLoader.glass`)

| advanced/frosted_glass_orb.mov | advanced/prism_crystal.mov | advanced/aurora_mesh.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/frosted_glass_orb.mov" width="160" autoplay loop muted playsinline></video><br>**Glass Orb**<br>`MotionGlassStyle.glassOrb` | <video src="assets/loaders/advanced/prism_crystal.mov" width="160" autoplay loop muted playsinline></video><br>**Prism Crystal**<br>`MotionGlassStyle.prismCrystal` | <video src="assets/loaders/advanced/aurora_mesh.mov" width="160" autoplay loop muted playsinline></video><br>**Aurora Mesh**<br>`MotionGlassStyle.aurora` |

#### 💎 Luxury Category (`MotionLoader.luxury`)

| advanced/prism_shine_diamond.mov | advanced/silk_flow_gradient.mov | advanced/watch_clockwork_gear.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/prism_shine_diamond.mov" width="160" autoplay loop muted playsinline></video><br>**Diamond Spark**<br>`MotionLuxuryStyle.diamondSpark` | <video src="assets/loaders/advanced/silk_flow_gradient.mov" width="160" autoplay loop muted playsinline></video><br>**Silk Flow**<br>`MotionLuxuryStyle.silkFlow` | <video src="assets/loaders/advanced/watch_clockwork_gear.mov" width="160" autoplay loop muted playsinline></video><br>**Premium Watch**<br>`MotionLuxuryStyle.premiumWatch` |
| *No Preview (Asset Missing)* | | |
| **Gold Sweep**<br>`MotionLuxuryStyle.goldSweep` | | |

#### 🎮 Gaming Category (`MotionLoader.gaming`)

| advanced/hero_xp_shield.mov | advanced/magic_runic_ring.mov | advanced/retro_crt_pixel.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/hero_xp_shield.mov" width="160" autoplay loop muted playsinline></video><br>**XP Progress**<br>`MotionGamingStyle.xpProgress` | <video src="assets/loaders/advanced/magic_runic_ring.mov" width="160" autoplay loop muted playsinline></video><br>**Boss Fight**<br>`MotionGamingStyle.bossFight` | <video src="assets/loaders/advanced/retro_crt_pixel.mov" width="160" autoplay loop muted playsinline></video><br>**Retro Pixel**<br>`MotionGamingStyle.pixel` |

#### 📊 SaaS Category (`MotionLoader.saas`)

| advanced/skeleton_grid.mov | advanced/chart_analytics.mov | advanced/sync_cloud_bubbles.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/skeleton_grid.mov" width="160" autoplay loop muted playsinline></video><br>**Pulse Grid**<br>`MotionSaasStyle.pulseGrid` | <video src="assets/loaders/advanced/chart_analytics.mov" width="160" autoplay loop muted playsinline></video><br>**Analytics Chart**<br>`MotionSaasStyle.analytics` | <video src="assets/loaders/advanced/sync_cloud_bubbles.mov" width="160" autoplay loop muted playsinline></video><br>**Cloud Sync**<br>`MotionSaasStyle.cloudSync` |

#### 🌿 Nature Category (`MotionLoader.nature`)

| advanced/glowing_firefly_light.mov | advanced/wind_tornado_dust.mov | *No Preview (Asset Missing)* |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/glowing_firefly_light.mov" width="160" autoplay loop muted playsinline></video><br>**Firefly Glow**<br>`MotionNatureStyle.firefly` | <video src="assets/loaders/advanced/wind_tornado_dust.mov" width="160" autoplay loop muted playsinline></video><br>**Tornado Vortex**<br>`MotionNatureStyle.tornado` | **Volcano**<br>`MotionNatureStyle.volcano` |
| *No Preview (Asset Missing)* | *No Preview (Asset Missing)* | |
| **Leaf Wind**<br>`MotionNatureStyle.leafWind` | **Solar Eclipse**<br>`MotionNatureStyle.solarEclipse` | |

#### 🌌 Space Category (`MotionLoader.space`)

| advanced/black_hole.mov | advanced/glaxy_spiral.mov | advanced/warp_respective.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/black_hole.mov" width="160" autoplay loop muted playsinline></video><br>**Black Hole**<br>`MotionSpaceStyle.blackHole` | <video src="assets/loaders/advanced/glaxy_spiral.mov" width="160" autoplay loop muted playsinline></video><br>**Galaxy**<br>`MotionSpaceStyle.galaxy` | <video src="assets/loaders/advanced/warp_respective.mov" width="160" autoplay loop muted playsinline></video><br>**Warp Speed**<br>`MotionSpaceStyle.warpSpeed` |

#### 📐 Minimal Category (`MotionLoader.minimal`)

| advanced/lemniscate_path.mov | advanced/morphing_shapes.mov | advanced/3d_wave_ribbon.mov |
| :---: | :---: | :---: |
| <video src="assets/loaders/advanced/lemniscate_path.mov" width="160" autoplay loop muted playsinline></video><br>**Line Draw**<br>`MotionMinimalStyle.lineDraw` | <video src="assets/loaders/advanced/morphing_shapes.mov" width="160" autoplay loop muted playsinline></video><br>**Morph Shape**<br>`MotionMinimalStyle.morphShape` | <video src="assets/loaders/advanced/3d_wave_ribbon.mov" width="160" autoplay loop muted playsinline></video><br>**Infinite Ribbon**<br>`MotionMinimalStyle.infiniteRibbon` |

---

### 🎨 Compound Effect Stack System (`MotionBuilder`)

Exposed via `MotionBuilder`, this unified decorator system allows wrapping **any** arbitrary child widget with stackable, GPU-optimized cascading compound visual animations!

- **Usage**:
  ```dart
  MotionBuilder(
    duration: const Duration(seconds: 4),
    effects: const [
      GlowEffect(color: Colors.purple, blurRadius: 16.0),
      FloatEffect(dy: 8.0),
      OrbitEffect(radius: 20.0, speed: 1.2),
    ],
    child: Image.asset('assets/images/logo.png'),
  )
  ```
- **Stackable Effects**:
  - `GlowEffect(Color color, double blurRadius, double spreadRadius)` — Adds a pulsing neon bloom shadow halo behind the child.
  - `FloatEffect(double dy)` — Floats the child vertically up and down in smooth sinusoidal curves.
  - `OrbitEffect(double radius, double speed)` — Orbits the child itself (or nested markers) in a circular path.
  - `RippleEffect(Color color, double maxRadius)` — Shoots multiple expanding circular waves behind the child.
  - `GlitchEffect(double intensity)` — Trigger random RGB digital split distortions and skews for cyberpunk aesthetics.
- **Parameters**:
  - `effects`: A list of [MotionEffect] components to apply sequentially (applied inner-to-outer).
  - `child`: The target widget to compound.
  - `duration`: Central loop duration cycle (default: `3 seconds`).

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

<p align="left">
  <img src="assets/payment_qr.jpg" width="200" alt="Scan to Pay Ajeet Kumar Sah"/>
</p>

Every cup helps keep the screen bright and the code clean!

