import 'dart:async';

import 'package:flutter/material.dart';

/// Chặn thao tác rời màn khi còn dữ liệu chưa lưu.
///
/// Việc này phải làm bằng `PopScope` chứ không phải bằng cách giấu nút Back:
/// nút Back cứng của Android, cử chỉ vuốt cạnh màn của iOS và nút mũi tên trên
/// `AppBar` đều đổ về cùng một chỗ, và `PopScope` là chỗ đó.
class UnsavedChangesScreen extends StatefulWidget {
  const UnsavedChangesScreen({super.key});

  @override
  State<UnsavedChangesScreen> createState() => _UnsavedChangesScreenState();
}

class _UnsavedChangesScreenState extends State<UnsavedChangesScreen> {
  final TextEditingController _controller = TextEditingController();

  bool get _hasUnsavedChanges => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    // `canPop` được đọc lúc `build`, nên mỗi lần gõ phải dựng lại — nếu không,
    // ô vừa có chữ mà Back vẫn thoát được như thường.
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmDiscard() async {
    final bool? discard = await showDialog<bool>(
      context: context,
      // Dialog cũng là một route nằm trên stack — đặt tên để nó hiện rõ ở màn
      // Stack Visualizer thay vì thành một dòng "(không tên)".
      routeSettings: const RouteSettings(name: 'Dialog xác nhận'),
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Bỏ nội dung đang gõ?'),
        content: const Text('Nội dung chưa lưu sẽ mất.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ở lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Bỏ'),
          ),
        ],
      ),
    );

    if (discard == true && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      // `false` = chặn lại. Chặn xong thì trách nhiệm thoát màn chuyển hẳn
      // sang mình, Flutter sẽ không tự làm nữa.
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        // `didPop == true` nghĩa là màn đã đóng rồi, không còn gì để hỏi.
        if (didPop) return;
        unawaited(_confirmDiscard());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Chặn rời màn')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Text(
              _hasUnsavedChanges
                  ? 'Có nội dung chưa lưu — Back sẽ bị chặn.'
                  : 'Chưa gõ gì — Back thoát bình thường.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              // "Lưu" ở đây chỉ là xoá cờ chưa-lưu, đủ để thấy `canPop` đảo
              // chiều ngay lập tức.
              onPressed: _hasUnsavedChanges ? _controller.clear : null,
              child: const Text('Lưu (giả vờ)'),
            ),
          ],
        ),
      ),
    );
  }
}
