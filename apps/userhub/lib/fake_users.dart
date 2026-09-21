import 'package:characters/characters.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String role;

  String get initials =>
      name.isEmpty ? '?' : name.characters.first.toUpperCase();
}

const List<User> fakeUsers = <User>[
  User(
    id: 1,
    name: 'Nguyễn Văn An',
    email: 'an.nguyen@userhub.vn',
    role: 'Admin',
  ),
  User(
    id: 2,
    name: 'Trần Thị Bình',
    email: 'binh.tran@userhub.vn',
    role: 'Điều phối',
  ),
  User(
    id: 3,
    name: 'Lê Hoàng Cường',
    email: 'cuong.le@userhub.vn',
    role: 'Nhân viên',
  ),
  User(
    id: 4,
    name: 'Phạm Thu Dung',
    email: 'dung.pham@userhub.vn',
    role: 'Nhân viên',
  ),
  User(id: 5, name: 'Võ Minh Đức', email: 'duc.vo@userhub.vn', role: 'Kế toán'),
  User(
    id: 6,
    name: 'Đặng Thị Hoa',
    email: 'hoa.dang@userhub.vn',
    role: 'Nhân sự',
  ),
  User(
    id: 7,
    name: 'Bùi Quốc Khánh',
    email: 'khanh.bui@userhub.vn',
    role: 'Nhân viên',
  ),
  User(
    id: 8,
    name: 'Hồ Ngọc Lan',
    email: 'lan.ho@userhub.vn',
    role: 'Thực tập',
  ),
];

User? findUserById(int id) {
  for (final User user in fakeUsers) {
    if (user.id == id) return user;
  }
  return null;
}
