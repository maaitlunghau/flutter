# M04 — Forms & Input

**Thời lượng:** 3 ngày · **Lab:** `apps/04_forms_lab` · **Capstone:** Login chuyển sang `Form`, và dựng mới màn Register

> **Đây là module trả nợ có chủ ý.** M02 bắt validate bằng tay, M03 giữ nguyên
> như vậy. Giờ mới thay bằng `Form` + `validator` — để bạn so được hai bản cạnh
> nhau và thấy chính xác nó tiết kiệm cái gì, thay vì tin lời.

## Mục tiêu

Học xong module này bạn có thể:

- Gom nhiều ô nhập vào một `Form` và validate **tất cả bằng một lời gọi**
- Nói được vì sao `Form` cần `GlobalKey` — và vì sao chỗ này `GlobalKey` là đúng
  trong khi M02 bảo *"đừng rải bừa"*
- Chọn đúng `autovalidateMode` cho từng ô, và nói được hậu quả khi chọn sai
- Cho bàn phím nhảy từ ô này sang ô kia bằng `FocusNode` và `textInputAction`
- Chữa được cảnh **bàn phím che mất ô đang gõ** — và giải thích vì sao nó xảy ra
- Validate **chéo giữa hai ô** (mật khẩu ↔ xác nhận mật khẩu) và xử lý được ca
  sửa ô thứ nhất sau khi ô thứ hai đã hợp lệ
- Chặn ký tự ngay lúc gõ bằng `TextInputFormatter`

## Khái niệm cốt lõi

- **`Form` không vẽ gì cả.** Nó là một widget vô hình gom các `FormField` con lại
  để gọi `validate()`, `save()`, `reset()` một lượt
- **`GlobalKey<FormState>` là cách duy nhất chạm được vào `FormState` từ ngoài.**
  Đây đúng là ca `GlobalKey` tồn tại vì nó, không phải lạm dụng
- **`validator` trả `String?`** — `null` nghĩa là hợp lệ. Trả chuỗi là hiện lỗi.
  Không `throw`, không trả `bool`
- **`autovalidateMode`** quyết định *khi nào* lỗi hiện ra. Ba lựa chọn, và
  `onUserInteraction` gần như luôn là cái đúng
- **`TextFormField` = `TextField` + `FormField`.** Vẫn dùng `controller` được,
  nhưng giờ có thêm `initialValue`, `validator`, `onSaved`
- **`FocusNode` là tài nguyên có vòng đời** — phải `dispose`, y như
  `TextEditingController` ở M02
- **Bàn phím không che widget, nó thu nhỏ viewport.** Ô nhập bị khuất vì nằm
  ngoài vùng còn lại, không phải vì bị đè lên

## Lab

`apps/04_forms_lab` — Claude viết làm **bản tham chiếu**, bốn màn:

1. **Tay vs `Form`** — cùng một form ba ô, dựng hai lần: bản validate thủ công
   kiểu M02 và bản dùng `Form`. Hiện số dòng code của mỗi bên ngay trên màn.
2. **Ba kiểu `autovalidateMode`** — ba form giống hệt, khác đúng một tham số.
   Gõ vào cả ba để thấy `always` báo lỗi ngay khi chưa gõ chữ nào.
3. **Bàn phím che ô** — một form dài, cố tình để ô cuối bị che, kèm công tắc bật
   tắt cách chữa. Có hiện `MediaQuery.viewInsets.bottom` để thấy con số thật.
4. **Validate chéo** — mật khẩu + xác nhận. Kèm cái bẫy: sửa ô mật khẩu **sau
   khi** ô xác nhận đã hợp lệ thì lỗi không tự hiện lại.

## Tự dựng lại — `apps/practice/lib/m04/`

Bước này **làm đủ**. Mô tả là **hành vi và tiêu chí Xong**, không phải code; chỉ
mở lab khi bí.

> **Chốt 2026-09-22: bỏ hẳn bài `0011` và `0012`.** Người học gọi *"code dùm tui
> practice/lib/m04 cho hoàn chỉnh"*, nên cả 5 màn được viết một lượt kèm doc
> comment giải thích đúng những gì hai bài đó định dạy — vòng đời `FocusNode`,
> `textInputAction` vs `onFieldSubmitted`, bàn phím thu nhỏ viewport chứ không
> che, formatter chặn lúc gõ còn validator chặn sau khi gõ, và thời điểm chạy
> lại `validator` khi validate chéo. Viết lại thành HTML là nói lần thứ hai.
>
> Phần đáng giữ — thứ tra cứu lại được — dồn vào **cheat sheet**
> `docs/reference/forms-va-input.md` lúc đóng module. Một file thay hai bài.
>
> Hệ quả: M04 chỉ có **một** bài giảng (`0010`). Số bài kế tiếp là `0011`, dành
> cho M05. Claude nối route `/m04/...` vào cây route của `practice` khi bạn
có màn, không viết gì thêm.

