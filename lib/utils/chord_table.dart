final numOfKeysUtil = keyListUtil.length;

const keyListUtil = [
  "C", // 0
  "D♭", // 1
  "D", // 2
  "E♭", // 3
  "E", // 4
  "F", // 5
  "G♭", // 6
  "G", // 7
  "A♭", // 8
  "A", // 9
  "B♭", // 10
  "B", // 11
];

const pitchSharpUtil = [
  "C", // 0
  "C♯", // 1
  "D", // 2
  "D♯", // 3
  "E", // 4
  "F", // 5
  "F♯", // 6
  "G", // 7
  "G♯", // 8
  "A", // 9
  "A♯", // 10
  "B", // 11
];
const pitchFlatUtil = [
  "C", // 0
  "D♭", // 1
  "D", // 2
  "E♭", // 3
  "E", // 4
  "F", // 5
  "G♭", // 6
  "G", // 7
  "A♭", // 8
  "A", // 9
  "B♭", // 10
  "B", // 11
];

String pitchUtil(bool isSharp, int index) {
  return isSharp ? pitchSharpUtil[index % 12] : pitchFlatUtil[index % 12];
}

const qualityUtil = [
  [
    "m",
    [0, 3, 7]
  ],
  [
    "m7",
    [0, 3, 7, 10]
  ],
  [
    "m7♭5",
    [0, 3, 6, 10]
  ],
  [
    "m7♭9",
    [0, 3, 7, 10, 13]
  ],
  [
    "m7♭9♭5",
    [0, 3, 6, 10, 13]
  ],
  [
    "m9",
    [0, 3, 7, 10, 14]
  ],
  [
    "m(add9)",
    [0, 3, 7, 14]
  ],
  [
    "m(add11)",
    [0, 3, 7, 17]
  ],
  [
    "m11",
    [0, 3, 7, 10, 14, 17]
  ],
  [
    "m13",
    [0, 3, 7, 10, 14, 17, 21]
  ],
  [
    "m6/7",
    [0, 3, 7, 9, 10]
  ],
  [
    "m6",
    [0, 3, 7, 9]
  ],
  [
    "mM7",
    [0, 3, 7, 11]
  ],
  [
    "mM9",
    [0, 3, 7, 11, 14]
  ],
  [
    "M",
    [0, 4, 7]
  ],
  [
    "M7",
    [0, 4, 7, 11]
  ],
  [
    "M7♯11",
    [0, 4, 7, 11, 18]
  ],
  [
    "M7♯5",
    [0, 4, 8, 11]
  ],
  [
    "M9",
    [0, 4, 7, 11, 14]
  ],
  [
    "add2",
    [0, 2, 4, 7]
  ],
  [
    "add9",
    [0, 4, 7, 14]
  ],
  [
    "add11",
    [0, 4, 7, 17]
  ],
  [
    "sus2",
    [0, 2, 7]
  ],
  [
    "sus4",
    [0, 5, 7]
  ],
  [
    "7sus2",
    [0, 2, 7, 10]
  ],
  [
    "7sus4",
    [0, 5, 7, 10]
  ],
  [
    "7sus4♭9",
    [0, 5, 7, 10, 13]
  ],
  [
    "9sus4",
    [0, 5, 7, 10, 14]
  ],
  [
    "aug",
    [0, 4, 8]
  ],
  [
    "aug7",
    [0, 4, 8, 10]
  ],
  [
    "dim",
    [0, 3, 6]
  ],
  [
    "dim7",
    [0, 3, 6, 9]
  ],
  [
    "7",
    [0, 4, 7, 10]
  ],
  [
    "7♭5",
    [0, 4, 6, 10]
  ],
  [
    "7♭9",
    [0, 4, 7, 10, 13]
  ],
  [
    "7♭9♭5",
    [0, 4, 6, 10, 13]
  ],
  [
    "7♭13",
    [0, 4, 7, 10, 20]
  ],
  [
    "7♯5",
    [0, 4, 8, 10]
  ],
  [
    "7♯9",
    [0, 4, 7, 10, 15]
  ],
  [
    "7♯9♯5",
    [0, 4, 8, 10, 15]
  ],
  [
    "7♭9♯5",
    [0, 4, 8, 10, 13]
  ],
  [
    "7(13)",
    [0, 4, 7, 10, 21]
  ],
  [
    "7alt",
    [0, 4, 6, 10, 13]
  ],
  [
    "9",
    [0, 4, 7, 10, 14]
  ],
  [
    "9♭5",
    [0, 4, 6, 10, 14]
  ],
  [
    "9♯5",
    [0, 4, 8, 10, 14]
  ],
  [
    "7/6",
    [0, 4, 7, 9, 10]
  ],
  [
    "6/9",
    [0, 4, 7, 9, 14]
  ],
  [
    "6",
    [0, 4, 7, 9]
  ],
  [
    "11",
    [0, 4, 7, 10, 14, 17]
  ],
  [
    "13",
    [0, 4, 7, 10, 14, 17, 21]
  ],
];

