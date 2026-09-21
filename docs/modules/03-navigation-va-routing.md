# M03 — Navigation & Routing

**Thời lượng:** 3 ngày · **Lab:** `apps/03_navigation_lab` · **Capstone:** route tree `userhub` — Splash → Login → Home → User detail

> **Nợ mang sang từ M01 và M02:** màn **User list**. Hai module trước đều hoãn vì
> chưa có đường đi tới nó. M03 có điều hướng rồi thì dựng luôn — nó là nơi màn
> User detail được mở ra từ.

## Mục tiêu

Học xong module này bạn có thể:

- Đẩy và gỡ màn bằng `Navigator`, **truyền dữ liệu đi** và **nhận kết quả trả về**
- Nói được stack màn hình đang có gì ở thời điểm bất kỳ, và vì sao nút Back của
  Android đôi khi thoát app thay vì lùi một màn
- Chặn thao tác rời màn bằng `PopScope` khi người dùng còn dữ liệu chưa lưu
- Dựng một **route tree khai báo** bằng `go_router`: path param, route lồng nhau,
  màn 404
- Viết `redirect` làm **auth guard** — chưa đăng nhập thì mọi đường đều đổ về Login
- Mở đúng một màn sâu trong app từ **một cái link bên ngoài**, và chứng minh được
  bằng lệnh `adb`

## Khái niệm cốt lõi

- **Navigator là một cái stack.** `push` chồng lên, `pop` bóc ra. Mọi thứ khác
  chỉ là cách nói khác của hai việc này
- `Navigator.push` trả về một **`Future`** — nó hoàn thành khi màn kia `pop`, và
  giá trị truyền vào `pop` chính là kết quả. Đây là cách một màn "trả lời" màn gọi nó
- **Route có tên** (`onGenerateRoute`) gỡ được chuyện import chéo giữa các màn,
  nhưng vẫn không mô tả được cấu trúc — nó chỉ là một cái `switch`
- **`go_router` đảo chiều bài toán:** thay vì ra lệnh "đẩy màn này lên", bạn
  **khai báo** cây đường đi, rồi nói "tôi muốn ở địa chỉ này". Stack do router tự suy ra
- **`redirect` chạy trước mọi lần điều hướng** — đó là chỗ duy nhất nên đặt auth
  guard, không phải rải `if` trong `build` của từng màn
- **`go` khác `push`.** `go` thay thế cả nhánh theo địa chỉ mới; `push` chồng thêm.
  Nhầm hai cái này là nguồn của "bấm Back ra màn lạ"
- **Deep link không phải tính năng của Flutter** — nó là `intent-filter` trong
  `AndroidManifest.xml` của Android. Flutter chỉ nhận cái URI mà hệ điều hành đưa vào

## Lab

`apps/03_navigation_lab` — Claude viết làm **bản tham chiếu**, bốn màn:

1. **Stack Visualizer** — hiện danh sách các màn đang nằm trong `Navigator`, cập
   nhật theo thời gian thực. Có nút `push`, `pop`, `pushReplacement`,
   `pushAndRemoveUntil` để nhìn thấy cái stack biến dạng theo từng lệnh.
2. **Trả kết quả về** — màn A mở màn B để chọn một giá trị; B `pop` kèm giá trị;
   A `await` và hiện lên. Kèm nhánh người dùng bấm Back — kết quả là `null`.
3. **Chặn rời màn** — form có dữ liệu chưa lưu, dùng `PopScope` để hỏi lại trước
   khi thoát.
4. **Route tree bằng `go_router`** — `/`, `/users`, `/users/:id`, một route lồng,
   một màn 404, và một `redirect` giả lập auth guard bật/tắt được bằng công tắc.

Deep link được cấu hình trong `android/app/src/main/AndroidManifest.xml` của lab
và kiểm chứng bằng `adb`, không phải bằng cách bấm trong app.

## Tự dựng lại — `apps/practice/lib/m03/`

Bước này **làm đủ**. Mô tả là **hành vi và tiêu chí Xong**, không phải code; chỉ
mở lab khi bí.

### Vòng 1 — hai màn

*Bài giảng: `0007` — Navigator là một cái stack.*

**Màn 1 — nhìn thấy cái stack**

Một màn hiện **độ sâu hiện tại** của stack và một hàng nút: `push`,
`pushReplacement`, `pop`. Mỗi màn được đẩy lên phải hiện số thứ tự của chính nó.

