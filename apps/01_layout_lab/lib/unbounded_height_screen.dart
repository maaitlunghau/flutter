import 'package:flutter/material.dart';

/// Thí nghiệm 3 — `ListView` đặt thẳng vào `Column` thì nổ.
///
/// Màn này ship ở trạng thái **chạy được**. Muốn thấy nó nổ thì đọc chú thích
/// trong `_buildList` và bỏ comment đúng một dòng.
class UnboundedHeightScreen extends StatefulWidget {
  const UnboundedHeightScreen({super.key});

  @override
  State<UnboundedHeightScreen> createState() => _UnboundedHeightScreenState();
}

enum _Fix { expanded, shrinkWrap }

class _UnboundedHeightScreenState extends State<UnboundedHeightScreen> {
  _Fix _fix = _Fix.expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Unbounded Height')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Column đưa xuống cho con chiều cao UNBOUNDED. ListView cũng muốn '
              'cao vô hạn. Không ai chốt được con số — đó là lúc Flutter ném lỗi.',
              style: theme.textTheme.bodyMedium,
            ),
          ),

          SegmentedButton<_Fix>(
            segments: const [
              ButtonSegment(value: _Fix.expanded, label: Text('Expanded')),
              ButtonSegment(value: _Fix.shrinkWrap, label: Text('shrinkWrap')),
            ],
            selected: {_fix},
            onSelectionChanged: (s) => setState(() => _fix = s.first),
          ),
          const SizedBox(height: 12),

          _buildList(),
        ],
      ),
    );
  }

  Widget _buildList() {
    final list = ListView.builder(
      // shrinkWrap bảo ListView tự đo hết item rồi cao bằng tổng. Chỉ an toàn
      // với danh sách ngắn — nó dựng mọi item ngay, không còn lazy nữa.
      shrinkWrap: _fix == _Fix.shrinkWrap,
      itemCount: 30,
      itemBuilder: (context, index) => ListTile(
        dense: true,
        leading: CircleAvatar(radius: 14, child: Text('$index')),
        title: Text('Dòng số $index'),
      ),
    );

    // ── MUỐN THẤY NÓ NỔ THÌ BỎ COMMENT DÒNG DƯỚI ĐÂY ──
    // Trả thẳng ListView về cho Column, không ai chốt chiều cao:
    //   Vertical viewport was given unbounded height.
    // Xem xong nhớ comment lại.
    //
    // return list;

    return switch (_fix) {
      // Expanded chốt chiều cao bằng đúng phần còn thừa của Column — đây là
      // cách dùng trong hầu hết trường hợp thật.
      _Fix.expanded => Expanded(child: list),
      // shrinkWrap thì ListView tự cao bằng nội dung, nên Column không cần chốt.
      _Fix.shrinkWrap => Flexible(child: list),
    };
  }
}
