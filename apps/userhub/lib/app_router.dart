import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_state.dart';
import 'login_screen.dart';
import 'not_found_screen.dart';
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
    final bool goingToLogin = location == '/login';

    if (!loggedIn && !goingToLogin) {
      final String from = Uri.encodeComponent(state.uri.toString());
      return '/login?from=$from';
    }

    if (loggedIn && goingToLogin) {
      return state.uri.queryParameters['from'] ?? '/users';
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