- Tiêu chí: `push` ba lần → màn thứ tư ghi "màn số 4"; bấm Back ba lần về được màn gốc
- Tiêu chí: `pushReplacement` ở màn số 3 → độ sâu **không tăng**, và bấm Back từ
  đó về thẳng màn số 2, không thấy lại màn số 3
- Tiêu chí: ở màn gốc, nút `pop` bấm không có tác dụng gì. Nói được vì sao
- Gợi ý duy nhất: `Navigator.canPop(context)` cho biết còn gì để bóc không

**Màn 2 — hỏi và nhận câu trả lời**

Màn chính hiện một giá trị đang chọn (mặc định "chưa chọn"). Bấm vào mở màn danh
sách; chọn một mục thì quay về và giá trị hiện lên.

- Tiêu chí: chọn một mục → quay về, giá trị hiện đúng
- Tiêu chí: **bấm Back** thay vì chọn → giá trị cũ giữ nguyên, không bị xoá thành rỗng
- Tiêu chí: chỉ ra được kiểu dữ liệu của cái `Navigator.push` trả về, và vì sao
  nó phải nullable
- Gợi ý duy nhất: hàm gọi `push` phải là `async`

### Vòng 2 — hai màn

*Bài giảng: `0008` — Route tree khai báo với `go_router`.*

**Màn 3 — cây đường đi**

Dựng lại ba màn trên bằng `go_router` thay vì `Navigator`: một danh sách ở
`/m03/items`, một màn chi tiết ở `/m03/items/:id`, và một màn 404 cho đường không tồn tại.

- Tiêu chí: gõ thẳng một `id` không tồn tại vào đường dẫn → ra màn 404, app không crash
- Tiêu chí: vào chi tiết bằng `go` → bấm Back quay về danh sách, **không** thoát app
- Tiêu chí: nói được `id` đi từ đường dẫn vào màn chi tiết qua đâu
- Gợi ý duy nhất: `errorBuilder` là chỗ dựng màn 404

**Màn 4 — cửa có khoá**

Thêm một công tắc "đã đăng nhập" (một biến trong bộ nhớ, chưa cần lưu gì) và một
`redirect` dùng nó.

- Tiêu chí: tắt công tắc → mọi đường trong `/m03/...` đều đổ về màn khoá
- Tiêu chí: bật công tắc → quay lại được **đúng màn đang định vào**, không phải
  luôn luôn về trang chủ
- Tiêu chí: `redirect` **không** rơi vào vòng lặp vô hạn. Nói được điều kiện nào
  chặn vòng lặp đó
- Gợi ý duy nhất: `redirect` trả `null` nghĩa là "cứ đi tiếp"

### Vòng 3 — một màn

*Bài giảng: `0009` — Deep link: hệ điều hành gõ cửa app.*

**Màn 5 — mở từ bên ngoài**

App mở thẳng vào một màn chi tiết khi nhận link từ ngoài.

- Tiêu chí: app **đang đóng** → chạy lệnh `adb` với link chứa `id` → app mở
  đúng màn chi tiết của `id` đó
- Tiêu chí: app **đang chạy ở màn khác** → cũng nhảy đúng màn đó
- Tiêu chí: từ màn vừa deep link vào, bấm Back **không** thoát thẳng ra ngoài mà
  về được danh sách. Nói được vì sao stack lại có màn danh sách trong đó
- Bằng chứng nằm ở lệnh `adb`, không phải ở nút bấm trong app

## Chia vòng

3 ngày, 3 vòng học:

| Vòng | Nội dung | Ra cái gì |
|---|---|---|
| 1 | `Navigator` — stack, truyền & trả dữ liệu, `PopScope` | bài `0007` + lab màn 1-3 + practice màn 1-2 |
| 2 | `go_router` — route tree, path param, `redirect` làm auth guard | bài `0008` + lab màn 4 + practice màn 3-4 + **capstone route tree** |
| 3 | Deep link Android + đóng module | bài `0009` + deep link ở lab + practice màn 5 + **capstone User list & detail** |

## Capstone task

Trong `apps/userhub/`, thay `home: const LoginScreen()` bằng một **route tree
thật** và trả nốt món nợ User list.

**Vòng 2 — dựng route tree:**

- `/splash` → `/login` → `/home`, chuyển bằng `go_router`
- Splash đứng ~1 giây rồi tự quyết định đi Login hay Home
- `redirect` làm auth guard: chưa đăng nhập thì mọi đường đều về `/login`
- Đăng nhập thành công (kiểm tra rỗng bằng tay như M02, **chưa gọi API**) → vào `/home`
- Ở `/home` có nút Đăng xuất → về `/login`, và **bấm Back không quay lại được `/home`**

