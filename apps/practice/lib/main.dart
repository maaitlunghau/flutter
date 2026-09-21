import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice/m01/center_mystery_screen.dart';
import 'package:practice/m01/constraints_probe_screen.dart';
import 'package:practice/m01/tight_vs_loose_screen.dart';
import 'package:practice/m02/key_trap_screen.dart';
import 'package:practice/m02/lifecycle_logger_screen.dart';
import 'package:practice/m03/pick_result_screen.dart';
import 'package:practice/m03/stack_visualizer_screen.dart';
import 'package:practice/m03/unsaved_changes_screen.dart';

import 'app_router.dart';
import 'm00/counter_screen.dart';
import 'm02/dispose_leak_screen.dart';

void main() {
  runApp(const PracticeApp());
}

class PracticeApp extends StatelessWidget {
  const PracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // `MaterialApp.router` thay cho `MaterialApp`: không còn `home:`, vì màn
    // đầu tiên giờ là hệ quả của `initialLocation` trong cây route.
    // `stackObserver` chuyển sang `GoRouter.observers` — xem app_router.dart.
    return MaterialApp.router(
      title: 'Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      routerConfig: practiceRouter,
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
          // M00
          _SectionHeader('M00 — Khởi động'),
          _ExerciseTile(
            title: 'Bộ đếm',
            subtitle: 'StatefulWidget, setState, hot reload',
            screen: CounterScreen(),
          ),

          // M01
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

          // M02
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

          // M03 - Navigator & Routing
          _SectionHeader('M03 — Navigator & Routing'),
          _ExerciseTile(
            title: 'Stack Visualizer',
            subtitle: 'Xem stack của Navigator',
            screen: StackVisualizerScreen(),
            routeName: 'Màn #1',
          ),
          _ExerciseTile(
            title: 'Trả kết quả về',
            subtitle: 'push trả Future — bấm Back thì nhận null',
            screen: PickResultScreen(),
          ),
          _ExerciseTile(
            title: 'Chặn rời màn',
            subtitle: 'PopScope: hỏi lại khi còn dữ liệu chưa lưu',
            screen: UnsavedChangesScreen(),
          ),
          _LocationTile(
            title: 'Cây đường đi (go_router)',
            subtitle: '/m03/items, path param :id, màn 404',
            location: '/m03/items',
          ),
          _LocationTile(
            title: 'Cửa có khoá',
            subtitle: 'redirect làm auth guard, nhớ chỗ đang định vào',
            location: '/m03/locked',
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
    this.screen,
    this.routeName,
  });

  final String title;
  final String subtitle;
  final Widget? screen;

  /// Tên route là thứ duy nhất [StackObserver] nhìn thấy được. Để trống thì
  /// lấy luôn [title] — mọi bài tập đều có tên đọc được mà không phải khai lại.
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => screen ?? const NOtImplementedScreen(),
          settings: RouteSettings(name: routeName ?? title),
        ),
      ),
    );
  }
}

/// Khác [_ExerciseTile] đúng một chỗ: nó không biết màn đích là widget nào, chỉ
/// biết **địa chỉ**. Đó là cả điểm mạnh — menu không cần `import` màn kia nữa.
class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.title,
    required this.subtitle,
    required this.location,
  });

  final String title;
  final String subtitle;
  final String location;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.alt_route),
      onTap: () => context.go(location),
    );
  }
}

class NOtImplementedScreen extends StatelessWidget {
  const NOtImplementedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('No screen yet.')),
      body: const Center(child: Text('No screen yet.')),
    );
  }
}
