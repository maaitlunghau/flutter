import 'package:flutter/material.dart';

/// Cùng một form ba ô, dựng hai lần. Hành vi bên ngoài giống hệt nhau — khác
/// biệt duy nhất nằm ở chỗ **trạng thái lỗi được giữ ở đâu**.
class ManualVsFormScreen extends StatefulWidget {
  const ManualVsFormScreen({super.key});

  @override
  State<ManualVsFormScreen> createState() => _ManualVsFormScreenState();
}

enum _Flavor { manual, form }

class _ManualVsFormScreenState extends State<ManualVsFormScreen> {
  _Flavor _flavor = _Flavor.manual;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tay vs Form')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SegmentedButton<_Flavor>(
            segments: const <ButtonSegment<_Flavor>>[
              ButtonSegment<_Flavor>(
                value: _Flavor.manual,
                label: Text('Thủ công'),
              ),
              ButtonSegment<_Flavor>(value: _Flavor.form, label: Text('Form')),
            ],
            selected: <_Flavor>{_flavor},
            onSelectionChanged: (Set<_Flavor> picked) =>
                setState(() => _flavor = picked.first),
          ),
          const SizedBox(height: 16),
          const _Scoreboard(),
          const SizedBox(height: 16),
          // `Key` khác nhau để đổi tab là vứt hẳn `State` cũ đi — nếu không,
          // Flutter ghép theo vị trí và giữ lại giá trị đã gõ ở bản kia.
          // Đây đúng là `UniqueKey` ở bài 0006, dùng có chủ đích.
          if (_flavor == _Flavor.manual)
            const _ManualForm(key: ValueKey<String>('manual'))
          else
            const _ValidatedForm(key: ValueKey<String>('form')),
        ],
      ),
    );
  }
}

class _Scoreboard extends StatelessWidget {
  const _Scoreboard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Thêm ô thứ tư thì phải sửa mấy chỗ?',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            const _ScoreRow(
              label: 'Thủ công',
              count: '3 chỗ',
              detail: 'biến lỗi · dòng trong _submit · onChanged',
            ),
            const SizedBox(height: 8),
            const _ScoreRow(
              label: 'Form',
              count: '1 chỗ',
              detail: 'thêm TextFormField, hết',
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.label,
    required this.count,
    required this.detail,
  });

  final String label;
  final String count;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 80,
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        SizedBox(
          width: 56,
          child: Text(
            count,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            detail,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bản thủ công — kiểu đã viết ở M02.
// ---------------------------------------------------------------------------

class _ManualForm extends StatefulWidget {
  const _ManualForm({super.key});

  @override
  State<_ManualForm> createState() => _ManualFormState();
}

class _ManualFormState extends State<_ManualForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Một biến cho mỗi ô. Đây là thứ sẽ nhân lên theo số ô.
  String? _nameError;
  String? _emailError;
  String? _ageError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _nameError = validateName(_nameController.text);
      _emailError = validateEmail(_emailController.text);
      _ageError = validateAge(_ageController.text);
    });

    if (_nameError != null || _emailError != null || _ageError != null) return;

    showResult(context, _nameController.text, _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Tên',
            border: const OutlineInputBorder(),
            errorText: _nameError,
          ),
          // Mỗi ô phải tự dọn lỗi của mình. Ba ô là ba khối gần giống hệt nhau.
          onChanged: (_) {
            if (_nameError != null) setState(() => _nameError = null);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            border: const OutlineInputBorder(),
            errorText: _emailError,
          ),
          onChanged: (_) {
            if (_emailError != null) setState(() => _emailError = null);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Tuổi',
            border: const OutlineInputBorder(),
            errorText: _ageError,
          ),
          onChanged: (_) {
            if (_ageError != null) setState(() => _ageError = null);
          },
        ),
        const SizedBox(height: 20),
        FilledButton(onPressed: _submit, child: const Text('Gửi')),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bản dùng Form — cùng luật kiểm tra, không còn biến lỗi nào.
// ---------------------------------------------------------------------------

class _ValidatedForm extends StatefulWidget {
  const _ValidatedForm({super.key});

  @override
  State<_ValidatedForm> createState() => _ValidatedFormState();
}

class _ValidatedFormState extends State<_ValidatedForm> {
  /// Phải là field của `State`. Tạo trong `build` thì mỗi lần vẽ lại sinh một
  /// chìa mới, và `validate()` im lặng không làm gì.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submit() {
    // Một lời gọi chạy hết mọi `validator` bên dưới `Form`.
    if (!_formKey.currentState!.validate()) return;

    showResult(context, _nameController.text, _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
          const SizedBox(height: 12),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Tuổi',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) => validateAge(value ?? ''),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _submit, child: const Text('Gửi')),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Luật kiểm tra dùng chung, để so sánh không bị nhiễu bởi khác biệt về luật.
// ---------------------------------------------------------------------------

String? validateName(String value) =>
    value.trim().isEmpty ? 'Tên không được để trống' : null;

String? validateEmail(String value) {
  final String trimmed = value.trim();
  if (trimmed.isEmpty) return 'Email không được để trống';
  // Cố ý kiểm tra thô. Regex email "đúng chuẩn" dài vài trăm ký tự và vẫn sai;
  // chốt chặn thật nằm ở server.
  if (!trimmed.contains('@') || !trimmed.contains('.')) {
    return 'Email trông không hợp lệ';
  }
  return null;
}

String? validateAge(String value) {
  final String trimmed = value.trim();
  if (trimmed.isEmpty) return 'Tuổi không được để trống';
  final int? age = int.tryParse(trimmed);
  if (age == null) return 'Tuổi phải là số';
  if (age < 1 || age > 120) return 'Tuổi phải nằm trong 1–120';
  return null;
}

void showResult(BuildContext context, String name, String email) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Hợp lệ — $name · $email')));
}
