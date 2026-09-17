import 'package:flutter/material.dart';

/// Màn đăng nhập.
///
/// Phải là `StatefulWidget` vì màn này có **ba thứ cần nhớ** giữa các lần vẽ:
/// mật khẩu đang ẩn hay hiện, và hai thông báo lỗi. Ba thứ đó sống trong
/// `State`, không sống trong `build()`.
///
/// Chưa gọi API (M05), chưa dùng `Form`/`validator` (M04), chưa điều hướng (M03).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller là cầu nối để ĐỌC nội dung ô nhập. Không có nó thì `build()`
  // không biết người dùng đã gõ gì.
  //
  // Nó tự đăng ký listener nên phải trả lại ở dispose(), nếu không là rò rỉ.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // true = đang che ký tự. Đổi giá trị này rồi setState là nút con mắt hoạt động.
  bool _obscurePassword = true;

  // null = chưa có lỗi. Dùng String? thay vì bool để chính chuỗi lỗi nằm luôn
  // trong state, khỏi phải map từ bool sang câu chữ ở chỗ khác.
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    // Cặp đôi của phần khởi tạo bên trên. Viết ngay lúc tạo controller, đừng
    // để "lát nữa" — vì lát nữa là lúc quên.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Kiểm tra bằng tay. M04 sẽ thay toàn bộ hàm này bằng `Form` + `validator`;
  /// làm tay một lần để thấy `Form` tiết kiệm được cái gì.
  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Tính lỗi trước, gán sau. Gộp cả hai vào MỘT setState để màn hình chỉ vẽ
    // lại một lần thay vì hai.
    setState(() {
      _emailError = email.isEmpty ? 'Email không được để trống' : null;
      _passwordError = password.isEmpty ? 'Mật khẩu không được để trống' : null;
    });

    if (_emailError != null || _passwordError != null) return;

    // Chưa có backend để hỏi. M05 sẽ thay dòng này bằng lời gọi API thật.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đăng nhập với $email — API sẽ nối ở M05')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // SafeArea tránh tai thỏ và thanh điều hướng của hệ thống.
      body: SafeArea(
        // Center + SingleChildScrollView là cặp giải quyết BA vấn đề cùng lúc:
        //   - màn cao: nội dung nằm giữa, đẹp
        //   - màn thấp / xoay ngang: cuộn được, không tràn
        //   - bàn phím bật lên: Scaffold co vùng body lại, chỗ còn lại cuộn
        //     được nên nút Đăng nhập không bị che
        // Thử đổi thành Column thường rồi xoay ngang là thấy ngay nó vỡ.
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),

            // mainAxisSize.min để cụm nội dung co đúng bằng nó — có vậy Center
            // mới có cái để căn giữa.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'UserHub',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đăng nhập để tiếp tục',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: _emailController,
                  // Bàn phím hiện sẵn @ và dấu chấm — chi tiết nhỏ nhưng người
                  // dùng cảm nhận được ngay.
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.mail_outline),
                    border: const OutlineInputBorder(),
                    // errorText null thì không có gì hiện. Khác null thì ô tự
                    // chuyển sang màu lỗi và chừa chỗ cho dòng chữ bên dưới —
                    // không phải tự vẽ Text lỗi bằng tay.
                    errorText: _emailError,
                  ),
                  // Xoá lỗi ngay khi người dùng bắt đầu sửa. Bắt họ nhìn chữ đỏ
                  // cho tới lần bấm nút tiếp theo là cảm giác rất khó chịu.
                  onChanged: (_) {
                    if (_emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  // Gõ xong bấm Enter trên bàn phím là gửi luôn.
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    errorText: _passwordError,
                    // Nút con mắt. Toàn bộ cơ chế chỉ là: đảo một bool rồi
                    // setState — Flutter dựng lại TextField với obscureText mới.
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      tooltip: _obscurePassword
                          ? 'Hiện mật khẩu'
                          : 'Ẩn mật khẩu',
                      onPressed: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                    ),
                  ),
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                ),
                const SizedBox(height: 8),

                // Align để nút co đúng bằng chữ. Không có nó thì
                // crossAxisAlignment.stretch ở trên sẽ kéo nó rộng cả hàng.
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Khôi phục mật khẩu — chưa làm'),
                        ),
                      );
                    },
                    child: const Text('Quên mật khẩu?'),
                  ),
                ),
                const SizedBox(height: 16),

                FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    // Chiều CAO cố định thì an toàn; chiều RỘNG cố định mới là
                    // thứ làm vỡ layout ở máy khác. Ở đây rộng do stretch quyết.
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Đăng nhập'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
