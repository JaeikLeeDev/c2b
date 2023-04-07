import 'package:flutter/material.dart';

import 'package:get/get.dart';

import "../models/preset.dart";
import "../utils/chord_table.dart";
import "../utils/preset_database.dart";
import '../controllers/select_controller.dart';
import 'package:c2b/theme/app_colors.dart';
import 'package:c2b/theme/app_text_styles.dart';

class ChordSelectScreen extends StatefulWidget {
  const ChordSelectScreen({super.key});

  @override
  State<ChordSelectScreen> createState() => _ChordSelectScreenState();
}

class _ChordSelectScreenState extends State<ChordSelectScreen> {
  final _selectController = Get.put(SelectController());

  int _selectedRootIndex = 0;
  final _presetNameTextController = TextEditingController();
  List<Preset> _presetList = [];
  final _db = PresetDatabase();

  //TODO: Remove or encapsulate
  void _reset() {
    _selectController.set();
    setState(() {
      _selectedRootIndex = 0;
    });
  }

  void _initPreset() async {
    await _db.init();
    await _loadPresetList();
  }

  void _saveAsPreset() async {
    await _db.saveAsPreset(
      _presetNameTextController.text,
      _selectController.get(),
    );
    await _loadPresetList();
    _presetNameTextController.clear();
  }

  Future<void> _loadPresetList() async {
    var presetList = await _db.getPresetList();
    setState(() {
      _presetList = presetList;
    });
  }

  @override
  void initState() {
    _initPreset();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

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
            icon: Icon(Icons.arrow_back)),
        actions: [
          /* Set key */
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: DropdownButton(
              alignment: AlignmentDirectional.center,
              iconEnabledColor: Colors.white,
              value: _selectController.getKeyIndex(),
              items: keyListUtil.map((keyStr) {
                var keyIndex = keyIndexUtil(keyStr);
                var relativeKeyStr = keyListUtil[(keyIndex + 9) % 12];
                return DropdownMenuItem(
                  value: keyIndexUtil(keyStr),
                  child: Text(
                    '${keyStr}M(${relativeKeyStr}m)',
                    style: title2Style.copyWith(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectController.setKeyIndex(value!);
                });
              },
            ),
          ),
          /* Diatonic */
          TextButton(
            onPressed: () => _selectController.setDiatonic(),
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
                  return _selectController.isNotEmpty()
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
                                _saveAsPreset();
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
            child: Text("Save Preset", style: title2Style),
          ),
          /* clean up db */
          TextButton(
            onPressed: () async {
              await _db.cleanUpDb();
              _reset();
            },
            child: Text('cleanUpDb', style: title2Style),
          ),
          /* Done */
          TextButton(
            onPressed: () {
              _selectController.setChordList();
              Get.toNamed('/training');
            },
            child: Text('Done', style: title2Style),
          ),
        ],
      ),
      body: GetBuilder<SelectController>(
        builder: (_) {
          return Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* List of roots */
              Flexible(
                flex: 2,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return TextButton(
                      onPressed: () => setState(() {
                        _selectedRootIndex = index;
                      }),
                      child: Text(
                        rootStringUtil(_selectController.getKeyIndex(), index),
                        style: selectorStyle,
                      ),
                    );
                  },
                  itemCount: numOfKeysUtil,
                ),
              ),
              const RowDivider(),
              /* List of chords that can user select*/
              Flexible(
                flex: 4,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Checkbox(
                            value: _selectController.isCheckedAt(
                                _selectedRootIndex, index),
                            onChanged: (isSelected) {
                              if (isSelected!) {
                                _selectController.select(
                                    _selectedRootIndex, index);
                              } else {
                                _selectController.deselect(
                                    _selectedRootIndex, index);
                              }
                            },
                            activeColor: AppColors.secondary,
                          ),
                        ),
                        Text(
                          '${rootStringUtil(_selectController.getKeyIndex(), _selectedRootIndex)}${qualityToStringUtil(index)}',
                          style: listItemStyle,
                        ),
                      ],
                    );
                  },
                  itemCount: qualityUtil.length,
                ),
              ),
              const RowDivider(),
              /* List of selected chords */
              Flexible(
                flex: 4,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var chord = _selectController.atIndex(index);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          chord.name(),
                          style: listItemStyle,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle_rounded,
                            size: screenWidth * 0.03,
                          ),
                          onPressed: () {
                            _selectController.deselect(
                                chord.rootIndex, chord.qualityIndex);
                          },
                          color: AppColors.secondary,
                        ),
                      ],
                    );
                  },
                  itemCount: _selectController.length(),
                ),
              ),
              const RowDivider(),
              /* List of presets */
              Flexible(
                flex: 3,
                child: ClipRect(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var preset = _presetList[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        dismissThresholds: const {
                          DismissDirection.endToStart: 0.5
                        },
                        onDismissed: (direction) async {
                          await _db.deletePreset(preset.id);
                          _loadPresetList();
                        },
                        confirmDismiss: (direction) {
                          return showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content:
                                      Text('Delete preset "${preset.name}"?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        return Navigator.of(context).pop(false);
                                      },
                                      child: const Text('NO'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        return Navigator.of(context).pop(true);
                                      },
                                      child: const Text('YES'),
                                    )
                                  ],
                                );
                              }).then((value) => Future.value(value));
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
                          onPressed: () => _selectController.set(
                              checkedChords: (preset.chordList).toList()),
                          child: Text(
                            preset.name,
                            overflow: TextOverflow.ellipsis,
                            style: selectorStyle,
                          ),
                        ),
                      );
                    },
                    itemCount: _presetList.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

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
