class User {
  final int? id;
  final String name;
  final String password;
  final int isActive;

  const User({
    this.id,
    required this.name,
    required this.password,
    this.isActive = 1,
  });

  bool get active => isActive == 1;

  User copyWith({int? id, String? name, String? password, int? isActive}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      '_password': password,
      'isActive': isActive,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      password: (map['_password'] ?? map['password'] ?? '') as String,
      isActive: (map['isActive'] as int?) ?? 1,
    );
  }
}
