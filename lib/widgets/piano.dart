// Reference
// https://rodydavis.com/posts/making-a-piano/

import 'package:flutter/material.dart';

import 'package:tonic/tonic.dart';
import 'package:get/get.dart';

import '../controllers/training_controller.dart';

import 'package:c2b/theme/app_colors.dart';

const BorderRadiusGeometry borderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0));

/// 가상건반 UI
class Piano extends StatelessWidget {
  Piano({super.key});

  final bool _showLabels = true;
  final TrainingController _tc = Get.find();

  /// 건반 한개를 그리는 함수.
  ///
  /// 건반이 선택됨: 연두색
  /// [accidental]이 true인 경우: 검은 건반
  /// [accidental]이 false인 경우: 흰 건반
  ///
  /// [midi]는 해당 건반(음)의 MIDI값. 88건반의 MIDI값의 범위는 21(A0)~108(C8).
  /// [keyWidth]는 건반의 너비.
  Widget _buildKey(int midi, bool accidental, double keyWidth) {
    final pitchName = Pitch.fromMidiNumber(midi).toString();

    final pianoKey = InkWell(
      borderRadius: borderRadius as BorderRadius,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: _tc.pianoStates[midi]
                  ? AppColors.secondary
                  : accidental
                      ? Colors.black
                      : Colors.white,
            ),
            child: Container(),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 20.0,
            child: _showLabels
                ? Text(
                    pitchName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Noto Music',
                      color: !accidental ? Colors.black : Colors.white,
                    ),
                  )
                : Container(),
          ),
        ],
      ),
      onTap: () => _tc.togglePianoState(midi),
    );

    if (accidental) {
      return Container(
        width: keyWidth,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        padding: EdgeInsets.symmetric(horizontal: keyWidth * 0.1),
        child: Material(
          elevation: 6.0,
          borderRadius: borderRadius,
          shadowColor: const Color(0x802196F3),
          child: pianoKey,
        ),
      );
    } else {
      return Container(
        width: keyWidth,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: pianoKey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double keyWidth = size.width * 0.08;

    return ListView.builder(
      itemCount: _tc.octaveCount,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final int i = index * 12;
        return SafeArea(
          child: Stack(children: <Widget>[
            /* 흰 건반 */
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildKey(24 + i, false, keyWidth),
                _buildKey(26 + i, false, keyWidth),
                _buildKey(28 + i, false, keyWidth),
                _buildKey(29 + i, false, keyWidth),
                _buildKey(31 + i, false, keyWidth),
                _buildKey(33 + i, false, keyWidth),
                _buildKey(35 + i, false, keyWidth),
              ],
            ),
            /* 검은 건반 */
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: size.height * 0.2,
              top: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(width: keyWidth * 0.5),
                  _buildKey(25 + i, true, keyWidth),
                  _buildKey(27 + i, true, keyWidth),
                  Container(width: keyWidth),
                  _buildKey(30 + i, true, keyWidth),
                  _buildKey(32 + i, true, keyWidth),
                  _buildKey(34 + i, true, keyWidth),
                  Container(width: keyWidth * 0.5),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}
