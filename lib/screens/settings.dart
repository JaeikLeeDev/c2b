import 'package:flutter/material.dart';

import "../utils/preset_database.dart";

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
                  final db = PresetDatabase();
                  if (db.isOpen() == false) db.init();
                  await db.cleanUpDb();
                },
                child: Text('Clean up DB'),
              ),
            ),
          ],
        ));
  }
}
