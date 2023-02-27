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

  void _setChordSelection({List<Chord> checkedChords = const []}) {
    // Reset
    setState(() {
      _selectedChords = [];
      _chordCheckboxVal = List.generate(
        keyListSharpUtil.length,
        (i) => List.generate(
          chordSuffixesUtil.length,
          (i) => false,
          growable: false,
        ),
        growable: false,
      );
    });
    for (var chord in checkedChords) {
      _selectChord(chord.key, chord.suffixIndex);
    }
  }

  //TODO: Remove or encapsulate
  void _setDiatonicSelection() {
    _selectChord(_selectedKeyIndex, suffixIndexMapUtil['M']!);
    _selectChord(_selectedKeyIndex, suffixIndexMapUtil['M7']!);
    _selectChord(_selectedKeyIndex + 1, suffixIndexMapUtil['m']!);
    _selectChord(_selectedKeyIndex + 1, suffixIndexMapUtil['m7']!);
    _selectChord(_selectedKeyIndex + 2, suffixIndexMapUtil['m']!);
    _selectChord(_selectedKeyIndex + 2, suffixIndexMapUtil['m7']!);
    _selectChord(_selectedKeyIndex + 3, suffixIndexMapUtil['M']!);
    _selectChord(_selectedKeyIndex + 3, suffixIndexMapUtil['M7']!);
    _selectChord(_selectedKeyIndex + 4, suffixIndexMapUtil['M']!);
    _selectChord(_selectedKeyIndex + 4, suffixIndexMapUtil['7']!);
    _selectChord(_selectedKeyIndex + 4, suffixIndexMapUtil['sus4']!);
    _selectChord(_selectedKeyIndex + 4, suffixIndexMapUtil['7sus4']!);
    _selectChord(_selectedKeyIndex + 5, suffixIndexMapUtil['m']!);
    _selectChord(_selectedKeyIndex + 5, suffixIndexMapUtil['m7']!);
    _selectChord(_selectedKeyIndex + 6, suffixIndexMapUtil['dim']!);
    _selectChord(_selectedKeyIndex + 6, suffixIndexMapUtil['m7♭5']!);
  }

  void _selectChord(int key, int suffixIndex) {
    if (_chordCheckboxVal[key][suffixIndex] == true) return;
    setState(() {
      /* TODO:
       * Remove input manipulation (converting to be within range 0~11) from high level function.
       * Move to wrapper implementation not to make user care of it.
       */
      _chordCheckboxVal[key % 12][suffixIndex] = true;
      _selectedChords.add(Chord(
        key: key,
        suffixIndex: suffixIndex,
      ));
    });
  }

  void _deSelectChord(int key, int suffixIndex) {
    if (_chordCheckboxVal[key][suffixIndex] == false) return;
    setState(() {
      /* TODO:
       * Remove input manipulation (converting to be within range 0~11) from high level function.
       * Move to wrapper implementation not to make user care of it.
       */
      _chordCheckboxVal[key % 12][suffixIndex] = false;
      _selectedChords.removeWhere(
          (chord) => key == chord.key && suffixIndex == chord.suffixIndex);
    });
  }

  void _reset() {
    _setChordSelection();
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

  @override
  void initState() {
    _initPreset();
    _setChordSelection();
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
          /* Diatonic */
          TextButton(
            onPressed: _setDiatonicSelection,
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
                  return _selectedChords.isNotEmpty
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
                ..._selectedChords.map(
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
      body: Row(
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
                    style:
                        const TextStyle(fontFamily: 'Noto Music', fontSize: 18),
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
                      value: _chordCheckboxVal[_selectedKeyIndex][index],
                      onChanged: (isSelected) {
                        if (isSelected!) {
                          _selectChord(_selectedKeyIndex, index);
                        } else {
                          _deSelectChord(_selectedKeyIndex, index);
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
                var chord = _selectedChords[index];
                return ListTile(
                  title: Text(
                    chord.name,
                    style: const TextStyle(fontFamily: 'Noto Music'),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_rounded),
                    onPressed: () {
                      _deSelectChord(chord.key, chord.suffixIndex);
                    },
                  ),
                );
              },
              itemCount: _selectedChords.length,
            ),
          ),
          const RowDivider(),
          /* List of presets */
          Flexible(
            flex: 4,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _setChordSelection(
                      checkedChords: (_presetList[index].chordList).toList()),
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
