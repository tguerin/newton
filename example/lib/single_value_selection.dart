import 'package:example/theme_extensions.dart';
import 'package:flutter/material.dart';

class SingleValueSelection extends StatefulWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final bool roundValue;
  final ValueChanged<double> onChanged;

  const SingleValueSelection({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
    this.roundValue = true,
    required this.min,
    required this.max,
  });

  @override
  State<SingleValueSelection> createState() => _SingleValueSelectionState();
}

class _SingleValueSelectionState extends State<SingleValueSelection> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final formattedValue = widget.roundValue ? _value.round() : _value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.title}: $formattedValue",
          style: textTheme.labelLarge,
        ),
        SizedBox(
          width: 200,
          child: Slider(
            value: _value,
            min: widget.min,
            max: widget.max,
            label: "$formattedValue",
            onChanged: (value) {
              setState(() {
                _value = value;
                widget.onChanged(value);
              });
            },
          ),
        )
      ],
    );
  }

  @override
  void didUpdateWidget(SingleValueSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
  }
}
