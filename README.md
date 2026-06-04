# flutter_motion_kit 🚀

[![pub package](https://img.shields.io/pub/v/flutter_motion_kit.svg?logo=dart&logoColor=00C2FF&style=flat-square)](https://pub.dev/packages/flutter_motion_kit)
[![Platform Support](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20macos%20%7C%20windows-blue.svg?style=flat-square)](https://pub.dev/packages/flutter_motion_kit)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square)](LICENSE)
[![Live Demo](https://img.shields.io/badge/demo-live_preview-success.svg?logo=google-chrome&logoColor=white&style=flat-square)](https://flutter-motion-kit.web.app/)

A centralized, production-grade Flutter animation and loader library powered by GetX. Exposes premium loaders, custom-painted skeletons, frosted glassmorphism containers, 3D pointer-tracking cards, liquid-swipe page transitions, and interactive particle background effects under a single unified API.

<p align="center">
  <a href="https://flutter-motion-kit.web.app/">
    <img src="assets/loaders/live_preview_button.svg" width="320" alt="⚡ Try Interactive Dashboard" />
  </a>
</p>

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

<table>
  <tr>
    <th align="center">standard/dots.gif</th>
    <th align="center">standard/typing.gif</th>
    <th align="center">standard/pulse.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/standard/dots.gif" width="160" /><br><b>Dots</b><br><code>MotionDotsLoader</code></td>
    <td align="center"><img src="assets/loaders/standard/typing.gif" width="160" /><br><b>Typing</b><br><code>MotionTypingIndicator</code></td>
    <td align="center"><img src="assets/loaders/standard/pulse.gif" width="160" /><br><b>Pulse</b><br><code>MotionPulseLoader</code></td>
  </tr>
  <tr>
    <td align="center"><b>standard/orbit.gif</b></td>
    <td align="center"><b>standard/DNA.gif</b></td>
    <td align="center"><b>standard/AI.gif</b></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/standard/orbit.gif" width="160" /><br><b>Orbit</b><br><code>MotionOrbitLoader</code></td>
    <td align="center"><img src="assets/loaders/standard/DNA.gif" width="160" /><br><b>DNA</b><br><code>MotionDnaLoader</code></td>
    <td align="center"><img src="assets/loaders/standard/AI.gif" width="160" /><br><b>AI</b><br><code>MotionAiLoader</code></td>
  </tr>
  <tr>
    <td align="center"><b>standard/liquid.gif</b></td>
    <td align="center"><b>standard/wave.gif</b></td>
    <td align="center"><b>standard/futuristic.gif</b></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/standard/liquid.gif" width="160" /><br><b>Liquid</b><br><code>MotionLiquidLoader</code></td>
    <td align="center"><img src="assets/loaders/standard/wave.gif" width="160" /><br><b>Wave</b><br><code>MotionWaveLoader</code></td>
    <td align="center"><img src="assets/loaders/standard/futuristic.gif" width="160" /><br><b>Futuristic</b><br><code>MotionFuturisticLoader</code></td>
  </tr>
  <tr>
    <td align="center"><b>standard/matrix.gif</b></td>
    <td align="center"><b>standard/gradient_rotating.gif</b></td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/standard/matrix.gif" width="160" /><br><b>Matrix</b><br><code>MotionMatrixLoader</code></td>
    <td align="center"><img src="assets/loaders/standard/gradient_rotating.gif" width="160" /><br><b>Gradient Rotating</b><br><code>MotionGradientRotatingLoader</code></td>
    <td></td>
  </tr>
</table>

---

### Advanced Category Loaders (60+ Premium Presets)

Exposes named category factory constructors on `MotionLoader` allowing direct, beautifully clean initialization of specialized category families. Below are the grids showcasing all advanced vector loaders, grouped by category.

#### 🧠 AI Category (`MotionLoader.ai`)

<table>
  <tr>
    <th align="center">advanced/neural_network.gif</th>
    <th align="center">advanced/AI_thinking.gif</th>
    <th align="center">advanced/quantum_warp.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/neural_network.gif" width="160" /><br><b>Neural Network</b><br><code>MotionAiStyle.neuralNetwork</code></td>
    <td align="center"><img src="assets/loaders/advanced/AI_thinking.gif" width="160" /><br><b>AI Thinking</b><br><code>MotionAiStyle.thinking</code></td>
    <td align="center"><img src="assets/loaders/advanced/quantum_warp.gif" width="160" /><br><b>Quantum Warp</b><br><code>MotionAiStyle.quantum</code></td>
  </tr>
  <tr>
    <td align="center"><b>advanced/token_stream.gif</b></td>
    <td align="center"><b>advanced/token_predictor.gif</b></td>
    <td align="center"><b>advanced/neural_pulse.gif</b></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/token_stream.gif" width="160" /><br><b>Token Stream</b><br><code>MotionAiStyle.tokenStream</code></td>
    <td align="center"><img src="assets/loaders/advanced/token_predictor.gif" width="160" /><br><b>Token Predictor</b><br><code>MotionAiStyle.tokenPrediction</code></td>
    <td align="center"><img src="assets/loaders/advanced/neural_pulse.gif" width="160" /><br><b>Neural Pulse</b><br><code>MotionAiStyle.neuralPulse</code></td>
  </tr>
  <tr>
    <td align="center"><b>advanced/tensor_data_matrix.gif</b></td>
    <td align="center"><b>advanced/scifi_cyber_eye.gif</b></td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/tensor_data_matrix.gif" width="160" /><br><b>TensorFlow</b><br><code>MotionAiStyle.tensorFlow</code></td>
    <td align="center"><img src="assets/loaders/advanced/scifi_cyber_eye.gif" width="160" /><br><b>AI Cyber Eye</b><br><code>MotionAiStyle.aiEye</code></td>
    <td></td>
  </tr>
</table>

#### 🦾 Cyberpunk Category (`MotionLoader.cyberpunk`)

<table>
  <tr>
    <th align="center">advanced/console_boot_terminal.gif</th>
    <th align="center">advanced/cyber_spatial_rift.gif</th>
    <th align="center">advanced/hud_concentric_ring.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/console_boot_terminal.gif" width="160" /><br><b>Terminal Boot</b><br><code>MotionCyberpunkStyle.terminalBoot</code></td>
    <td align="center"><img src="assets/loaders/advanced/cyber_spatial_rift.gif" width="160" /><br><b>Glitch</b><br><code>MotionCyberpunkStyle.glitch</code></td>
    <td align="center"><img src="assets/loaders/advanced/hud_concentric_ring.gif" width="160" /><br><b>Cyber Ring HUD</b><br><code>MotionCyberpunkStyle.cyberRing</code></td>
  </tr>
  <tr>
    <td align="center"><b>advanced/data_stream_pipes.gif</b></td>
    <td align="center"><b>advanced/firewall_scanner_radar.gif</b></td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/data_stream_pipes.gif" width="160" /><br><b>Data Stream</b><br><code>MotionCyberpunkStyle.dataStream</code></td>
    <td align="center"><img src="assets/loaders/advanced/firewall_scanner_radar.gif" width="160" /><br><b>Firewall Scanner</b><br><code>MotionCyberpunkStyle.firewallScanner</code></td>
    <td></td>
  </tr>
</table>

#### 🧲 Physics Category (`MotionLoader.physics`)

<table>
  <tr>
    <th align="center">advanced/newton_pendulum.gif</th>
    <th align="center">advanced/bounce_chain.gif</th>
    <th align="center">advanced/gravity_orbit.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/newton_pendulum.gif" width="160" /><br><b>Pendulum</b><br><code>MotionPhysicsStyle.pendulum</code></td>
    <td align="center"><img src="assets/loaders/advanced/bounce_chain.gif" width="160" /><br><b>Bounce Chain</b><br><code>MotionPhysicsStyle.bounceChain</code></td>
    <td align="center"><img src="assets/loaders/advanced/gravity_orbit.gif" width="160" /><br><b>Gravity Orbit</b><br><code>MotionPhysicsStyle.gravityOrbit</code></td>
  </tr>
  <tr>
    <td align="center"><b>advanced/falling_hourglass_sand.gif</b></td>
    <td align="center"><b>advanced/magnetic_filings.gif</b></td>
    <td align="center"><i>No Preview (Asset Missing)</i></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/falling_hourglass_sand.gif" width="160" /><br><b>Sand Simulation</b><br><code>MotionPhysicsStyle.sandSimulation</code></td>
    <td align="center"><img src="assets/loaders/advanced/magnetic_filings.gif" width="160" /><br><b>Magnetic Field</b><br><code>MotionPhysicsStyle.magneticField</code></td>
    <td align="center"><b>Fluid Particle</b><br><code>MotionPhysicsStyle.fluidParticle</code></td>
  </tr>
</table>

#### 📐 Geometry Category (`MotionLoader.geometry`)

<table>
  <tr>
    <th align="center">advanced/impossible_infinity_cube.gif</th>
    <th align="center">advanced/honeycomb_radial_wave.gif</th>
    <th align="center">advanced/recursive_fractal_tree.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/impossible_infinity_cube.gif" width="160" /><br><b>Infinite Cube</b><br><code>MotionGeometryStyle.infiniteCube</code></td>
    <td align="center"><img src="assets/loaders/advanced/honeycomb_radial_wave.gif" width="160" /><br><b>Hexagon Swarm</b><br><code>MotionGeometryStyle.hexagonSwarm</code></td>
    <td align="center"><img src="assets/loaders/advanced/recursive_fractal_tree.gif" width="160" /><br><b>Fractal Tree</b><br><code>MotionGeometryStyle.fractal</code></td>
  </tr>
  <tr>
    <td align="center"><b>advanced/smooth_polygon_morph.gif</b></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/smooth_polygon_morph.gif" width="160" /><br><b>Polygon Morph</b><br><code>MotionGeometryStyle.polygonMorph</code></td>
    <td></td>
    <td></td>
  </tr>
</table>

#### 💬 Social Category (`MotionLoader.social`)

<table>
  <tr>
    <th align="center">advanced/reels_neon_progress.gif</th>
    <th align="center">advanced/live_broadcast_signl.gif</th>
    <th align="center">advanced/story_gradient_ring.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/reels_neon_progress.gif" width="160" /><br><b>Reels Upload</b><br><code>MotionSocialStyle.reelsUpload</code></td>
    <td align="center"><img src="assets/loaders/advanced/live_broadcast_signl.gif" width="160" /><br><b>Live Stream</b><br><code>MotionSocialStyle.liveStream</code></td>
    <td align="center"><img src="assets/loaders/advanced/story_gradient_ring.gif" width="160" /><br><b>Story Ring</b><br><code>MotionSocialStyle.storyRing</code></td>
  </tr>
</table>

#### 📦 3D Category (`MotionLoader.threeD`)

<table>
  <tr>
    <th align="center">advanced/3d_parallax_cubes.gif</th>
    <th align="center">advanced/stacked_isometric_block.gif</th>
    <th align="center">advanced/wire_sphere_landscape.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/3d_parallax_cubes.gif" width="160" /><br><b>Floating Cube</b><br><code>MotionThreeDStyle.floatingCube</code></td>
    <td align="center"><img src="assets/loaders/advanced/stacked_isometric_block.gif" width="160" /><br><b>Isometric Blocks</b><br><code>MotionThreeDStyle.isometric</code></td>
    <td align="center"><img src="assets/loaders/advanced/wire_sphere_landscape.gif" width="160" /><br><b>Holographic Sphere</b><br><code>MotionThreeDStyle.holographicSphere</code></td>
  </tr>
</table>

#### 🎵 Audio Category (`MotionLoader.audio`)

<table>
  <tr>
    <th align="center">advanced/equalizer_sound_freq.gif</th>
    <th align="center">advanced/spinning_retro_record.gif</th>
    <th align="center">advanced/bass_reactive_curve.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/equalizer_sound_freq.gif" width="160" /><br><b>Equalizer</b><br><code>MotionAudioStyle.equalizer</code></td>
    <td align="center"><img src="assets/loaders/advanced/spinning_retro_record.gif" width="160" /><br><b>Retro Vinyl</b><br><code>MotionAudioStyle.vinyl</code></td>
    <td align="center"><img src="assets/loaders/advanced/bass_reactive_curve.gif" width="160" /><br><b>Beat Wave</b><br><code>MotionAudioStyle.beatWave</code></td>
  </tr>
</table>

#### 🎨 Artistic Category (`MotionLoader.artistic`)

<table>
  <tr>
    <th align="center">advanced/origami_paper_crane.gif</th>
    <th align="center">advanced/calligraphy_infinity.gif</th>
    <th align="center"><i>No Preview (Asset Missing)</i></th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/origami_paper_crane.gif" width="160" /><br><b>Origami</b><br><code>MotionArtisticStyle.origami</code></td>
    <td align="center"><img src="assets/loaders/advanced/calligraphy_infinity.gif" width="160" /><br><b>Calligraphy Stroke</b><br><code>MotionArtisticStyle.calligraphyStroke</code></td>
    <td align="center"><b>Zen Circle</b><br><code>MotionArtisticStyle.zenCircle</code></td>
  </tr>
</table>

#### 🌌 Experimental Category (`MotionLoader.experimental`)

<table>
  <tr>
    <th align="center">advanced/melting_time_wraop_clock.gif</th>
    <th align="center">advanced/sci_fi_energy_portal.gif</th>
    <th align="center">advanced/cyber_spatial_rift.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/melting_time_wraop_clock.gif" width="160" /><br><b>Time Warp</b><br><code>MotionExperimentalStyle.timeWarp</code></td>
    <td align="center"><img src="assets/loaders/advanced/sci_fi_energy_portal.gif" width="160" /><br><b>Energy Portal</b><br><code>MotionExperimentalStyle.portal</code></td>
    <td align="center"><img src="assets/loaders/advanced/cyber_spatial_rift.gif" width="160" /><br><b>Dimensional Rift</b><br><code>MotionExperimentalStyle.dimensionalRift</code></td>
  </tr>
  <tr>
    <td align="center"><b>advanced/cosmic_tunnel_stars.gif</b></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/cosmic_tunnel_stars.gif" width="160" /><br><b>Wormhole</b><br><code>MotionExperimentalStyle.wormhole</code></td>
    <td></td>
    <td></td>
  </tr>
</table>

#### 🌊 Liquid Category (`MotionLoader.liquid`)

<table>
  <tr>
    <th align="center">advanced/fluid_attraction.gif</th>
    <th align="center">advanced/water_drop_pulse.gif</th>
    <th align="center">advanced/ink_spread.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/fluid_attraction.gif" width="160" /><br><b>Lava Lamp</b><br><code>MotionLiquidStyle.lavaLamp</code></td>
    <td align="center"><img src="assets/loaders/advanced/water_drop_pulse.gif" width="160" /><br><b>Water Drop</b><br><code>MotionLiquidStyle.waterDrop</code></td>
    <td align="center"><img src="assets/loaders/advanced/ink_spread.gif" width="160" /><br><b>Ink Spread</b><br><code>MotionLiquidStyle.inkSpread</code></td>
  </tr>
</table>

#### 🔮 Glass Category (`MotionLoader.glass`)

<table>
  <tr>
    <th align="center">advanced/frosted_glass_orb.gif</th>
    <th align="center">advanced/prism_crystal.gif</th>
    <th align="center">advanced/aurora_mesh.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/frosted_glass_orb.gif" width="160" /><br><b>Glass Orb</b><br><code>MotionGlassStyle.glassOrb</code></td>
    <td align="center"><img src="assets/loaders/advanced/prism_crystal.gif" width="160" /><br><b>Prism Crystal</b><br><code>MotionGlassStyle.prismCrystal</code></td>
    <td align="center"><img src="assets/loaders/advanced/aurora_mesh.gif" width="160" /><br><b>Aurora Mesh</b><br><code>MotionGlassStyle.aurora</code></td>
  </tr>
</table>

#### 💎 Luxury Category (`MotionLoader.luxury`)

<table>
  <tr>
    <th align="center">advanced/prism_shine_diamond.gif</th>
    <th align="center">advanced/silk_flow_gradient.gif</th>
    <th align="center">advanced/watch_clockwork_gear.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/prism_shine_diamond.gif" width="160" /><br><b>Diamond Spark</b><br><code>MotionLuxuryStyle.diamondSpark</code></td>
    <td align="center"><img src="assets/loaders/advanced/silk_flow_gradient.gif" width="160" /><br><b>Silk Flow</b><br><code>MotionLuxuryStyle.silkFlow</code></td>
    <td align="center"><img src="assets/loaders/advanced/watch_clockwork_gear.gif" width="160" /><br><b>Premium Watch</b><br><code>MotionLuxuryStyle.premiumWatch</code></td>
  </tr>
  <tr>
    <td align="center"><i>No Preview (Asset Missing)</i></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><b>Gold Sweep</b><br><code>MotionLuxuryStyle.goldSweep</code></td>
    <td></td>
    <td></td>
  </tr>
</table>

#### 🎮 Gaming Category (`MotionLoader.gaming`)

<table>
  <tr>
    <th align="center">advanced/hero_xp_shield.gif</th>
    <th align="center">advanced/magic_runic_ring.gif</th>
    <th align="center">advanced/retro_crt_pixel.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/hero_xp_shield.gif" width="160" /><br><b>XP Progress</b><br><code>MotionGamingStyle.xpProgress</code></td>
    <td align="center"><img src="assets/loaders/advanced/magic_runic_ring.gif" width="160" /><br><b>Boss Fight</b><br><code>MotionGamingStyle.bossFight</code></td>
    <td align="center"><img src="assets/loaders/advanced/retro_crt_pixel.gif" width="160" /><br><b>Retro Pixel</b><br><code>MotionGamingStyle.pixel</code></td>
  </tr>
</table>

#### 📊 SaaS Category (`MotionLoader.saas`)

<table>
  <tr>
    <th align="center">advanced/skeleton_grid.gif</th>
    <th align="center">advanced/chart_analytics.gif</th>
    <th align="center">advanced/sync_cloud_bubbles.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/skeleton_grid.gif" width="160" /><br><b>Pulse Grid</b><br><code>MotionSaasStyle.pulseGrid</code></td>
    <td align="center"><img src="assets/loaders/advanced/chart_analytics.gif" width="160" /><br><b>Analytics Chart</b><br><code>MotionSaasStyle.analytics</code></td>
    <td align="center"><img src="assets/loaders/advanced/sync_cloud_bubbles.gif" width="160" /><br><b>Cloud Sync</b><br><code>MotionSaasStyle.cloudSync</code></td>
  </tr>
</table>

#### 🌿 Nature Category (`MotionLoader.nature`)

<table>
  <tr>
    <th align="center">advanced/glowing_firefly_light.gif</th>
    <th align="center">advanced/wind_tornado_dust.gif</th>
    <th align="center"><i>No Preview (Asset Missing)</i></th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/glowing_firefly_light.gif" width="160" /><br><b>Firefly Glow</b><br><code>MotionNatureStyle.firefly</code></td>
    <td align="center"><img src="assets/loaders/advanced/wind_tornado_dust.gif" width="160" /><br><b>Tornado Vortex</b><br><code>MotionNatureStyle.tornado</code></td>
    <td align="center"><b>Volcano</b><br><code>MotionNatureStyle.volcano</code></td>
  </tr>
  <tr>
    <td align="center"><i>No Preview (Asset Missing)</i></td>
    <td align="center"><i>No Preview (Asset Missing)</i></td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><b>Leaf Wind</b><br><code>MotionNatureStyle.leafWind</code></td>
    <td align="center"><b>Solar Eclipse</b><br><code>MotionNatureStyle.solarEclipse</code></td>
    <td></td>
  </tr>
</table>

#### 🌌 Space Category (`MotionLoader.space`)

<table>
  <tr>
    <th align="center">advanced/black_hole.gif</th>
    <th align="center">advanced/glaxy_spiral.gif</th>
    <th align="center">advanced/warp_respective.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/black_hole.gif" width="160" /><br><b>Black Hole</b><br><code>MotionSpaceStyle.blackHole</code></td>
    <td align="center"><img src="assets/loaders/advanced/glaxy_spiral.gif" width="160" /><br><b>Galaxy</b><br><code>MotionSpaceStyle.galaxy</code></td>
    <td align="center"><img src="assets/loaders/advanced/warp_respective.gif" width="160" /><br><b>Warp Speed</b><br><code>MotionSpaceStyle.warpSpeed</code></td>
  </tr>
</table>

#### 📐 Minimal Category (`MotionLoader.minimal`)

<table>
  <tr>
    <th align="center">advanced/lemniscate_path.gif</th>
    <th align="center">advanced/morphing_shapes.gif</th>
    <th align="center">advanced/3d_wave_ribbon.gif</th>
  </tr>
  <tr>
    <td align="center"><img src="assets/loaders/advanced/lemniscate_path.gif" width="160" /><br><b>Line Draw</b><br><code>MotionMinimalStyle.lineDraw</code></td>
    <td align="center"><img src="assets/loaders/advanced/morphing_shapes.gif" width="160" /><br><b>Morph Shape</b><br><code>MotionMinimalStyle.morphShape</code></td>
    <td align="center"><img src="assets/loaders/advanced/3d_wave_ribbon.gif" width="160" /><br><b>Infinite Ribbon</b><br><code>MotionMinimalStyle.infiniteRibbon</code></td>
  </tr>
</table>

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

#### `MotionPullToRefresh`

- **Description**: Next-generation, high-performance pull-to-refresh wrapper exposing 20 premium visual custom-painted animations. Supports physics-based bouncing and clamping styles, custom hold delays, haptics, and adaptive dark/light themes.
- **Usage**:
  ```dart
  MotionPullToRefresh(
    animation: MotionRefreshAnimation.liquidMorph,
    onRefresh: () async {
      await Future.delayed(const Duration(seconds: 2));
    },
    child: ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
    ),
  )
  ```
- **Parameters**:
  - `onRefresh`: The asynchronous callback task triggered upon release.
  - `animation`: The active `MotionRefreshAnimation` layout preset indicator to render.
  - `refreshDuration`: The minimum duration the indicator remains visible (defaults to `3 seconds`).
  - `collapseDuration`: The duration taken to smoothly slide up/collapse after refresh completes.
  - `style`: The visual layout style (`bouncing` or `clamping`).
  - `showStatusText`: Toggles rendering of helper text (e.g. "PULL TO REFRESH").
  - `enableHaptics`: Toggles vibration feedback.

---

### 🎨 20 Refresh Indicator Animations Preview

#### 🌊 Fluid & Nature Preset Grid

| **Liquid Morph** | **Tornado** | **Ink Spread** |
| :---: | :---: | :---: |
| <img src="assets/refresh/liquid_morph.gif" width="160" /><br>`liquidMorph` | <img src="assets/refresh/tornado.gif" width="160" /><br>`tornado` | <img src="assets/refresh/ink_spread.gif" width="160" /><br>`inkSpread` |
| **Crystal Growth** | **Phoenix Rebirth** | |
| <img src="assets/refresh/crystal_growth.gif" width="160" /><br>`crystalGrowth` | <img src="assets/refresh/phoenix_rebirth.gif" width="160" /><br>`phoenixRebirth` | |

#### 🌌 Cosmic & Gravitational Preset Grid

| **Black Hole** | **Planet Orbit** | **Magnetic Orb** |
| :---: | :---: | :---: |
| <img src="assets/refresh/black_hole.gif" width="160" /><br>`blackHole` | <img src="assets/refresh/planet_orbit.gif" width="160" /><br>`planetOrbit` | <img src="assets/refresh/magnetic_orb.gif" width="160" /><br>`magneticOrb` |
| **Portal** | | |
| <img src="assets/refresh/portal.gif" width="160" /><br>`portal` | | |

#### 🦾 Technical & Flagship Preset Grid

| **Rocket Launch** | **DNA Helix** | **Jelly Bounce** |
| :---: | :---: | :---: |
| <img src="assets/refresh/rocket_laungh.gif" width="160" /><br>`rocketLaunch` | <img src="assets/refresh/dna_helix.gif" width="160" /><br>`dnaHelix` | <img src="assets/refresh/jelly_bounce.gif" width="160" /><br>`jellyBounce` |
| **Infinity Symbol** | **Neural Network** | **Clockwork** |
| <img src="assets/refresh/infinity_symbol.gif" width="160" /><br>`infinitySymbol` | <img src="assets/refresh/neural_network.gif" width="160" /><br>`neuralNetwork` | <img src="assets/refresh/clockwork.gif" width="160" /><br>`clockwork` |
| **Origami Bird** | **Lightning Charge** | **Fireworks** |
| <img src="assets/refresh/origami_bird.gif" width="160" /><br>`origamiBird` | <img src="assets/refresh/lighting_charge.gif" width="160" /><br>`lightningCharge` | <img src="assets/refresh/firework.gif" width="160" /><br>`fireworks` |
| **Hologram** | **Signature** | |
| <img src="assets/refresh/hologram.gif" width="160" /><br>`hologram` | <img src="assets/refresh/signature.gif" width="160" /><br>`signature` | |

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
  ![Motion Transition Routes](assets/loaders/transition_effects.gif)
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

