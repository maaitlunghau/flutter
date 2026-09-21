import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;

  String? get email => _email;

  /// Chưa có backend để hỏi — M05 sẽ thay chỗ này bằng lời gọi API thật, và
  /// lúc đó mới có token để giữ.
  void logIn(String email) {
    _isLoggedIn = true;
    _email = email;
    notifyListeners();
  }

  void logOut() {
    _isLoggedIn = false;
    _email = null;
    notifyListeners();
  }
}

/// Trạng thái nằm trong RAM nên tắt app là mất — M09 mới lo chuyện nhớ phiên.
/// Biến toàn cục cũng là bước lùi có chủ ý: M06 và M07 sẽ thay chỗ này bằng
/// cách đưa state xuống qua cây widget, để M03 chỉ phải lo đúng một chuyện là
/// điều hướng.
final AuthState authState = AuthState();
