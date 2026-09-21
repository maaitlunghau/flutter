library;

String? requiredText(String? value, String fieldName) =>
    (value == null || value.trim().isEmpty)
    ? '$fieldName không được để trống'
    : null;

String? validateEmail(String? value) {
  final String? empty = requiredText(value, 'Email');
  if (empty != null) return empty;

  final String trimmed = value!.trim();
  if (!trimmed.contains('@') || !trimmed.contains('.')) {
    return 'Email trông không hợp lệ';
  }
  return null;
}

String? validateAge(String? value) {
  final String? empty = requiredText(value, 'Tuổi');
  if (empty != null) return empty;

  final int? age = int.tryParse(value!.trim());
  if (age == null) return 'Tuổi phải là số';
  if (age < 1 || age > 120) return 'Tuổi phải nằm trong 1–120';
  return null;
}

String? validatePhone(String? value) {
  final String? empty = requiredText(value, 'Điện thoại');
  if (empty != null) return empty;

  final String digits = value!.trim();
  if (digits.length < 9 || digits.length > 11) {
    return 'Điện thoại phải có 9–11 chữ số';
  }
  return null;
}

String? validatePassword(String? value) {
  final String? empty = requiredText(value, 'Mật khẩu');
  if (empty != null) return empty;

  if (value!.length < 8) return 'Mật khẩu phải từ 8 ký tự';
  return null;
}

String? validateConfirm(String? value, String password) {
  final String? empty = requiredText(value, 'Xác nhận mật khẩu');
  if (empty != null) return empty;

  if (value != password) return 'Hai mật khẩu không khớp';
  return null;
}
