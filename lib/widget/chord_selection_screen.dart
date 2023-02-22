import 'package:flutter/material.dart';

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

  List<List<bool>> chordCheckboxVal = List.generate(
      12, (i) => List.generate(15, (i) => false, growable: false),
      growable: false);
  int selectedKeyIndex = 0;

  List<String> selectedChords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedChords);
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
                    selectedKeyIndex = index;
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
                    '${keyListSharp[selectedKeyIndex]}${chordSuffix[index]}',
                    style: TextStyle(fontFamily: 'Noto Music'),
                  ),
                  leading: Checkbox(
                    value: chordCheckboxVal[selectedKeyIndex][index],
                    onChanged: (isSelected) {
                      setState(() {
                        if (isSelected != null) {
                          chordCheckboxVal[selectedKeyIndex][index] =
                              isSelected;
                          if (isSelected) {
                            selectedChords.add(
                                '${keyListSharp[selectedKeyIndex]}${chordSuffix[index]}');
                          } else {
                            selectedChords.removeWhere((chord) =>
                                chord ==
                                '${keyListSharp[selectedKeyIndex]}${chordSuffix[index]}');
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
                    selectedChords[index],
                    style: TextStyle(fontFamily: 'Noto Music'),
                  ),
                  // leading: Checkbox(
                  //   value: null,
                  //   onChanged: null,
                  // ),
                );
              },
              itemCount: selectedChords.length,
            ),
          ),
        ],
      ),
    );
  }
}
