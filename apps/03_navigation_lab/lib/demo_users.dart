/// Dữ liệu cứng. M05 mới gọi API thật — ở đây chỉ cần một danh sách có `id` để
/// path param `/users/:id` có chỗ mà trỏ tới.
class DemoUser {
  const DemoUser({required this.id, required this.name, required this.role});

  final int id;
  final String name;
  final String role;
}

const List<DemoUser> demoUsers = <DemoUser>[
  DemoUser(id: 1, name: 'Lê Minh Anh', role: 'Quản trị'),
  DemoUser(id: 2, name: 'Trần Quốc Bảo', role: 'Biên tập'),
  DemoUser(id: 3, name: 'Phạm Thu Hà', role: 'Kế toán'),
  DemoUser(id: 4, name: 'Nguyễn Văn Dũng', role: 'Kỹ thuật'),
  DemoUser(id: 5, name: 'Võ Thị Lan', role: 'Nhân sự'),
  DemoUser(id: 6, name: 'Đặng Hoài Nam', role: 'Kỹ thuật'),
];

/// Trả `null` khi không có — màn chi tiết phải tự xử lý, vì path param **không**
/// tự kiểm tra tính hợp lệ giùm bạn.
DemoUser? findUser(String? rawId) {
  final int? id = int.tryParse(rawId ?? '');
  if (id == null) {
    return null;
  }
  for (final DemoUser user in demoUsers) {
    if (user.id == id) {
      return user;
    }
  }
  return null;
}
