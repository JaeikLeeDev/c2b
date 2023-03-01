import 'package:flutter/material.dart';
import '../widgets/bar.dart';

class Score extends StatelessWidget {
  final bool _chordConstructOn;
  final List<List<String>> chordList;
  final List<int> randomChordIndexList;
  final int chordCounter;

  const Score(this._chordConstructOn,
      {required this.chordList,
      required this.randomChordIndexList,
      required this.chordCounter,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Phrase - top
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Bar(
              _chordConstructOn,
              chord: chordList[randomChordIndexList[0]],
              isCur: 0 == chordCounter,
            ),
            Bar(
              _chordConstructOn,
              chord: chordList[randomChordIndexList[1]],
              isCur: 1 == chordCounter,
            ),
            Bar(
              _chordConstructOn,
              chord: chordList[randomChordIndexList[2]],
              isCur: 2 == chordCounter,
            ),
            Bar(
              _chordConstructOn,
              chord: chordList[randomChordIndexList[3]],
              isCur: 3 == chordCounter,
            ),
          ],
        ),
        // Phrase - bottom
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Bar(
              _chordConstructOn,
              chord: chordList[randomChordIndexList[4]],
              isCur: 4 == chordCounter,
            ),
            Bar(
              _chordConstructOn,
              chord: chordList[randomChordIndexList[5]],
              isCur: 5 == chordCounter,
            ),
            Bar(
              _chordConstructOn,
              chord: chordList[randomChordIndexList[6]],
              isCur: 6 == chordCounter,
            ),
            Bar(
              _chordConstructOn,
              chord: chordList[randomChordIndexList[7]],
              isCur: 7 == chordCounter,
            ),
          ],
        ),
      ],
    );
  }
}
