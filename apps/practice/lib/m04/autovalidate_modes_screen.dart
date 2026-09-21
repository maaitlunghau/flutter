import 'package:flutter/material.dart';

import 'validators.dart';

class AutovalidateModesScreen extends StatefulWidget {
  const AutovalidateModesScreen({super.key});

  @override
  State<AutovalidateModesScreen> createState() =>
      _AutovalidateModesScreenState();
}

class _AutovalidateModesScreenState extends State<AutovalidateModesScreen> {
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
            showSelectedIcon: false,
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
          _DemoForm(key: ValueKey<AutovalidateMode>(_mode), mode: _mode),
        ],
      ),
    );
  }

  String _explain(AutovalidateMode mode) {
    switch (mode) {
      case AutovalidateMode.disabled:
        return 'Lỗi chỉ hiện khi bấm Gửi. Mặc định của Flutter, hợp với form '
            'ngắn có đúng một nút gửi.';
      case AutovalidateMode.onUserInteraction:
        return 'Mỗi ô im lặng cho tới khi người dùng chạm vào chính nó. Gần như '
            'luôn là lựa chọn đúng cho form dài.';
      case AutovalidateMode.always:
        return 'Lỗi hiện ngay khi mở màn, chưa gõ gì đã đỏ. Đúng về kỹ thuật '
            '(ô đang rỗng thật), nhưng với màn đăng ký thì giống như bị mắng vì '
            'chưa làm gì cả.';
      case AutovalidateMode.onUnfocus:
        return 'Ô báo lỗi khi con trỏ rời khỏi nó.';
      case AutovalidateMode.onUserInteractionIfError:
        return 'Chỉ bật tự-validate sau khi ô đã từng sai một lần.';
    }
  }
}

class _DemoForm extends StatefulWidget {
  const _DemoForm({super.key, required this.mode});

  final AutovalidateMode mode;

  @override
  State<_DemoForm> createState() => _DemoFormState();
}

class _DemoFormState extends State<_DemoForm> {
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
            validator: (String? value) => requiredText(value, 'Tên'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: validateEmail,
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
