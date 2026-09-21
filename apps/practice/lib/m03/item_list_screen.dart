import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'practice_auth.dart';
import 'practice_items.dart';

/// Danh sách ở `/m03/items`, kèm một **thanh địa chỉ** để gõ thẳng đường dẫn.
///
/// Máy Android không có thanh địa chỉ như trình duyệt, nên phải tự gắn một cái
/// — đó là cách duy nhất thử `/m03/items/999` mà chưa cần tới `adb`.
class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final TextEditingController _locationController = TextEditingController(
    text: '/m03/items/999',
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
        title: const Text('/m03/items'),
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Về menu practice',
          onPressed: () => context.go('/'),
        ),
        actions: <Widget>[
          // Gạt tắt ngay tại đây để thấy redirect đá mình ra màn khoá.
          ListenableBuilder(
            listenable: practiceAuth,
            builder: (BuildContext context, Widget? child) {
              return Switch(
                value: practiceAuth.isLoggedIn,
                onChanged: (bool value) => practiceAuth.isLoggedIn = value,
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
              itemCount: practiceItems.length,
              itemBuilder: (BuildContext context, int index) {
                final PracticeItem item = practiceItems[index];

                return ListTile(
                  leading: CircleAvatar(child: Text('${item.id}')),
                  title: Text(item.title),
                  subtitle: Text(item.note),
                  trailing: const Icon(Icons.chevron_right),
                  // `go` chứ không phải `push`: ta đổi chỗ đứng sang một địa
                  // chỉ khác, còn stack hai tầng do quan hệ cha–con tự sinh ra.
                  onTap: () => context.go('/m03/items/${item.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
