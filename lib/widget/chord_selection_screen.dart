import 'package:flutter/material.dart';

import "../models/chord.dart";
import "../models/preset.dart";
import "../utils/chord_table.dart";
import "../utils/preset_database.dart";

class ChordSelectionScreen extends StatefulWidget {
  const ChordSelectionScreen({super.key});

  @override
  State<ChordSelectionScreen> createState() => _ChordSelectionScreenState();
}

class _ChordSelectionScreenState extends State<ChordSelectionScreen> {
  // 12 key, 15 chord suffix
  List<List<bool>> _chordCheckboxVal = [];
  int _selectedKeyIndex = 0;
  List<Chord> _selectedChords = [];
  final _presetNameTextController = TextEditingController();
  List<Preset> _presetList = [];
  final _db = PresetDatabase(tableName: 'Presets');

  void _setChordCheckbox({List<Chord> checkedChords = const []}) {
    setState(() {
      _chordCheckboxVal = List.generate(
        keyListSharp.length,
        (i) => List.generate(
          chordSuffixes.length,
          (i) => false,
          growable: false,
        ),
        growable: false,
      );
      for (var chord in checkedChords) {
        _chordCheckboxVal[chord.key][chord.suffix] = true;
      }
    });
  }

  void _saveAsPreset() async {
    await _db.saveAsPreset(
      _presetNameTextController.text,
      _selectedChords,
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

  void _selectPreset(List<Chord> chordList) {
    var chords = chordList.toList();
    _setChordCheckbox(checkedChords: chords);
    setState(() {
      _selectedChords = chords;
    });
  }

  void _addToSelectedChords(int key, int suffix) {
    setState(() {
      _selectedChords.add(Chord(
        key: key,
        suffix: suffix,
      ));
    });
  }

  void _removeFromSelectedChords(int key, int suffix) {
    setState(() {
      _selectedChords
          .removeWhere((chord) => key == chord.key && suffix == chord.suffix);
    });
  }

  void _reset() {
    _setChordCheckbox();
    setState(() {
      _selectedKeyIndex = 0;
      _selectedChords = [];
    });
  }

  void _initPreset() async {
    await _db.init();
    await _loadPresetList();
  }

  @override
  void initState() {
    _initPreset();
    _setChordCheckbox();
    super.initState();
  }

  @override
  void dispose() {
    _db.closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
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
                  return _selectedChords.isNotEmpty
                      ? AlertDialog(
                          title: const Text('Save preset'),
                          content: TextFormField(
                            controller: _presetNameTextController,
                            decoration:
                                InputDecoration(hintText: "Preset name"),
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
                ..._selectedChords.map(
                  (chord) {
                    return [chord.name, "none"];
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
      body: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* List of keys */
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () => setState(() {
                    _selectedKeyIndex = index;
                  }),
                  child: Text(
                    keyListSharp[index],
                    style: TextStyle(fontFamily: 'Noto Music'),
                  ),
                );
              },
              itemCount: keyListSharp.length,
            ),
          ),
          /* List of chords that can user select*/
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${keyListSharp[_selectedKeyIndex]}${chordSuffixes[index]}',
                    style: const TextStyle(fontFamily: 'Noto Music'),
                  ),
                  leading: Checkbox(
                    value: _chordCheckboxVal[_selectedKeyIndex][index],
                    onChanged: (isSelected) {
                      if (isSelected != null) {
                        setState(() {
                          _chordCheckboxVal[_selectedKeyIndex][index] =
                              isSelected;
                        });
                        if (isSelected) {
                          _addToSelectedChords(_selectedKeyIndex, index);
                        } else {
                          _removeFromSelectedChords(_selectedKeyIndex, index);
                        }
                      }
                    },
                  ),
                );
              },
              itemCount: chordSuffixes.length,
            ),
          ),
          /* List of selected chords */
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _selectedChords[index].name,
                    style: const TextStyle(fontFamily: 'Noto Music'),
                  ),
                  // leading: Checkbox(
                  //   value: null,
                  //   onChanged: null,
                  // ),
                );
              },
              itemCount: _selectedChords.length,
            ),
          ),
          /* List of presets */
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _selectPreset(_presetList[index].chordList),
                  title: Text(_presetList[index].name),
                );
              },
              itemCount: _presetList.length,
            ),
          ),
        ],
      ),
    );
  }
}
