import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

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
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: InputDecorator(
            isFocused: _isOpen,
            decoration: const InputDecoration(
              label: Text('Select Color Preset'),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: ClipRRect(
            child: DropdownButton2<T>(
              onChanged: widget.onChange,
              value: widget.value,
              items: widget.items,
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(
                  right: 8,
                ),
              ),
              onMenuStateChange: (bool isOpen) {
                _isOpen = isOpen;
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }
}
