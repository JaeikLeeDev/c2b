import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: TextButton(
              onPressed: () => Get.toNamed('/chord_select'),
              child: const Text('Chord Training'),
            ),
          ),
          Card(
            child: TextButton(
              onPressed: () => Get.toNamed('/chord_dictionary'),
              child: const Text('Chord Dictionary'),
            ),
          ),
          Card(
            child: TextButton(
              onPressed: () => Get.toNamed('/settings'),
              child: const Text('Settings'),
            ),
          ),
        ],
      ),
    );
  }
}
