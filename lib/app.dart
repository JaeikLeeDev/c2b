import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:c2b/theme/app_theme.dart';
import 'screens/home.dart';
import 'screens/chord_select.dart';
import 'screens/training.dart';
import 'screens/chord_dictionary.dart';
import 'screens/settings.dart';

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
        // 첫 화면
        GetPage(name: '/', page: () => const HomeScreen()),
        // 연습 화면
        GetPage(name: '/training', page: () => const TrainingScreen()),
        // 코드 선택 화면: 연습에 포함시킬 코드 모음을 만듬
        GetPage(name: '/chord_select', page: () => const ChordSelectScreen()),
        // 코드별 구성음 사전
        GetPage(
          name: '/chord_dictionary',
          page: () => const ChordDictionaryScreen(),
        ),
        // 설정 화면
        GetPage(name: '/settings', page: () => SettingsScreen()),
      ],
    );
  }
}
