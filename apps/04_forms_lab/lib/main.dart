import 'package:flutter/material.dart';

import 'autovalidate_screen.dart';
import 'manual_vs_form_screen.dart';

void main() {
  runApp(const FormsLabApp());
}

class FormsLabApp extends StatelessWidget {
  const FormsLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forms Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const LabMenuScreen(),
    );
  }
}

class LabMenuScreen extends StatelessWidget {
  const LabMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('M04 — Forms lab')),
      body: ListView(
        children: const <Widget>[
          _LabTile(
            title: 'Tay vs Form',
            subtitle: 'Cùng một form ba ô, dựng hai kiểu',
            destination: ManualVsFormScreen(),
          ),
          _LabTile(
            title: 'Lỗi hiện lúc nào',
            subtitle: 'Ba autovalidateMode, khác đúng một tham số',
            destination: AutovalidateScreen(),
          ),
        ],
      ),
    );
  }
}

class _LabTile extends StatelessWidget {
  const _LabTile({
    required this.title,
    required this.subtitle,
    required this.destination,
  });

  final String title;
  final String subtitle;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (BuildContext context) => destination),
      ),
    );
  }
}
