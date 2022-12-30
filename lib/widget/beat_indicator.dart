import 'package:flutter/material.dart';

class BeatIndicator extends StatelessWidget {
  final beatCounter;
  final beatSet;

  const BeatIndicator({
    required this.beatCounter,
    required this.beatSet,
    super.key,
  });

  Color _colorBeatIndicator(int indicatorNumber) {
    if ((beatCounter % beatSet) == indicatorNumber) {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: _colorBeatIndicator(0),
        ),
        CircleAvatar(backgroundColor: _colorBeatIndicator(1)),
        CircleAvatar(backgroundColor: _colorBeatIndicator(2)),
        CircleAvatar(backgroundColor: _colorBeatIndicator(3)),
      ],
    );
  }
}
