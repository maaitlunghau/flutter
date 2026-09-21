import 'package:flutter/material.dart';

import 'pick_result_screen.dart';
import 'stack_observer.dart';
import 'stack_visualizer_screen.dart';
import 'unsaved_changes_screen.dart';

void main() {
  runApp(const NavigationLabApp());
}

class NavigationLabApp extends StatelessWidget {
  const NavigationLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      // Gắn observer ở đây thì nó nghe được *mọi* thao tác điều hướng của app,
      // kể cả những thao tác xảy ra trong màn khác.
      navigatorObservers: <NavigatorObserver>[stackObserver],
      home: const LabMenuScreen(),
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
