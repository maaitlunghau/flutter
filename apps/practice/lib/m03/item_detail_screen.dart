import 'package:flutter/material.dart';

import 'not_found_screen.dart';
import 'practice_items.dart';

/// Màn chi tiết ở `/m03/items/:id`.
///
/// `id` đi vào đây **từ đường dẫn**, không từ constructor của màn gọi nó — đó
/// là lý do màn này mở được từ một link bên ngoài, khi màn danh sách còn chưa
/// tồn tại.
class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.rawId});

  final String? rawId;

  @override
  Widget build(BuildContext context) {
    final PracticeItem? item = findItem(rawId);

    // Route khớp không có nghĩa là dữ liệu có thật. Router chỉ đối chiếu hình
    // dạng đường dẫn; kiểm tra `id` là việc của màn này.
    if (item == null) {
      return NotFoundScreen(
        location: '/m03/items/${rawId ?? ''}',
        reason: 'Route khớp, nhưng không có item id này.',
      );
    }

    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('/m03/items/${item.id}')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(radius: 36, child: Text('${item.id}')),
              const SizedBox(height: 16),
              Text(item.title, style: text.headlineSmall),
              const SizedBox(height: 4),
              Text(item.note, style: text.bodyMedium),
              const SizedBox(height: 24),
              Text(
                'id đi từ đường dẫn vào đây qua state.pathParameters',
                style: text.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
