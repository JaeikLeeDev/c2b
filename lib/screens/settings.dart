import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/presets_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final _db = Get.put(PresetsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings Screen'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            /* clean up DB */
            Card(
              child: TextButton(
                onPressed: () async {
                  await _db.clear();
                },
                child: const Text('Clean up preset DB'),
              ),
            ),
          ],
        ));
  }
}
