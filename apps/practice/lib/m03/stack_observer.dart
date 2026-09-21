import 'package:flutter/material.dart';

class StackObserver extends NavigatorObserver {
  final ValueNotifier<List<String>> routes = ValueNotifier<List<String>>(
    <String>[],
  );

  void _mutate(void Function(List<String> draft) change) {
    final List<String> draft = List<String>.of(routes.value);
    change(draft);
    routes.value = draft;
  }

  String _nameOf(Route<dynamic>? route) =>
      route?.settings.name ?? '(không tên)';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _mutate((List<String> draft) => draft.add(_nameOf(route)));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _mutate((List<String> draft) {
      if (draft.isNotEmpty) draft.removeLast();
    });
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _mutate((List<String> draft) => draft.remove(_nameOf(route)));
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _mutate((List<String> draft) {
      final int index = draft.lastIndexOf(_nameOf(oldRoute));
      if (index != -1) draft[index] = _nameOf(newRoute);
    });
  }
}

final StackObserver stackObserver = StackObserver();
