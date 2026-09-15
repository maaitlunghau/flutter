import 'package:flutter/material.dart';

import 'constraint_readout.dart';

/// Thí nghiệm 2 — constraints không đi xuống nguyên si. Mỗi tầng cha đều
/// cắt bớt trước khi đưa tiếp.
///
/// Màn này cũng để lộ sẵn thứ sẽ nổ ở vòng 2: trong một `Column`, con nhận
/// chiều cao **unbounded**. Nhớ mặt nó từ bây giờ.
class ConstraintsProbeScreen extends StatelessWidget {
  const ConstraintsProbeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Constraints Probe')),

      // ListView thay cho Column để màn này không bao giờ overflow, kể cả khi
      // bạn bật cỡ chữ lớn trong Settings của máy.
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ConstraintReadout(label: 'Tầng 0 — con trực tiếp của ListView'),
          SizedBox(height: 16),

          // Mỗi Padding ăn mất 24 ở mỗi bên, tức maxWidth tụt đúng 48 mỗi tầng.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ConstraintReadout(label: 'Tầng 1 — sau 1 Padding 24'),
          ),
          SizedBox(height: 16),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ConstraintReadout(label: 'Tầng 2 — sau 2 Padding 24'),
            ),
          ),
          SizedBox(height: 32),

          _ColumnTrap(),
        ],
      ),
    );
  }
}

/// Con của `Column` nhận chiều cao **unbounded** theo trục chính.
///
/// Đây chính là lý do `ListView` đặt thẳng vào `Column` thì nổ: `ListView`
/// muốn cao vô hạn, mà `Column` cũng không giới hạn nó — không ai chốt được
/// con số nào cả.
class _ColumnTrap extends StatelessWidget {
  const _ColumnTrap();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bên trong một Column',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        const ConstraintReadout(label: 'Con của Column — nhìn dòng h'),
      ],
    );
  }
}
