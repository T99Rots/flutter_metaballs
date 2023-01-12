import 'package:example/utils/color_presets.dart';
import 'package:example/widgets/_widget.dart';
import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Alignment alignment = Alignment.bottomRight;
  ColorPreset selectedPreset = colorPresets.first;
  int metaballs = 40;
  Range size = const Range(min: 25, max: 40);
  Range speed = const Range(min: 0.33, max: 1);
  ColorPreset? customPreset;
  double bounceIntensity = 10;
  double glowIntensity = 0.6;
  double glowRadius = 1;

  @override
  Widget build(BuildContext context) {
    final bool small = MediaQuery.of(context).size.width < 800;

    final ThemeData theme = Theme.of(context);

    final ColorScheme colorScheme = computeColorScheme(theme.colorScheme);

    return Theme(
      data: theme.copyWith(
        colorScheme: colorScheme,
        textSelectionTheme: theme.textSelectionTheme.copyWith(
          selectionColor: colorScheme.primary.withOpacity(0.25),
        ),
      ),
      child: Scaffold(
        drawer: !small
            ? null
            : Drawer(
                child: _buildDrawerBody(),
              ),
        body: Row(
          children: <Widget>[
            if (!small)
              SizedBox(
                width: 320,
                child: _buildDrawerBody(),
              ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 1.5,
                    colors: <Color>[
                      Color.fromARGB(255, 13, 35, 61),
                      Colors.black,
                    ],
                  ),
                ),
                child: Metaballs(
                  config: MetaballsConfig(
                    glowRadius: glowRadius,
                    glowIntensity: glowIntensity,
                    radius: size,
                    metaballs: metaballs,
                    bounceIntensity: bounceIntensity,
                    gradient: gradient,
                    speed: speed,
                    effects: [
                      MetaballsEffect.grow(),
                    ],
                  ),
                  child: !small ? null : _buildMenuButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align _buildMenuButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Builder(builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: OutlinedButton(
            style: const ButtonStyle(
              textStyle: MaterialStatePropertyAll<TextStyle>(
                TextStyle(
                  shadows: <Shadow>[
                    Shadow(blurRadius: 10),
                  ],
                ),
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(
                  Icons.settings_rounded,
                  size: 16,
                ),
                SizedBox(width: 10.0),
                Text('Configure Metaballs'),
              ],
            ),
          ),
        );
      }),
    );
  }

  ExampleDrawer _buildDrawerBody() {
    return ExampleDrawer(
      onPresetChange: onPresetChange,
      gradient: gradient,
      alignment: alignment,
      onAlignmentChange: onAlignmentChange,
      speed: speed,
      onSpeedChange: onSpeedChange,
      size: size,
      onSizeChange: onSizeChange,
      metaballs: metaballs,
      onMetaballsChange: onMetaballsChange,
      presets: allPresets,
      selectedPreset: selectedPreset,
      bounceIntensity: bounceIntensity,
      glowIntensity: glowIntensity,
      glowRadius: glowRadius,
      onBounceIntensityChange: onBounceIntensityChange,
      onGlowIntensityChange: onGlowIntensityChange,
      onGlowRadiusChange: onGlowRadiusChange,
    );
  }

  Gradient get gradient {
    return LinearGradient(
      colors: <Color>[
        selectedPreset.startColor,
        selectedPreset.endColor,
      ],
      begin: -alignment,
      end: alignment,
    );
  }

  List<ColorPreset> get allPresets {
    return <ColorPreset>[
      ...colorPresets,
      if (customPreset != null) customPreset!,
    ];
  }

  /// Creates a [ColorScheme] based on the current selected preset to make the ui
  /// match the metaballs colors.
  ColorScheme computeColorScheme(ColorScheme base) {
    final HSVColor startColor = HSVColor.fromColor(selectedPreset.startColor);
    final HSVColor endColor = HSVColor.fromColor(selectedPreset.endColor);

    final Color primary = HSVColor.fromColor(
      Color.lerp(
        selectedPreset.startColor,
        selectedPreset.endColor,
        0.5 - ((startColor.saturation - endColor.saturation) / 2),
      )!,
    ).withValue(1.0).toColor();

    final Color onPrimary = primary.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return base.copyWith(
      primary: primary,
      onPrimary: onPrimary,
    );
  }

  void onPresetChange(ColorPreset preset, bool custom) {
    selectedPreset = preset;
    if (custom) {
      customPreset = preset;
    }
    setState(() {});
  }

  void onAlignmentChange(Alignment alignment) {
    this.alignment = alignment;
    setState(() {});
  }

  void onSpeedChange(Range speed) {
    this.speed = speed;
    setState(() {});
  }

  void onSizeChange(Range size) {
    this.size = size;
    setState(() {});
  }

  void onMetaballsChange(int metaballs) {
    this.metaballs = metaballs;
    setState(() {});
  }

  void onBounceIntensityChange(double bounceIntensity) {
    this.bounceIntensity = bounceIntensity;
    setState(() {});
  }

  void onGlowIntensityChange(double glowIntensity) {
    this.glowIntensity = glowIntensity;
    setState(() {});
  }

  void onGlowRadiusChange(double glowRadius) {
    this.glowRadius = glowRadius;
    setState(() {});
  }
}
