# Cheat sheet — Forms & Input (M04)

> Thay cho hai bài giảng `0011` và `0012` đã bỏ. Chỉ chứa thứ **không suy ra
> được từ code** — chỗ nào đọc code là hiểu thì không chép lại vào đây.
>
> Code tham chiếu: `apps/04_forms_lab/lib/` · `apps/practice/lib/m04/` ·
> `apps/userhub/lib/login_screen.dart` và `register_screen.dart`.

---

## Ba thứ phải có

```dart
final _formKey = GlobalKey<FormState>();   // field của State, KHÔNG tạo trong build

Form(
  key: _formKey,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  child: TextFormField(
    controller: _emailController,
    validator: (value) => value!.isEmpty ? 'Email is required' : null,
  ),
)

if (_formKey.currentState!.validate()) { /* mọi ô đều sạch */ }
```

**`validator` trả `String?`** — `null` là hợp lệ. Không `throw`, không trả `bool`.

**Tạo `_formKey` trong `build` thì `validate()` im lặng không làm gì** — không lỗi,
không log, không crash. Chìa mới không trỏ vào `FormState` nào. Đây là lỗi tốn
thời gian nhất của module này.

---

## `autovalidateMode` — lỗi hiện lúc nào

Flutter 3.47 có **năm** giá trị, không phải ba. Viết `switch` thiếu nhánh là
analyzer của repo báo lỗi.

| Giá trị | Lỗi hiện khi | Dùng cho |
|---|---|---|
| `disabled` | chỉ khi gọi `validate()` | mặc định; form ngắn một nút gửi |
| `onUserInteraction` | sau khi chạm vào **ô đó** | **gần như luôn đúng** cho form dài |
| `always` | ngay khi mở màn | hiếm; màn sửa dữ liệu có sẵn |
| `onUnfocus` | khi con trỏ rời ô | ô cần gõ xong mới kiểm được |
| `onUserInteractionIfError` | sau khi ô đã **từng sai** | im lặng với người gõ đúng ngay |

`always` ở màn đăng ký = bốn dòng đỏ trước khi người dùng gõ ký tự nào.

---

## `GlobalKey` — ba tầng, ba mục đích

| Chìa | Phạm vi | Dùng để |
|---|---|---|
| `GlobalKey<FormState>` | cả form | `validate()` · `save()` · `reset()` một lượt |
| `GlobalKey<FormFieldState<String>>` | **một ô** | đánh thức đúng một ô, không bôi đỏ ô khác |
| `ValueKey` | ghép `State` | không liên quan form — xem bài `0006` |

M02 bảo *"đừng rải `GlobalKey` bừa"*. Hai cái đầu là ca `GlobalKey` **sinh ra vì
nó**: `FormState` nằm trong widget `Form`, nút Gửi nằm chỗ khác, và không có
đường nào khác để chạm tới.

---

## Validate chéo — cái bẫy đắt nhất

**Flutter chỉ chạy lại `validator` của ô vừa đổi.**

Hệ quả: gõ khớp cả hai ô mật khẩu → quay lại sửa ô thứ nhất → ô xác nhận
**không biết gì**, vẫn xanh, và form nói "hợp lệ" trong khi hai mật khẩu đã khác nhau.

```dart
// ô Password
onChanged: (_) => _confirmKey.currentState?.validate(),

// ô Confirm
key: _confirmKey,
validator: (value) => validateConfirmPassword(value, _passwordController.text),
```

**Vì sao chìa riêng cho một ô, không gọi `_formKey.currentState!.validate()`?**
Cái đó cũng chữa được, nhưng nó validate **cả form** — người dùng mới gõ ô mật
khẩu mà ô Tên và Email đã bị bôi đỏ dù chưa chạm tới.

**Quan hệ một chiều.** Sửa ô Confirm không cần đánh thức ô Password, vì
`validator` của Password không phụ thuộc Confirm.

---

## Bàn phím **không** che widget

