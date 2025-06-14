import 'package:c2b/widgets/select_key_dropdown.dart';
import 'package:c2b/widgets/select_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import "../utils/chord_table.dart";
import '../controllers/presets_controller.dart';
import '../controllers/select_controller.dart';
import 'package:c2b/theme/app_colors.dart';
import 'package:c2b/theme/app_text_styles.dart';

import '../widgets/row_divider.dart';

class ChordSelectScreen extends StatefulWidget {
  const ChordSelectScreen({super.key});

  @override
  State<ChordSelectScreen> createState() => _ChordSelectScreenState();
}

/* State Lifecycle
 * 
 * initState(): HomeScreen에서 ChordSelectScreen으로 이동할 때.
 * dispose(): ChordSelectScreen에서 HomeScreen으로 이동할 때
 * ChordSelectScreen, TrainingScreen 간 이동할 때는 State 유지
 */
class _ChordSelectScreenState extends State<ChordSelectScreen> {
  final _sc = Get.put(SelectController());
  final _db = Get.put(PresetsController());
  final _presetNameTextController = TextEditingController();

  //TODO: Remove or encapsulate
  void _reset() {
    _sc.setSelected(const []);
    _sc.rootIndex = 0;
  }

  @override
  void initState() {
    /* Orientation을 landscape로 강제
     * TrainingScreen에서 ChordSelectScreen로 가는 것 이외 이동경로는 없기 때문에
     * TrainingScreen의 Orientation도 동일하게 landscape로 강제됨
     */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    /* Remove orientation constraints */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    var title2Style =
        AppTextStyle.title2.copyWith(fontSize: screenWidth * 0.024);
    var listItemStyle =
        AppTextStyle.button1.copyWith(fontSize: screenWidth * 0.023);
    var selectorStyle =
        AppTextStyle.button1.copyWith(fontSize: screenWidth * 0.024);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          /* Select key */
          GetBuilder<SelectController>(
            builder: (selCtrlr) {
              return SelectKeyDropdown(
                value: selCtrlr.keyIndex,
                onChanged: (value) => selCtrlr.setKeyIndex(value!),
              );
            },
          ),
          /* Diatonic */
          TextButton(
            onPressed: () => _sc.setDiatonic(),
            child: Text('Diatonic', style: title2Style),
          ),
          /* Reset */
          TextButton(
            onPressed: _reset,
            child: Text('Reset', style: title2Style),
          ),
          /* Save Preset */
          TextButton(
            onPressed: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Dialog - get preset name
                  return _sc.isNotEmpty()
                      ? AlertDialog(
                          title: const Text('Save preset'),
                          content: TextFormField(
                            controller: _presetNameTextController,
                            decoration:
                                const InputDecoration(hintText: "Preset name"),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('CANCEL'),
                              onPressed: () {
                                _presetNameTextController.clear();
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                _db.saveAsPreset(
                                  _presetNameTextController.text,
                                  _sc.selected,
                                );
                                _presetNameTextController.clear();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      : const AlertDialog(
                          content: Text("No chord selected"),
                        );
                },
              )
            },
            child: Text("Save", style: title2Style),
          ),
          /* Done */
          TextButton(
            onPressed: () {
              if (_sc.setTraining()) {
                Get.toNamed('/training');
              } else {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return const AlertDialog(
                      content: Text("No chord selected"),
                    );
                  },
                );
              }
            },
            child: Text('Done', style: title2Style),
          ),
        ],
      ),
      body: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* Root note selector */
          GetBuilder<SelectController>(
            builder: (selCtrlr) {
              return Flexible(
                flex: 2,
                child: SelectRoot(
                  keyIndex: selCtrlr.keyIndex,
                  onPressed: (index) => selCtrlr.rootIndex = index,
                ),
              );
            },
          ),
          const RowDivider(),
          /* List of chords that user can select */
          GetBuilder<SelectController>(
            builder: (selCtrlr) {
              return Flexible(
                flex: 4,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Checkbox(
                            value: selCtrlr.isCheckedAt(index),
                            onChanged: (isSelected) {
                              if (isSelected!) {
                                selCtrlr.select(selCtrlr.rootIndex, index);
                              } else {
                                selCtrlr.deselect(selCtrlr.rootIndex, index);
                              }
                            },
                            activeColor: AppColors.secondary,
                          ),
                        ),
                        Text(
                          '${rootStringUtil(selCtrlr.keyIndex, selCtrlr.rootIndex)}${qualityToStringUtil(index)}',
                          style: listItemStyle,
                        ),
                      ],
                    );
                  },
                  itemCount: qualityUtil.length,
                ),
              );
            },
          ),
          const RowDivider(),
          /* List of selected chords */
          GetBuilder<SelectController>(
            builder: (selCtrlr) {
              return Flexible(
                flex: 4,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var chord = selCtrlr.atIndex(index);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          chordNameUtil(
                            selCtrlr.keyIndex,
                            chord.rootIndex,
                            chord.qualityIndex,
                          ),
                          style: listItemStyle,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle_rounded,
                            size: screenWidth * 0.03,
                          ),
                          onPressed: () {
                            selCtrlr.deselect(
                                chord.rootIndex, chord.qualityIndex);
                          },
                          color: AppColors.secondary,
                        ),
                      ],
                    );
                  },
                  itemCount: selCtrlr.length(),
                ),
              );
            },
          ),
          const RowDivider(),
          /* List of presets */
          Flexible(
            flex: 3,
            child: GetBuilder<PresetsController>(
              builder: (db) {
                return ClipRect(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var preset = db.presetList[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        dismissThresholds: const {
                          DismissDirection.endToStart: 0.5
                        },
                        onDismissed: (direction) async {
                          await db.deletePreset(preset.id);
                        },
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text('Delete preset "${preset.name}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text('NO'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    child: const Text('YES'),
                                  )
                                ],
                              );
                            },
                          ).then(
                            (value) => Future.value(value),
                          );
                        },
                        background: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                          ),
                          alignment: Alignment.centerRight,
                          color: AppColors.secondary,
                          child: const Icon(
                            Icons.delete,
                          ),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () =>
                              _sc.setSelected((preset.chordList).toList()),
                          child: Text(
                            preset.name,
                            overflow: TextOverflow.ellipsis,
                            style: selectorStyle,
                          ),
                        ),
                      );
                    },
                    itemCount: db.presetList.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
