import 'package:flutter/material.dart';

import './chord_selection_screen.dart';

class ChordSetButton extends StatelessWidget {
  final Function setChordTrainingSet;
  const ChordSetButton(this.setChordTrainingSet, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        minimumSize: const Size(36, 36),
        fixedSize: const Size(50, 36),
      ),
      child: const Icon(Icons.settings),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push() return Future.
    // Future will be completed after Navigator.pop() is called
    final List<String> result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChordSelectionScreen()),
    );

    setChordTrainingSet([
      ...result.map(
        (chord) {
          return [chord, "none"];
        },
      )
    ]);
  }
}
