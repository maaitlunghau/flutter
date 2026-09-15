import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void _incrementWithSetState() {
    setState(() => _counter++);
  }

  void _incrementWithoutSetState() {
    _counter++;
    debugPrint('_counter giờ là $_counter — nhưng màn hình vẫn chưa đổi');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('M00 — Bộ đếm')),
      body: Center(
        // mainAxisSize.min để cụm nội dung co đúng bằng nó, rồi Center mới căn
        // giữa được. Để max thì Column chiếm hết chiều cao và không còn gì để căn.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Số lần bấm nút:', style: theme.textTheme.bodyLarge),
            Text('$_counter', style: theme.textTheme.displayLarge),
            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _incrementWithSetState,
              icon: const Icon(Icons.add),
              label: const Text('Tăng — có setState'),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _incrementWithoutSetState,
              icon: const Icon(Icons.bug_report_outlined),
              label: const Text('Tăng — KHÔNG setState'),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Bấm nút thứ hai vài lần rồi nhìn console: giá trị tăng đều, '
                'màn hình đứng im. Sau đó bấm nút thứ nhất một lần — con số '
                'nhảy vọt lên đúng tổng đã cộng dồn.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
