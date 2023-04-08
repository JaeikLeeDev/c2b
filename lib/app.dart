import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/select_controller.dart';

import 'package:c2b/theme/app_theme.dart';
import 'screens/home.dart';
import 'screens/chord_select.dart';
import 'screens/training.dart';
import 'screens/chord_lookup.dart';
import 'screens/settings.dart';

class C2bApp extends StatelessWidget {
  C2bApp({super.key});

  final _selectController = Get.put(SelectController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'C2B',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/training', page: () => const TrainingScreen()),
        GetPage(name: '/chord_select', page: () => const ChordSelectScreen()),
        GetPage(name: '/chord_lookup', page: () => const ChordLookupScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
      ],
    );
  }
}
