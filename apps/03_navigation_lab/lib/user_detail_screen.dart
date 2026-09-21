import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'demo_users.dart';

/// Màn chi tiết, nhận `id` **từ đường dẫn** chứ không phải từ constructor của
/// màn gọi nó. Đó là lý do nó mở được từ một deep link bên ngoài — người gọi
/// không cần tồn tại.
class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.rawId});

  final String? rawId;

  @override
  Widget build(BuildContext context) {
    final DemoUser? user = findUser(rawId);

    return Scaffold(
      appBar: AppBar(title: Text('/users/${rawId ?? ''}')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: user == null
              ? _MissingUser(rawId: rawId)
              : _UserCard(user: user),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});

  final DemoUser user;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(radius: 36, child: Text('${user.id}')),
        const SizedBox(height: 16),
        Text(user.name, style: text.headlineSmall),
        const SizedBox(height: 4),
        Text(user.role, style: text.bodyMedium),
        const SizedBox(height: 24),
        Text(
          'id đi từ đường dẫn vào đây qua state.pathParameters',
          style: text.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MissingUser extends StatelessWidget {
  const _MissingUser({required this.rawId});

  final String? rawId;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.person_off_outlined, size: 48),
        const SizedBox(height: 16),
        Text('Không có user id "${rawId ?? ''}"', style: text.titleMedium),
        const SizedBox(height: 12),
        Text(
          'Route vẫn khớp, màn vẫn mở — path param chỉ là một đoạn chữ, '
          'router không biết id nào có thật. Kiểm tra là việc của màn này.',
          style: text.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () => context.go('/users'),
          child: const Text('Về danh sách'),
        ),
      ],
    );
  }
}
