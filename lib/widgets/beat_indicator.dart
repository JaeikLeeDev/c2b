import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:c2b/theme/app_colors.dart';
import '../controllers/training_controller.dart';

class BeatIndicator extends StatelessWidget {
  BeatIndicator({
    required this.radius,
    super.key,
  });

  final TrainingController _tc = Get.find();
  final double radius;

  @override
  Widget build(BuildContext context) {
    var currentBeat =
        ((_tc.divisionCounter % (_tc.beatsPerBar * _tc.meter)) / _tc.meter)
            .floor();
    return Row(
      children: [
        for (int i = 0; i < _tc.beatsPerBar; i++)
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
              backgroundColor: AppColors.secondary,
              radius: radius,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: radius * 0.9,
            ),
          );
  }
}
