/// Dữ liệu cứng cho vòng 2. Chỉ cần một danh sách có `id` để path param
/// `/m03/items/:id` có chỗ mà trỏ tới.
class PracticeItem {
  const PracticeItem({
    required this.id,
    required this.title,
    required this.note,
  });

  final int id;
  final String title;
  final String note;
}

const List<PracticeItem> practiceItems = <PracticeItem>[
  PracticeItem(id: 1, title: 'Bàn phím cơ', note: 'Switch nâu, 87 phím'),
  PracticeItem(id: 2, title: 'Chuột không dây', note: 'Pin sạc, 2.4GHz'),
  PracticeItem(id: 3, title: 'Màn hình 27"', note: '2K, 144Hz'),
  PracticeItem(id: 4, title: 'Tai nghe chụp tai', note: 'Chống ồn chủ động'),
  PracticeItem(id: 5, title: 'Đế tản nhiệt', note: 'Nhôm, chỉnh được 6 nấc'),
];

/// Trả `null` khi không tìm thấy — path param chỉ là một đoạn chữ, router không
/// kiểm tra giùm rằng `id` đó có thật hay không.
PracticeItem? findItem(String? rawId) {
  final int? id = int.tryParse(rawId ?? '');
  if (id == null) {
    return null;
  }
  for (final PracticeItem item in practiceItems) {
    if (item.id == id) {
      return item;
    }
  }
  return null;
}
