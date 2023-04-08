import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () => Get.toNamed('/chord_select'),
            child: const Text('Chord Training'),
          ),
          TextButton(
            onPressed: () => Get.toNamed('/chord_lookup'),
            child: const Text('Chord Table'),
          ),
          TextButton(
            onPressed: () => Get.toNamed('/settings'),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
