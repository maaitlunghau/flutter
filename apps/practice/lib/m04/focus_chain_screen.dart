import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'validators.dart';

/// Màn 3 — bàn phím tự đi tiếp.
///
/// Hai thứ khác nhau hay bị gộp làm một:
/// - `textInputAction` đổi **hình dạng** phím dưới cùng bên phải bàn phím
/// - `onFieldSubmitted` quyết định **bấm vào đó thì làm gì**
///
/// Đặt `TextInputAction.next` mà không chuyển focus thì phím hiện mũi tên nhưng
/// bấm vào chẳng đi đâu cả.
class FocusChainScreen extends StatefulWidget {
  const FocusChainScreen({super.key});

  @override
  State<FocusChainScreen> createState() => _FocusChainScreenState();
}

class _FocusChainScreenState extends State<FocusChainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  /// `FocusNode` là tài nguyên có vòng đời, y như `TextEditingController` ở
  /// M02 — quên `dispose` là rò rỉ thật, không phải cảnh báo suông.
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Vẽ lại để cái bảng bên dưới chỉ đúng ô đang có con trỏ.
    for (final FocusNode node in _nodes) {
      node.addListener(_onFocusChanged);
    }
  }

  List<FocusNode> get _nodes => <FocusNode>[
    _nameFocus,
    _emailFocus,
    _phoneFocus,
    _noteFocus,
  ];

  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    for (final FocusNode node in _nodes) {
      node.removeListener(_onFocusChanged);
      node.dispose();
    }
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    // Đóng bàn phím trước khi hiện SnackBar, không thì nó bị che mất.
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Hợp lệ')));
  }

  String get _focusedLabel {
    if (_nameFocus.hasFocus) return 'Tên';
    if (_emailFocus.hasFocus) return 'Email';
    if (_phoneFocus.hasFocus) return 'Điện thoại';
    if (_noteFocus.hasFocus) return 'Ghi chú';
    return 'không ô nào';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Bàn phím đi tiếp')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Con trỏ đang ở: $_focusedLabel',
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              focusNode: _nameFocus,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) => requiredText(value, 'Tên'),
              onFieldSubmitted: (_) => _emailFocus.requestFocus(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: validateEmail,
              onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              // `inputFormatters` chặn **ngay lúc gõ**, trước cả khi ký tự lọt
              // vào ô. Khác hẳn `validator` — thứ chỉ lên tiếng sau khi người
              // dùng đã gõ xong. Hai tầng, hai thời điểm.
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              decoration: const InputDecoration(
                labelText: 'Điện thoại',
                helperText: 'Thử gõ chữ cái — bàn phím sẽ không nhận',
                border: OutlineInputBorder(),
              ),
              validator: validatePhone,
              onFieldSubmitted: (_) => _noteFocus.requestFocus(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              focusNode: _noteFocus,
              // Ô cuối: phím đổi thành "done" và bấm vào thì gửi luôn.
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) => requiredText(value, 'Ghi chú'),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: const Text('Gửi')),
          ],
        ),
      ),
    );
  }
}
