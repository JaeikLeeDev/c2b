import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/preset_db_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                  final PresetDbController db = Get.find();
                  if (db.isOpen() == false) db.init();
                  await db.cleanUpDb();
                },
                child: const Text('Clean up preset DB'),
              ),
            ),
          ],
        ));
  }
}
