import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/select_controller.dart';
import 'bar.dart';

class Score extends StatelessWidget {
  Score(this._chordConstructOn,
      {required this.randomChordIndexList,
      required this.chordCounter,
      required this.chordPerPhrase,
      super.key});

  final bool _chordConstructOn;
  final List<int> randomChordIndexList;
  final int chordCounter;
  final int chordPerPhrase;
  final SelectController _selectController = Get.find();
  late final List<List<String>> chordList;

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
              for (int i = 0; i < chordPerPhrase; i++)
                Bar(
                  _chordConstructOn,
                  chord: (_selectController
                      .getTraining())[randomChordIndexList[i]],
                  isCur: i == chordCounter,
                ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.03),
          /* Phrase - bottom */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = chordPerPhrase; i < chordPerPhrase * 2; i++)
                Bar(
                  _chordConstructOn,
                  chord: (_selectController
                      .getTraining())[randomChordIndexList[i]],
                  isCur: i == chordCounter,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
