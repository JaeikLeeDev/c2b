import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final List<String> chord;
  final bool isCur;
  final bool _chordConstructOn;

  const Bar(
    this._chordConstructOn, {
    required this.chord,
    required this.isCur,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.35,
      width: screenSize.width * 0.25,
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.05,
          horizontal: screenSize.width * 0.01,
        ),
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.black,
              width: 3.0,
            ),
          ),
        ),
        child: Column(
          children: [
            Text(
              chord[0],
              style: TextStyle(
                  fontSize: 30, color: isCur ? Colors.blue : Colors.black),
            ),
            const SizedBox(height: 10),
            if (_chordConstructOn == true)
              Text(
                chord[1],
                style: TextStyle(
                    fontSize: 20, color: isCur ? Colors.blue : Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
