import 'package:flutter/material.dart';

// Toàn bộ file này cố tình viết ngắn. Đọc một lượt từ trên xuống, rồi chạy
// 4 thí nghiệm trong docs/lessons/0001-*.html — mục đích của lab là xem chuyện
// gì xảy ra khi bạn PHÁ nó, không phải xem nó chạy đúng thế nào.

void main() {
  // Hot reload KHÔNG BAO GIỜ quay lại hàm này. Sửa bất cứ thứ gì ở đây đều phải
  // hot restart (bấm R) mới thấy thay đổi.
  runApp(const HelloApp());
}

class HelloApp extends StatelessWidget {
  const HelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp cung cấp theme, điều hướng và localization cho mọi thứ nằm
    // bên dưới nó. Không có nó, các widget như Scaffold không tìm thấy Material
    // context để đọc và sẽ ném lỗi lúc chạy.
    return MaterialApp(
      title: 'Hello Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const CounterPage(title: 'M00 — Hot reload lab'),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.title});

  // Thuộc tính của Widget là bất biến — đó là lý do nó phải `final`. Widget bị
  // vứt đi và dựng lại liên tục; nó là BẢN MÔ TẢ, không phải object có vòng đời.
  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // ĐÂY mới là object có vòng đời. Nó sống sót qua hot reload — chính vì vậy
  // sửa số 0 bên dưới sẽ không có tác dụng gì cho tới khi bạn hot restart.
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // Chạy đúng MỘT LẦN, lúc State này được tạo ra. Hot reload sẽ không chạy
    // lại nó — đây là nguồn gốc rất phổ biến của câu "ơ sao sửa rồi mà không đổi?".
  }

  void _increment() {
    // setState KHÔNG PHẢI là "cập nhật giao diện". Nó đánh dấu State này bẩn để
    // Flutter xếp lịch gọi lại build() ở khung hình kế tiếp. Nếu sửa _counter
    // bên ngoài setState thì giá trị vẫn đổi nhưng màn hình không bao giờ vẽ lại.
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    // Được gọi ở mỗi khung hình cần vẽ lại nhánh này — có thể 60 lần mỗi giây.
    // Nên giữ nó thật nhẹ: không gọi mạng, không đọc ghi file, không parse dữ liệu.
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Số lần bấm nút:'),
            Text('$_counter', style: theme.textTheme.displayMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        tooltip: 'Tăng',
        child: const Icon(Icons.add),
      ),
    );
  }
}
