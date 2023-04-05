import 'package:flutter/material.dart';

import 'package:c2b/theme/app_colors.dart';

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
      height: screenSize.height * 0.33,
      width: screenSize.width * 0.25,
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.03,
          horizontal: screenSize.width * 0.01,
        ),
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          children: [
            Text(
              chord[0],
              style: TextStyle(
                  fontFamily: 'Noto Music',
                  fontSize: screenSize.width * 0.033,
                  color: isCur ? AppColors.primary : Colors.black),
            ),
            const SizedBox(height: 10),
            if (_chordConstructOn == true)
              Text(
                chord[1],
                style: TextStyle(
                    fontFamily: 'Noto Music',
                    fontSize: screenSize.width * 0.025,
                    color: isCur ? AppColors.primary : Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
