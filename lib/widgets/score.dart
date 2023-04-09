import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/select_controller.dart';
import '../controllers/training_controller.dart';
import 'bar.dart';

class Score extends StatelessWidget {
  Score({super.key});

  final TrainingController _tc = Get.find();
  final SelectController _sc = Get.find();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /* Phrase - top */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < _tc.chordPerPhrase; i++)
                Bar(
                  _tc.onOffOptions[0],
                  chord: (_sc.getTraining())[_tc.randomChordIndexList[i]],
                  isCur: i == _tc.chordCounter,
                ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.03),
          /* Phrase - bottom */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = _tc.chordPerPhrase; i < _tc.chordPerPhrase * 2; i++)
                Bar(
                  _tc.onOffOptions[0],
                  chord: (_sc.getTraining())[_tc.randomChordIndexList[i]],
                  isCur: i == _tc.chordCounter,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
