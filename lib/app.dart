import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'screens/chord_select.dart';
import 'screens/training.dart';
import 'screens/home.dart';
import 'package:c2b/theme/app_theme.dart';

class C2bApp extends StatelessWidget {
  const C2bApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'C2B',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/training', page: () => const TrainingScreen()),
        GetPage(name: '/chord_select', page: () => ChordSelectScreen()),
      ],
    );
  }
}
