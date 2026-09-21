import 'package:flutter/material.dart';

import 'app_router.dart';

void main() {
  runApp(const UserHubApp());
}

class UserHubApp extends StatelessWidget {
  const UserHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UserHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: appRouter,
    );
  }
}