final diatonicUtil = [
  // root
  [0, qualityIndexOf('M')],
  [0, qualityIndexOf('M7')],
  [0, qualityIndexOf('M9')],
  // 2 of the key
  [2, qualityIndexOf('m')],
  [2, qualityIndexOf('m7')],
  [2, qualityIndexOf('m9')],
  // 3 of the key
  [4, qualityIndexOf('m')],
  [4, qualityIndexOf('m7')],
  [4, qualityIndexOf('m7♭9')],
  // 4 of the key
  [5, qualityIndexOf('M')],
  [5, qualityIndexOf('M7')],
  [5, qualityIndexOf('M9')],
  // 5 of the key
  [7, qualityIndexOf('M')],
  [7, qualityIndexOf('7')],
  [7, qualityIndexOf('9')],
  [7, qualityIndexOf('sus4')],
  [7, qualityIndexOf('7sus4')],
  [7, qualityIndexOf('9sus4')],
  // 6 of the key
  [9, qualityIndexOf('m')],
  [9, qualityIndexOf('m7')],
  [9, qualityIndexOf('m9')],
  // 7 of the key
  [11, qualityIndexOf('dim')],
  [11, qualityIndexOf('m7♭5')],
  [11, qualityIndexOf('m7♭9♭5')],
];

int keyIndexUtil(String index) {
  return keyListUtil.indexOf(index);
}

// key: chord quality name. ex) m7, 7sus4, ...
// value: location(index) of a chord quality in qualityUtil
final Map<String, int> _qualityToIndexMapUtil = {
  for (int qulityIndex = 0; qulityIndex < qualityUtil.length; qulityIndex++)
    qualityUtil[qulityIndex][0] as String: qulityIndex,
};

int qualityIndexOf(String quality) {
  return _qualityToIndexMapUtil[quality] as int;
}

String qualityToStringUtil(int index) {
  return qualityUtil[index][0] as String;
}

String chordNotesUtil(int keyIdx, int rootIdx, int qualityIdx) {
  var noteList = qualityUtil[qualityIdx][1] as List<int>;
  bool isSharp = isSharpGroup(keyIdx);

  // Get notes of the chord using the key
  // and the distance (integer notation) from the root.
  String notesStr = pitchUtil(isSharp, rootIdx);
  for (int i = 1; i < noteList.length; i++) {
    notesStr += " ${pitchUtil(isSharp, rootIdx + noteList[i])}";
  }
  return notesStr;
}

// return a String of a chord notation
// ex) C#m7, E7sus4, Gadd9, ...
String chordNameUtil(int keyIdx, int rootIdx, int qualityIdx) {
  return isSharpGroup(keyIdx)
      ? '${pitchUtil(true, rootIdx)}${qualityToStringUtil(qualityIdx)}'
      : '${pitchUtil(false, rootIdx)}${qualityToStringUtil(qualityIdx)}';
}

String rootStringUtil(int keyIndex, int rootIndex) {
  return pitchUtil(isSharpGroup(keyIndex), rootIndex);
}

bool isSharpGroup(int keyIndex) {
  bool isSharp;

  switch (keyIndex % 12) {
    case 0: // C
    case 7: // G
    case 2: // D
    case 9: // A
    case 4: // E
    case 11: // B
      isSharp = true;
      break;
    case 5: // F, Gb
    case 10: // Bb
    case 3: // Eb, D#
    case 8: // Ab, G#
    case 1: // Db, C#
    case 6: // Gb, F#
      isSharp = false;
      break;
    default:
      isSharp = true;
      break;
  }

  return isSharp;
}

// sample chord training set
const fMajorChordListUtil = [
  ['FM', 'F A C'],
  ['FM7', 'F A C E'],
  ['FM9', 'F A C E G'],
  ['Fsus4', 'F B♭ C'],
  ['F7sus4', 'F B♭ C E♭'],
  ['Gm', 'G B♭ D'],
  ['Gm7', 'G B♭ D F'],
  ['Gm9', 'G B♭ D F A'],
  ['Gsus4', 'G C D'],
  ['Am', 'A C E'],
  ['Am7', 'A C E G'],
  ['Asus4', 'A D E'],
  ['B♭M', 'B♭ D F'],
  ['B♭6', 'B♭ D F G'],
  ['B♭m6', 'B♭ D♭ F G'],
  ['B♭M7', 'B♭ D F A'],
  ['B♭mM7', 'B♭ D♭ F A'],
  ['B7(♭5)', 'B E♭ F A'],
  ['CM', 'C E G'],
  ['Cm7', 'C E♭ G B♭'],
  ['C7', 'C E G B♭'],
  ['Csus4', 'C F G'],
  ['C7sus4', 'C F G B♭'],
  ['C9sus4', 'C F G B♭ D'],
  ['Dm', 'D F A'],
  ['Dm7', 'D F A C'],
  ['Dsus4', 'D G A'],
  ['D7sus4', 'D G A C'],
  ['Edim', 'E G B♭'],
  ['Edim7', 'E G B♭ D♭'],
  ['Em7(♭5)', 'E G B♭ D'],
];

