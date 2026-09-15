import 'package:flutter/material.dart';

/// Menu của M01. **Đây là chỗ của bạn** — file này hiện chỉ là cái khung rỗng
/// để app chạy được, không phải lời giải.
///
/// Mỗi khi dựng xong một màn, thêm nó vào `children` bên dưới và xoá bớt phần
/// hướng dẫn này đi.
class M01Menu extends StatelessWidget {
  const M01Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('M01 — Widget & Layout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Chưa dựng màn nào.', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Đề bài ba màn nằm ở docs/modules/01-widget-va-layout.md, '
            'mục "Tự dựng lại". Dựng xong màn nào thì thêm một ListTile ở đây '
            'trỏ tới nó.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
