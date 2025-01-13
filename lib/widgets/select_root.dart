import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../utils/chord_table.dart';

class SelectRoot extends StatelessWidget {
  /// 보여줄 코드의 근음을 선택하는 UI를 생성.
  /// CM7 코드의 근음은 C, F#m 코드의 근음은 F#.
  const SelectRoot({
    required this.keyIndex,
    required this.onPressed,
    super.key,
  });

  /// 현재 화면의 key(scale) 선택 드롭다운에서 선택된 key의 인덱스.
  /// 현재 선택된 key에 따라 코드를 b방식으로 표기할지 #방식으로 표기할지 정하기 위함.
  final int keyIndex;

  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var orientation = MediaQuery.of(context).orientation;

    return ListView.builder(
      itemBuilder: (context, index) {
        return TextButton(
          onPressed: () => onPressed(index),
          child: Text(
            rootStringUtil(keyIndex, index),
            style: AppTextStyle.button1.copyWith(
              fontSize: orientation == Orientation.landscape
                  ? screenWidth * 0.024
                  : screenWidth * 0.04,
            ),
          ),
        );
      },
      itemCount: numOfKeysUtil,
    );
  }
}
