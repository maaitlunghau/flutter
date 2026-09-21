import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_state.dart';
import 'fake_users.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Người dùng'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: authState.logOut,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Đang đăng nhập: ${authState.email ?? '—'}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: fakeUsers.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                final User user = fakeUsers[index];

                return ListTile(
                  leading: CircleAvatar(child: Text(user.initials)),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/users/${user.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
