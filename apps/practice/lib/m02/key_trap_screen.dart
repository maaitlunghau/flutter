import 'package:flutter/material.dart';

class KeyTrapScreen extends StatefulWidget {
  const KeyTrapScreen({super.key});

  @override
  State<KeyTrapScreen> createState() => _KeyTrapScreenState();
}

class _KeyTrapScreenState extends State<KeyTrapScreen> {
  List<String> _labels = ['Cam', 'Chuối', 'Dừa', 'Ổi'];

  void _removeFirst() {
    if (_labels.length <= 1) return;
    setState(() => _labels = _labels.sublist(1));
  }

  void _reset() {
    setState(() {
      _labels = ['Cam', 'Chuối', 'Dừa', 'Ổi'];
      _colorCursor = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Key Trap')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Màu của mỗi ô do State của nó tự chọn lúc initState, nên màu là '
            '"trí nhớ" của State. Xoá phần tử đầu rồi xem màu có đi theo nhãn '
            'hay ở lại đúng vị trí cũ.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              FilledButton.tonal(
                onPressed: _removeFirst,
                child: const Text('Xoá phần tử đầu'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: _reset, child: const Text('Reset')),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _Column(labels: _labels, useKeys: false)),
              const SizedBox(width: 16),
              Expanded(child: _Column(labels: _labels, useKeys: true)),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'Không Key: Flutter ghép State cũ với widget mới theo VỊ TRÍ, nên màu '
            'ở lại chỗ cũ còn nhãn thì trượt lên — sai cặp.\n\n'
            'Có ValueKey: Flutter ghép theo key, nên State đi theo đúng nhãn của '
            'nó. Ô "Cam" bị xoá mang theo màu của chính nó.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({required this.labels, required this.useKeys});

  final List<String> labels;
  final bool useKeys;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          useKeys ? 'Có ValueKey' : 'Không Key',
          style: theme.textTheme.titleSmall?.copyWith(
            color: useKeys
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: 8),
        for (final label in labels)
          _ColorTile(key: useKeys ? ValueKey(label) : null, label: label),
      ],
    );
  }
}

int _colorCursor = 0;

const List<Color> _palette = [
  Color(0xFFE57373),
  Color(0xFF81C784),
  Color(0xFF64B5F6),
  Color(0xFFFFB74D),
  Color(0xFFBA68C8),
  Color(0xFF4DB6AC),
  Color(0xFFA1887F),
  Color(0xFF90A4AE),
];

class _ColorTile extends StatefulWidget {
  const _ColorTile({super.key, required this.label});

  final String label;

  @override
  State<_ColorTile> createState() => _ColorTileState();
}

class _ColorTileState extends State<_ColorTile> {
  late final Color _color;

  @override
  void initState() {
    super.initState();
    _color = _palette[_colorCursor++ % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        widget.label,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
