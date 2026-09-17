import 'package:flutter/material.dart';
import 'package:practice/m01/center_mystery_screen.dart';
import 'package:practice/m01/constraints_probe_screen.dart';
import 'package:practice/m01/tight_vs_loose_screen.dart';
import 'package:practice/m02/key_trap_screen.dart';
import 'package:practice/m02/lifecycle_logger_screen.dart';

import 'm00/counter_screen.dart';
import 'm02/dispose_leak_screen.dart';

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
      body: ListView(
        children: const [
          _SectionHeader('M00 — Khởi động'),
          _ExerciseTile(
            title: 'Bộ đếm',
            subtitle: 'StatefulWidget, setState, hot reload',
            screen: CounterScreen(),
          ),

          _SectionHeader('M01 — Widget & Layout'),
          _ExerciseTile(
            title: 'Center Mystery',
            subtitle: 'Cùng một ô vuông, lúc phủ kín - lúc chính xác 100x100',
            screen: CenterMysteryScreen(),
          ),
          _ExerciseTile(
            title: 'Constraints Probe',
            subtitle: 'Đọc bốn con số ở từng tầng của cây',
            screen: ConstraintsProbeScreen(),
          ),
          _ExerciseTile(
            title: 'Tight vs Loose',
            subtitle: 'Cùng một SizedBox(50, 50) dưới hai loại constraints',
            screen: TightVsLooseScreen(),
          ),

          _SectionHeader('M02 — StatefulWidget'),
          _ExerciseTile(
            title: 'Key Trap',
            subtitle: 'State đi theo VỊ TRÍ hay theo KEY?',
            screen: KeyTrapScreen(),
          ),
          _ExerciseTile(
            title: 'Dispose Leak',
            subtitle: 'Bỏ quên timer.cancel() trong dispose',
            screen: DisposeLeakScreen(),
          ),
          _ExerciseTile(
            title: 'StatefulBuilder',
            subtitle: 'Cách dùng StatefulBuilder để setState trong builder',
            screen: LifecycleLoggerScreen(),
          ),
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
