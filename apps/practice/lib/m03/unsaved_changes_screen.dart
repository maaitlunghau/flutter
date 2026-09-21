import 'dart:async';

import 'package:flutter/material.dart';

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
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (bool didPop, Object? result) {
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
              onPressed: _hasUnsavedChanges ? _controller.clear : null,
              child: const Text('Lưu (giả vờ)'),
            ),
          ],
        ),
      ),
    );
  }
}
