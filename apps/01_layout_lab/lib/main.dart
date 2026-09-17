import 'package:flutter/material.dart';

import 'center_mystery_screen.dart';
import 'constraints_probe_screen.dart';
import 'expanded_vs_flexible_screen.dart';
import 'flex_overflow_screen.dart';
import 'tight_vs_loose_screen.dart';
import 'unbounded_height_screen.dart';

void main() {
  runApp(const LayoutLabApp());
}

class LayoutLabApp extends StatelessWidget {
  const LayoutLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Layout Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
      appBar: AppBar(title: const Text('M01 — Layout lab · vòng 1')),
      body: ListView(
        children: const [
          _LabTile(
            title: 'Center Mystery',
            subtitle: 'Cùng một ô vuông, lúc phủ kín lúc đúng 100×100',
            destination: CenterMysteryScreen(),
          ),
          _LabTile(
            title: 'Constraints Probe',
            subtitle: 'Đọc bốn con số ở từng tầng của cây',
            destination: ConstraintsProbeScreen(),
          ),
          _LabTile(
            title: 'Tight vs Loose',
            subtitle: 'Cùng một SizedBox(50, 50) dưới hai loại constraints',
            destination: TightVsLooseScreen(),
          ),
          _LabTile(
            title: 'Flex Overflow',
            subtitle: 'Thêm ô cho tới khi sọc vàng đen hiện ra',
            destination: FlexOverflowScreen(),
          ),
          _LabTile(
            title: 'Expanded vs Flexible',
            subtitle: 'Cùng một ô 60px, bốn cách bọc khác nhau',
            destination: ExpandedVsFlexibleScreen(),
          ),
          _LabTile(
            title: 'Unbounded Height',
            subtitle: 'ListView trong Column, và hai cách chữa',
            destination: UnboundedHeightScreen(),
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
      // Điều hướng là chuyện của M03. Ở đây cố tình dùng đúng một dòng
      // Navigator thô, không go_router, để không phải học trước thứ chưa cần.
      onTap: () =>
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => destination)),
    );
  }
}
