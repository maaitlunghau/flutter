import 'package:flutter/material.dart';

import 'login_screen.dart';

void main() {
  runApp(const UserHubApp());
}

/// Gốc của app. Đây là `MaterialApp` **duy nhất** trong toàn bộ userhub —
/// mọi màn khác chỉ trả về `Scaffold`.
///
/// Lồng thêm một `MaterialApp` nữa sẽ đẻ ra một `Navigator` riêng, và hậu quả
/// đầu tiên nhìn thấy được là nút back biến mất khỏi `AppBar`.
class UserHubApp extends StatelessWidget {
  const UserHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UserHub',
      debugShowCheckedModeBanner: false,

      // fromSeed sinh ra cả bảng màu Material 3 từ một màu gốc. Tới M10 sẽ
      // thay bằng theme riêng; hiện tại chỉ cần nó nhất quán.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),

      // Chưa có điều hướng — đó là M03. Tạm thời trỏ thẳng vào màn Login.
      home: const LoginScreen(),
    );
  }
}
