import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Màn 5 của M03 — bảng tra lệnh `adb` để thử deep link.
///
/// Màn này **không** làm gì cả về mặt điều hướng: deep link đã chạy được ngay
/// khi khai báo xong `intent-filter` trong `AndroidManifest.xml`, cây route ở
/// `app_router.dart` không phải sửa một dòng nào. Nó tồn tại vì bằng chứng của
/// vòng 3 nằm ở lệnh `adb`, mà lệnh đó thì dài và dễ gõ sai.
class DeepLinkScreen extends StatelessWidget {
  const DeepLinkScreen({super.key});

  static const String _adb = '~/Library/Android/sdk/platform-tools/adb';
  static const String _package = 'com.example.practice';

  static const String _wrongCommand =
      'adb shell am start -a android.intent.action.VIEW \\\n'
      '  -d "practicelab://m03/items/3"';

  static const String _rightCommand =
      'adb shell am start -a android.intent.action.VIEW \\\n'
      '  -d "practicelab:///m03/items/3"';

  static const String _coldCommand =
      'adb shell am force-stop $_package\n'
      'adb shell am start -a android.intent.action.VIEW \\\n'
      '  -d "practicelab:///m03/items/5"';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('/m03/deeplink'),
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Về menu practice',
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _Note(
            'Deep link không phải tính năng của Flutter. Nó là thoả thuận với '
            'Android, khai báo trong AndroidManifest.xml. Cây route không đổi '
            'một dòng nào.',
          ),
          SizedBox(height: 8),
          _Note('adb không nằm trong PATH, gõ nguyên đường dẫn:\n$_adb'),
          _CommandCard(
            label: 'Hai dấu gạch — SAI',
            command: _wrongCommand,
            explain:
                'host nuốt mất "m03", path chỉ còn "/items/3". Router đi tìm '
                'route tên đó, không thấy, rơi vào errorBuilder → màn 404.',
            isWrong: true,
          ),
          _CommandCard(
            label: 'Ba dấu gạch — ĐÚNG',
            command: _rightCommand,
            explain:
                'host rỗng, nên cả "/m03/items/3" nằm trọn trong path và khớp '
                '/m03/items/:id. Bấm Back từ đó phải về được danh sách.',
          ),
          _CommandCard(
            label: 'Cold start — app đang đóng',
            command: _coldCommand,
            explain:
                'Tắt hẳn process rồi mới gọi link. Đi đường code khác với lúc '
                'app đang chạy, nên phải thử riêng.',
          ),
          _Note(
            'Công tắc đăng nhập vẫn có hiệu lực: tắt nó rồi deep link vào '
            '/m03/items/3 thì redirect đá thẳng ra màn khoá. Đó là điểm mạnh '
            'của việc đặt auth guard ở redirect — deep link cũng phải đi qua nó.',
          ),
        ],
      ),
    );
  }
}

class _CommandCard extends StatelessWidget {
  const _CommandCard({
    required this.label,
    required this.command,
    required this.explain,
    this.isWrong = false,
  });

  final String label;
  final String command;
  final String explain;
  final bool isWrong;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = isWrong
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  isWrong ? Icons.cancel_outlined : Icons.check_circle_outline,
                  size: 18,
                  color: accent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(color: accent),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_all_outlined, size: 18),
                  tooltip: 'Chép lệnh',
                  // Chép được thì đỡ gõ sai dấu gạch — chính là thứ bài học này
                  // muốn bạn nhìn thấy khác biệt.
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: command));
                    if (!context.mounted) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã chép lệnh')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: SelectableText(
                command,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            Text(explain, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
