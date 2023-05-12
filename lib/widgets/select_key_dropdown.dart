import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../utils/chord_table.dart';

class SelectKeyDropdown extends StatelessWidget {
  const SelectKeyDropdown({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int value;
  final void Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var orientation = MediaQuery.of(context).orientation;
    var title2Style = AppTextStyle.title2.copyWith(color: Colors.black);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: DropdownButton(
        alignment: AlignmentDirectional.center,
        iconEnabledColor: Colors.white,
        value: value,
        items: keyListUtil.map((keyStr) {
          var keyIndex = keyIndexUtil(keyStr);
          var relativeKeyStr = keyListUtil[(keyIndex + 9) % 12];
          return DropdownMenuItem(
            value: keyIndexUtil(keyStr),
            child: Text(
              '${keyStr}M(${relativeKeyStr}m)',
              style: title2Style.copyWith(
                fontSize: orientation == Orientation.landscape
                    ? screenWidth * 0.024
                    : screenWidth * 0.04,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
