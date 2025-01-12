import 'package:c2b/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/select_controller.dart';
import '../controllers/training_controller.dart';
import "../utils/chord_table.dart";
import 'bar.dart';

class Score extends StatelessWidget {
  Score({super.key});

  final TrainingController _tc = Get.find();
  final SelectController _sc = Get.find();

  bool _isCorrect() {
    return listEquals(
      [...(_tc.selected).map((e) => e % 12)]..sort(),
      [
        ...(qualityUtil[_sc.selected[_tc.randomChordIndexList[_tc.chordCounter]]
                .qualityIndex][1] as List<int>)
            .map((e) =>
                (e +
                    (_sc.selected[_tc.randomChordIndexList[_tc.chordCounter]])
                        .rootIndex) %
                12),
      ]..sort(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: _tc.pianoOn
          /* 가상 건반 모드 UI */
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /* 현재 선택된(누른) 건반의 음들 나열 */
                Expanded(
                  child: Center(
                    child: Text(
                      _tc.selectedToString(),
                      style: TextStyle(
                        fontFamily: 'Noto Music',
                        fontSize: screenSize.width * 0.04,
                        color:
                            _isCorrect() ? AppColors.secondary : Colors.black,
                      ),
                    ),
                  ),
                ),
                /* 두 마디 */
                Bar(
                  chord: (_sc
                      .training)[_tc.randomChordIndexList[_tc.chordCounter]],
                  isCur: true,
                ),
                Bar(
                  chord: (_sc.training)[
                      _tc.randomChordIndexList[_tc.chordCounter + 1]],
                  isCur: false,
                ),
              ],
            )
          /* 기본 연습 모드 UI */
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* Phrase - top */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < _tc.chordPerPhrase; i++)
                      Bar(
                        chord: (_sc.training)[_tc.randomChordIndexList[i]],
                        isCur: i == _tc.chordCounter,
                      ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),
                /* Phrase - bottom */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = _tc.chordPerPhrase;
                        i < _tc.chordPerPhrase * 2;
                        i++)
                      Bar(
                        chord: (_sc.training)[_tc.randomChordIndexList[i]],
                        isCur: false,
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}
