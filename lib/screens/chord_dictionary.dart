import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/dictionary_controller.dart';
import '../theme/app_text_styles.dart';
import '../utils/chord_table.dart';
import '../widgets/row_divider.dart';
import '../widgets/select_key.dart';
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
    var listItemStyle =
        AppTextStyle.button1.copyWith(fontSize: screenWidth * 0.04);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            /* Select key */
            GetBuilder<DictionaryController>(
              builder: (dicCtrlr) {
                return SelectKey(
                  value: dicCtrlr.keyIndex,
                  onChanged: (value) => dicCtrlr.setKeyIndex(value!),
                );
              },
            ),
          ]),
      body: GetBuilder<DictionaryController>(
        builder: (dicCtrlr) {
          return Row(
            children: [
              Flexible(
                flex: 1,
                child: SelectRoot(
                  keyIndex: dicCtrlr.keyIndex,
                  onPressed: (index) => dicCtrlr.rootIndex = index,
                ),
              ),
              const RowDivider(),

              //TODO: On pressing 'Diatonic' button, show only Diatonic chords.
              Flexible(
                flex: 4,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    String chordNote =
                        rootStringUtil(dicCtrlr.keyIndex, dicCtrlr.rootIndex);
                    chordNote += "${qualityToStringUtil(index)}: ";
                    chordNote += chordNotesUtil(dicCtrlr.rootIndex, index);
                    return Text(chordNote, style: listItemStyle);
                  },
                  itemCount: qualityUtil.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
