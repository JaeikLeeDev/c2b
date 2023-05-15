import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../utils/chord_table.dart';

class SelectRoot extends StatelessWidget {
  const SelectRoot({
    required this.keyIndex,
    required this.onPressed,
    super.key,
  });

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
