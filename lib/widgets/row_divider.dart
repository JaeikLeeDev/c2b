import 'package:flutter/material.dart';

class RowDivider extends StatelessWidget {
  const RowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      color: Colors.grey,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }
}
