import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import "../models/chord.dart";

class ChordSelectionScreen extends StatefulWidget {
  const ChordSelectionScreen({super.key});

  @override
  State<ChordSelectionScreen> createState() => _ChordSelectionScreenState();
}

class _ChordSelectionScreenState extends State<ChordSelectionScreen> {
  final keyListSharp = [
    "C",
    "C♯",
    "D",
    "D♯",
    "E",
    "F",
    "F♯",
    "G",
    "G♯",
    "A",
    "A♯",
    "B",
  ];
  final keyListFlat = [
    "C",
    "D♭",
    "D",
    "E♭",
    "E",
    "F",
    "G♭",
    "G",
    "A♭",
    "A",
    "B♭",
    "B",
  ];
  final chordSuffix = [
    "M",
    "m",
    "dim",
    "aug",
    "sus2",
    "sus4",
    "M7",
    "m7",
    "7",
    "dim7",
    "aug7",
    "mM7",
    "m7(♭5)",
    "6",
    "m6",
  ];

  // 12 key, 15 chord suffix
  List<List<bool>> chordCheckboxVal = List.generate(
      12, (i) => List.generate(15, (i) => false, growable: false),
      growable: false);

  TextEditingController _presetNameTextController = TextEditingController();
  int _selectedKeyIndex = 0;
  List<String> _selectedChords = [];
  List<Map> _presetList = [];

  late final Database _chordPresetDb;
  final String _dbName = 'chord_presets.db';
  final String _tableName = 'Presets';
  late final String _databasesPath;

  Future<void> _getDbPath() async {
    var path = await getDatabasesPath();
    _databasesPath = join(path, _dbName);
    print(_databasesPath);
  }

  Future<void> _openDb() async {
    _chordPresetDb = await openDatabase(
      _databasesPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, name TEXT, chords TEXT)');
      },
    );
  }

  Future<void> _closeDb() async {
    await _chordPresetDb.close();
  }

  void _cleanUpDb() async {
    await _closeDb();
    await deleteDatabase(_databasesPath);
    await _openDb();
  }

  Future<void> _savePreset(String presetName) async {
    var count = Sqflite.firstIntValue(
        await _chordPresetDb.rawQuery('SELECT COUNT(*) FROM $_tableName'));
    if (count == null) count = 0;

    await _chordPresetDb.transaction((txn) async {
      var id = await txn.rawInsert(
          'INSERT INTO $_tableName(id, name, chords) VALUES(?, ?, ?)',
          [count! + 1, presetName, _selectedChords.join(',')]);
      print('inserted: $id');
    });
  }

  Future<void> _loadPresetList() async {
    var presetList = await _chordPresetDb.rawQuery('SELECT * FROM $_tableName');
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

  void _initPresetList() async {
    await _getDbPath();
    await _openDb();
    await _loadPresetList();
  }

  void _reset() {
    _loadPresetList();
    setState(() {
      _selectedKeyIndex = 0;
      _selectedChords = [];
    });
  }

  @override
  void initState() {
    _initPresetList();
    super.initState();
  }

  @override
  void dispose() {
    _closeDb();
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
                          title: Text('Save preset'),
                          content: TextFormField(
                            controller: _presetNameTextController,
                            decoration:
                                InputDecoration(hintText: "Preset name"),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('CANCEL'),
                              onPressed: () {
                                _presetNameTextController.clear();
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('OK'),
                              onPressed: () async {
                                await _savePreset(
                                    _presetNameTextController.text);
                                await _loadPresetList();
                                _presetNameTextController.clear();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      : AlertDialog(
                          content: Text("No chord selected"),
                        );
                },
              )
            },
            child: Text("Save Preset"),
          ),
          TextButton(
            onPressed: () {
              _cleanUpDb();
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
                    style: TextStyle(fontFamily: 'Noto Music'),
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
                    style: TextStyle(fontFamily: 'Noto Music'),
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
