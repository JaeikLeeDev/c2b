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
      child: const Icon(Icons.settings),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push() return Future.
    // Future will be completed after Navigator.pop() is called
    final String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChordSelectionScreen()),
    );

    setChordTrainingSet([
      [result, 'sadasdf'],
      ['sddf', result],
    ]);
  }
}
