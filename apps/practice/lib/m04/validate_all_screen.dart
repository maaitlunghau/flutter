import 'package:flutter/material.dart';

import 'validators.dart';

class ValidateAllScreen extends StatefulWidget {
  const ValidateAllScreen({super.key});

  @override
  State<ValidateAllScreen> createState() => _ValidateAllScreenState();
}

class _ValidateAllScreenState extends State<ValidateAllScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  int _validateCount = 0;
  bool _lastResult = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submit() {
    final bool ok = _formKey.currentState!.validate();

    setState(() {
      _validateCount++;
      _lastResult = ok;
    });

    if (!ok) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Hợp lệ — ${_nameController.text.trim()} · '
          '${_emailController.text.trim()} · ${_ageController.text.trim()} tuổi',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Validate cả form')),
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
                      'validate() đã chạy: $_validateCount lần',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _validateCount == 0
                          ? 'Chưa bấm Gửi lần nào'
                          : 'Lần gần nhất trả về: $_lastResult',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tuổi',
                border: OutlineInputBorder(),
              ),
              validator: validateAge,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: const Text('Gửi')),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                _formKey.currentState!.reset();
                _nameController.clear();
                _emailController.clear();
                _ageController.clear();
              },
              child: const Text('Xoá hết'),
            ),
          ],
        ),
      ),
    );
  }
}
