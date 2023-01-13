import 'package:flutter/material.dart';

class BeatIndicator extends StatelessWidget {
  final beatCounter;
  final beatSet;
  final radius;

  const BeatIndicator({
    required this.beatCounter,
    required this.beatSet,
    required this.radius,
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
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            backgroundColor: _colorBeatIndicator(0),
            radius: radius,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            backgroundColor: _colorBeatIndicator(1),
            radius: radius,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            backgroundColor: _colorBeatIndicator(2),
            radius: radius,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            backgroundColor: _colorBeatIndicator(3),
            radius: radius,
          ),
        ),
      ],
    );
  }
}
