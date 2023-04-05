import 'package:flutter/material.dart';

import 'package:get/get.dart';

import "../models/preset.dart";
import "../utils/chord_table.dart";
import "../utils/preset_database.dart";
import '../controllers/select_controller.dart';

class ChordSelectScreen extends StatefulWidget {
  const ChordSelectScreen({super.key});

  @override
  State<ChordSelectScreen> createState() => _ChordSelectScreenState();
}

class _ChordSelectScreenState extends State<ChordSelectScreen> {
  final SelectController _selectController = Get.find();

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          /* Key */
          DropdownButton(
            value: _selectController.getKeyIndex(),
            items: keyListUtil.map((keyStr) {
              var keyIndex = keyIndexUtil(keyStr);
              var relativeKeyStr = keyListUtil[(keyIndex + 9) % 12];
              return DropdownMenuItem(
                value: keyIndexUtil(keyStr),
                child: Text(
                  '${keyStr}M(${relativeKeyStr}m)',
                  style: const TextStyle(
                    fontFamily: 'Noto Music',
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectController.setKeyIndex(value!);
              });
            },
          ),
          /* Diatonic */
          TextButton(
            onPressed: () => _selectController.setDiatonic(),
            child: const Text(
              'Diatonic',
              style: TextStyle(color: Colors.white),
            ),
          ),
          /* Reset */
          TextButton(
            onPressed: _reset,
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
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
            child: const Text(
              "Save Preset",
              style: TextStyle(color: Colors.white),
            ),
          ),
          /* clean up db */
          TextButton(
            onPressed: () async {
              await _db.cleanUpDb();
              _reset();
            },
            child: const Text(
              'cleanUpDb',
              style: TextStyle(color: Colors.white),
            ),
          ),
          /* Done */
          TextButton(
            onPressed: () {
              var trainingSet = [
                ..._selectController.get().map(
                  (chord) {
                    return [chord.name(), chordNotesUtil(chord)];
                  },
                )
              ];
              Navigator.pop(context, trainingSet);
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
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
                        style: const TextStyle(
                            fontFamily: 'Noto Music', fontSize: 18),
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
                    return ListTile(
                      title: Text(
                        '${rootStringUtil(_selectController.getKeyIndex(), _selectedRootIndex)}${qualityToStringUtil(index)}',
                        style: const TextStyle(fontFamily: 'Noto Music'),
                      ),
                      leading: Checkbox(
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
                          }),
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
                    return ListTile(
                      title: Text(
                        chord.name(),
                        style: const TextStyle(fontFamily: 'Noto Music'),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_rounded),
                        onPressed: () {
                          _selectController.deselect(
                              chord.rootIndex, chord.qualityIndex);
                        },
                      ),
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
                                    ElevatedButton(
                                      onPressed: () {
                                        return Navigator.of(context).pop(false);
                                      },
                                      child: const Text('CANCEL'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        return Navigator.of(context).pop(true);
                                      },
                                      child: const Text('DELETE'),
                                    ),
                                  ],
                                );
                              }).then((value) => Future.value(value));
                        },
                        background: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        child: ListTile(
                          onTap: () => _selectController.set(
                              checkedChords: (preset.chordList).toList()),
                          title: Text(
                            preset.name,
                            overflow: TextOverflow.ellipsis,
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
