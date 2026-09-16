import 'package:flutter/material.dart';

class TightVsLooseScreen extends StatefulWidget {
  const TightVsLooseScreen({super.key});

  @override
  State<TightVsLooseScreen> createState() => _TightVsLooseScreenState();
}

class _TightVsLooseScreenState extends State<TightVsLooseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tight vs Loose')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Chưa dựng.\n\n'
            'Đề bài: docs/modules/01-widget-va-layout.md\n'
            'mục "Tự dựng lại" — màn 3.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
