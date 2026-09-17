import 'package:flutter/material.dart';

/// Thí nghiệm 1 — đếm xem mỗi callback vòng đời chạy bao nhiêu lần.
///
/// Cả màn này chỉ để trả lời một câu: `initState` chạy MỘT lần, `build` chạy
/// rất nhiều lần. Đọc con số thì không cần tin lời ai.
class LifecycleLoggerScreen extends StatefulWidget {
  const LifecycleLoggerScreen({super.key});

  @override
  State<LifecycleLoggerScreen> createState() => _LifecycleLoggerScreenState();
}

class _LifecycleLoggerScreenState extends State<LifecycleLoggerScreen> {
  // Title đổi được để ép cha dựng lại _Child với tham số mới — đó là cách duy
  // nhất làm didUpdateWidget chạy.
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
                  // setState ở ĐÂY làm cha dựng lại, kéo theo _Child dựng lại.
                  // State của _Child không bị tạo mới — đó là điều cần thấy.
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
  // Các biến đếm này nằm trong State nên chúng sống sót qua mọi lần build.
  // Nếu để trong build() thì lần nào cũng về 0 và thí nghiệm vô nghĩa.
  int _initStateCount = 0;
  int _didChangeDepsCount = 0;
  int _didUpdateCount = 0;
  int _buildCount = 0;

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
    debugPrint('didUpdateWidget: "${oldWidget.title}" → "${widget.title}"');
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
          _Counter('build', _buildCount),
          const SizedBox(height: 20),
          Text(
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
