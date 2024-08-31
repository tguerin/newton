import 'package:example/theme_extensions.dart';
import 'package:flutter/material.dart';

class SingleValueSelection extends StatefulWidget {
  const SingleValueSelection({
    required this.value,
    required this.title,
    required this.onChanged,
    required this.min,
    required this.max,
    super.key,
    this.precision = 2,
  });

  final String title;
  final double value;
  final double min;
  final double max;
  final int precision;
  final ValueChanged<double> onChanged;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.title}: ${_value.toStringAsFixed(_value.truncateToDouble() == _value ? 0 : widget.precision)}',
          style: textTheme.labelLarge,
        ),
        SizedBox(
          width: 200,
          child: Slider(
            value: _value,
            min: widget.min,
            max: widget.max,
            label: _value.toStringAsFixed(_value.truncateToDouble() == _value ? 0 : widget.precision),
            onChanged: (value) {
              setState(() {
                _value = value;
                widget.onChanged(value);
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(SingleValueSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
  }
}
