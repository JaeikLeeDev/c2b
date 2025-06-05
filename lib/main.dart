import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import 'package:c2b/app.dart';

void main() {
  // Make sure the WidgetsFlutterBinding instance is initialized
  // that is needed to call a function that requires calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // debugRepaintRainbowEnabled = true;
  // debugRepaintTextRainbowEnabled = true;
  runApp(const C2bApp());
}
