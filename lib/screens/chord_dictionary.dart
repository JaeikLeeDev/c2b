import 'package:flutter/material.dart';

class ChordDictionaryScreen extends StatelessWidget {
  const ChordDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chord Dictionary Screen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Chord Dictionary Screen'),
      ),
    );
  }
}
