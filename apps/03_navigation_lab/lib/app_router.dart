import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'auth_state.dart';
import 'login_gate_screen.dart';
import 'main.dart';
import 'not_found_screen.dart';
import 'stack_observer.dart';
import 'user_detail_screen.dart';
import 'user_list_screen.dart';

/// Nhánh duy nhất bị gác. Menu và ba màn vòng 1 để mở tự do — gác cả app thì
/// không còn chỗ nào bật công tắc lên nữa.
const String _guardedPrefix = '/users';

/// Cây đường đi của lab.
///
/// Toàn bộ cấu trúc app nằm gọn trong file này và đọc được từ trên xuống — đó
/// chính là thứ `Navigator.push` rải rác trong `onPressed` không bao giờ cho.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // Observer của vòng 1 vẫn dùng được nguyên: `go_router` dựng một `Navigator`
  // thật bên dưới chứ không thay thế nó.
  observers: <NavigatorObserver>[stackObserver],
  // Thiếu dòng này thì gạt công tắc xong router không biết mà chạy lại
  // `redirect` — màn khoá cứ đứng yên.
  refreshListenable: authState,
  errorBuilder: (BuildContext context, GoRouterState state) =>
      NotFoundScreen(location: state.uri.toString()),
  redirect: (BuildContext context, GoRouterState state) {
    final String location = state.matchedLocation;

    if (location.startsWith(_guardedPrefix) && !authState.isLoggedIn) {
      // Nhớ lại chỗ người dùng định vào, để lát nữa trả họ về đúng đó thay vì
      // quăng về trang chủ.
      final String from = Uri.encodeComponent(state.uri.toString());
      return '/login?from=$from';
    }

    if (location == '/login' && authState.isLoggedIn) {
      final String? from = state.uri.queryParameters['from'];
      // Điều kiện chặn vòng lặp: đích đến mà lại là chính màn khoá thì bỏ qua,
      // không thì redirect tự gọi mình mãi mãi.
      if (from == null || from.startsWith('/login')) {
        return _guardedPrefix;
      }
      return from;
    }

    // `null` nghĩa là "cứ đi tiếp".
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const LabMenuScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) =>
          LoginGateScreen(from: state.uri.queryParameters['from']),
    ),
    GoRoute(
      path: _guardedPrefix,
      builder: (BuildContext context, GoRouterState state) =>
          const UserListScreen(),
      routes: <RouteBase>[
        GoRoute(
          // Route con **không** có dấu `/` ở đầu. Đường đầy đủ là `/users/:id`,
          // và chính quan hệ cha–con này là thứ đặt màn danh sách xuống dưới
          // màn chi tiết trong stack.
          path: ':id',
          builder: (BuildContext context, GoRouterState state) =>
              UserDetailScreen(rawId: state.pathParameters['id']),
        ),
      ],
    ),
  ],
);
