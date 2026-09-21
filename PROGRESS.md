# Tiến độ

> Claude: đọc file này **trước** khi bắt đầu bất kỳ module nào,
> và cập nhật nó **sau** khi kết thúc mỗi vòng học.

## Đang ở đâu

- **Module hiện tại:** M05 — Async & tầng dữ liệu *(chưa bắt đầu)*
- **Vòng:** M04 đóng 2026-09-22, 1 bài giảng + lab + practice + capstone
- **Cập nhật lần cuối:** 2026-09-22

## Việc tiếp theo

**M04 xong ngày 2026-09-22.** Sản phẩm:
[bài 0010](docs/lessons/0010-form-formstate-va-validator.html) ·
[cheat sheet Forms & Input](docs/reference/forms-va-input.md) ·
lab `apps/04_forms_lab` 2 màn · `apps/practice/lib/m04/` 5 màn ·
**capstone**: `login_screen.dart` chuyển sang `Form`, và màn Register mới.

**Tiếp theo — M05 Async & tầng dữ liệu, 5 ngày.**

- [ ] Đề bài `docs/modules/05-*.md` — chưa viết
- [ ] Lab `apps/05_api_lab` — chưa tạo
- [ ] Capstone: nối thật vào Spring API — login → JWT → `GET /users`

> **Hết chặn — đã có spec API** ngày 2026-09-22:
> [`docs/reference/backend-api.md`](docs/reference/backend-api.md), đối chiếu
> backend commit `a873614` branch `feature/user-management`.

**Nhưng spec bẻ lại hình dạng M05.** Roadmap ghi capstone là *"login → JWT →
GET /users"*. Backend **chưa có endpoint auth nào** — không `/api/auth/login`,
không register, không refresh; `SecurityConfig` đang `permitAll()`.

Hai quyết định chốt 2026-09-22:

- **M05 vẫn làm đủ, phần auth thì fake.** Dựng `AuthRepository` và interceptor
  gắn `Authorization` đầy đủ, nhưng token do client tự sinh. Khi backend có auth
  thật thì chỉ đổi một hàm. Nửa đọc dữ liệu (`GET /api/users`) là thật 100%.
- **Màn Register giữ fake, không nối vào `POST /api/users`.** Spec tự cảnh báo
  endpoint đó bắt client gửi `role` nên **về nghiệp vụ là admin-only** — nối vào
  màn tự đăng ký công khai là dạy một thói quen sai. Chờ `/api/auth/register`.

### Spec làm lộ ra một chỗ phải sửa trong `userhub`

**`id` của backend là UUID chuỗi**, `userhub` đang dùng `int`:

| Chỗ | Hiện tại | Phải thành |
|---|---|---|
| `fake_users.dart` | `final int id` · `findUserById(int)` | `String` |
| `user_detail_screen.dart` | `int.tryParse(userId)` | bỏ hẳn |
| Deep link | `userhub:///users/7` | `userhub:///users/<uuid>` |
| Tiêu chí Xong M03 | `users/7` | phải viết lại |

May là `UserDetailScreen` đã nhận `String` thô ngay từ M03 — chỉ bỏ `int.tryParse`
là xong, không phải sửa kiến trúc. Kèm theo: `name` → `fullName`, và thêm
`enabled`, `imageUrl`, `emailVerified`…

**M08 cũng bị ảnh hưởng:** "refresh-token interceptor" là một trong bốn việc
chính của module đó, và nó cũng chờ backend Auth.

Chạy bằng `/flutter-module 05`.

### M04 — những gì đáng nhớ

**Bỏ hẳn bài `0011` và `0012`** (quyết 2026-09-22). Người học gọi *"code dùm tui
practice/lib/m04 cho hoàn chỉnh"*, nên cả 5 màn được viết một lượt kèm doc comment
giải thích đúng thứ hai bài đó định dạy. Phần tra cứu lại được dồn vào **cheat
sheet** — một file thay hai bài. Hệ quả: số bài kế tiếp là `0011`, dành cho M05.

**Chỗ auth guard của M03 bị thực tế bẻ.** `/register` phải vào được khi **chưa**
đăng nhập, nhưng `redirect` chia thế giới làm hai: `/login` và tất cả phần còn
lại. Cách chữa không phải thêm một `if` mà là đặt tên khái niệm:

```dart
final bool isPublic = location == '/login' || location == '/register';
```

Và **cả hai** vế phải đổi theo — quên vế `loggedIn && isPublic` thì người đã đăng
nhập vào `/register` vẫn thấy form đăng ký lần nữa.

**Validate chéo cần chìa riêng cho một ô.** Flutter chỉ chạy lại `validator` của
ô vừa đổi, nên sửa ô mật khẩu sau khi ô xác nhận đã hợp lệ thì form nói "hợp lệ"
trong khi hai mật khẩu đã khác nhau. Dùng `GlobalKey<FormFieldState<String>>` cho
riêng ô xác nhận, không dùng `_formKey.currentState!.validate()` — cái đó bôi đỏ
cả những ô người dùng chưa chạm tới.

### M03 — tóm tắt

Đóng 2026-09-21, đủ 3 vòng + capstone + review, rồi sửa 5 việc từ review ngày
2026-09-22 (`61a3413` → `51e8706`). Nợ **User list** mang từ M01 đã trả xong.
Chi tiết ở `docs/modules/03-navigation-va-routing.md`.

