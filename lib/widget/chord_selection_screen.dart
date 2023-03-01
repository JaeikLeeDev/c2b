import 'package:flutter/material.dart';

import 'package:get/get.dart';

import "../models/preset.dart";
import "../utils/chord_table.dart";
import "../utils/preset_database.dart";
import '../controllers/select_controller.dart';

class ChordSelectionScreen extends StatefulWidget {
  const ChordSelectionScreen({super.key});

  @override
  State<ChordSelectionScreen> createState() => _ChordSelectionScreenState();
}

class _ChordSelectionScreenState extends State<ChordSelectionScreen> {
  final SelectController _selectController = Get.find();
  int _selectedKeyIndex = 0;
  final _presetNameTextController = TextEditingController();
  List<Preset> _presetList = [];
  final _db = PresetDatabase();

  //TODO: Remove or encapsulate
  void _reset() {
    _selectController.set();
    setState(() {
      _selectedKeyIndex = 0;
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
          /* Diatonic */
          TextButton(
            onPressed: () => _selectController.setDiatonic(_selectedKeyIndex),
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
                    return [chord.name, chordNotesUtil(chord.toDecodedChord())];
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
              /* List of keys */
              Flexible(
                flex: 2,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return TextButton(
                      onPressed: () => setState(() {
                        _selectedKeyIndex = index;
                      }),
                      child: Text(
                        keyListSharpUtil[index],
                        style: const TextStyle(
                            fontFamily: 'Noto Music', fontSize: 18),
                      ),
                    );
                  },
                  itemCount: keyListSharpUtil.length,
                ),
              ),
              const RowDivider(),
              /* List of chords that can user select*/
              Flexible(
                flex: 3,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        '${keyListSharpUtil[_selectedKeyIndex]}${chordNameUtil(index)}',
                        style: const TextStyle(fontFamily: 'Noto Music'),
                      ),
                      leading: Checkbox(
                          value: _selectController.isCheckedAt(
                              _selectedKeyIndex, index),
                          onChanged: (isSelected) {
                            if (isSelected!) {
                              _selectController.select(
                                  _selectedKeyIndex, index);
                            } else {
                              _selectController.deselect(
                                  _selectedKeyIndex, index);
                            }
                          }),
                    );
                  },
                  itemCount: chordSuffixesUtil.length,
                ),
              ),
              const RowDivider(),
              /* List of selected chords */
              Flexible(
                flex: 3,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var chord = _selectController.atIndex(index);
                    return ListTile(
                      title: Text(
                        chord.name,
                        style: const TextStyle(fontFamily: 'Noto Music'),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_rounded),
                        onPressed: () {
                          _selectController.deselect(
                              chord.key, chord.suffixIndex);
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
                flex: 4,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => _selectController.set(
                          checkedChords:
                              (_presetList[index].chordList).toList()),
                      title: Text(_presetList[index].name),
                    );
                  },
                  itemCount: _presetList.length,
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