/* Integer Notation
["m", [0, 3, 7]],
["m7", [0, 3, 7, 10]],
["m7♭5", [0, 3, 6, 10]],
["m7♭9", [0, 3, 7, 10, 13]],
["m7♭9♭5", [0, 3, 6, 10, 13]],
["m9", [0, 3, 7, 10, 14]],
["m(add4)", [0, 3, 7, 12]],
["m(add9)", [0, 3, 7, 14]],
["m(add11)", [0, 3, 7, 17]],
["m11", [0, 3, 7, 10, 14, 17]],
["m13", [0, 3, 7, 10, 14, 17, 21]],
["m6/7", [0, 3, 7, 9, 10]],
["m6", [0, 3, 7, 9]],
["mM7", [0, 3, 7, 11]],
["mM9", [0, 3, 7, 11, 14]],
["M", [0, 4, 7]],
["M7", [0, 4, 7, 11]],
["M7♯11", [0, 4, 7, 11, 18]],
["M7♯5", [0, 4, 8, 11]],
["M9", [0, 4, 7, 11, 14]],
["add4", [0, 4, 7, 12]],
["add9", [0, 4, 7, 14]],
["add11", [0, 4, 7, 17]],
["sus2", [0, 2, 7]],
["sus4", [0, 5, 7]],
["7sus2", [0, 2, 7, 10]],
["7sus4", [0, 5, 7, 10]],
["7sus4♭9", [0, 5, 7, 10, 13]],
["9sus4", [0, 5, 7, 10]],
["aug", [0, 4, 8]],
["aug7", [0, 4, 8, 10]],
["dim", [0, 3, 6]],
["dim7", [0, 3, 6, 9]],
["7♯9♯5", [0, 4, 8, 10, 15]],
["7♯5", [0, 4, 8, 10]],
["7♭9♯5", [0, 4, 8, 10, 13]],
["7♯9♯5", [0, 4, 8, 10, 15]],
["7♯9", [0, 4, 7, 10, 15]],
["7(13)", [0, 4, 7, 10, 14, 17, 21]],
["7", [0, 4, 7, 10]],
["7alt", [0, 4, 6, 10, 13]],
["7♭13", [0, 4, 7, 10, 14, 17, 20]],
["7♭5", [0, 4, 6, 10]],
["7♭9♭5", [0, 4, 6, 10, 13]],
["7♭9", [0, 4, 7, 10, 13]],
["9♯5", [0, 4, 8, 10, 14]],
["9", [0, 4, 7, 10, 14]],
["9♭5", [0, 4, 6, 10, 14]],
["6/7", [0, 4, 7, 9, 10]],
["6/9", [0, 4, 7, 9, 14]],
["6", [0, 4, 7, 9]],
["11", [0, 4, 7, 10, 14, 17]],
["13", [0, 4, 7, 10, 14, 17, 21]],

-------------------------------

C11: 0, 4, 7, 10, 14, 17
C13: 0, 4, 7, 10, 14, 17, 21
C6/7: 0, 4, 7, 9, 10
C6/9: 0, 4, 7, 9, 14
C6: 0, 4, 7, 9
C7♯5♯9: 0, 4, 8, 10, 15
C7♯5: 0, 4, 8, 10
C7♯5♭9: 0, 4, 8, 10, 13
C7♯9♯5: 0, 4, 8, 10, 15
C7♯9: 0, 4, 7, 10, 15
C7(13): 0, 4, 7, 10, 14, 17, 21
C7: 0, 4, 7, 10
C7alt: 0, 4, 6, 10, 13
C7♭13: 0, 4, 7, 10, 14, 17, 20
C7♭5: 0, 4, 6, 10
C7♭5♭9: 0, 4, 6, 10, 13
C7♭9: 0, 4, 7, 10, 13
C7sus2: 0, 2, 7, 10
C7sus4: 0, 5, 7, 10
C7sus4♭9: 0, 5, 7, 10, 13
C9♯5: 0, 4, 8, 10, 14
C9: 0, 4, 7, 10, 14
C9♭5: 0, 4, 6, 10, 14
Cadd11: 0, 4, 7, 17
Cadd4: 0, 4, 7, 12
Cadd9: 0, 4, 7, 14
Caug: 0, 4, 8
Caug7: 0, 4, 8, 10
Cdim: 0, 3, 6
Cdim7: 0, 3, 6, 9
Cm(add11): 0, 3, 7, 17
Cm(add4): 0, 3, 7, 12
Cm(add9): 0, 3, 7, 14
Cm: 0, 3, 7
CM: 0, 4, 7
Cm11: 0, 3, 7, 10, 14, 17
Cm13: 0, 3, 7, 10, 14, 17, 21
Cm6/7: 0, 3, 7, 9, 10
Cm6: 0, 3, 7, 9
CM7(♯11): 0, 4, 7, 11, 18
CM7(♯5): 0, 4, 8, 11
Cm7: 0, 3, 7, 10
CM7: 0, 4, 7, 11
Cm7♭5: 0, 3, 6, 10
Cm9: 0, 3, 7, 10, 14
CM9: 0, 4, 7, 11, 14
CmM7: 0, 3, 7, 11
CmM9: 0, 3, 7, 11, 14
Csus2: 0, 2, 7
Csus4: 0, 5, 7
*/
