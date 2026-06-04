/// Defines the 20 premium visual animations available for [MotionPullToRefresh].
enum MotionRefreshAnimation {
  /// Droplet stretching vertically and snapping into sinusoidal water waves.
  liquidMorph,

  /// Rocket gradually appearing and launching upwards with particle exhaust.
  rocketLaunch,

  /// Event horizon sucking in spiraling gravity particles and collapsing.
  blackHole,

  /// Double-helix DNA strand oscillating with 3D depth node projections.
  dnaHelix,

  /// Elastic wobbling spring-damped header simulation.
  jellyBounce,

  /// Attracting iron filings and particles radially toward a glowing sphere.
  magneticOrb,

  /// Tracing the Lemniscate of Bernoulli infinity loop with neon glows.
  infinitySymbol,

  /// Upward-spiraling dust and wind particle tornado vortex.
  tornado,

  /// Rising embers merging into a phoenix outline and wingspan flap.
  phoenixRebirth,

  /// Moving synapse nodes drawing animated line segments on proximity.
  neuralNetwork,

  /// Rotating multi-layered concentric scifi depth rings.
  portal,

  /// Procedural interlocking gears rotating with differential gear ratios.
  clockwork,

  /// Fold crease segments morphing into a flying vector origami bird.
  origamiBird,

  /// Branching crackling lightning sparks storing energy and discharging.
  lightningCharge,

  /// Concentric solar rings with planetary nodes orbiting at periodic rates.
  planetOrbit,

  /// Procedural crystal growth mapping branch segments outwards.
  crystalGrowth,

  /// Celebratory fireworks shooting rockets and spawning gravity-dragged embers.
  fireworks,

  /// Expanding radial fluid ink spread lines with variable viscosity.
  inkSpread,

  /// Holographic scrolling scanlines with grid planes and pixel glitches.
  hologram,

  /// Flagship Motion Kit signature particles assembling into the 'M' logo.
  signature,
}

/// Bounding visual layout styles for the pull-to-refresh container.
enum MotionRefreshStyle {
  /// The list view is pushed down organically, leaving a top overscroll gap where the loader renders.
  /// This is standard iOS/bouncing behavior.
  bouncing,

  /// The list view remains static, and the loader floats down from the top, hovering over the content.
  /// This is standard Android/clamping behavior.
  clamping,
}