Bài học đắt nhất: bộ lọc `?from=` **làm hỏng deep link**. Khi deep link mở app từ
trạng thái đóng, `state.uri` là URI **đầy đủ có scheme** (`userhub:///users/7`),
không phải `/users/7`. `flutter analyze` sạch suốt; chỉ chạy lại `adb` mới phát
hiện. Cách chữa là **chuẩn hoá lúc ghi** (chỉ giữ path + query), không phải nới
bộ lọc.

Hai bẫy deep link khác: phải viết **ba** dấu gạch `scheme:///users/3`, và thiếu
meta-data `flutter_deeplinking_enabled` thì deep link **im lặng không chạy**.

### Ba việc cố ý hoãn — vẫn còn treo

Không phải quên; sửa bây giờ sẽ lấy mất bài học của module sau:

- **Hai biến toàn cục `authState` và `appRouter`** → M06 (`InheritedWidget` viết
  tay) + M07 (Riverpod). Thêm: `appRouter` dựng lúc load file nên **không test
  được** → ghi nhớ khi tới M14.
- **Splash cứng 1 giây** → M09, khi có token dưới đĩa để đọc.
- **Nút Đăng nhập / Đăng ký không có trạng thái "đang xử lý"** → M05, khi có
  `await` thật thì mới có cái để khoá.

### Hai chỗ đang lệch nhau

- **`userhub` không mang comment nào**, trong khi `CLAUDE.md` ghi *"comment tiếng
  Việt ở mọi nơi, kể cả `userhub`"*. Chưa quyết sửa bên nào.
- **Chuỗi UI trong `userhub` dùng tiếng Anh**, còn `practice` và các lab dùng
  tiếng Việt. Cố ý — quyết 2026-09-22.

**Có thể làm lệch thứ tự:** lab `apps/12_firebase_lab` độc lập với `userhub`, nên
khi trên lớp dạy tới Firebase thì làm nửa lab của M12 luôn. Chỉ nửa capstone mới
bắt buộc đứng sau M09. Xem
[roadmap, mục M12](docs/roadmap.md#m12--firebase-bổ-sung-không-thay-thế).

## Trạng thái các module

| # | Module | Trạng thái |
|---|---|---|
| 00 | Khởi động & công cụ | ✅ |
| 01 | Widget & Layout | ✅ |
| 02 | Stateful & vòng đời | ✅ |
| 03 | Navigation & Routing | ✅ |
| 04 | Forms & Input | ✅ |
| 05 | Async & tầng dữ liệu | ⬜ |
| 06 | State nền tảng | ⬜ |
| 07 | Riverpod | ⬜ |
| 08 | Kiến trúc ứng dụng | ⬜ |
| 09 | Lưu trữ & offline | ⬜ |
| 10 | Polish & UX | ⬜ |
| 11 | Hiệu năng & debug | ⬜ |
| 12 | Firebase | ⬜ |
| 13 | Release | ⬜ |
| 14 | Testing & CI (tuỳ chọn) | ⬜ |

## Hạ tầng đã dựng

- [x] `apps/practice` — sân tập của người học, một app dùng chung 15 module
- [x] `.gitignore` + hook `commit-msg` + hook `pre-commit`
- [x] Pub workspace ở root + `apps/00_hello_flutter`
- [x] `analysis_options.yaml` dùng chung
- [x] Docs khung: README · CLAUDE.md · MISSION.md · roadmap.md
- [x] Skill `/flutter-module`
- [x] `apps/userhub` — đã khởi tạo, `applicationId com.maaitlunghau.userhub`
- [x] `.env.example` + đề bài M00
- [x] Emulator `pixel_dev` + `userhub` chạy được trên Android

## Nợ kỹ thuật đang treo

- **Chưa có spec API Spring Boot.** Cần trước khi vào **M05**: danh sách endpoint,
  hình dạng request/response, JWT thuần hay có refresh token. Quyết định này ảnh
  hưởng kiến trúc `packages/api_client` ở M08.
- **`flutter doctor` báo giả về license.** `✗ Android license status unknown` sẽ
  còn đó mãi: cmdline-tools mới bỏ cờ `--licenses`, Flutter 3.47 vẫn gọi cờ cũ.
  License thực tế đã accept — Gradle xác nhận khi build. Đừng đuổi theo nó.
- **`flutter emulators --create` không dùng được** vì cùng lý do trên. Tạo AVD
  bằng `avdmanager`. Đã ghi lệnh đầy đủ trong đề bài M00.
- **Chưa dựng Firebase project.** Cần trước khi vào lab M12: một Firebase project
  trên tài khoản Google, `flutterfire` CLI, và chốt xem `google-services.json` có
  commit hay không. File đó **không phải secret** — nó nằm sẵn trong APK đã ship —
  nhưng repo này có thể public sau, nên mặc định là `.gitignore` cho tới khi có lý
  do khác. Chưa chặn gì: M12 còn xa, và lab làm sớm được nếu lớp dạy tới.
- **iOS hoãn lại theo chủ ý.** `apps/userhub/ios/` đã sinh sẵn với đúng bundle id
  nhưng **chưa từng build** — placeholder chưa verify. Cần Xcode đầy đủ +
  CocoaPods. Không chặn việc học Android.
