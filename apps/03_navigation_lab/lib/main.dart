import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'pick_result_screen.dart';
import 'unsaved_changes_screen.dart';
import 'stack_visualizer_screen.dart';

void main() {
  runApp(const NavigationLabApp());
}

class NavigationLabApp extends StatelessWidget {
  const NavigationLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    // `MaterialApp.router` thay cho `MaterialApp`: không còn `home:`, vì màn
    // đầu tiên giờ là hệ quả của `initialLocation` trong cây route.
    // Observer chuyển sang `GoRouter.observers` — xem app_router.dart.
    return MaterialApp.router(
      title: 'Navigation Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: appRouter,
    );
  }
}

class LabMenuScreen extends StatelessWidget {
  const LabMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('M03 — Navigation lab')),
      body: ListView(
        children: const <Widget>[
          _LabTile(
            title: 'Stack Visualizer',
            subtitle: 'Nhìn stack biến dạng theo từng lệnh điều hướng',
            routeName: 'Màn #1',
            destination: StackVisualizerScreen(),
          ),
          _LabTile(
            title: 'Trả kết quả về',
            subtitle: 'push trả Future — và bấm Back thì nhận null',
            routeName: 'Trả kết quả về',
            destination: PickResultScreen(),
          ),
          _LabTile(
            title: 'Chặn rời màn',
            subtitle: 'PopScope: hỏi lại khi còn dữ liệu chưa lưu',
            routeName: 'Chặn rời màn',
            destination: UnsavedChangesScreen(),
          ),
          Divider(height: 32),
          _LocationTile(
            title: 'Route tree bằng go_router',
            subtitle: 'path param, màn 404, redirect làm auth guard',
            location: '/users',
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
    required this.routeName,
    required this.destination,
  });

  final String title;
  final String subtitle;
  final String routeName;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => destination,
          settings: RouteSettings(name: routeName),
        ),
      ),
    );
  }
}

/// Khác [_LabTile] đúng một chỗ: nó không biết màn đích là widget nào, chỉ biết
/// **địa chỉ**. Đó là cả điểm mạnh — màn này không cần `import` màn kia nữa.
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