**Vòng 3 — User list & detail + deep link:**

- `/home` hiện danh sách user, **data hardcode** — đây là món nợ của M01
- Bấm một user → `/users/:id`, màn detail đọc `id` từ đường dẫn
- Deep link `userhub:///users/7` mở thẳng màn detail, kiểm chứng bằng `adb`

**Cố ý chưa làm ở module này:**

| Thứ | Để dành cho |
|---|---|
| `Form` / `TextFormField` / `validator` | M04 |
| Gọi API thật, JWT | M05 |
| Auth state tách khỏi widget | M06 → M07 |
| Nhớ phiên đăng nhập sau khi tắt app | M09 |

Cờ "đã đăng nhập" ở module này là **một biến trong bộ nhớ**. Tắt app là mất. Đó
là chủ ý — cùng logic với "validate bằng tay ở M02".

## Tiêu chí Xong

- [ ] `userhub` mở ra là Splash, không phải Login
- [ ] Chưa đăng nhập, ép vào `/home` → bị đẩy về `/login`
- [ ] Đăng nhập → `/home`; Đăng xuất → `/login` và Back **không** quay lại `/home`
- [ ] `/home` có danh sách user hardcode, bấm vào ra `/users/:id` đúng người
- [ ] `adb shell am start -a android.intent.action.VIEW -d "userhub:///users/7"`
      mở đúng màn detail của user 7, cả khi app đang đóng lẫn đang chạy
      (**ba** dấu gạch — xem bẫy 6)
- [ ] Đường dẫn không tồn tại → màn 404, app không crash
- [ ] Giải thích được bằng lời: `go` khác `push` chỗ nào, và khi nào dùng cái nào
- [ ] Giải thích được bằng lời: vì sao auth guard đặt ở `redirect` chứ không phải
      trong `build` của từng màn
- [ ] `flutter analyze` ở root báo `No issues found!`

## Bẫy thường gặp

**`adb` không nằm trong `PATH`.** Vòng 3 kiểm chứng deep link bằng `adb`, nhưng
gõ thẳng `adb` thì shell báo `command not found` — Flutter gọi nó bằng đường dẫn
tuyệt đối nên không bao giờ lộ ra chuyện này. Máy đang để ở:

```bash
~/Library/Android/sdk/platform-tools/adb
```

Thêm vào `PATH` trong `~/.zshrc`, hoặc gõ nguyên đường dẫn. Đã xác minh
2026-09-21 khi cài lab lên emulator.

**6. Deep link hai dấu gạch thì host nuốt mất đoạn đầu đường dẫn.**

`scheme://users/3` phân tích ra `host = users`, `path = /3` — và `go_router`
khớp route theo **path**, nên nó đi tìm route tên `/3`, không thấy, rơi vào
`errorBuilder`. Màn 404 hiện ra dù cấu hình manifest đúng hết.

```bash
ADB=~/Library/Android/sdk/platform-tools/adb
$ADB shell am start -a android.intent.action.VIEW -d "navlab://users/3"   # → 404
$ADB shell am start -a android.intent.action.VIEW -d "navlab:///users/3"  # → đúng màn
```

**Ba** dấu gạch nghĩa là host rỗng, nhờ vậy cả `/users/3` nằm trọn trong path.
Đã xác minh trên `apps/03_navigation_lab` ngày 2026-09-21, cả hai dạng, cả cold
start lẫn warm start. Chi tiết: [bài 0009](../lessons/0009-deep-link-he-dieu-hanh-go-cua-app.html).

**7. Thiếu `flutter_deeplinking_enabled` thì hỏng âm thầm.**

App **vẫn mở** khi nhận link, nên rất dễ tưởng đã xong — nhưng URI không tới
được `Router` và bạn thấy màn ở `initialLocation` y như vừa bấm icon. Không lỗi,
không cảnh báo. Cờ này đặt trong thẻ `<activity>` của `AndroidManifest.xml`.

## Nguồn

- Flutter — Navigation and routing (trang tổng):
  https://docs.flutter.dev/ui/navigation
- Flutter — `Navigator` class:
  https://api.flutter.dev/flutter/widgets/Navigator-class.html
- Flutter — `PopScope` class:
  https://api.flutter.dev/flutter/widgets/PopScope-class.html
- Flutter — Deep linking:
  https://docs.flutter.dev/ui/navigation/deep-linking
- `go_router` package (do đội Flutter duy trì):
  https://pub.dev/packages/go_router
