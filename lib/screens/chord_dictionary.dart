import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/dictionary_controller.dart';
import '../theme/app_text_styles.dart';
import '../utils/chord_table.dart';
import '../widgets/row_divider.dart';
import '../widgets/select_key_dropdown.dart';
import '../widgets/select_root.dart';

class ChordDictionaryScreen extends StatefulWidget {
  const ChordDictionaryScreen({super.key});

  @override
  State<ChordDictionaryScreen> createState() => _ChordDictionaryScreenState();
}

class _ChordDictionaryScreenState extends State<ChordDictionaryScreen> {
  final _dc = Get.put(DictionaryController());

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var listItemStyle =
        AppTextStyle.button1.copyWith(fontSize: screenWidth * 0.05);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            /* Select key Dropdown */
            GetBuilder<DictionaryController>(
              builder: (dicCtrlr) {
                return SelectKeyDropdown(
                  value: dicCtrlr.keyIndex,
                  onChanged: (value) => dicCtrlr.setKeyIndex(value!),
                );
              },
            ),
            /* Diatonic Button */
            GetBuilder<DictionaryController>(
              builder: (dicCtrlr) {
                return SizedBox(
                  width: screenWidth * 0.2,
                  child: TextButton(
                    onPressed: () => dicCtrlr.toggleShowOnlyDiatonicOn(),
                    child: Text(
                      dicCtrlr.showOnlyDiatonicOn ? 'All' : 'Diatonic',
                      style: AppTextStyle.title2.copyWith(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                );
              },
            ),
          ]),
      body: GetBuilder<DictionaryController>(
        builder: (dicCtrlr) {
          return Row(
            children: [
              if (dicCtrlr.showOnlyDiatonicOn == false)
                Flexible(
                  flex: 1,
                  child: SelectRoot(
                    keyIndex: dicCtrlr.keyIndex,
                    onPressed: (index) => dicCtrlr.rootIndex = index,
                  ),
                ),
              const RowDivider(),
              Flexible(
                flex: 4,
                child: _ChordList(
                  showOnlyDiatonicOn: dicCtrlr.showOnlyDiatonicOn,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChordList extends StatelessWidget {
  _ChordList({
    required this.showOnlyDiatonicOn,
    super.key,
  });

  final bool showOnlyDiatonicOn;
  final DictionaryController _dc = Get.find();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var listItemStyle =
        AppTextStyle.button1.copyWith(fontSize: screenWidth * 0.05);
    return showOnlyDiatonicOn
        ? ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const Divider(
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  Row(
                    children: [
                      /* Chord name */
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Container(
                          alignment: Alignment.center,
                          height: screenHeight * 0.1,
                          child: Text(
                            chordNameUtil(
                              _dc.keyIndex,
                              _dc.keyIndex + diatonicUtil[index][0],
                              diatonicUtil[index][1],
                            ),
                            style: listItemStyle,
                          ),
                        ),
                      ),
                      /* Chord notes */
                      Flexible(
                        flex: 5,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: screenHeight * 0.1,
                          child: Text(
                            chordNotesUtil(
                                _dc.keyIndex,
                                _dc.keyIndex + diatonicUtil[index][0],
                                diatonicUtil[index][1]),
                            style: listItemStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            itemCount: diatonicUtil.length,
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const Divider(
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  Row(
                    children: [
                      /* Chord name */
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Container(
                          alignment: Alignment.center,
                          height: screenHeight * 0.1,
                          child: Text(
                            chordNameUtil(_dc.keyIndex, _dc.rootIndex, index),
                            style: listItemStyle,
                          ),
                        ),
                      ),
                      /* Chord notes */
                      Flexible(
                        flex: 5,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: screenHeight * 0.1,
                          child: Text(
                            chordNotesUtil(_dc.keyIndex, _dc.rootIndex, index),
                            style: listItemStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            itemCount: qualityUtil.length,
          );
  }
}
