import 'package:flutter/material.dart';

// import "../models/chord.dart";
import "../utils/chord_table.dart";
import "../utils/preset_database.dart";

class ChordSelectionScreen extends StatefulWidget {
  const ChordSelectionScreen({super.key});

  @override
  State<ChordSelectionScreen> createState() => _ChordSelectionScreenState();
}

class _ChordSelectionScreenState extends State<ChordSelectionScreen> {
  // 12 key, 15 chord suffix
  List<List<bool>> chordCheckboxVal = List.generate(
      12, (i) => List.generate(15, (i) => false, growable: false),
      growable: false);

  final _presetNameTextController = TextEditingController();
  int _selectedKeyIndex = 0;
  List<String> _selectedChords = [];
  List<Map> _presetList = [];
  final _tableName = 'Presets';
  final _db = PresetDatabase(tableName: 'Presets');

  void _savePreset() async {
    await _db.savePreset(
      _presetNameTextController.text,
      _selectedChords,
    );
    await _loadPresetList();
    _presetNameTextController.clear();
  }

  Future<void> _loadPresetList() async {
    var presetList = await _db.query('SELECT * FROM $_tableName');
    setState(() {
      _presetList = presetList;
    });
    print("preset list:");
    print(_presetList);
  }

  void _selectPreset(int index) {
    // index != id. id doesn't guarantee consistent increment
    setState(() {
      _selectedChords = (_presetList[index]['chords']).toString().split(',');
    });
    print(_selectedChords);
  }

  void _reset() {
    _loadPresetList();
    setState(() {
      _selectedKeyIndex = 0;
      _selectedChords = [];
    });
  }

  void initPreset() async {
    await _db.init();
    await _loadPresetList();
  }

  @override
  void initState() {
    initPreset();
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
                                _savePreset();
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
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedChords);
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
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${keyListSharp[_selectedKeyIndex]}${chordSuffix[index]}',
                    style: const TextStyle(fontFamily: 'Noto Music'),
                  ),
                  leading: Checkbox(
                    value: chordCheckboxVal[_selectedKeyIndex][index],
                    onChanged: (isSelected) {
                      setState(() {
                        if (isSelected != null) {
                          chordCheckboxVal[_selectedKeyIndex][index] =
                              isSelected;
                          if (isSelected) {
                            _selectedChords.add(
                                '${keyListSharp[_selectedKeyIndex]}${chordSuffix[index]}');
                          } else {
                            _selectedChords.removeWhere((chord) =>
                                chord ==
                                '${keyListSharp[_selectedKeyIndex]}${chordSuffix[index]}');
                          }
                        }
                      });
                    },
                  ),
                );
              },
              itemCount: chordSuffix.length,
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _selectedChords[index],
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
          // List of presets
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _selectPreset(index),
                  title: Text(_presetList[index]['name']),
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
