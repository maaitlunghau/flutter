import 'package:flutter/material.dart';

/// `Navigator.push` trả về một `Future` hoàn thành lúc màn kia `pop`. Màn này
/// bày ra cả mặt trái của chuyện đó: người dùng có thể bấm Back thay vì chọn,
/// và lúc ấy kết quả là `null`.
class PickResultScreen extends StatefulWidget {
  const PickResultScreen({super.key});

  @override
  State<PickResultScreen> createState() => _PickResultScreenState();
}

class _PickResultScreenState extends State<PickResultScreen> {
  String? _picked;

  /// Công tắc để bật/tắt đúng một dòng code — dòng phân biệt giữa bản chạy đúng
  /// và cái bug kinh điển "bấm Back là mất lựa chọn cũ".
  bool _guardAgainstNull = true;

  Future<void> _openPicker() async {
    // Tham số kiểu <String> nói cho Flutter biết màn kia được phép `pop` cái
    // gì. Bỏ nó đi thì kết quả về thành `dynamic` và analyzer không chặn được
    // khi bạn `pop` nhầm kiểu.
    final String? result = await Navigator.push<String>(
      context,
      MaterialPageRoute<String>(
        builder: (BuildContext context) => const _PickerScreen(),
        settings: const RouteSettings(name: 'Picker'),
      ),
    );

    // Màn có thể đã bị đóng trong lúc đang `await`, lúc đó `setState` ném lỗi.
    if (!mounted) return;

    if (_guardAgainstNull && result == null) return;
    setState(() => _picked = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trả kết quả về')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: ListTile(
              title: const Text('Đang chọn'),
              subtitle: Text(_picked ?? 'chưa chọn'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openPicker,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: _guardAgainstNull,
            onChanged: (bool value) =>
                setState(() => _guardAgainstNull = value),
            title: const Text('Kiểm tra null trước khi gán'),
            subtitle: const Text(
              'Tắt đi, chọn một quả, rồi vào lại và bấm Back: '
              'lựa chọn cũ bị xoá trắng.',
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerScreen extends StatelessWidget {
  const _PickerScreen();

  static const List<String> _fruits = <String>['Cam', 'Chuối', 'Dừa', 'Ổi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nút Back ở AppBar do Flutter tự thêm cũng chỉ gọi `pop` — nhưng `pop`
      // không kèm giá trị, nên bên kia nhận `null`.
      appBar: AppBar(title: const Text('Chọn một quả')),
      body: ListView(
        children: <Widget>[
          for (final String fruit in _fruits)
            ListTile(
              title: Text(fruit),
              onTap: () => Navigator.pop(context, fruit),
            ),
        ],
      ),
    );
  }
}
