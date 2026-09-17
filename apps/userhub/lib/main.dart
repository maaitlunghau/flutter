import 'package:flutter/material.dart';

import 'login_screen.dart';

void main() {
  runApp(const UserHubApp());
}

class UserHubApp extends StatelessWidget {
  const UserHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UserHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),

      // Chưa có điều hướng — đó là M03. Tạm thời trỏ thẳng vào màn Login.
      home: const LoginScreen(),
    );
  }
}
