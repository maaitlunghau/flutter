import 'package:flutter/material.dart';

class ConstraintsProbeScreen extends StatelessWidget {
  const ConstraintsProbeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Constraints Probe')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Chưa dựng.\n\n'
            'Đề bài: docs/modules/01-widget-va-layout.md\n'
            'mục "Tự dựng lại" — màn 2.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
