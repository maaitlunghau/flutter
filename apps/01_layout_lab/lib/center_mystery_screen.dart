import 'package:flutter/material.dart';

import 'constraint_readout.dart';

/// Thí nghiệm 1 — cùng một ô vuông xin 100×100, lúc được nghe lúc bị bỏ qua.
///
/// Đây là bài học thật của vòng 1: widget không tự quyết kích thước, nó chỉ
/// nêu nguyện vọng. Cha có tôn trọng hay không là chuyện của constraints.
class CenterMysteryScreen extends StatefulWidget {
  const CenterMysteryScreen({super.key});

  @override
  State<CenterMysteryScreen> createState() => _CenterMysteryScreenState();
}

class _CenterMysteryScreenState extends State<CenterMysteryScreen> {
  bool _wrapInCenter = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Ô vuông này xin đúng 100×100 và không bao giờ đổi trong suốt thí nghiệm.
    // Mọi khác biệt bạn thấy trên màn hình đều đến từ widget BỌC NGOÀI nó.
    final box = Container(
      width: 100,
      height: 100,
      color: theme.colorScheme.primary,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Center Mystery')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Bọc ô vuông trong Center'),
            subtitle: Text(
              _wrapInCenter ? 'Center(child: box)' : 'box',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            value: _wrapInCenter,
            onChanged: (value) => setState(() => _wrapInCenter = value),
          ),
          const Divider(height: 1),

          // SizedBox.expand ép constraints TIGHT xuống con — mô phỏng đúng thứ
          // mà body của Scaffold đưa xuống khi không có gì chen vào giữa.
          // Không có nó thì Column sẽ cho chiều cao unbounded và thí nghiệm hỏng.
          Expanded(
            child: SizedBox.expand(
              child: _wrapInCenter ? Center(child: box) : box,
            ),
          ),

          const Divider(height: 1),

          // Cùng kiểu bọc như trên, nhưng thay ô màu bằng bảng số. So hai dòng
          // constraints ở hai trạng thái công tắc là ra toàn bộ câu trả lời.
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 120,
              child: _wrapInCenter
                  ? const Center(child: _probe)
                  : const SizedBox.expand(child: _probe),
            ),
          ),
        ],
      ),
    );
  }
}

const Widget _probe = ConstraintReadout(
  label: 'Constraints mà ô vuông nhận được',
);