### Vòng 1 — hai màn

*Bài giảng: `0010` — `Form`, `FormState` và `validator`.*

**Màn 1 — một nút validate cả form**

Ba ô: tên, email, tuổi. Một nút Gửi. Bấm Gửi khi còn ô sai thì mọi ô sai đều
hiện lỗi cùng lúc.

- Tiêu chí: bấm Gửi với cả ba ô trống → **cả ba** hiện lỗi, không phải mỗi ô đầu
- Tiêu chí: email sai định dạng → lỗi riêng cho ô email, hai ô kia vẫn im
- Tiêu chí: tất cả hợp lệ → hiện một `SnackBar` kèm giá trị đã nhập
- Tiêu chí: nói được `_formKey.currentState!.validate()` trả về cái gì và bạn
  dùng giá trị đó làm gì
- Gợi ý duy nhất: `GlobalKey<FormState>` phải là field của `State`, không được
  tạo mới trong `build`

**Màn 2 — lỗi hiện lúc nào**

Cùng một form hai ô, nhưng có ba nút chuyển qua lại giữa `disabled`, `always`,
`onUserInteraction`.

- Tiêu chí: `always` → lỗi hiện **ngay khi mở màn**, chưa gõ gì đã đỏ
- Tiêu chí: `disabled` → không bao giờ tự hiện, chỉ hiện khi bấm nút Gửi
- Tiêu chí: `onUserInteraction` → im cho tới khi người dùng chạm vào ô đó
- Tiêu chí: nói được vì sao `always` là lựa chọn tệ cho màn đăng ký
- Gợi ý duy nhất: đổi `autovalidateMode` thì phải cho `Form` dựng lại

### Vòng 2 — hai màn

*Bài giảng `0011` **đã bỏ** — xem khối quyết định ở đầu mục này.*

**Màn 3 — bàn phím tự đi tiếp**

Form bốn ô xếp dọc. Bàn phím phải nhảy được từ ô này sang ô kế tiếp, và ô cuối
thì nút bàn phím là "xong" chứ không phải "tiếp".

- Tiêu chí: gõ xong ô 1, bấm nút trên bàn phím → con trỏ nhảy sang ô 2, bàn phím
  **không đóng**
- Tiêu chí: ở ô 4, nút bàn phím đổi thành "done"; bấm vào thì submit luôn
- Tiêu chí: thoát màn giữa chừng → không có cảnh báo rò rỉ nào ở console
- Gợi ý duy nhất: mỗi `FocusNode` là một tài nguyên, giống `TextEditingController`

**Màn 4 — bàn phím che ô cuối**

Form dài hơn màn hình. Có một công tắc bật/tắt cách chữa, và hiện số
`MediaQuery.of(context).viewInsets.bottom` theo thời gian thực.

- Tiêu chí: tắt công tắc, chạm ô cuối → ô bị khuất sau bàn phím
- Tiêu chí: bật công tắc, chạm ô cuối → ô tự trượt lên trên bàn phím
- Tiêu chí: con số `viewInsets.bottom` là **0** khi bàn phím đóng và > 0 khi mở
- Tiêu chí: nói được vì sao gọi đây là "thu nhỏ viewport" chứ không phải "che"
- Gợi ý duy nhất: có hai thứ phải cùng đúng — `Scaffold` và widget cuộn

### Vòng 3 — một màn

*Bài giảng `0012` **đã bỏ** — xem khối quyết định ở đầu mục này.*

**Màn 5 — hai ô phải khớp nhau**

Ô mật khẩu + ô xác nhận mật khẩu. Kèm một nút Gửi.

- Tiêu chí: hai ô khác nhau → ô xác nhận báo lỗi
- Tiêu chí: **cái bẫy** — gõ khớp cho cả hai, rồi quay lại sửa ô mật khẩu. Ô xác
  nhận phải báo lỗi lại. Nói được vì sao mặc định nó **không** báo
- Tiêu chí: mật khẩu ngắn hơn 8 ký tự → lỗi riêng, không lẫn với lỗi không khớp
- Gợi ý duy nhất: `validator` của ô này đọc được giá trị ô kia — câu hỏi là
  *khi nào* nó được gọi lại

