import 'package:flutter/material.dart';

import 'stack_observer.dart';

/// Màn này **tự đẩy chính nó** lên stack. Nhờ vậy cái bảng stack luôn hiển thị,
/// và bạn thấy được hình dạng stack biến đổi ngay trong lúc thao tác thay vì
/// phải nhớ mình đã bấm gì.
class StackVisualizerScreen extends StatelessWidget {
  const StackVisualizerScreen({super.key, this.depth = 1});

  /// Vị trí của màn này trong stack, chỉ dùng để đặt tên cho dễ đọc.
  final int depth;

  /// Tên route là thứ duy nhất [StackObserver] nhìn thấy được — không đặt tên
  /// thì cả bảng chỉ toàn dòng "(không tên)".
  static Route<void> route(int depth, {String suffix = ''}) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => StackVisualizerScreen(depth: depth),
      settings: RouteSettings(name: 'Màn #$depth$suffix'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Stack Visualizer — màn #$depth')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Expanded(child: _StackTable()),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                FilledButton(
                  onPressed: () => navigator.push(route(depth + 1)),
                  child: const Text('push'),
                ),
                FilledButton.tonal(
                  // Thay chính mình, nên màn mới giữ nguyên vị trí `depth`.
                  onPressed: () => navigator.pushReplacement(
                    route(depth, suffix: ' (thay)'),
                  ),
                  child: const Text('pushReplacement'),
                ),
                FilledButton.tonal(
                  // `(route) => false` nghĩa là không giữ lại gì hết — đây đúng
                  // là thứ cần dùng cho nút Đăng xuất.
                  onPressed: () => navigator.pushAndRemoveUntil(
                    route(1),
                    (Route<dynamic> route) => false,
                  ),
                  child: const Text('pushAndRemoveUntil'),
                ),
                OutlinedButton(
                  onPressed: () => _pop(context),
                  child: const Text('pop'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pop(BuildContext context) {
    // Gọi `pop` ở màn cuối cùng thì Flutter đẩy cả app xuống nền. Hỏi trước
    // bằng `canPop` là cách duy nhất phân biệt "lùi một màn" với "thoát app".
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đáy stack rồi — không còn gì để bóc.')),
    );
  }
}

class _StackTable extends StatelessWidget {
  const _StackTable();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: stackObserver.routes,
      builder: (BuildContext context, List<String> routes, Widget? child) {
        // Đảo lại để đỉnh stack nằm trên cùng, khớp với trực giác "màn đang
        // nhìn thấy thì ở trên".
        final List<String> topFirst = routes.reversed.toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topFirst.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Độ sâu: ${routes.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }

            final int position = index - 1;
            final bool isTop = position == 0;
            final bool isBottom = position == topFirst.length - 1;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: isTop
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              child: ListTile(
                dense: true,
                leading: Text('${topFirst.length - position}'),
                title: Text(topFirst[position]),
                trailing: Text(
                  isTop
                      ? 'đỉnh — đang thấy'
                      : isBottom
                      ? 'đáy'
                      : '',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
