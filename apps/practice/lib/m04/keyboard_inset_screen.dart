import 'package:flutter/material.dart';

import 'validators.dart';

/// Màn 4 — bàn phím che ô cuối.
///
/// Bàn phím **không đè lên** widget. Nó báo cho app biết "phần dưới màn hình
/// không dùng được nữa" qua `MediaQuery.viewInsets.bottom`, và `Scaffold` thu
/// nhỏ vùng vẽ lại cho vừa. Ô nhập biến mất vì nó nằm ngoài vùng còn lại, chứ
/// không phải vì bị che.
///
/// Hai thứ phải cùng đúng thì ô mới tự trượt lên:
/// 1. `Scaffold.resizeToAvoidBottomInset` bật — để viewport thu lại
/// 2. thân màn cuộn được — để Flutter còn chỗ mà kéo ô vào tầm nhìn
class KeyboardInsetScreen extends StatefulWidget {
  const KeyboardInsetScreen({super.key});

  @override
  State<KeyboardInsetScreen> createState() => _KeyboardInsetScreenState();
}

class _KeyboardInsetScreenState extends State<KeyboardInsetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List<TextEditingController>.generate(6, (_) => TextEditingController());

  bool _avoidKeyboard = true;

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double inset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('Bàn phím che ô')),
      // Tắt cái này là viewport **không** thu lại: `Scaffold` vẫn cao bằng cả
      // màn hình, phần dưới nằm dưới bàn phím, và ô cuối không cách nào thấy.
      resizeToAvoidBottomInset: _avoidKeyboard,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'viewInsets.bottom = ${inset.toStringAsFixed(1)}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      inset == 0
                          ? 'Bàn phím đang đóng'
                          : 'Bàn phím đang chiếm ${inset.toStringAsFixed(0)} '
                                'pixel logic ở đáy',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SwitchListTile(
              value: _avoidKeyboard,
              onChanged: (bool value) => setState(() => _avoidKeyboard = value),
              title: const Text('resizeToAvoidBottomInset'),
              subtitle: const Text(
                'Tắt đi rồi chạm ô cuối: ô nằm lì dưới bàn phím',
              ),
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < _controllers.length; i++) ...<Widget>[
              TextFormField(
                controller: _controllers[i],
                textInputAction: i == _controllers.length - 1
                    ? TextInputAction.done
                    : TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Ô số ${i + 1}',
                  border: const OutlineInputBorder(),
                ),
                validator: (String? value) =>
                    requiredText(value, 'Ô số ${i + 1}'),
              ),
              const SizedBox(height: 12),
            ],
            FilledButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (!_formKey.currentState!.validate()) return;
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Hợp lệ')));
              },
              child: const Text('Gửi'),
            ),
          ],
        ),
      ),
    );
  }
}