## Chia vòng

3 ngày, 3 vòng học:

| Vòng | Nội dung | Ra cái gì |
|---|---|---|
| 1 | `Form`, `GlobalKey<FormState>`, `validator`, `autovalidateMode` | bài `0010` + lab màn 1-2 + practice màn 1-2 + **capstone: Login chuyển sang `Form`** |
| 2 | `FocusNode`, `textInputAction`, bàn phím, `TextInputFormatter` | ~~bài `0011`~~ (bỏ) + lab màn 3 + practice màn 3-4 |
| 3 | Validate chéo, luồng submit | ~~bài `0012`~~ (bỏ) + lab màn 4 + practice màn 5 + **capstone: màn Register** |

## Capstone task

**Vòng 1 — thay ruột `login_screen.dart`:**

- Bọc bằng `Form`, đổi `TextField` → `TextFormField`, chuyển logic kiểm tra rỗng
  trong `_submit()` thành `validator`
- Xoá `_emailError` / `_passwordError` và mấy chỗ `setState` dọn lỗi thủ công
- Giữ nguyên hành vi bên ngoài: nút con mắt, gọi `authState.logIn()`, không đụng
  vào `app_router.dart`
- **So số dòng trước/sau** — đó là câu trả lời cho câu hỏi M02 để ngỏ

> **Chốt 2026-09-22: giữ `TextEditingController`, không chuyển sang `onSaved`.**
> `onSaved` chỉ chạy khi gọi `save()`, tức là **sau** khi validate xong — quá
> muộn cho việc validate chéo ở Register, nơi `validator` của ô xác nhận phải
> đọc được giá trị ô mật khẩu *ngay lúc đang validate*. M05 gọi API cũng cần
> giá trị ngay trong tay. `onSaved` sẽ nhắc tới trong bài giảng để biết mặt,
> không dùng trong capstone.

**Vòng 3 — dựng mới màn Register:**

- Route `/register`, thêm vào cây route M03. Có đường đi từ Login sang
- Bốn ô: tên, email, mật khẩu, xác nhận mật khẩu
- Validate chéo: hai ô mật khẩu phải khớp
- Bàn phím nhảy được giữa các ô; ô cuối submit
- Đăng ký thành công → `authState.logIn()` → `redirect` tự đưa vào `/users`
- `/register` phải **vào được khi chưa đăng nhập** — nếu không thì không ai đăng
  ký được. Đây là chỗ phải sửa `redirect` của M03

**Cố ý chưa làm ở module này:**

| Thứ | Để dành cho |
|---|---|
| Gọi API thật để đăng ký | M05 |
| Trạng thái "đang gửi", khoá nút | M05 |
| Auth state tách khỏi widget | M06 → M07 |
| Nhớ phiên sau khi tắt app | M09 |

## Tiêu chí Xong

- [ ] `login_screen.dart` dùng `Form` + `validator`, không còn biến lỗi thủ công
- [ ] Bấm Đăng nhập khi cả hai ô trống → **cả hai** hiện lỗi cùng lúc
- [ ] Có `/register`, vào được **khi chưa đăng nhập**, và có đường đi từ Login
- [ ] Register: hai ô mật khẩu khác nhau → báo lỗi; sửa ô đầu sau khi ô sau đã
      hợp lệ → **vẫn báo lỗi lại**
- [ ] Bàn phím nhảy được qua hết các ô của Register; ô cuối submit
- [ ] Không ô nào bị bàn phím che, kể cả khi xoay ngang
- [ ] Đăng ký thành công → vào thẳng `/users`
- [ ] Mọi `FocusNode` và `TextEditingController` đều được `dispose`
- [ ] Giải thích được bằng lời: vì sao `Form` cần `GlobalKey`
- [ ] Giải thích được bằng lời: `autovalidateMode` nào cho màn nào, vì sao
- [ ] `flutter analyze` ở root báo `No issues found!`

## Bẫy thường gặp

*(để trống — điền dần khi thật sự vấp phải)*

## Nguồn

- Flutter — Build a form with validation:
  https://docs.flutter.dev/cookbook/forms/validation
- Flutter — `Form` class:
  https://api.flutter.dev/flutter/widgets/Form-class.html
- Flutter — `FormState` class:
  https://api.flutter.dev/flutter/widgets/FormState-class.html
- Flutter — `FocusNode` class:
  https://api.flutter.dev/flutter/widgets/FocusNode-class.html
- Flutter — Focus and text fields:
  https://docs.flutter.dev/get-started/fundamentals/user-input
