import 'package:flutter/material.dart';

class ChordLookupScreen extends StatelessWidget {
  const ChordLookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chord Lookup Screen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Chord Lookup Screen'),
      ),
    );
  }
}
