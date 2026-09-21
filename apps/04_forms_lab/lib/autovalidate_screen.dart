import 'package:flutter/material.dart';

import 'manual_vs_form_screen.dart' show validateEmail, validateName;

/// Cùng một form hai ô, khác đúng **một tham số**. `validator` quyết định kiểm
/// tra cái gì; `autovalidateMode` quyết định lỗi hiện ra lúc nào — và chọn sai
/// thì form đúng về logic vẫn khó chịu để dùng.
class AutovalidateScreen extends StatefulWidget {
  const AutovalidateScreen({super.key});

  @override
  State<AutovalidateScreen> createState() => _AutovalidateScreenState();
}

class _AutovalidateScreenState extends State<AutovalidateScreen> {
  AutovalidateMode _mode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Lỗi hiện lúc nào')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SegmentedButton<AutovalidateMode>(
            segments: const <ButtonSegment<AutovalidateMode>>[
              ButtonSegment<AutovalidateMode>(
                value: AutovalidateMode.disabled,
                label: Text('disabled'),
              ),
              ButtonSegment<AutovalidateMode>(
                value: AutovalidateMode.onUserInteraction,
                label: Text('onUser…'),
              ),
              ButtonSegment<AutovalidateMode>(
                value: AutovalidateMode.always,
                label: Text('always'),
              ),
            ],
            selected: <AutovalidateMode>{_mode},
            onSelectionChanged: (Set<AutovalidateMode> picked) =>
                setState(() => _mode = picked.first),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_explain(_mode), style: theme.textTheme.bodyMedium),
            ),
          ),
          const SizedBox(height: 16),
          // `ValueKey` theo mode: đổi chế độ là vứt hẳn `State` cũ và dựng form
          // mới tinh. Không có nó, Flutter ghép `State` theo vị trí nên ô vẫn
          // giữ nguyên chữ đã gõ và cả vết đã-chạm-vào — thí nghiệm mất sạch ý
          // nghĩa. Đúng `UniqueKey` của bài 0006, ở đây dùng bản có giá trị.
          _ModeDemoForm(key: ValueKey<AutovalidateMode>(_mode), mode: _mode),
        ],
      ),
    );
  }

  String _explain(AutovalidateMode mode) {
    switch (mode) {
      case AutovalidateMode.disabled:
        return 'Lỗi chỉ hiện khi bấm Gửi. Mặc định của Flutter, hợp với form '
            'ngắn có một nút gửi.';
      case AutovalidateMode.onUserInteraction:
        return 'Mỗi ô im lặng cho tới khi người dùng chạm vào nó. Gần như luôn '
            'là lựa chọn đúng cho form dài.';
      case AutovalidateMode.always:
        return 'Lỗi hiện ngay khi mở màn, chưa gõ gì đã đỏ. Đúng về kỹ thuật, '
            'nhưng với màn đăng ký thì giống như bị mắng vì chưa làm gì.';
      case AutovalidateMode.onUnfocus:
        return 'Ô báo lỗi khi con trỏ rời khỏi nó. Nằm giữa hai thái cực trên.';
      case AutovalidateMode.onUserInteractionIfError:
        return 'Chỉ bật tự-validate sau khi ô đã từng sai một lần. Im lặng với '
            'người gõ đúng ngay từ đầu.';
    }
  }
}

class _ModeDemoForm extends StatefulWidget {
  const _ModeDemoForm({super.key, required this.mode});

  final AutovalidateMode mode;

  @override
  State<_ModeDemoForm> createState() => _ModeDemoFormState();
}

class _ModeDemoFormState extends State<_ModeDemoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.mode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Tên',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) => validateName(value ?? ''),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) => validateEmail(value ?? ''),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Hợp lệ')));
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }
}
