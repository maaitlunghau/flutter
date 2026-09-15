import 'package:flutter/material.dart';

import 'm00/counter_screen.dart';

void main() {
  runApp(const PracticeApp());
}

class PracticeApp extends StatelessWidget {
  const PracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const PracticeMenuScreen(),
    );
  }
}

class PracticeMenuScreen extends StatelessWidget {
  const PracticeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice — sân tập')),

      // ListView chứ không Column: tới M07 danh sách này sẽ dài hơn màn hình,
      // Column thì tràn còn ListView thì cuộn.
      body: ListView(
        children: const [
          _SectionHeader('M00 — Khởi động'),
          _ExerciseTile(
            title: 'Bộ đếm',
            subtitle: 'StatefulWidget, setState, hot reload',
            screen: CounterScreen(),
          ),

          _SectionHeader('M01 — Widget & Layout'),
          _NotBuiltYet(
            'docs/modules/01-widget-va-layout.md — mục "Tự dựng lại"',
          ),

          // Dựng xong màn nào thì thêm một _ExerciseTile ngay dưới tiêu đề
          // module tương ứng, và xoá dòng _NotBuiltYet của module đó đi.
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    required this.title,
    required this.subtitle,
    required this.screen,
  });

  final String title;
  final String subtitle;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () =>
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => screen)),
    );
  }
}

class _NotBuiltYet extends StatelessWidget {
  const _NotBuiltYet(this.where);

  final String where;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        'Chưa dựng màn nào. Đề bài: $where',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }
}
