class Contact {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final int isFavorite;

  const Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.isFavorite = 0,
  });

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    int? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
      'isFavorite': isFavorite,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      isFavorite: (map['isFavorite'] as int?) ?? 0,
    );
  }
}
