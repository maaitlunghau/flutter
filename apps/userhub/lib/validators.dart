String? requiredText(String? value, String fieldName) =>
    (value == null || value.trim().isEmpty) ? '$fieldName is required' : null;

String? validateEmail(String? value) {
  final String? empty = requiredText(value, 'Email');
  if (empty != null) return empty;

  final String trimmed = value!.trim();
  if (!trimmed.contains('@') || !trimmed.contains('.')) {
    return 'Email looks invalid';
  }
  return null;
}

String? validatePassword(String? value) {
  final String? empty = requiredText(value, 'Password');
  if (empty != null) return empty;

  if (value!.length < 8) return 'Password must be at least 8 characters';
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  final String? empty = requiredText(value, 'Password confirmation');
  if (empty != null) return empty;

  if (value != password) return 'Passwords do not match';
  return null;
}
