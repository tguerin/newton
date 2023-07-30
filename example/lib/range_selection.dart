import 'package:example/theme_extensions.dart';
import 'package:flutter/material.dart';

class RangeSelection extends StatefulWidget {
  final String title;
  final double min;
  final double max;
  final double initialMin;
  final double initialMax;
  final bool roundValue;
  final int divisions;
  final ValueChanged<RangeValues> onChanged;

  const RangeSelection({
    super.key,
    required this.min,
    required this.max,
    required this.title,
    required this.onChanged,
    this.roundValue = true,
    this.divisions = 100,
    required this.initialMin,
    required this.initialMax,
  });

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
    final formattedMin =
        widget.roundValue ? _min.round() : _min.toStringAsPrecision(2);
    final formattedMax =
        widget.roundValue ? _max.round() : _max.toStringAsPrecision(2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.title}: $formattedMin - $formattedMax",
          style: textTheme.labelLarge,
        ),
        SizedBox(
          width: 200,
          child: RangeSlider(
            values: RangeValues(_min, _max),
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            labels: RangeLabels("$formattedMin.", "$formattedMax"),
            onChanged: (values) {
              setState(() {
                _min = values.start;
                _max = values.end;
                widget.onChanged(values);
              });
            },
          ),
        )
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
