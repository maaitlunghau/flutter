import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'm03/item_detail_screen.dart';
import 'm03/item_list_screen.dart';
import 'm03/locked_screen.dart';
import 'm03/not_found_screen.dart';
import 'm03/practice_auth.dart';
import 'm03/stack_observer.dart';
import 'main.dart';

/// Nhánh duy nhất bị gác.
///
/// Gác cả `/m03` thì `/m03/locked` cũng bị gác, và `redirect` sẽ tự đẩy mình
/// vào vòng lặp — màn khoá phải nằm ngoài vùng gác.
const String _guardedPrefix = '/m03/items';

/// Địa chỉ màn khoá. Tách ra hằng số vì nó xuất hiện ở ba chỗ trong `redirect`.
const String _lockedPath = '/m03/locked';

/// Cây đường đi của app practice.
///
/// Các bài M00–M02 vẫn mở bằng `Navigator.push` từ menu — chúng không cần địa
/// chỉ riêng. Chỉ vòng 2 của M03 sống trong cây này, vì nó là thứ đang học.
final GoRouter practiceRouter = GoRouter(
  initialLocation: '/',
  // `stackObserver` của vòng 1 vẫn dùng được nguyên: `go_router` dựng một
  // `Navigator` thật bên dưới chứ không thay thế nó.
  observers: <NavigatorObserver>[stackObserver],
  // Thiếu dòng này thì gạt công tắc xong router không biết mà chạy lại
  // `redirect`, và màn khoá cứ đứng yên.
  refreshListenable: practiceAuth,
  errorBuilder: (BuildContext context, GoRouterState state) =>
      NotFoundScreen(location: state.uri.toString()),
  redirect: (BuildContext context, GoRouterState state) {
    final String location = state.matchedLocation;

    if (location.startsWith(_guardedPrefix) && !practiceAuth.isLoggedIn) {
      // Nhớ lại chỗ người dùng định vào, để lát nữa trả họ về đúng đó thay vì
      // quăng về danh sách.
      final String from = Uri.encodeComponent(state.uri.toString());
      return '$_lockedPath?from=$from';
    }

    if (location == _lockedPath && practiceAuth.isLoggedIn) {
      final String? from = state.uri.queryParameters['from'];
      // Điều kiện chặn vòng lặp: đích đến mà lại là chính màn khoá thì bỏ qua,
      // không thì `redirect` gọi lại chính mình mãi mãi.
      if (from == null || from.startsWith(_lockedPath)) {
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
          const PracticeMenuScreen(),
    ),
    GoRoute(
      path: _lockedPath,
      builder: (BuildContext context, GoRouterState state) =>
          LockedScreen(from: state.uri.queryParameters['from']),
    ),
    GoRoute(
      path: _guardedPrefix,
      builder: (BuildContext context, GoRouterState state) =>
          const ItemListScreen(),
      routes: <RouteBase>[
        GoRoute(
          // Route con **không** có dấu `/` ở đầu. Đường đầy đủ là
          // `/m03/items/:id`, và chính quan hệ cha–con này đặt màn danh sách
          // xuống dưới màn chi tiết trong stack — nên Back về được danh sách.
          path: ':id',
          builder: (BuildContext context, GoRouterState state) =>
              ItemDetailScreen(rawId: state.pathParameters['id']),
        ),
      ],
    ),
  ],
);
