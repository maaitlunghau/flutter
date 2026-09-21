import 'package:flutter/material.dart';

import 'fake_users.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final int? id = int.tryParse(userId);
    final User? user = id == null ? null : findUserById(id);

    return Scaffold(
      appBar: AppBar(title: Text(user?.name ?? 'Not found user!')),
      body: user == null ? _NotFound(userId: userId) : _Detail(user: user),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Center(
          child: CircleAvatar(
            radius: 48,
            child: Text(user.initials, style: theme.textTheme.displaySmall),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            user.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 32),
        _Field(label: 'Employee ID', value: '#${user.id}'),
        _Field(label: 'Email', value: user.email),
        _Field(label: 'Role', value: user.role),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.person_off_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Not found any user with ID "$userId"',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
