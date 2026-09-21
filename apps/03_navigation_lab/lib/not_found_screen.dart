import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Màn 404. Bỏ `errorBuilder` đi thì `go_router` vẫn đỡ được, nhưng bằng một
/// màn lỗi mặc định tiếng Anh kèm stack trace — không phải thứ người dùng nên
/// thấy.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.location});

  final String location;

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
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Về menu lab'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
