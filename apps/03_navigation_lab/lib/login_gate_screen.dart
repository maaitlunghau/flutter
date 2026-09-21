import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_state.dart';

/// Màn khoá. Không có ô nhập gì cả — chỉ một công tắc, vì module này học
/// `redirect`, không học form.
class LoginGateScreen extends StatelessWidget {
  const LoginGateScreen({super.key, this.from});

  /// Địa chỉ người dùng định vào lúc bị chặn. `redirect` nhét nó vào query
  /// param, và cũng chính `redirect` đọc lại để trả họ về đúng đó.
  final String? from;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('/login'),
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Về menu lab',
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
                    ? 'Bật công tắc để vào /users.'
                    : 'Bạn đang định vào:\n$from',
                style: text.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ListenableBuilder(
                listenable: authState,
                builder: (BuildContext context, Widget? child) {
                  return SwitchListTile(
                    title: const Text('Đã đăng nhập'),
                    value: authState.isLoggedIn,
                    // Không gọi `context.go` ở đây. Chỉ đổi cờ, rồi
                    // `refreshListenable` đánh thức `redirect` — điều hướng là
                    // hệ quả của state, không phải của cú bấm.
                    onChanged: (bool value) => authState.isLoggedIn = value,
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
