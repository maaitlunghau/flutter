import 'package:flutter/material.dart';

import 'm01/m01_menu.dart';

void main() {
  runApp(const PracticeApp());
}

/// Sân tập của người học. Mỗi module một thư mục con trong `lib/`.
///
/// App này cố ý chỉ có một `flutter run` duy nhất cho cả 15 module — menu gốc
/// dẫn xuống menu từng module, giống hệt cách `01_layout_lab` dẫn xuống 3 màn.
class PracticeApp extends StatelessWidget {
  const PracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      // Mẹo lúc làm việc: đang tập trung vào một module thì đổi tạm dòng này
      // thành `const M01Menu()` để khỏi bấm hai lần mỗi lần hot restart.
      home: const RootMenuScreen(),
    );
  }
}

class RootMenuScreen extends StatelessWidget {
  const RootMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice — sân tập')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('M01 — Widget & Layout'),
            subtitle: const Text('constraints, Row/Column, Stack'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (_) => const M01Menu())),
          ),
          // Tới module nào thì thêm một ListTile ở đây, và một thư mục lib/mNN/.
        ],
      ),
    );
  }
}
