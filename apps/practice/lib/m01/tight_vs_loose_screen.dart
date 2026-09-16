import 'package:flutter/material.dart';
import 'package:practice/m01/constraint_readout.dart';

class TightVsLooseScreen extends StatelessWidget {
  const TightVsLooseScreen({super.key});

  static const double _frame = 160;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tight vs Loose')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hai bên dùng CHUNG một SizedBox(width: 50, height: 50).'
            'Chỉ khác widget bọc ngoài.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // IntrinsicHeight: để hai cột cao bằng nhau
          // NÓ đắt về hiệu năng: chỉ dùng được vì đây là lab với đúng 2 phần tử
          // đừng bê thói quen này vào project thực tế.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Case(
                    title: 'LOOSE',
                    code: 'Align(child: sample)',
                    // Align đưa xuống loose: "to bao nhiêu cũng được, miễn tối đa 160"
                    wrap: (child) =>
                        Align(alignment: Alignment.topLeft, child: child),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _Case(
                    title: 'TIGHT',
                    code: 'SizedBox.expand(child: sample)',
                    // SizedBox.expand đưa xuống tight: "mày đúng 160x160, hết!"
                    wrap: (child) => SizedBox.expand(child: child),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

typedef _Wrapper = Widget Function(Widget child);

class _Case extends StatelessWidget {
  final String title;
  final String code;
  final _Wrapper wrap;

  const _Case({required this.title, required this.code, required this.wrap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sample = SizedBox(
      width: 50,
      height: 50,
      child: ColoredBox(color: theme.colorScheme.primary),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          code,
          style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
        ),
        const SizedBox(height: 12),

        // Khung 160x160 vẽ ra để nhìn thấy "chỗ được cho" rộng tới đâu
        Container(
          width: TightVsLooseScreen._frame,
          height: TightVsLooseScreen._frame,
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: wrap(sample),
        ),
        const SizedBox(height: 12),

        // 180 chứ ko phải 110: cột này chỉ rộng 160 nên dòng constraints bị xuống hàng
        // cao gần gấp đôi so với khi đo ở màn rộng
        // đây đúng là cái bẫy trước đó - chiều cao cứng luôn đúng cho một màn hình duy nhất.
        SizedBox(
          width: TightVsLooseScreen._frame,
          height: 180,
          child: wrap(const ConstraintReadout(label: 'sample nhận được')),
        ),
      ],
    );
  }
}
