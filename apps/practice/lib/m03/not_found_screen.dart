import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Màn 404 dùng chung cho hai trường hợp:
///
/// 1. `errorBuilder` — đường dẫn không khớp route nào
/// 2. `/m03/items/:id` với `id` không có thật — route vẫn khớp, nhưng dữ liệu
///    thì không, nên màn chi tiết tự trả về màn này
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.location, this.reason});

  final String location;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.wrong_location_outlined, size: 48),
              const SizedBox(height: 16),
              Text('Không có đường này', style: text.headlineSmall),
              const SizedBox(height: 12),
              Text(location, style: text.bodyMedium),
              if (reason != null) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  reason!,
                  style: text.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/m03/items'),
                child: const Text('Về danh sách'),
              ),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Về menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
