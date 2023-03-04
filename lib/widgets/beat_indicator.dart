import 'package:flutter/material.dart';

class BeatIndicator extends StatelessWidget {
  final int currentBeat;
  final int beatsPerBar;
  final double radius;

  const BeatIndicator({
    required this.currentBeat,
    required this.radius,
    required this.beatsPerBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < beatsPerBar; i++)
          BeatCircle(
            isCurrentBeat: currentBeat == i,
            radius: radius,
          )
      ],
    );
  }
}

class BeatCircle extends StatelessWidget {
  final bool isCurrentBeat;
  final double radius;
  const BeatCircle(
      {required this.isCurrentBeat, required this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    return isCurrentBeat
        ? Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundColor: Colors.orange,
              radius: radius,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: radius * 0.9,
            ),
          );
  }
}
