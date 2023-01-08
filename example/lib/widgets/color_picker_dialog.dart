import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    super.key,
    required this.title,
    required this.initialColor,
    required this.onChange,
  });

  final String title;
  final Color initialColor;
  final Function(Color color) onChange;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color currentColor = widget.initialColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                height: 429,
                child: ColorPicker(
                  enableAlpha: false,
                  portraitOnly: true,
                  pickerAreaBorderRadius: BorderRadius.circular(5),
                  onColorChanged: (Color value) {
                    currentColor = value;
                  },
                  pickerColor: widget.initialColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onChange(currentColor);
                    },
                    child: const Text('Save'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