Nó báo `MediaQuery.viewInsets.bottom > 0`, và `Scaffold` **thu nhỏ vùng vẽ** lại
cho vừa. Ô nhập biến mất vì nằm ngoài vùng còn lại, không phải vì bị đè lên.

Hai thứ phải **cùng** đúng thì ô mới tự trượt lên:

1. `Scaffold.resizeToAvoidBottomInset: true` — mặc định đã bật
2. thân màn **cuộn được** (`ListView`, `SingleChildScrollView`)

Thiếu vế 2 là ca hay gặp hơn: `Column` trần thì không có chỗ nào để kéo ô vào tầm nhìn.

---

## `textInputAction` vs `onFieldSubmitted`

Hai thứ khác nhau, hay bị gộp làm một:

| | Việc |
|---|---|
| `textInputAction` | đổi **hình dạng** phím góc phải bàn phím (`→\|` / `✓`) |
| `onFieldSubmitted` | quyết định **bấm vào đó thì làm gì** |

Đặt `TextInputAction.next` mà không chuyển focus → phím hiện mũi tên nhưng bấm
vào chẳng đi đâu.

```dart
textInputAction: TextInputAction.next,
onFieldSubmitted: (_) => _emailFocus.requestFocus(),
```

Ô cuối: `TextInputAction.done` + `onFieldSubmitted: (_) => _submit()`.

**`FocusNode` là tài nguyên có vòng đời** — phải `dispose`, y như
`TextEditingController`.

---

## `TextInputFormatter` vs `validator` — hai tầng, hai thời điểm

| | Chặn khi |
|---|---|
| `inputFormatters` | **ngay lúc gõ**, ký tự không lọt được vào ô |
| `validator` | **sau khi gõ xong**, lên tiếng bằng chữ đỏ |

```dart
inputFormatters: <TextInputFormatter>[
  FilteringTextInputFormatter.digitsOnly,
  LengthLimitingTextInputFormatter(11),
],
```

Formatter hợp với ràng buộc **hiển nhiên** (số điện thoại chỉ có số). Ràng buộc
cần giải thích (email sai định dạng) thì phải là `validator` — chặn im lặng mà
không nói vì sao là cách nhanh nhất làm người dùng bực.

---

## `controller` vs `onSaved`

Repo này **giữ `controller`**. `onSaved` chỉ chạy khi gọi `save()`, tức là **sau**
khi validate xong — quá muộn cho validate chéo, nơi `validator` cần đọc giá trị ô
khác *ngay lúc đang validate*. M05 gọi API cũng cần giá trị ngay trong tay.

---

## Vài chi tiết dễ vấp

- **`FormState.reset()` không đụng `controller`.** Nó xoá lỗi và đưa về
  `initialValue`, nhưng chữ đã gõ vẫn còn. Muốn sạch thì phải `clear()` từng
  controller.
- **Đổi `autovalidateMode` thì phải cho `Form` dựng lại.** Không có `Key` thì
  Flutter ghép `State` theo vị trí, ô giữ nguyên chữ và cả vết "đã chạm vào".
- **`FocusScope.of(context).unfocus()` trước khi hiện `SnackBar`** — không thì
  bàn phím che mất nó.
- **Thêm một ô: `Form` sửa 1 chỗ, làm tay sửa 3** (biến lỗi · dòng trong
  `_submit` · `onChanged` dọn lỗi).

---

## Nguồn

- [Flutter cookbook — Build a form with validation](https://docs.flutter.dev/cookbook/forms/validation)
- [Flutter API — Form](https://api.flutter.dev/flutter/widgets/Form-class.html)
- [Flutter API — FormState](https://api.flutter.dev/flutter/widgets/FormState-class.html)
- [Flutter API — FocusNode](https://api.flutter.dev/flutter/widgets/FocusNode-class.html)
- [Flutter — User input fundamentals](https://docs.flutter.dev/get-started/fundamentals/user-input)
