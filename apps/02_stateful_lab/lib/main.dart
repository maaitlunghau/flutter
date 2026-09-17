import 'package:flutter/material.dart';

import 'dispose_leak_screen.dart';
import 'key_trap_screen.dart';
import 'lifecycle_logger_screen.dart';

void main() {
  runApp(const StatefulLabApp());
}

class StatefulLabApp extends StatelessWidget {
  const StatefulLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Lab',
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
      appBar: AppBar(title: const Text('M02 — Stateful lab')),
      body: ListView(
        children: const [
          _LabTile(
            title: 'Lifecycle Logger',
            subtitle: 'Đếm số lần mỗi callback vòng đời chạy',
            destination: LifecycleLoggerScreen(),
          ),
          _LabTile(
            title: 'Dispose Leak',
            subtitle: 'Timer vẫn chạy sau khi màn đã đóng — nhìn console',
            destination: DisposeLeakScreen(),
          ),
          _LabTile(
            title: 'Key Trap',
            subtitle: 'Xoá phần tử đầu, xem state nhảy sang widget khác',
            destination: KeyTrapScreen(),
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
      onTap: () =>
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => destination)),
    );
  }
}
