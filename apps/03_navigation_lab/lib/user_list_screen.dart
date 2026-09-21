import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_state.dart';
import 'demo_users.dart';

/// Danh sách user, kèm một **thanh địa chỉ** để gõ thẳng đường dẫn.
///
/// Thanh địa chỉ là thứ máy Android không có sẵn như trình duyệt, nhưng nó cho
/// bạn thử `/users/999` và `/khong-ton-tai` mà không cần tới `adb` — deep link
/// thật để dành vòng 3.
class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _locationController = TextEditingController(
    text: '/users/999',
  );

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _goToTypedLocation() {
    final String target = _locationController.text.trim();
    if (target.isEmpty) {
      return;
    }
    context.go(target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('/users'),
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Về menu lab',
          onPressed: () => context.go('/'),
        ),
        actions: <Widget>[
          // Gạt tắt ở đây để thấy redirect đá mình ra màn khoá ngay lập tức.
          ListenableBuilder(
            listenable: authState,
            builder: (BuildContext context, Widget? child) {
              return Switch(
                value: authState.isLoggedIn,
                onChanged: (bool value) => authState.isLoggedIn = value,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Đường dẫn',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _goToTypedLocation(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _goToTypedLocation,
                  child: const Text('Đi'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: demoUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final DemoUser user = demoUsers[index];

                return ListTile(
                  leading: CircleAvatar(child: Text('${user.id}')),
                  title: Text(user.name),
                  subtitle: Text(user.role),
                  trailing: const Icon(Icons.chevron_right),
                  // `go` chứ không phải `push`: ta đang *đổi chỗ đứng* sang một
                  // địa chỉ khác, và stack hai tầng do cây route tự sinh ra.
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
