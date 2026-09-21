import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'practice_auth.dart';

/// Màn khoá ở `/m03/locked`. Không có ô nhập nào cả — vòng này học `redirect`,
/// không học form.
class LockedScreen extends StatelessWidget {
  const LockedScreen({super.key, this.from});

  /// Địa chỉ người dùng định vào lúc bị chặn. `redirect` nhét nó vào query
  /// param, và cũng chính `redirect` đọc lại để trả họ về đúng chỗ đó.
  final String? from;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('/m03/locked'),
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Về menu practice',
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 16),
              Text('Cửa đang khoá', style: text.headlineSmall),
              const SizedBox(height: 12),
              Text(
                from == null
                    ? 'Bật công tắc để vào /m03/items.'
                    : 'Bạn đang định vào:\n$from',
                style: text.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ListenableBuilder(
                listenable: practiceAuth,
                builder: (BuildContext context, Widget? child) {
                  return SwitchListTile(
                    title: const Text('Đã đăng nhập'),
                    value: practiceAuth.isLoggedIn,
                    // Cố ý KHÔNG gọi `context.go` ở đây. Chỉ đổi cờ, rồi
                    // `refreshListenable` đánh thức `redirect` — điều hướng là
                    // hệ quả của state, không phải của cú bấm.
                    onChanged: (bool value) => practiceAuth.isLoggedIn = value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
