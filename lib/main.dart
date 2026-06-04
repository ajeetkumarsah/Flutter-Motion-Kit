import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Import our central exports
import 'flutter_motion_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inject and initialize central GetX controllers
  await MotionConfigService.init();

  runApp(const MotionShowcaseApp());
}

class MotionShowcaseApp extends StatelessWidget {
  const MotionShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<MotionThemeController>();

    return Obx(() {
      return MaterialApp(
        title: 'MotionKit Pro Showcase',
        debugShowCheckedModeBanner: false,
        theme: themeController.theme.toThemeData(),
        home: const ShowcaseDashboard(),
      );
    });
  }
}

class ShowcaseDashboard extends StatefulWidget {
  const ShowcaseDashboard({super.key});

  @override
  State<ShowcaseDashboard> createState() => _ShowcaseDashboardState();
}

class _ShowcaseDashboardState extends State<ShowcaseDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTab = 0;
  int _activeBgType = 1; // 0: None, 1: Particles, 2: Aurora

  // Pull-To-Refresh Customizations
  MotionRefreshAnimation _selectedRefreshAnim =
      MotionRefreshAnimation.liquidMorph;
  double _refreshParticles = 20.0;
  double _refreshGlow = 6.0;
  double _refreshSpeed = 1.0;
  bool _showRefreshStatusText = true;
  double _refreshHoldSeconds = 3.0;
  MotionRefreshStyle _selectedRefreshStyle = MotionRefreshStyle.bouncing;

  // Loader Customizations
  MotionLoaderType _selectedLoaderType = MotionLoaderType.ai;
  Color _loaderColor = MotionColors.primaryNeon;
  double _loaderSize = 60.0;
  bool _useAdvancedLoaders = false;
  int _selectedAdvancedIndex = 0;
