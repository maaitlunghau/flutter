import 'package:flutter/material.dart';

import 'constraint_readout.dart';

/// Thí nghiệm 3 — cùng một `SizedBox(width: 50, height: 50)`, đặt dưới hai
/// loại constraints.
///
/// Dưới loose nó đúng 50×50. Dưới tight nó bị phình ra 160×160 — nó **xin** 50
/// nhưng không được cho. `SizedBox` không phải là lệnh, nó là nguyện vọng.
class TightVsLooseScreen extends StatelessWidget {
  const TightVsLooseScreen({super.key});

  static const double _frame = 160;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tight vs Loose')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hai bên dùng CHUNG một SizedBox(width: 50, height: 50). '
            'Chỉ khác widget bọc ngoài.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // IntrinsicHeight để hai cột cao bằng nhau cho dễ so. Nó đắt về hiệu
          // năng — chỉ dùng được vì đây là lab với đúng hai phần tử. Đừng bê
          // thói quen này vào userhub.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Case(
                    title: 'LOOSE',
                    code: 'Align(child: sample)',
                    // Align đưa xuống loose: "to bao nhiêu cũng được, tối đa 160".
                    wrap: (child) =>
                        Align(alignment: Alignment.topLeft, child: child),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _Case(
                    title: 'TIGHT',
                    code: 'SizedBox.expand(child: sample)',
                    // SizedBox.expand đưa xuống tight: "mày đúng 160×160, hết".
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
  const _Case({required this.title, required this.code, required this.wrap});

  final String title;
  final String code;
  final _Wrapper wrap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Chính nó. Không đổi giữa hai bên — đó là toàn bộ ý nghĩa của thí nghiệm.
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

        // Khung 160×160 vẽ ra để nhìn thấy "chỗ được cho" rộng tới đâu.
        Container(
          width: TightVsLooseScreen._frame,
          height: TightVsLooseScreen._frame,
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: wrap(sample),
        ),
        const SizedBox(height: 12),

        // 180 chứ không phải 110: cột này chỉ rộng 160 nên dòng constraints bị
        // xuống hàng, cao gần gấp đôi so với khi đo ở màn rộng. Đây đúng là cái
        // bẫy mà M01 dạy — chiều cao cứng luôn đúng cho một cỡ màn hình duy nhất.
        SizedBox(
          width: TightVsLooseScreen._frame,
          height: 180,
          child: wrap(const ConstraintReadout(label: 'sample nhận được')),
        ),
      ],
    );
  }
}
