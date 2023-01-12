import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:example/utils/_utils.dart';
import 'package:example/widgets/_widget.dart';
import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

/// The drawer for the app with all configuration options.
class ExampleDrawer extends StatelessWidget {
  const ExampleDrawer({
    super.key,
    required this.onPresetChange,
    required this.gradient,
    required this.alignment,
    required this.onAlignmentChange,
    required this.speed,
    required this.onSpeedChange,
    required this.size,
    required this.onSizeChange,
    required this.metaballs,
    required this.onMetaballsChange,
    required this.presets,
    required this.selectedPreset,
    this.selectedEffect,
    required this.bounceIntensity,
    required this.glowIntensity,
    required this.glowRadius,
    required this.onBounceIntensityChange,
    required this.onGlowIntensityChange,
    required this.onGlowRadiusChange,
  });

  final void Function(ColorPreset newPreset, bool custom) onPresetChange;

  final Gradient gradient;
  final List<ColorPreset> presets;
  final ColorPreset selectedPreset;
  final MetaballsEffect? selectedEffect;

  final double bounceIntensity;
  final void Function(double newBounceIntensity) onBounceIntensityChange;

  final double glowIntensity;
  final void Function(double newGlowIntensity) onGlowIntensityChange;

  final double glowRadius;
  final void Function(double newGlowRadius) onGlowRadiusChange;

  final Alignment alignment;
  final void Function(Alignment newPreset) onAlignmentChange;

  final Range speed;
  final void Function(Range newSpeed) onSpeedChange;

  final Range size;
  final void Function(Range newSpeed) onSizeChange;

  final int metaballs;
  final void Function(int newSpeed) onMetaballsChange;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 35.0),
                  child: Text(
                    'METABALLS\nEXAMPLE',
                    style: TextStyle(
                      fontSize: 45,
                    ),
                  ),
                ),
                _buildGeneralSection(),
                _buildEffectsSection(),
                _buildGradientSection(context),
                _buildExportSection(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  DrawerSection _buildExportSection(BuildContext context) {
    return DrawerSection(
      title: 'Export',
      children: <Widget>[
        OutlinedButton(
          onPressed: () {
            showExportDialog(context: context);
          },
          child: const Text('Export Configuration'),
        )
      ],
    );
  }

  DrawerSection _buildGradientSection(BuildContext context) {
    return DrawerSection(
      title: 'Colors & Gradient',
      children: <Widget>[
        BetterDropdown<ColorPreset>(
          onChange: (ColorPreset? value) {
            if (value != null) {
              onPresetChange(value, false);
            }
          },
          items: presets
              .map(
                (ColorPreset preset) => DropdownMenuItem<ColorPreset>(
                  value: preset,
                  child: Row(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        elevation: 3,
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                preset.startColor,
                                preset.endColor,
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(preset.name),
                    ],
                  ),
                ),
              )
              .toList(),
          value: selectedPreset,
        ),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  selectedPreset.startColor,
                ),
              ),
              onPressed: () {
                showColorPicker(
                  context: context,
                  title: 'Pick color 1',
                  initialColor: selectedPreset.startColor,
                  onChange: (Color color) {
                    setCustomPreset(
                      startColor: color,
                      endColor: selectedPreset.endColor,
                    );
                  },
                );
              },
              child: const SizedBox(width: 40),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  selectedPreset.endColor,
                ),
              ),
              onPressed: () {
                showColorPicker(
                  context: context,
                  title: 'Pick color 2',
                  initialColor: selectedPreset.endColor,
                  onChange: (Color color) {
                    setCustomPreset(
                      startColor: selectedPreset.startColor,
                      endColor: color,
                    );
                  },
                );
              },
              child: const SizedBox(width: 40),
            ),
          ],
        ),
        const SizedBox(height: 20),
        DirectionSelectorAndPreview(
          alignment: alignment,
          gradient: gradient,
          onChange: (Alignment newAlignment) {
            onAlignmentChange(newAlignment);
          },
        ),
      ],
    );
  }

  DrawerSection _buildEffectsSection() {
    return DrawerSection(
      title: 'Effects',
      children: <Widget>[
        DropdownMenu<EffectPreset>(
          label: const Text('Select effect'),
          dropdownMenuEntries: effectPresets
              .map(
                (EffectPreset preset) => DropdownMenuEntry<EffectPreset>(
                  value: preset,
                  label: preset.name,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildGeneralSection() {
    return SliderTheme(
      data: const SliderThemeData(),
      child: DrawerSection(
        title: 'General',
        children: <Widget>[
          SliderWrapper(
            label: 'Metaball count',
            value: metaballs.toString(),
          ),
          Slider(
            value: metaballs.toDouble(),
            min: 1,
            max: 128,
            onChanged: (double value) {
              onMetaballsChange(value.toInt());
            },
          ),
          SliderWrapper(
            label: 'Speed',
            value: '${speed.min} - ${speed.max}',
          ),
          RangeSlider(
            values: RangeValues(
              speed.min,
              speed.max,
            ),
            min: 0,
            max: 3,
            onChanged: (RangeValues value) {
              onSpeedChange(Range(
                min: value.start.roundToPrecision(2),
                max: value.end.roundToPrecision(2),
              ));
            },
          ),
          SliderWrapper(
            label: 'Radius',
            value: '${size.min} - ${size.max}',
          ),
          RangeSlider(
            values: RangeValues(size.min, size.max),
            min: 0,
            max: 100,
            onChanged: (RangeValues value) {
              onSizeChange(Range(
                min: value.start.roundToPrecision(1),
                max: value.end.roundToPrecision(1),
              ));
            },
          ),
          SliderWrapper(
            label: 'Bounce Intensity',
            value: bounceIntensity.toString(),
          ),
          Slider(
            value: bounceIntensity,
            min: 1,
            max: 100,
            onChanged: (double value) {
              onBounceIntensityChange(value.roundToPrecision(1));
            },
          ),
          SliderWrapper(
            label: 'Glow Intensity',
            value: glowIntensity.toString(),
          ),
          Slider(
            value: glowIntensity,
            min: 0,
            max: 1,
            onChanged: (double value) {
              onGlowIntensityChange(value.roundToPrecision(2));
            },
          ),
          SliderWrapper(
            label: 'Glow Radius',
            value: glowRadius.toString(),
          ),
          Slider(
            value: glowRadius,
            min: 0,
            max: 1,
            onChanged: (double value) {
              onGlowRadiusChange(value.roundToPrecision(2));
            },
          ),
        ],
      ),
    );
  }

  void setCustomPreset({
    required Color startColor,
    required Color endColor,
  }) {
    onPresetChange(
      ColorPreset(
        name: 'Custom',
        startColor: startColor,
        endColor: endColor,
      ),
      true,
    );
  }

  void showColorPicker({
    required BuildContext context,
    required String title,
    required Color initialColor,
    required Function(Color color) onChange,
  }) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return ColorPickerDialog(
          initialColor: initialColor,
          title: title,
          onChange: onChange,
        );
      },
    );
  }

  void showExportDialog({
    required BuildContext context,
  }) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return ExportDialog(
          code: CodeGenerator(
            selectedPreset: selectedPreset,
            alignment: alignment,
            speed: speed,
            size: size,
            metaballs: metaballs,
            selectedEffect: selectedEffect,
            bounceIntensity: bounceIntensity,
            glowIntensity: glowIntensity,
            glowRadius: glowRadius,
          ).generate(),
        );
      },
    );
  }
}