// In your parent State class
  final ScrollController _scrollController = ScrollController();

  static const List<Map<String, String>> _advancedLoadersMeta = [
    {'category': 'AI', 'style': 'neuralNetwork', 'label': 'NEURAL NETWORK'},
    {'category': 'AI', 'style': 'thinking', 'label': 'AI THINKING'},
    {'category': 'AI', 'style': 'quantum', 'label': 'QUANTUM WARP'},
    {'category': 'AI', 'style': 'tokenStream', 'label': 'TOKEN STREAM'},
    {'category': 'AI', 'style': 'tokenPrediction', 'label': 'TOKEN PREDICTOR'},
    {'category': 'AI', 'style': 'neuralPulse', 'label': 'NEURAL PULSE'},
    {'category': 'AI', 'style': 'tensorFlow', 'label': 'TENSOR DATA MATRIX'},
    {'category': 'AI', 'style': 'aiEye', 'label': 'SCIFI CYBER EYE'},
    {'category': 'LIQUID', 'style': 'lavaLamp', 'label': 'LAVA LAMP'},
    {'category': 'LIQUID', 'style': 'waterDrop', 'label': 'WATER DROP RIPPLE'},
    {'category': 'LIQUID', 'style': 'inkSpread', 'label': 'INK SPREAD'},
    {'category': 'GLASS', 'style': 'glassOrb', 'label': 'FROSTED GLASS ORB'},
    {'category': 'GLASS', 'style': 'prismCrystal', 'label': 'PRISM CRYSTAL'},
    {'category': 'GLASS', 'style': 'aurora', 'label': 'AURORA MESH'},
    {'category': 'SPACE', 'style': 'blackHole', 'label': 'BLACK HOLE'},
    {'category': 'SPACE', 'style': 'galaxy', 'label': 'GALAXY SPIRAL'},
    {'category': 'SPACE', 'style': 'warpSpeed', 'label': 'WARP PERSPECTIVE'},
    {'category': 'GAMING', 'style': 'xpProgress', 'label': 'HERO XP SHIELD'},
    {'category': 'GAMING', 'style': 'bossFight', 'label': 'MAGIC RUNIC RING'},
    {'category': 'GAMING', 'style': 'pixel', 'label': 'RETRO CRT PIXEL'},
    {'category': 'PHYSICS', 'style': 'pendulum', 'label': 'NEWTON PENDULUM'},
    {'category': 'PHYSICS', 'style': 'bounceChain', 'label': 'BOUNCE CHAIN'},
    {'category': 'PHYSICS', 'style': 'gravityOrbit', 'label': 'GRAVITY ORBIT'},
    {
      'category': 'PHYSICS',
      'style': 'fluidParticle',
      'label': 'FLUID ATTRACTION'
    },
    {
      'category': 'PHYSICS',
      'style': 'sandSimulation',
      'label': 'FALLING HOURGLASS SAND'
    },
    {
      'category': 'PHYSICS',
      'style': 'magneticField',
      'label': 'MAGNETIC FILINGS'
    },
    {'category': 'MINIMAL', 'style': 'lineDraw', 'label': 'LEMNISCATE PATH'},
    {'category': 'MINIMAL', 'style': 'morphShape', 'label': 'MORPHING SHAPES'},
    {
      'category': 'MINIMAL',
      'style': 'infiniteRibbon',
      'label': '3D WAVE RIBBON'
    },
    {'category': 'SAAS', 'style': 'pulseGrid', 'label': 'SKELETON GRID'},
    {'category': 'SAAS', 'style': 'analytics', 'label': 'CHART ANALYTICS'},
    {'category': 'SAAS', 'style': 'cloudSync', 'label': 'SYNC CLOUD BUBBLES'},
    {
      'category': 'CYBERPUNK',
      'style': 'terminalBoot',
      'label': 'CONSOLE BOOT TERMINAL'
    },
    {'category': 'CYBERPUNK', 'style': 'glitch', 'label': 'RGB CYBER GLITCH'},
    {
      'category': 'CYBERPUNK',
      'style': 'cyberRing',
      'label': 'HUD CONCENTRIC RING'
    },
    {
      'category': 'CYBERPUNK',
      'style': 'dataStream',
      'label': 'DATA STREAM PIPES'
    },
    {
      'category': 'CYBERPUNK',
      'style': 'firewallScanner',
      'label': 'FIREWALL SCANNER RADAR'
    },
    {
      'category': 'NATURE',
      'style': 'firefly',
      'label': 'GLOWING FIREFLY LIGHTS'
    },
    {'category': 'NATURE', 'style': 'tornado', 'label': 'WIND TORNADO DUST'},
    {
      'category': 'NATURE',
      'style': 'volcano',
      'label': 'MOLTEN MAGMA ERUPTION'
    },
    {
      'category': 'NATURE',
      'style': 'leafWind',
      'label': 'FALLING AUTUMN LEAVES'
    },
    {
      'category': 'NATURE',
      'style': 'solarEclipse',
      'label': 'SOLAR ECLIPSE CORONA'
    },
    {
      'category': 'LUXURY',
      'style': 'diamondSpark',
      'label': 'PRISM SHINE DIAMOND'
    },
    {'category': 'LUXURY', 'style': 'silkFlow', 'label': 'SILK FLOW GRADIENT'},
    {'category': 'LUXURY', 'style': 'goldSweep', 'label': 'GOLD BAR SHIMMER'},
    {
      'category': 'LUXURY',
      'style': 'premiumWatch',
      'label': 'WATCH CLOCKWORK GEAR'
    },
    {
      'category': 'GEOMETRY',
      'style': 'infiniteCube',
      'label': 'IMPOSSIBLE INFINITY CUBE'
    },
    {
      'category': 'GEOMETRY',
      'style': 'hexagonSwarm',
      'label': 'HONEYCOMB RADIAL WAVE'
    },
    {
      'category': 'GEOMETRY',
      'style': 'fractal',
      'label': 'RECURSIVE FRACTAL TREE'
    },
    {
      'category': 'GEOMETRY',
      'style': 'polygonMorph',
      'label': 'SMOOTH POLYGON MORPH'
    },
    {
      'category': 'SOCIAL',
      'style': 'reelsUpload',
      'label': 'REELS NEON PROGRESS'
    },
    {
      'category': 'SOCIAL',
      'style': 'liveStream',
      'label': 'LIVE BROADCAST SIGNAL'
    },
    {
      'category': 'SOCIAL',
      'style': 'storyRing',
      'label': 'STORY GRADIENT RING'
    },
    {
      'category': 'THREED',
      'style': 'floatingCube',
      'label': '3D PARALLAX CUBES'
    },
    {
      'category': 'THREED',
      'style': 'isometric',
      'label': 'STACKED ISOMETRIC BLOCK'
    },
    {
      'category': 'THREED',
      'style': 'holographicSphere',
      'label': 'WIRE SPHERE LANDSCAPE'
    },
    {
      'category': 'AUDIO',
      'style': 'equalizer',
      'label': 'EQUALIZER SOUND FREQ'
    },
    {'category': 'AUDIO', 'style': 'vinyl', 'label': 'SPINNING RETRO RECORD'},
    {'category': 'AUDIO', 'style': 'beatWave', 'label': 'BASS REACTIVE CURVE'},
    {
      'category': 'ARTISTIC',
      'style': 'zenCircle',
      'label': 'ENSO ZEN BRUSH STROKE'
    },
    {
      'category': 'ARTISTIC',
      'style': 'origami',
      'label': 'ORIGAMI PAPER CRANE'
    },
    {
      'category': 'ARTISTIC',
      'style': 'calligraphyStroke',
      'label': 'CALLIGRAPHY INFINITY'
    },
    {
      'category': 'EXPERIMENTAL',
      'style': 'timeWarp',
      'label': 'MELTING TIME WARP CLOCK'
    },
    {
      'category': 'EXPERIMENTAL',
      'style': 'portal',
      'label': 'SCI-FI ENERGY PORTAL'
    },
    {
      'category': 'EXPERIMENTAL',
      'style': 'dimensionalRift',
      'label': 'CYBER SPATIAL RIFT'
    },
    {
      'category': 'EXPERIMENTAL',
      'style': 'wormhole',
      'label': 'COSMIC TUNNEL STARS'
    },
  ];

  Widget _buildAdvancedLoaderItem(int index) {
    if (index < 0 || index >= _advancedLoadersMeta.length) {
      return Container();
    }
    final meta = _advancedLoadersMeta[index];
    final category = meta['category']!.toLowerCase();
    final style = meta['style']!;
    return MotionLoader.generator(
      category: category,
      style: style,
      color: _loaderColor,
      size: _loaderSize,
    );
  }

  Widget _buildAdvancedLoaderItemPreview(int index, Color color) {
    if (index < 0 || index >= _advancedLoadersMeta.length) {
      return Container();
    }
    final meta = _advancedLoadersMeta[index];
    final category = meta['category']!.toLowerCase();
    final style = meta['style']!;
    return MotionLoader.generator(
      category: category,
      style: style,
      color: color,
      size: 28,
      glow: false,
    );
  }

  Widget _buildPresetToggleBtn(bool targetValue, String label) {
    final active = _useAdvancedLoaders == targetValue;
    final primaryColor = Get.find<MotionThemeController>().theme.primaryColor;
    return InkWell(
      onTap: () => setState(() => _useAdvancedLoaders = targetValue),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? primaryColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? primaryColor : Colors.white24,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: active ? primaryColor : Colors.grey[400],
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // Morph widget configuration
  int _morphStep = 0;

  // Fake system monitoring
  double _fps = 60.0;
  late Timer _fpsTimer;

  @override
  void initState() {
    super.initState();
    // Simulate real-time rendering statistics
    _fpsTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() {
          _fps = 58.0 + (math.Random().nextDouble() * 2.0);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fpsTimer.cancel();
    super.dispose();
  }

  // Helper to generate the preview code snippet
  String _generateLoaderCode() {
    final colorStr = _loaderColor == MotionColors.primaryNeon
        ? 'MotionColors.primaryNeon'
        : _loaderColor == Colors.amber
            ? 'Colors.amber'
            : _loaderColor == Colors.redAccent
                ? 'Colors.redAccent'
                : _loaderColor == Colors.cyanAccent
                    ? 'Colors.cyanAccent'
                    : 'Colors.white';

    if (_useAdvancedLoaders) {
      final meta = _advancedLoadersMeta[_selectedAdvancedIndex];
      final styleEnum =
          'Motion${meta['category']!.substring(0, 1)}${meta['category']!.substring(1).toLowerCase()}Style';
      return '''
MotionLoader.${meta['category']!.toLowerCase()}(
  style: $styleEnum.${meta['style']},
  color: $colorStr,
  size: ${_loaderSize.round()}.0,
)
''';
    }

    return '''
MotionLoader(
  type: MotionLoaderType.${_selectedLoaderType.name},
  color: $colorStr,
  size: ${_loaderSize.round()}.0,
)
''';
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = MotionTheme.of(context);
    final motion = Get.find<MotionController>();
    final themeController = Get.find<MotionThemeController>();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    final isTablet = screenWidth >= 900 && screenWidth < 1250;

    Widget backgroundWidget;
    if (_activeBgType == 1) {
      backgroundWidget = const MotionParticleBackground();
    } else if (_activeBgType == 2) {
      backgroundWidget = const MotionAuroraBackground();
    } else {
      backgroundWidget = Container(color: activeTheme.backgroundColor);
    }

    return Scaffold(
      key: _scaffoldKey,
      // On narrow viewports, sidebar and customize panels slide out as Drawers
      drawer: isMobile
          ? Drawer(
              backgroundColor: activeTheme.backgroundColor,
              child: _buildSidebar(activeTheme, themeController),
            )
          : null,
      endDrawer: (isMobile || isTablet)
          ? Drawer(
              backgroundColor: activeTheme.backgroundColor,
              child: _buildControlPanel(activeTheme, motion, themeController),
            )
          : null,
      body: Stack(
        children: [
          // Dynamic particle or aurora active backgrounds
          Positioned.fill(child: backgroundWidget),

          // Main horizontal page layout
          SafeArea(
            child: Row(
              children: [
                // 1. Sidebar Navigation (Static on Desktop, Drawer on Mobile)
                if (!isMobile) _buildSidebar(activeTheme, themeController),

                // 2. Main content panels
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Responsive Dashboard Header
                        _buildHeader(activeTheme, motion, isMobile, isTablet),
                        const SizedBox(height: 16),

                        // Active Tab Screen wrapped in glass container
                        Expanded(
                          child: MotionGlassContainer(
                            borderRadius: 24,
                            blur: 16,
                            opacity: activeTheme.isDark ? 0.06 : 0.4,
                            padding: const EdgeInsets.all(16.0),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: _buildSelectedTabScreen(activeTheme,
                                  motion, themeController, screenWidth),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Right Customization Sidebar (Static on wide Desktop, Drawer on Tablet/Mobile)
                if (!isMobile && !isTablet)
                  _buildControlPanel(activeTheme, motion, themeController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Layout (Fully scrollable & overflow immune)
  Widget _buildSidebar(
      MotionThemeData activeTheme, MotionThemeController themeController) {
    final isDark = activeTheme.isDark;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: activeTheme.surfaceColor.withValues(alpha: isDark ? 0.4 : 0.8),
        border: Border(
          right: BorderSide(
            color: activeTheme.primaryColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cyberpunk Logo
          _buildLogo(activeTheme),
          const SizedBox(height: 24),

          // Menu navigation options (Vertically scrollable)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSidebarItem(0, 'Dashboard Home',
                      Icons.space_dashboard_rounded, activeTheme),
                  _buildSidebarItem(1, 'Loaders Playground',
                      Icons.donut_large_rounded, activeTheme),
                  _buildSidebarItem(2, 'Buttons & Clicks',
                      Icons.ads_click_rounded, activeTheme),
                  _buildSidebarItem(
                      3, 'Cards & Skeletons', Icons.style_rounded, activeTheme),
                  _buildSidebarItem(4, 'Transitions & Morphs',
                      Icons.transform_rounded, activeTheme),
                  _buildSidebarItem(
                      5, 'Pull-To-Refresh', Icons.refresh_rounded, activeTheme),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Active Background Selector (Locked at the bottom)
          _buildBgSelector(activeTheme),
        ],
      ),
    );
  }

  Widget _buildLogo(MotionThemeData activeTheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: activeTheme.accentGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.blur_on, color: Colors.black, size: 22),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MOTIONKIT',
              style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: activeTheme.primaryColor,
                  shadows: [
                    if (activeTheme.glowEffect)
                      Shadow(
                        color: activeTheme.primaryColor.withValues(alpha: 0.8),
                        blurRadius: 10,
                      )
                  ]),
            ),
            const Text(
              'Ecosystem v1.0',
              style: TextStyle(
                  fontSize: 9, color: Colors.grey, letterSpacing: 1.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBgSelector(MotionThemeData activeTheme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BACKGROUND SHADER',
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBgButton(0, 'Void', activeTheme),
              _buildBgButton(1, 'Particles', activeTheme),
              _buildBgButton(2, 'Aurora', activeTheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
      int index, String title, IconData icon, MotionThemeData activeTheme) {
    final selected = _selectedTab == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() => _selectedTab = index);
          // Close drawer on tap on mobile
          if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
            Navigator.pop(context);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: selected ? activeTheme.accentGradient : null,
            color: selected ? null : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? Colors.black : Colors.grey,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? Colors.black : Colors.grey[400],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBgButton(int type, String label, MotionThemeData activeTheme) {
    final active = _activeBgType == type;
    return InkWell(
      onTap: () => setState(() => _activeBgType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: active ? activeTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: active ? Colors.black : Colors.white70,
          ),
        ),
      ),
    );
  }

  // Dashboard Header with Responsive drawer buttons
  Widget _buildHeader(MotionThemeData activeTheme, MotionController motion,
      bool isMobile, bool isTablet) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isVerySmall = screenWidth < 385;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hamburger menu button on mobile
              if (isMobile)
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 22),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),

              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedTab == 0
                          ? 'Core Monitoring'
                          : _selectedTab == 1
                              ? 'Loaders Lab'
                              : _selectedTab == 2
                                  ? 'Micro-Interactions'
                                  : _selectedTab == 3
                                      ? '3D Tilt & Skeletons'
                                      : 'Routes & Morphs',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isMobile)
                      Text(
                        'Real-time simulation engine running at 60fps',
                        style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Live stats panel & Customize Drawer trigger
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isVerySmall) ...[
              _buildStatChip('FPS', '${_fps.toStringAsFixed(1)} Hz',
                  Colors.green, isMobile),
              const SizedBox(width: 6),
            ],
            _buildStatChip(
              'SPEED',
              '${motion.speedMultiplier.toStringAsFixed(1)}x',
              motion.speedMultiplier != 1.0 ? Colors.amber : Colors.blue,
              isMobile,
            ),

            // Customize trigger button for Tablet/Mobile
            if (isMobile || isTablet)
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: IconButton(
                  icon: const Icon(Icons.tune_rounded,
                      color: Colors.white, size: 22),
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatChip(
      String label, String value, Color color, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          if (!isMobile)
            Text(
              '$label: ',
              style: const TextStyle(
                  fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  // Selected Screen Generator (Responsive layout routing)
  Widget _buildSelectedTabScreen(
      MotionThemeData activeTheme,
      MotionController motion,
      MotionThemeController themeController,
      double width) {
    switch (_selectedTab) {
      case 0:
        return _buildDashboardHome(activeTheme, motion, width);
      case 1:
        return _buildLoadersPlayground(activeTheme, width);
      case 2:
        return _buildButtonsPlayground(activeTheme, width);
      case 3:
        return _buildCardsPlayground(activeTheme, width);
      case 4:
        return _buildTransitionsPlayground(activeTheme, width);
      case 5:
        return _buildRefreshPlayground(activeTheme, width);
      default:
        return const SizedBox.shrink();
    }
  }

  // Tab 0: Home Overview
  Widget _buildDashboardHome(MotionThemeData activeTheme,
      MotionController motion, double screenWidth) {
    final useColumnLayout = screenWidth < 900;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        // Intro Showcase Box
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                activeTheme.primaryColor.withValues(alpha: 0.15),
                activeTheme.secondaryColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: activeTheme.primaryColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CENTRALIZED FLUTTER MOTION ECOSYSTEM',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: activeTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'One Single Package. Zero Performance Overhead.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This package acts as a centralized animation platform. Combining micro-interactions, responsive tap engines, fluid page transitions, glassmorphic filters, and AI computing animations under one consistent, accessibility-aware state management layer driven exclusively by GetX.',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey[300], height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick feature stats grids (Responsive wrapping to prevent overflows)
        GridView.count(
          crossAxisCount: useColumnLayout ? 1 : 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          childAspectRatio: useColumnLayout ? 2.5 : 1.6,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildFeatureStatsCard(
                '11 beautiful custom loaders',
                'Ready to deploy including futuristic AI scan and custom falling code matrix.',
                Icons.donut_large,
                activeTheme),
            _buildFeatureStatsCard(
                'Accessibility Compliant',
                'Dynamic listeners support "Reduce Motion" system triggers, mapping heavy items instantly.',
                Icons.accessibility_new,
                activeTheme),
            _buildFeatureStatsCard(
                '3D Canvas Tilt & Glass',
                'Physical models transforming on 3D perspective grids during pointer updates.',
                Icons.filter_hdr_outlined,
                activeTheme),
          ],
        ),
        const SizedBox(height: 16),

        // Micro features check lists
        if (useColumnLayout) ...[
          _buildEcosystemDirectivesBox(),
          const SizedBox(height: 16),
          _buildAccessibilityGuidelinesBox(),
        ] else
          Row(
            children: [
              Expanded(child: _buildEcosystemDirectivesBox()),
              const SizedBox(width: 16),
              Expanded(child: _buildAccessibilityGuidelinesBox()),
            ],
          )
      ],
    );
  }

  Widget _buildEcosystemDirectivesBox() {
    return MotionGlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ecosystem Directives',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 12),
          _buildCheckRow('GetX Central Controllers',
              'Inject theme, toggles, performance mode, and speeds globally.'),
          _buildCheckRow('Repaint Boundaries',
              'Constrained nodes avoiding full tree calculations.'),
          _buildCheckRow('No Placeholder Policy',
              'Complete live painters driving the canvas directly.'),
        ],
      ),
    );
  }

  Widget _buildAccessibilityGuidelinesBox() {
    return MotionGlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Accessibility Guidelines',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 12),
          _buildCheckRow('Scale Fallback',
              'Ticking speeds fall to zero scaling for vestibular conditions.'),
          _buildCheckRow('Low Memory Shader scaling',
              'Disables blurs for low-spec performance configurations.'),
          _buildCheckRow('Flexible curves',
              'Easily tweak elastic bounce behaviors in real time.'),
        ],
      ),
    );
  }

  Widget _buildFeatureStatsCard(
      String title, String desc, IconData icon, MotionThemeData activeTheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: activeTheme.primaryColor, size: 20),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style:
                TextStyle(fontSize: 10, color: Colors.grey[400], height: 1.3),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckRow(String label, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.cyan, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(desc,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Tab 1: Loaders Playground (Fully responsive, overflow-free)
  Widget _buildLoadersPlayground(
      MotionThemeData activeTheme, double screenWidth) {
    final useVerticalLayout = screenWidth < 950;

    if (useVerticalLayout) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Grid selection wrapper with explicit height
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Animation Preset',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPresetToggleBtn(false, 'STANDARD'),
                    const SizedBox(width: 4),
                    _buildPresetToggleBtn(true, 'ADVANCED'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: _buildLoadersGrid(activeTheme),
            ),
            const SizedBox(height: 20),

            // Live config and codes
            const Text(
              'Live Renderer & Configurator',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 460,
              child: _buildLoadersConfig(activeTheme),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        // 1. Grid of loaders selection
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Animation Preset',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPresetToggleBtn(false, 'STANDARD'),
                      const SizedBox(width: 8),
                      _buildPresetToggleBtn(true, 'ADVANCED (35+ EXTRAS)'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildLoadersGrid(activeTheme),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),

        // 2. Active Preview & live configs
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Live Renderer & Configurator',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildLoadersConfig(activeTheme),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildLoadersGrid(MotionThemeData activeTheme) {
    if (_useAdvancedLoaders) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.3,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: _advancedLoadersMeta.length,
        itemBuilder: (context, index) {
          final meta = _advancedLoadersMeta[index];
          final active = _selectedAdvancedIndex == index;

          return InkWell(
            onTap: () => setState(() => _selectedAdvancedIndex = index),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: active
                    ? activeTheme.primaryColor.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? activeTheme.primaryColor : Colors.white10,
                  width: active ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: _buildAdvancedLoaderItemPreview(index,
                          active ? activeTheme.primaryColor : Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meta['label']!,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: active ? activeTheme.primaryColor : Colors.white70,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.3,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: MotionLoaderType.values.length,
      itemBuilder: (context, index) {
        final type = MotionLoaderType.values[index];
        final active = _selectedLoaderType == type;

        return InkWell(
          onTap: () => setState(() => _selectedLoaderType = type),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: active
                  ? activeTheme.primaryColor.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: active ? activeTheme.primaryColor : Colors.white10,
                width: active ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: MotionLoader(
                      type: type,
                      color:
                          active ? activeTheme.primaryColor : Colors.grey[500],
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  type.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: active ? activeTheme.primaryColor : Colors.white70,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadersConfig(MotionThemeData activeTheme) {
    return Column(
      children: [
        // Live Preview Canvas
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: _useAdvancedLoaders
                        ? _buildAdvancedLoaderItem(_selectedAdvancedIndex)
                        : MotionLoader(
                            type: _selectedLoaderType,
                            color: _loaderColor,
                            size: _loaderSize,
                          ),
                  ),
                ),
                const SizedBox(height: 10),

                // Config controls with wrapped layout to prevent overflows
                Row(
                  children: [
                    const Text('Size: ',
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Expanded(
                      child: Slider(
                        value: _loaderSize,
                        min: 30,
                        max: 100,
                        activeColor: activeTheme.primaryColor,
                        onChanged: (val) => setState(() => _loaderSize = val),
                      ),
                    ),
                    Text('${_loaderSize.round()}px',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'monospace')),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('Color: ',
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                    _buildColorDot(MotionColors.primaryNeon),
                    _buildColorDot(Colors.amber),
                    _buildColorDot(Colors.redAccent),
                    _buildColorDot(Colors.cyanAccent),
                    _buildColorDot(Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Monospace Code output panel
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'INTEGRATION CODE',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                            letterSpacing: 0.5),
                      ),
                      MotionMorphingButton(
                        width: 70,
                        height: 24,
                        borderRadius: 6,
                        color: Colors.white12,
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: _generateLoaderCode()));
                          await Future.delayed(const Duration(
                              milliseconds: 600)); // mock copy delay
                        },
                        child: const Text('COPY',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _generateLoaderCode(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: Colors.lightGreenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildColorDot(Color col) {
    final active = _loaderColor == col;
    return InkWell(
      onTap: () => setState(() => _loaderColor = col),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: col,
          shape: BoxShape.circle,
          border: Border.all(
            color: active ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  // Tab 2: Buttons & Clicks (Responsive layout with Wrap or stacks to avoid overflows)
  Widget _buildButtonsPlayground(
      MotionThemeData activeTheme, double screenWidth) {
    final useVerticalLayout = screenWidth < 900;

    final demo1 = _buildClickDemoBox(
      'Scale On Tap Effect',
      'Pills compress scale down by 7% gracefully on pointer contacts, resuming elastic bounds on release.',
      MotionButton(
        effect: MotionButtonEffect.scale,
        onTap: () {},
        child: const Text('Scale Trigger',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 12)),
      ),
      activeTheme,
    );

    final demo2 = _buildClickDemoBox(
      'Neon Glow Blur Shadow',
      'Surrounds border bounds with glowing blurred radius, fading away if accessibility reduces motion.',
      MotionButton(
        effect: MotionButtonEffect.glow,
        onTap: () {},
        child: const Text('Glow Trigger',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 12)),
      ),
      activeTheme,
    );

    final demo3 = _buildClickDemoBox(
      'Custom Expanding Ripple',
      'Intercepts local pointer events, drawing expanding high-contrast fills outwards from the exact click origin.',
      MotionButton(
        effect: MotionButtonEffect.ripple,
        onTap: () {},
        child: const Text('Ripple Trigger',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 12)),
      ),
      activeTheme,
    );

    final demo4 = _buildClickDemoBox(
      'Pointer Magnetic Pulling',
      'Calculates finger displacement vector against center point, translating the matrix physically toward pointer.',
      MotionButton(
        effect: MotionButtonEffect.magnetic,
        onTap: () {},
        child: const Text('Magnetic Pull',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 12)),
      ),
      activeTheme,
    );

    final morphingAndMicro = useVerticalLayout
        ? Column(
            children: [
              _buildMorphingButtonSimulationBox(activeTheme),
              const SizedBox(height: 16),
              _buildMicroInteractionsBox(),
            ],
          )
        : Row(
            children: [
              Expanded(child: _buildMorphingButtonSimulationBox(activeTheme)),
              const SizedBox(width: 16),
              Expanded(child: _buildMicroInteractionsBox()),
            ],
          );

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const Text(
          'Dynamic Responsive Clicks',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),

        if (useVerticalLayout) ...[
          demo1,
          const SizedBox(height: 12),
          demo2,
          const SizedBox(height: 12),
          demo3,
          const SizedBox(height: 12),
          demo4,
        ] else ...[
          Row(
            children: [
              Expanded(child: demo1),
              const SizedBox(width: 12),
              Expanded(child: demo2),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: demo3),
              const SizedBox(width: 12),
              Expanded(child: demo4),
            ],
          ),
        ],
        const SizedBox(height: 20),

        // Morphing and Micro-interactions
        morphingAndMicro,
      ],
    );
  }

  Widget _buildMorphingButtonSimulationBox(MotionThemeData activeTheme) {
    return MotionGlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('State-Morphing Button (API Simulator)',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 6),
          const Text(
              'Tapping initiates simulated async operations, morphing layout into loaders, checkmarks or failure crosses.',
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              MotionMorphingButton(
                width: 130,
                height: 40,
                borderRadius: 10,
                onTap: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
                child: const Text('Success Morph',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              MotionMorphingButton(
                width: 130,
                height: 40,
                borderRadius: 10,
                color: Colors.deepPurple,
                onTap: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  throw Exception("Mock API Error");
                },
                child: const Text('Error Morph',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicroInteractionsBox() {
    return MotionGlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Interactive Micro-Interactions',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _buildMicroDot('Heart Burst', const MotionLikeButton(size: 28)),
              _buildMicroDot('Checkmark',
                  StatefulBuilder(builder: (context, setState) {
                bool checked = false;
                return InkWell(
                  onTap: () => setState(() => checked = !checked),
                  child: MotionAnimatedCheckmark(checked: checked, size: 28),
                );
              })),
              _buildMicroDot('Bookmark', const MotionBookmarkButton(size: 28)),
              _buildMicroDot('Liquid Switch',
                  StatefulBuilder(builder: (context, setState) {
                bool toggled = false;
                return MotionLiquidToggle(
                  initialValue: toggled,
                  onChanged: (val) => toggled = val,
                );
              })),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicroDot(String label, Widget child) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          child,
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontSize: 9, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildClickDemoBox(
      String title, String desc, Widget btn, MotionThemeData activeTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Text(desc,
              style: TextStyle(
                  fontSize: 10, color: Colors.grey[400], height: 1.3)),
          const SizedBox(height: 16),
          Center(child: btn),
        ],
      ),
    );
  }

  // Tab 3: Cards & Skeletons (Responsive wrapper to prevent overflows)
  Widget _buildCardsPlayground(
      MotionThemeData activeTheme, double screenWidth) {
    final useVerticalLayout = screenWidth < 950;

    if (useVerticalLayout) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _build3DCardSection(activeTheme),
            const SizedBox(height: 24),
            _buildSkeletonsSection(activeTheme),
          ],
        ),
      );
    }

    return Row(
      children: [
        // 1. 3D Tilt Card preview
        Expanded(
          flex: 4,
          child: _build3DCardSection(activeTheme),
        ),
        const SizedBox(width: 20),

        // 2. Shimmer & Skeletons Live presets
        Expanded(
          flex: 3,
          child: _buildSkeletonsSection(activeTheme),
        )
      ],
    );
  }

  Widget _build3DCardSection(MotionThemeData activeTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('3D Perspective Canvas Tilt Card',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 4),
        const Text(
            'Drag pointer or mouse across the container below to tilt the card on Z-axis coordinates.',
            style: TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 20),
        Center(
          child: MotionCard(
            maxTiltAngleX: 18,
            maxTiltAngleY: 18,
            elevation: 10,
            borderRadius: 24,
            shadowColor: activeTheme.primaryColor.withValues(alpha: 0.25),
            child: Container(
              width: 300,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    activeTheme.primaryColor.withValues(alpha: 0.7),
                    activeTheme.secondaryColor.withValues(alpha: 0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('MOTIONKIT PLATINUM',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.black)),
                      Icon(Icons.nfc, color: Colors.black, size: 20),
                    ],
                  ),
                  Spacer(),
                  Text('4000 1284 5691 0032',
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1.5)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CARD HOLDER',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold)),
                          Text('ELON MUSK',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EXPIRES',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold)),
                          Text('12/32',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonsSection(MotionThemeData activeTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Unified Shimmer Skeletons',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 12),
        Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text('PROFILE LAYOUT PRESET',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ),
                MotionSkeleton.profile(avatarSize: 50.0),
                const Divider(color: Colors.white10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text('CHAT INTERACTIVE PRESET',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ),
                MotionSkeleton.chat(),
                const Divider(color: Colors.white10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text('CARD PREVIEW PRESET',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ),
                MotionSkeleton.card(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Tab 4: Page Transitions & Morphs (Responsive vertical stacking)
  Widget _buildTransitionsPlayground(
      MotionThemeData activeTheme, double screenWidth) {
    final useVerticalLayout = screenWidth < 950;

    if (useVerticalLayout) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildMorphSection(activeTheme),
            const SizedBox(height: 24),
            _buildTransitionsSection(activeTheme),
          ],
        ),
      );
    }

    return Row(
      children: [
        // 1. Morph widget
        Expanded(
          flex: 4,
          child: _buildMorphSection(activeTheme),
        ),
        const SizedBox(width: 20),

        // 2. Page transition routers list
        Expanded(
          flex: 3,
          child: _buildTransitionsSection(activeTheme),
        )
      ],
    );
  }

  Widget _buildMorphSection(MotionThemeData activeTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shape & Layout Morphing',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 4),
        const Text(
            'Transition boundary shapes and internal child widgets dynamically with curves.',
            style: TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 16),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MotionMorphContainer(
                width: _morphStep == 0
                    ? 110.0
                    : _morphStep == 1
                        ? 260.0
                        : 220.0,
                height: _morphStep == 0
                    ? 110.0
                    : _morphStep == 1
                        ? 70.0
                        : 160.0,
                duration: const Duration(milliseconds: 550),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _morphStep == 0
                        ? 55.0
                        : _morphStep == 1
                            ? 12.0
                            : 20.0,
                  ),
                  gradient: LinearGradient(
                    colors: _morphStep == 0
                        ? [Colors.tealAccent, Colors.cyan]
                        : _morphStep == 1
                            ? [Colors.pinkAccent, Colors.purple]
                            : [Colors.amber, Colors.orangeAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_morphStep == 0
                              ? Colors.cyan
                              : _morphStep == 1
                                  ? Colors.pinkAccent
                                  : Colors.amber)
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: _buildMorphChild(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeTheme.primaryColor,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    _morphStep = (_morphStep + 1) % 3;
                  });
                },
                child: const Text('TRIGGER SHAPE MORPH',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransitionsSection(MotionThemeData activeTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Premium Custom Page Routes',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 12),
        Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTransitionRouteBtn('Symmetrical Fade transition', () {
                Navigator.push(
                    context,
                    MotionTransition.fade(
                        page: const SecondarySamplePage(title: 'Fade Route')));
              }),
              _buildTransitionRouteBtn('Swift Slide offset transition', () {
                Navigator.push(
                    context,
                    MotionTransition.slideRight(
                        page: const SecondarySamplePage(title: 'Slide Route')));
              }),
              _buildTransitionRouteBtn('Springy Zoom transition', () {
                Navigator.push(
                    context,
                    MotionTransition.zoom(
                        page: const SecondarySamplePage(title: 'Zoom Route')));
              }),
              _buildTransitionRouteBtn('Cyber Glass Overlay Backdrop blur', () {
                Navigator.push(
                    context,
                    MotionTransition.glassOverlay(
                        page: const SecondarySamplePage(
                            title: 'Glass Blur Overlay', hasScaffold: false)));
              }),
              _buildTransitionRouteBtn('Shared Axis fading sliding', () {
                Navigator.push(
                    context,
                    MotionTransition.sharedAxis(
                        page: const SecondarySamplePage(
                            title: 'Shared Axis Route'),
                        vertical: true));
              }),
              _buildTransitionRouteBtn('Fluid Liquid wave swipe sweep', () {
                Navigator.push(
                    context,
                    MotionTransition.liquidSwipe(
                        page: const SecondarySamplePage(
                            title: 'Liquid Sweep Route')));
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMorphChild() {
    switch (_morphStep) {
      case 0:
        return const Center(
          key: ValueKey('c0'),
          child: Icon(Icons.face_retouching_natural,
              size: 40, color: Colors.black87),
        );
      case 1:
        return const Center(
          key: ValueKey('c1'),
          child: Text(
            'SLIDE OVER BANNER',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Colors.white,
                fontFamily: 'monospace'),
          ),
        );
      case 2:
        return const Padding(
          key: ValueKey('c2'),
          padding: EdgeInsets.all(12.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.credit_card, size: 36, color: Colors.black87),
                SizedBox(height: 6),
                Text(
                  'MEMBER ACCESS',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Colors.black87),
                ),
                Text(
                  'ID: 993-841-A2',
                  style: TextStyle(
                      fontSize: 9,
                      color: Colors.black54,
                      fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTransitionRouteBtn(String label, VoidCallback routeTrigger) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          foregroundColor: Colors.cyan,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: routeTrigger,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 12, color: Colors.white60),
          ],
        ),
      ),
    );
  }

  // Right Side global animation configuration console (Scrollable vertically, overflow immune)
  Widget _buildControlPanel(MotionThemeData activeTheme,
      MotionController motion, MotionThemeController themeController) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: activeTheme.surfaceColor
            .withValues(alpha: activeTheme.isDark ? 0.4 : 0.8),
        border: Border(
          left: BorderSide(
            color: activeTheme.primaryColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune_rounded, color: Colors.amber, size: 18),
              SizedBox(width: 8),
              Text(
                'MOTION CONSOLE',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                    letterSpacing: 1.0),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Scrollable Settings List
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Speed Multiplier
                  _buildConsoleSlider(
                    'ANIMATION SPEED MULTIPLIER',
                    motion.speedMultiplier,
                    0.1,
                    3.0,
                    (val) => motion.setSpeedMultiplier(val),
                    '${motion.speedMultiplier.toStringAsFixed(1)}x',
                  ),
                  const SizedBox(height: 20),

                  // Accessibility features
                  const Text(
                    'ACCESSIBILITY OPTIONS',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 10),
                  _buildToggleRow(
                    'Reduce Motion',
                    'Vestibular crossfade overrides',
                    motion.reducedMotion,
                    (val) => motion.setReducedMotion(val),
                  ),
                  const SizedBox(height: 10),
                  _buildToggleRow(
                    'Performance Mode',
                    'Saves resource consumption',
                    motion.performanceMode,
                    (val) => motion.setPerformanceMode(val),
                  ),
                  const SizedBox(height: 10),
                  _buildToggleRow(
                    'Active Glows',
                    'Glow filters on surfaces',
                    themeController.glowEffect,
                    (val) => themeController.setGlowEffect(val),
                  ),
                  const SizedBox(height: 20),

                  // Presets Toggles
                  const Text(
                    'THEMATIC PRESETS',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 10),
                  _buildPresetBtn(
                      'Cyberpunk Pink Neon',
                      () => themeController.applyCyberpunkPreset(),
                      activeTheme),
                  const SizedBox(height: 6),
                  _buildPresetBtn(
                      'Gold Amber Midnight',
                      () => themeController.applyMidnightPresets(),
                      activeTheme),
                  const SizedBox(height: 6),
                  _buildPresetBtn(
                      'Ultra Violet Purple',
                      () => themeController.applyNeonPurplePreset(),
                      activeTheme),
                  const SizedBox(height: 6),
                  _buildPresetBtn(
                      'Clean Standard Light',
                      () => themeController.setTheme(MotionThemeData.light()),
                      activeTheme),
                  const SizedBox(height: 6),
                  _buildPresetBtn(
                      'Clean Midnight Dark',
                      () => themeController.setTheme(MotionThemeData.dark()),
                      activeTheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsoleSlider(String label, double value, double min, double max,
      ValueChanged<double> onChanged, String valStr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            Text(valStr,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'monospace')),
          ],
        ),
        const SizedBox(height: 6),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildToggleRow(
      String label, String sub, bool val, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text(sub,
                  style: const TextStyle(fontSize: 8, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Switch(
          value: val,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPresetBtn(
      String label, VoidCallback apply, MotionThemeData activeTheme) {
    return SizedBox(
      width: double.infinity,
      height: 32,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          foregroundColor: activeTheme.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 4),
        ),
        onPressed: apply,
        child: Text(label,
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  // Pull-To-Refresh Interactive Playground tab
  Widget _buildRefreshPlayground(
      MotionThemeData activeTheme, double screenWidth) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Pull-To-Refresh Indicators',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: activeTheme.textColor,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Experience 20 elite, custom-painted physics refresh indicators with complete customization.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Layout split
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = screenWidth > 800;
              final playground = Container(
                height: 380,
                decoration: BoxDecoration(
                  color: activeTheme.isDark
                      ? const Color(0xFF0F0F1B)
                      : const Color(0xFFE8E8EE),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: activeTheme.primaryColor.withValues(alpha: 0.15),
                      width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MotionPullToRefresh(
                    scrollController: _scrollController,
                    animation: _selectedRefreshAnim,
                    particleCount: _refreshParticles.round(),
                    glowStrength: _refreshGlow,
                    animationSpeed: _refreshSpeed,
                    showStatusText: _showRefreshStatusText,
                    refreshDuration: Duration(
                        milliseconds: (_refreshHoldSeconds * 1000).round()),
                    style: _selectedRefreshStyle,
                    color: activeTheme.primaryColor,
                    backgroundColor: Colors.transparent,
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 20,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (c, i) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: activeTheme.isDark
                                ? Colors.white.withValues(alpha: 0.03)
                                : Colors.black.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.swipe_down_rounded,
                                  color: activeTheme.primaryColor, size: 20),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Scrollable Demo Row ${i + 1} (Pull down to test!)',
                                  style: TextStyle(
                                      color: activeTheme.textColor,
                                      fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );

              final controls = Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: activeTheme.isDark
                      ? Colors.white.withValues(alpha: 0.02)
                      : Colors.black.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CUSTOMIZATION CONTROLS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: activeTheme.primaryColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Selected Style Dropdown
                    const Text('Select Animation Profile:',
                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: activeTheme.isDark
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<MotionRefreshAnimation>(
                          value: _selectedRefreshAnim,
                          isExpanded: true,
                          dropdownColor: activeTheme.isDark
                              ? const Color(0xFF0F0F1B)
                              : Colors.white,
                          style: TextStyle(
                              color: activeTheme.textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                          items: MotionRefreshAnimation.values.map((anim) {
                            return DropdownMenuItem(
                              value: anim,
                              child: Text(anim.name
                                  .replaceAllMapped(RegExp(r'([A-Z])'),
                                      (m) => ' ${m.group(1)}')
                                  .toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedRefreshAnim = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Selected Style Dropdown
                    const Text('Select Interaction Style (iOS vs Android):',
                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: activeTheme.isDark
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<MotionRefreshStyle>(
                          value: _selectedRefreshStyle,
                          isExpanded: true,
                          dropdownColor: activeTheme.isDark
                              ? const Color(0xFF0F0F1B)
                              : Colors.white,
                          style: TextStyle(
                              color: activeTheme.textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                          items: MotionRefreshStyle.values.map((style) {
                            return DropdownMenuItem(
                              value: style,
                              child: Text(style.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedRefreshStyle = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Particle Count Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Particle Density:',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('${_refreshParticles.round()}',
                            style: TextStyle(
                                fontSize: 11,
                                color: activeTheme.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _refreshParticles,
                      min: 8.0,
                      max: 40.0,
                      activeColor: activeTheme.primaryColor,
                      onChanged: (v) {
                        setState(() {
                          _refreshParticles = v;
                        });
                      },
                    ),

                    // Glow Strength Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Glow Blur Radius:',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('${_refreshGlow.toStringAsFixed(1)}px',
                            style: TextStyle(
                                fontSize: 11,
                                color: activeTheme.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _refreshGlow,
                      min: 0.0,
                      max: 12.0,
                      activeColor: activeTheme.primaryColor,
                      onChanged: (v) {
                        setState(() {
                          _refreshGlow = v;
                        });
                      },
                    ),

                    // Animation Speed Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Animation Ticker Speed:',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('${_refreshSpeed.toStringAsFixed(1)}x',
                            style: TextStyle(
                                fontSize: 11,
                                color: activeTheme.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _refreshSpeed,
                      min: 0.5,
                      max: 2.0,
                      activeColor: activeTheme.primaryColor,
                      onChanged: (v) {
                        setState(() {
                          _refreshSpeed = v;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // Show Status Text Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Show Status Helper Text:',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Switch(
                          value: _showRefreshStatusText,
                          activeThumbColor: activeTheme.primaryColor,
                          activeTrackColor:
                              activeTheme.primaryColor.withValues(alpha: 0.5),
                          onChanged: (v) {
                            setState(() {
                              _showRefreshStatusText = v;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Refresh Duration Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Refresh Visual Hold:',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('${_refreshHoldSeconds.toStringAsFixed(1)}s',
                            style: TextStyle(
                                fontSize: 11,
                                color: activeTheme.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _refreshHoldSeconds,
                      min: 0.0,
                      max: 5.0,
                      activeColor: activeTheme.primaryColor,
                      onChanged: (v) {
                        setState(() {
                          _refreshHoldSeconds = v;
                        });
                      },
                    ),
                  ],
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: playground),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: controls),
                  ],
                );
              } else {
                return Column(
                  children: [
                    playground,
                    const SizedBox(height: 24),
                    controls,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// Sample Secondary Page loaded during route transitions
class SecondarySamplePage extends StatelessWidget {
  final String title;
  final bool hasScaffold;

  const SecondarySamplePage({
    super.key,
    required this.title,
    this.hasScaffold = true,
  });

  @override
  Widget build(BuildContext context) {
    final activeTheme = MotionTheme.of(context);

    final content = Center(
      child: MotionGlassContainer(
        width: 280,
        height: 240,
        borderRadius: 24,
        blur: 20,
        opacity: 0.15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.green, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  color: Colors.black, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Route transitions successfully compiled!',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: activeTheme.primaryColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('DISMISS & RETURN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ],
        ),
      ),
    );

    if (hasScaffold) {
      return Scaffold(
        backgroundColor: activeTheme.backgroundColor,
        body: content,
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: content,
      );
    }
  }
}
