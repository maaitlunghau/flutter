import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_state.dart';
import 'login_screen.dart';
import 'not_found_screen.dart';
import 'register_screen.dart';
import 'splash_screen.dart';
import 'user_detail_screen.dart';
import 'user_list_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',

  errorBuilder: (BuildContext context, GoRouterState state) =>
      NotFoundScreen(location: state.uri.toString()),

  refreshListenable: authState,

  redirect: (BuildContext context, GoRouterState state) {
    final String location = state.matchedLocation;

    if (location == '/splash') return null;

    final bool loggedIn = authState.isLoggedIn;
    final bool isPublic = location == '/login' || location == '/register';

    if (!loggedIn && !isPublic) {
      final Uri uri = state.uri;
      final String target = uri.hasQuery
          ? '${uri.path}?${uri.query}'
          : uri.path;

      return '/login?from=${Uri.encodeComponent(target)}';
    }

    if (loggedIn && isPublic) {
      final String? from = state.uri.queryParameters['from'];

      final bool isInternal =
          from != null && from.startsWith('/') && !from.startsWith('//');

      return isInternal ? from : '/users';
    }

    return null;
  },

  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) =>
          const RegisterScreen(),
    ),
    GoRoute(
      path: '/users',
      builder: (BuildContext context, GoRouterState state) =>
          const UserListScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: ':id',
          builder: (BuildContext context, GoRouterState state) =>
              UserDetailScreen(userId: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);
