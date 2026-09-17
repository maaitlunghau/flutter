import 'package:flutter/material.dart';

/// Thí nghiệm 1 — tràn chỉ là một phép cộng bị vượt.
///
/// Thêm ô cho tới khi tổng bề rộng vượt bề rộng màn hình, rồi đối chiếu con số
/// trong thông báo lỗi với phép trừ hiện ngay trên đầu màn.
class FlexOverflowScreen extends StatefulWidget {
  const FlexOverflowScreen({super.key});

  @override
  State<FlexOverflowScreen> createState() => _FlexOverflowScreenState();
}

class _FlexOverflowScreenState extends State<FlexOverflowScreen> {
  static const double _boxWidth = 120;

  int _count = 2;
  bool _lastOneFlexes = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Bề rộng thật sự dùng được, sau khi trừ padding hai bên. Tính ở đây để
    // phép cộng trên màn khớp với con số Flutter in ra trong lỗi.
    final available = MediaQuery.sizeOf(context).width - 32;
    final demanded = _boxWidth * _count;
    final overflow = demanded - available;

    return Scaffold(
      appBar: AppBar(title: const Text('Flex Overflow')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              '$_count ô × ${_boxWidth.toStringAsFixed(0)} '
              '= ${demanded.toStringAsFixed(0)}\n'
              'chỗ có: ${available.toStringAsFixed(0)}\n'
              '${overflow > 0 ? "→ tràn ${overflow.toStringAsFixed(0)}" : "→ còn thừa ${(-overflow).toStringAsFixed(0)}"}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: overflow > 0 ? theme.colorScheme.error : null,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilledButton.tonal(
                  onPressed: _count > 1 ? () => setState(() => _count--) : null,
                  child: const Text('− ô'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () => setState(() => _count++),
                  child: const Text('+ ô'),
                ),
              ],
            ),
          ),

          SwitchListTile(
            title: const Text('Ô cuối bọc Expanded'),
            subtitle: const Text(
              'Expanded nhận phần CÒN THỪA, nên nó là thứ chịu co',
            ),
            value: _lastOneFlexes,
            onChanged: (value) => setState(() => _lastOneFlexes = value),
          ),
          const Divider(height: 1),
          const SizedBox(height: 24),

          // Đây là Row bị đem ra làm thí nghiệm. Mọi thứ phía trên chỉ là điều
          // khiển — đừng nhầm chúng vào bài học.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: _buildBoxes(theme)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBoxes(ThemeData theme) {
    return List<Widget>.generate(_count, (index) {
      final isLast = index == _count - 1;

      // KHÔNG dùng margin, và đây là chuyện có chủ ý: margin cũng chiếm chỗ
      // trên trục chính, nên phép tính hiện ở đầu màn sẽ lệch đúng bằng tổng
      // margin. Viền vẽ trong decoration thì không đội thêm kích thước, nên
      // mỗi ô chiếm đúng 120 và con số khớp với lỗi Flutter in ra.
      final box = Container(
        width: _boxWidth,
        height: 80,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          border: Border.all(color: theme.colorScheme.outline),
        ),
        alignment: Alignment.center,
        child: Text('${index + 1}'),
      );

      // Ô cuối bọc Expanded thì nó bỏ qua width 120 và nhận đúng phần còn thừa
      // — kể cả khi phần đó âm, lúc ấy nó co về 0 thay vì đẩy tràn.
      return _lastOneFlexes && isLast ? Expanded(child: box) : box;
    });
  }
}
