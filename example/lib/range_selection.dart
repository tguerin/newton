import 'package:example/theme_extensions.dart';
import 'package:flutter/material.dart';

class RangeSelection extends StatefulWidget {
  const RangeSelection({
    required this.min,
    required this.max,
    required this.title,
    required this.onChanged,
    required this.initialMin,
    required this.initialMax,
    super.key,
    this.divisions = 100,
    this.precision = 2,
  });

  final String title;
  final double min;
  final double max;
  final double initialMin;
  final double initialMax;
  final int divisions;
  final int precision;
  final ValueChanged<RangeValues> onChanged;

  @override
  State<RangeSelection> createState() => _RangeSelectionState();
}

class _RangeSelectionState extends State<RangeSelection> {
  late double _min;
  late double _max;

  @override
  void initState() {
    super.initState();
    _min = widget.initialMin;
    _max = widget.initialMax;
  }

  @override
  Widget build(BuildContext context) {
    final formattedMin = _min.toStringAsFixed(_min.truncateToDouble() == _min ? 0 : widget.precision);
    final formattedMax = _max.toStringAsFixed(_max.truncateToDouble() == _max ? 0 : widget.precision);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.title}: $formattedMin - $formattedMax',
          style: textTheme.labelLarge,
        ),
        SizedBox(
          width: 200,
          child: RangeSlider(
            values: RangeValues(_min, _max),
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            labels: RangeLabels(formattedMin, formattedMax),
            onChanged: (values) {
              setState(() {
                _min = values.start;
                _max = values.end;
                widget.onChanged(values);
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(RangeSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _min = widget.initialMin;
    _max = widget.initialMax;
  }
}
