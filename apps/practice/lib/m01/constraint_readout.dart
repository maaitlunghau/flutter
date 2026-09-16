import 'package:flutter/material.dart';

class ConstraintReadout extends StatelessWidget {
  const ConstraintReadout({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // LayoutBuilder là cách duy nhất đọc được constraints của chính chỗ mình đang đứng
    // build() ko nhìn thấy được chúng (constraints), nó chỉ biết context mà thôi, ko biết đc cha đã được xuống cái gì.
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(6),
          ),

          // mainAxisSize.min: để Column co dãn theo nội dung (bỏ dòng này: Column sẽ co giãn hết chiều cao được phép)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Text(
                describeConstraints(constraints),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// `double.inFinity` sẽ in ra thành chữ `Infinity` rất khó đọc
/// nên đổi thành ký hiệu toán học cho dễ đọc
String _n(double value) => value.isInfinite ? '∞' : value.toStringAsFixed(0);

String _kind({required bool tight, required bool bounded}) {
  if (tight) return 'tight';
  return bounded ? 'loose' : 'UNBOUNDED';
}

String describeConstraints(BoxConstraints c) {
  final w = _kind(tight: c.hasTightWidth, bounded: c.hasBoundedWidth);
  final h = _kind(tight: c.hasTightHeight, bounded: c.hasBoundedHeight);

  return 'width:  ${_n(c.minWidth)} → ${_n(c.maxWidth)}   ($w)\n'
      'height:  ${_n(c.minHeight)} → ${_n(c.maxHeight)}   ($h)';
}
