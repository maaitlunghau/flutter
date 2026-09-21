import 'package:flutter/foundation.dart';

/// Cờ "đã đăng nhập" của vòng 2 — **một biến trong bộ nhớ**, tắt app là mất.
///
/// Cố ý thô sơ: module này học điều hướng chứ không học quản lý state. Chỗ này
/// sẽ được thay từ M06.
class PracticeAuth extends ChangeNotifier {
  bool _isLoggedIn = true;

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    if (_isLoggedIn == value) {
      return;
    }
    _isLoggedIn = value;
    // Không có tiếng gọi này thì `refreshListenable` im lặng, và `redirect`
    // không bao giờ chạy lại.
    notifyListeners();
  }
}

/// Một instance duy nhất sống suốt đời app, vì router giữ tham chiếu tới nó.
final PracticeAuth practiceAuth = PracticeAuth();
