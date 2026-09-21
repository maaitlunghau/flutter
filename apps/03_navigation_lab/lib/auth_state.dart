import 'package:flutter/foundation.dart';

/// Cờ "đã đăng nhập" của lab — **một biến trong bộ nhớ**, tắt app là mất.
///
/// Cố ý thô sơ: module này học điều hướng, không học quản lý state. Từ M06 trở
/// đi chỗ này mới được thay bằng thứ tử tế.
class AuthState extends ChangeNotifier {
  bool _isLoggedIn = true;

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    if (_isLoggedIn == value) {
      return;
    }
    _isLoggedIn = value;
    // Phải báo ra ngoài thì GoRouter mới chạy lại redirect — xem
    // `refreshListenable` trong app_router.dart.
    notifyListeners();
  }
}

/// Một instance duy nhất sống suốt đời app, vì `GoRouter` giữ tham chiếu tới nó.
final AuthState authState = AuthState();
