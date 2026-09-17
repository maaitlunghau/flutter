import 'package:flutter/material.dart';

/// Chưa gọi API (M05)
/// Chưa dùng `Form`/`validator` (M04)
/// Chưa điều hướng (M03).
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

  bool _obscurePassword = true;

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
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.mail_outline),
                    border: const OutlineInputBorder(),
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
