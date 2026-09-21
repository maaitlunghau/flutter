import 'package:flutter/material.dart';

import 'validators.dart';

class PasswordMatchScreen extends StatefulWidget {
  const PasswordMatchScreen({super.key});

  @override
  State<PasswordMatchScreen> createState() => _PasswordMatchScreenState();
}

class _PasswordMatchScreenState extends State<PasswordMatchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> _confirmKey =
      GlobalKey<FormFieldState<String>>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _revalidateConfirm = true;
  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hai ô phải khớp')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            SwitchListTile(
              value: _revalidateConfirm,
              onChanged: (bool value) =>
                  setState(() => _revalidateConfirm = value),
              title: const Text('Validate lại ô xác nhận'),
              subtitle: const Text(
                'Tắt đi: gõ khớp cả hai, rồi sửa ô mật khẩu — ô xác nhận vẫn '
                'xanh dù đã sai',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: validatePassword,
              onChanged: (_) {
                if (_revalidateConfirm) {
                  _confirmKey.currentState?.validate();
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: _confirmKey,
              controller: _confirmController,
              obscureText: _obscure,
              decoration: const InputDecoration(
                labelText: 'Xác nhận mật khẩu',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) =>
                  validateConfirm(value, _passwordController.text),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (!_formKey.currentState!.validate()) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hai mật khẩu khớp')),
                );
              },
              child: const Text('Gửi'),
            ),
          ],
        ),
      ),
    );
  }
}
