import 'package:flutter/material.dart';

/// Thí nghiệm 2 — `Expanded` và `Flexible` khác nhau đúng một dòng trong SDK.
///
/// `class Expanded extends Flexible` với `fit: FlexFit.tight` — xem
/// `packages/flutter/lib/src/widgets/basic.dart:6021`. Màn này chỉ làm cho cái
/// khác biệt đó nhìn thấy được.
class ExpandedVsFlexibleScreen extends StatelessWidget {
  const ExpandedVsFlexibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expanded vs Flexible')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Row(
            label: 'Không bọc gì',
            note: 'Ô xin 60 và được đúng 60. Phần thừa bỏ trống.',
            mode: _Mode.bare,
          ),
          _Row(
            label: 'Flexible — fit: loose',
            note: 'Được chia nhiều hơn nhu cầu, nhưng chỉ lấy đúng 60.',
            mode: _Mode.flexible,
          ),
          _Row(
            label: 'Expanded — fit: tight',
            note: 'Bị ép lấy hết phần được chia, dù chỉ xin 60.',
            mode: _Mode.expanded,
          ),
          _Row(
            label: 'Spacer',
            note:
                'Chính là Expanded bọc SizedBox.shrink — đẩy ô xanh sang phải.',
            mode: _Mode.spacer,
          ),
        ],
      ),
    );
  }
}

enum _Mode { bare, flexible, expanded, spacer }

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.note, required this.mode});

  final String label;
  final String note;
  final _Mode mode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Ô này giống hệt nhau ở cả bốn hàng. Chỉ cách bọc là khác.
    final box = Container(
      width: 60,
      height: 44,
      color: theme.colorScheme.primary,
    );

    final children = switch (mode) {
      _Mode.bare => <Widget>[box],
      _Mode.flexible => <Widget>[Flexible(child: box)],
      _Mode.expanded => <Widget>[Expanded(child: box)],
      _Mode.spacer => <Widget>[const Spacer(), box],
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall),
          Text(note, style: theme.textTheme.bodySmall),
          const SizedBox(height: 6),

          // Khung xám cho thấy "chỗ được cho" rộng tới đâu, để so với ô bên trong.
          Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Row(children: children),
          ),
        ],
      ),
    );
  }
}
