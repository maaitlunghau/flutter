import 'package:flutter/material.dart';

/// Hiện ra đúng `BoxConstraints` mà vị trí này nhận được từ widget cha.
///
/// Cả module M01 xoay quanh việc đọc được bốn con số đó. Không có widget nào
/// của Flutter hiện chúng sẵn, nên lab tự dựng một cái.
class ConstraintReadout extends StatelessWidget {
  const ConstraintReadout({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // LayoutBuilder là cách duy nhất đọc được constraints của chính chỗ mình
    // đang đứng. build() bình thường không nhìn thấy chúng — nó chỉ biết
    // context, không biết cha đã đưa xuống cái gì.
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(6),
          ),
          // mainAxisSize.min để cái hộp co theo nội dung. Bỏ dòng này ra rồi
          // chạy lại là thấy ngay nó cố giãn hết chiều cao được phép.
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

/// `double.infinity` in ra thành chữ `Infinity` rất khó đọc trên màn hình bé,
/// nên đổi thành ký hiệu toán học.
String _n(double value) => value.isInfinite ? '∞' : value.toStringAsFixed(0);

/// Ba trạng thái này mới là thứ đáng nhớ, không phải bốn con số.
///
/// `tight` nghĩa là min == max — con không còn quyền chọn gì.
/// `unbounded` nghĩa là max vô hạn — đây chính là nguồn gốc của lỗi
/// "Vertical viewport was given unbounded height" sẽ gặp ở vòng 2.
String _kind({required bool tight, required bool bounded}) {
  if (tight) return 'tight';
  return bounded ? 'loose' : 'UNBOUNDED';
}

String describeConstraints(BoxConstraints c) {
  final w = _kind(tight: c.hasTightWidth, bounded: c.hasBoundedWidth);
  final h = _kind(tight: c.hasTightHeight, bounded: c.hasBoundedHeight);
  return 'w  ${_n(c.minWidth)} → ${_n(c.maxWidth)}   $w\n'
      'h  ${_n(c.minHeight)} → ${_n(c.maxHeight)}   $h';
}
