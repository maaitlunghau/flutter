import 'package:flutter/material.dart';

/// Menu của M00. **Đây là chỗ của bạn** — file này chỉ là khung rỗng để app
/// chạy được, không phải lời giải.
///
/// Dựng xong màn nào thì thêm một `ListTile` vào đây trỏ tới nó, rồi xoá bớt
/// phần hướng dẫn bên dưới.
class M00Menu extends StatelessWidget {
  const M00Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('M00 — Khởi động')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Chưa dựng màn nào.', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Đề bài nằm ở docs/modules/00-khoi-dong.md, mục "Tự dựng lại". '
            'Đây là bài khởi động — dựng xong rồi hãy sang M01.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
