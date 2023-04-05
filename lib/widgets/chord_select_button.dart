import 'package:flutter/material.dart';

import '../screens/chord_select.dart';

class ChordSelectButton extends StatelessWidget {
  final Function setChordTrainingSetCallback;
  final Function stopCallback;
  const ChordSelectButton(this.setChordTrainingSetCallback, this.stopCallback,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        stopCallback();
        _navigateAndDisplaySelection(context);
      },
      child: const Icon(Icons.settings),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push() return Future.
    // Future will be completed after Navigator.pop() is called
    final List<List<String>> result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChordSelectScreen()),
    );
    setChordTrainingSetCallback(result);
  }
}