class SliderWrapper extends StatelessWidget {
  const SliderWrapper({
    super.key,
    required this.label,
    required this.value,
    // required this.slider,
  });

  final String label;
  final String value;
  // final Widget slider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label),
        Text(value),
      ],
    );
  }
}

class BetterDropdown<T> extends StatefulWidget {
  const BetterDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChange,
  });

  final List<DropdownMenuItem<T>> items;
  final T value;
  final Function(T? value) onChange;

  @override
  State<BetterDropdown<T>> createState() => _BetterDropdownState<T>();
}

class _BetterDropdownState<T> extends State<BetterDropdown<T>> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: InputDecorator(
            isFocused: isOpen,
            decoration: const InputDecoration(label: Text('Select Color Preset'), border: OutlineInputBorder()),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            dropdownDecoration: BoxDecoration(
              color: const Color(0xff424242),
              borderRadius: BorderRadius.circular(5),
            ),
            focusColor: Colors.transparent,
            barrierColor: Colors.transparent,
            itemSplashColor: Colors.transparent,
            buttonSplashColor: Colors.transparent,
            buttonOverlayColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
            buttonHighlightColor: Colors.transparent,
            itemHighlightColor: Colors.transparent,
            onChanged: widget.onChange,
            value: widget.value,
            items: widget.items,
            onMenuStateChange: (bool isOpen) {
              this.isOpen = isOpen;
              setState(() {});
            },
            iconEnabledColor: isOpen ? Theme.of(context).colorScheme.primary : null,
            icon: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.arrow_drop_down),
            ),
          ),
        ),
      ],
    );
  }
}
