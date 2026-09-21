import 'package:flutter/material.dart';

/// Bản sao *quan sát được* của stack mà `Navigator` đang giữ.
///
/// Flutter không mở ra API nào để đọc danh sách route đang nằm trong
/// `Navigator` — nó là chi tiết nội bộ. Cách duy nhất nhìn được cái stack là
/// đứng ngoài nghe: `NavigatorObserver` được gọi lại sau **mọi** thao tác điều
/// hướng, nên ta tự dựng lại danh sách từ các sự kiện đó.
class StackObserver extends NavigatorObserver {
  /// Đáy stack nằm ở index 0, đỉnh ở cuối — giống thứ tự trong bài giảng 0007.
  final ValueNotifier<List<String>> routes = ValueNotifier<List<String>>(
    <String>[],
  );

  /// `ValueNotifier` chỉ báo khi *tham chiếu* đổi, nên phải tạo list mới thay vì
  /// sửa tại chỗ — sửa tại chỗ thì UI không bao giờ cập nhật.
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

  /// `pushAndRemoveUntil` gỡ từng route một, và chúng không nhất thiết nằm ở
  /// đỉnh — nên ở đây phải tìm theo tên chứ không bóc đỉnh như `didPop`.
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _mutate((List<String> draft) => draft.remove(_nameOf(route)));
  }

  /// `pushReplacement` rơi vào đây chứ không phải `didPush`: stack không dài
  /// thêm, chỉ có một ô bị thay ruột.
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _mutate((List<String> draft) {
      final int index = draft.lastIndexOf(_nameOf(oldRoute));
      if (index != -1) draft[index] = _nameOf(newRoute);
    });
  }
}

/// Phải là một instance duy nhất sống suốt đời app, vì nó được gắn vào
/// `MaterialApp.navigatorObservers` — dựng mới mỗi lần `build` là mất sạch
/// lịch sử đã ghi.
final StackObserver stackObserver = StackObserver();
