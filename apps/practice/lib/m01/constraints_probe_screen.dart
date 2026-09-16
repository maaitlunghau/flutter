import 'package:flutter/material.dart';
import 'package:practice/m01/constraint_readout.dart';

class ConstraintsProbeScreen extends StatelessWidget {
  const ConstraintsProbeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Constraints Probe')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ConstraintReadout(label: 'Tầng 0 - con trực tiếp của ListView'),
          SizedBox(height: 16),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ConstraintReadout(label: 'Tầng 1 - sau 1 Padding 24'),
          ),
          SizedBox(height: 16),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ConstraintReadout(label: 'Tầng 2 - sau 2 Padding 24'),
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
/// Đây chính là lý do `ListView` đặt thẳng vào `Column` thì nổ
/// `ListView` muốn cao vô hạn, mà `Column` cũng ko giới hạn nó - ko ai chốt được con số nào cả.
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
        const ConstraintReadout(label: 'Con của Column - nhìn dòng height'),
      ],
    );
  }
}
