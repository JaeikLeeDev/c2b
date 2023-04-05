import 'package:flutter/material.dart';
import '../widgets/bar.dart';

class Score extends StatelessWidget {
  final bool _chordConstructOn;
  final List<List<String>> chordList;
  final List<int> randomChordIndexList;
  final int chordCounter;
  final int chordPerPhrase;

  const Score(this._chordConstructOn,
      {required this.chordList,
      required this.randomChordIndexList,
      required this.chordCounter,
      required this.chordPerPhrase,
      super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Phrase - top
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < chordPerPhrase; i++)
                Bar(
                  _chordConstructOn,
                  chord: chordList[randomChordIndexList[i]],
                  isCur: i == chordCounter,
                ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.03),
          // Phrase - bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = chordPerPhrase; i < chordPerPhrase * 2; i++)
                Bar(
                  _chordConstructOn,
                  chord: chordList[randomChordIndexList[i]],
                  isCur: i == chordCounter,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
