import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/training_controller.dart';
import 'package:c2b/theme/app_colors.dart';

class Bar extends StatelessWidget {
  /// 한 마디를 생성
  Bar({
    required this.chord,
    required this.isCur,
    super.key,
  });

  final List<String> chord;
  final bool isCur;
  final TrainingController _tc = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    final screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: screenHeight * 0.27,
      width: screenWidth * 0.24,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* 코드 notation */
            Text(
              chord[0],
              style: TextStyle(
                  fontFamily: 'Noto Music',
                  fontSize: screenWidth * 0.038,
                  color: isCur ? AppColors.primary : Colors.black),
            ),
            const SizedBox(height: 10),
            /* 코드 구성음 */
            if (_tc.answerOn == true)
              Text(
                chord[1],
                style: TextStyle(
                    fontFamily: 'Noto Music',
                    fontSize: screenWidth * 0.028,
                    color: isCur ? AppColors.primary : Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
