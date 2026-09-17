import 'package:flutter/material.dart';

class LifecycleLoggerScreen extends StatefulWidget {
  const LifecycleLoggerScreen({super.key});

  @override
  State<LifecycleLoggerScreen> createState() => _LifecycleLoggerScreenState();
}

class _LifecycleLoggerScreenState extends State<LifecycleLoggerScreen> {
  String _childTitle = 'Tiêu đề A';
  int _nudge = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lifecycle Logger')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () => setState(() => _nudge++),
                  child: const Text('Ép rebuild'),
                ),
                FilledButton.tonal(
                  onPressed: () => setState(() {
                    _childTitle = _childTitle == 'Tiêu đề A'
                        ? 'Tiêu đề B'
                        : 'Tiêu đề A';
                  }),
                  child: const Text('Đổi tham số'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _Child(title: _childTitle, nudge: _nudge),
          ),
        ],
      ),
    );
  }
}

class _Child extends StatefulWidget {
  const _Child({required this.title, required this.nudge});

  final String title;
  final int nudge;

  @override
  State<_Child> createState() => _ChildState();
}

class _ChildState extends State<_Child> {
  int _initStateCount = 0;
  int _didChangeDepsCount = 0;
  int _didUpdateCount = 0;
  int _buildCount = 0;

  int _titleReallyChangedCount = 0;

  @override
  void initState() {
    super.initState();
    _initStateCount++;
    debugPrint('initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _didChangeDepsCount++;
    debugPrint('didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant _Child oldWidget) {
    super.didUpdateWidget(oldWidget);
    _didUpdateCount++;

    if (oldWidget.title != widget.title) {
      _titleReallyChangedCount++;
      debugPrint('title đổi: "${oldWidget.title}" → "${widget.title}"');
    } else {
      debugPrint('didUpdateWidget chạy, nhưng title KHÔNG đổi');
    }
  }

  @override
  void dispose() {
    debugPrint('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: theme.textTheme.titleLarge),
          Text('nudge = ${widget.nudge}', style: theme.textTheme.bodySmall),
          const SizedBox(height: 20),
          _Counter('initState', _initStateCount),
          _Counter('didChangeDependencies', _didChangeDepsCount),
          _Counter('didUpdateWidget', _didUpdateCount),
          _Counter('  ↳ title thật sự đổi', _titleReallyChangedCount),
          _Counter('build', _buildCount),
          const SizedBox(height: 20),
          Text(
            'Hai dòng didUpdateWidget lệch nhau: nó chạy mỗi lần cha dựng lại, '
            'kể cả khi không có gì đổi. Đó là lý do trong đó phải so oldWidget '
            'với widget trước khi làm việc nặng.\n\n'
            'Thoát màn rồi vào lại: mọi con số về 1 — vì đó là một State mới. '
            'dispose của State cũ in ra console.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter(this.label, this.count);

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
          Text(
            '$count',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
