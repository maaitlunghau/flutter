import 'dart:async';

import 'package:flutter/material.dart';

class DisposeLeakScreen extends StatefulWidget {
  const DisposeLeakScreen({super.key});

  @override
  State<DisposeLeakScreen> createState() => _DisposeLeakScreenState();
}

class _DisposeLeakScreenState extends State<DisposeLeakScreen> {
  bool _callDispose = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dispose Leak')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Mở màn con, đợi vài nhịp, rồi bấm back. Nhìn CONSOLE chứ không phải '
            'màn hình — đó là chỗ Timer để lại dấu vết.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text('Gọi timer.cancel() trong dispose'),
            subtitle: Text(
              _callDispose
                  ? 'Đúng cách — console im bặt sau khi thoát'
                  : 'Cố tình quên — console vẫn đếm sau khi thoát',
              style: theme.textTheme.bodySmall,
            ),
            value: _callDispose,
            onChanged: (v) => setState(() => _callDispose = v),
          ),
          const SizedBox(height: 16),

          FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => _TickerScreen(callDispose: _callDispose),
              ),
            ),
            child: const Text('Mở màn có Timer'),
          ),
        ],
      ),
    );
  }
}

class _TickerScreen extends StatefulWidget {
  const _TickerScreen({required this.callDispose});

  final bool callDispose;

  @override
  State<_TickerScreen> createState() => _TickerScreenState();
}

class _TickerScreenState extends State<_TickerScreen> {
  Timer? _timer;
  int _ticks = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _ticks++;
      debugPrint('tick $_ticks — màn còn sống? ${mounted ? "có" : "KHÔNG"}');

      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.callDispose) {
      _timer?.cancel();
      debugPrint('dispose: đã cancel timer');
    } else {
      debugPrint('dispose: CỐ TÌNH không cancel — timer vẫn sống');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Đang đếm…')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$_ticks', style: theme.textTheme.displayLarge),
            const SizedBox(height: 12),
            Text(
              widget.callDispose
                  ? 'Thoát ra: console dừng hẳn'
                  : 'Thoát ra: console VẪN đếm tiếp',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
