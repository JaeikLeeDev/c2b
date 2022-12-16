import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final List<String> chord;
  final bool isCur;
  const Bar({required this.chord, required this.isCur, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
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
            SizedBox(height: 10),
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
