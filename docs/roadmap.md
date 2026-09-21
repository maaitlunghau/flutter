# Roadmap — Flutter từ nền tảng tới sản phẩm ship được

15 module, M00 đến M14 (M14 tuỳ chọn). Ước lượng ~54 ngày làm việc với nhịp
3-4h/ngày → khoảng 8-11 tuần.

Mỗi module có hai nửa:

- **Lab** — app nhỏ độc lập trong `apps/`. Claude giảng và code mẫu.
- **Capstone** — người học tự áp dụng vào `apps/userhub/`, không nhìn lại code lab.

Thiết kế đầy đủ và lý do đằng sau từng lựa chọn:
[spec](superpowers/specs/2026-09-10-flutter-learning-workspace-design.md).

| # | Module | Trạng thái | Ngày | Lab | Capstone |
|---|---|:--:|:--:|---|---|
| 00 | Khởi động & công cụ | ✅ | 2 | `00_hello_flutter` — giải phẫu project, hot reload vs restart, DevTools | Khởi tạo `userhub`, chạy được trên Android *(iOS hoãn)* |
| 01 | Widget & Layout | ✅ | 5 | `01_layout_lab` — Row/Column/Flex, Stack, **constraints** | UI tĩnh: Login + User list, data hardcode |
| 02 | Stateful & vòng đời | ✅ | 3 | `02_stateful_lab` — setState, initState/dispose, Key | Tương tác local: hiện/ẩn mật khẩu, validate rỗng |
| 03 | Navigation & Routing | ✅ | 3 | `03_navigation_lab` — Navigator, go_router, deep link | Route tree: Splash → Login → User list → User detail |
| 04 | Forms & Input | ✅ | 3 | `04_forms_lab` — Form, validator, FocusNode, bàn phím | Login + Register hoàn chỉnh có validate |
| 05 | Async & tầng dữ liệu | ⬜ | 5 | `05_api_lab` — Future/Stream, HTTP client *(`http` hay `dio` chưa chốt)*, JSON, Repository | **Nối thật vào Spring API**: `GET /users` · login vẫn fake, backend chưa có Auth |
| 06 | State nền tảng | ⬜ | 4 | `06_state_lab` — cùng 1 app viết 3 cách | Tách auth state ra khỏi widget |
| 07 | Riverpod | ⬜ | 5 | `07_riverpod_lab` — Notifier, AsyncNotifier, family, autoDispose | Chuyển toàn bộ `userhub` sang Riverpod |
| 08 | Kiến trúc ứng dụng | ⬜ | 5 | *(không có lab — refactor thuần)* | Feature-first, `Result` thay `throw`, DI, refresh-token interceptor, env dev/prod |
| 09 | Lưu trữ & offline | ⬜ | 4 | `09_storage_lab` — 4 tầng lưu trữ, `sqflite` thô → `drift`, cache-then-network | Nhớ phiên đăng nhập, xem user offline |
| 10 | Polish & UX | ⬜ | 5 | `10_polish_lab` — Material 3, dark mode, animation, responsive | Theme hệ thống, skeleton loading, animation chuyển màn |
| 11 | Hiệu năng & debug | ⬜ | 3 | `11_perf_lab` — **app cố tình chậm, người học tối ưu** | Đo & tối ưu `userhub` bằng DevTools |
| 12 | Firebase | ⬜ | 4 | `12_firebase_lab` — Auth, Firestore, offline persistence (xem bên dưới) | FCM + deep link, Crashlytics, Storage cho avatar, Analytics |
| 13 | Release | ⬜ | 3 | — | Icon, splash native, flavor, ký AAB, build iOS, chạy trên máy thật |
| 14 | *(tuỳ chọn)* Testing & CI | ⬜ | — | — | Mở khoá khi bắt đầu thấy sợ mỗi lần refactor |

✅ xong · 🚧 đang làm · ⬜ chưa bắt đầu. Chi tiết đang ở đâu: [PROGRESS.md](../PROGRESS.md)

## Những lựa chọn có chủ ý

- **M01 dành hẳn 5 ngày cho layout & constraints.** Đây là chỗ người học Flutter
  mắc kẹt lâu nhất. Biết Dart không giúp gì ở đây — nó là hệ thống hoàn toàn mới.
- **M06 bắt buộc đứng trước M07.** Viết một `InheritedWidget` bằng tay. Riverpod
  về bản chất là `InheritedWidget` được đóng gói; hiểu tầng dưới thì tầng trên
  thành hiển nhiên thay vì ma thuật.
- **M11 là lab duy nhất Claude cố tình viết code xấu.** Không thể học tối ưu hiệu
  năng trên một app vốn đã nhanh.
- **Chạm API Spring thật từ M05**, sớm hơn giáo trình thông thường, vì backend đã
  có sẵn — không cần luyện trên API giả.
- **Firebase đứng ở M12, sau M09 và ngay trước Release.** Lý do đầy đủ ở mục
  *"M12 — Firebase"* bên dưới. Ngắn gọn: học Firestore trước M09 thì M09 mất sạch
  lý do tồn tại, còn Crashlytics chỉ có nghĩa khi app đã sắp ship.
- **Testing tách hẳn ra M14.** Đan test vào từ đầu sẽ làm chậm giai đoạn cần đà
  nhất. Đánh đổi có ý thức: refactor ở M08 và M10 sẽ không có lưới an toàn.

## M09 — bốn tầng lưu trữ

SQLite không phải khái niệm của Flutter: nó là database nhúng có sẵn trong cả
Android lẫn iOS — một file `.db` chạy SQL thật, không cần server. Flutter chỉ truy
cập nó qua package.

| Cách | Dùng cho | Trong `userhub` |
|---|---|---|
| `shared_preferences` | Key-value bé: dark mode, ngôn ngữ | Lưu setting |
| `flutter_secure_storage` | Bí mật, mã hoá qua Keychain / Keystore | **Lưu JWT** |
| File thường (`path_provider`) | Ảnh cache, file tải về | Avatar cache |
| **SQLite** (`sqflite` → `drift`) | Dữ liệu có cấu trúc, cần query/lọc/sắp xếp | **Cache user để xem offline** |

`shared_preferences` **không phải database** — nó là file XML/plist đọc hết vào
RAM. Nhét vài trăm bản ghi vào đó là phình bộ nhớ và không query nổi. Đây là lỗi
kinh điển của người mới.

Lộ trình: học `sqflite` thô trước (~nửa ngày) rồi dùng `drift` cho capstone —
cùng logic với M06 → M07. Chọn `drift` thay Hive/Isar vì đã có sẵn tư duy quan hệ
và SQL từ Spring Boot.

## M12 — Firebase: bổ sung, không thay thế

**Quyết định gốc: Spring Boot vẫn là nguồn dữ liệu của `userhub`.** Firebase vào
repo này để làm những việc backend chạy trên laptop không làm được, chứ không để
thay nó. Đây là hình dạng của app production thật — backend riêng cộng Firebase lo
dịch vụ nền tảng — và nó giữ nguyên lợi thế lớn nhất người học mang vào repo: một
API thật đã viết xong.

### Vì sao không sớm hơn

Firebase chồng lấn gần hết những gì M05, M08 và M09 bắt tự làm bằng tay:

| Roadmap dạy tự làm | Firebase làm sẵn |
|---|---|
| M05 — Dio, JSON, gắn JWT thủ công, Repository | SDK giấu hết HTTP; Auth tự quản token |
| M08 — refresh-token interceptor | không tồn tại, SDK tự refresh |
| M09 — `sqflite` → `drift`, cache-then-network | Firestore bật offline persistence bằng **một dòng** |

Học Firestore trước M09 thì M09 không còn lý do tồn tại: người học sẽ không bao
giờ hiểu vì sao cache-then-network là việc khó. **Sau M09 là ràng buộc cứng.**

### Vì sao không muộn hơn

Crashlytics chỉ có nghĩa với **release build chạy trên máy thật** — crash trong
debug thì đã thấy ngay ở console. FCM cũng vậy: notification nền cần app cài thật,
không phải `flutter run`. Đặt Firebase **ngay trước** Release nghĩa là M13 ship
một app đã có Crashlytics bên trong. Đặt sau Release thì gắn Crashlytics vào app
đã ship xong — vô nghĩa.

Thêm nữa, `flutterfire configure` sửa `android/app/build.gradle`, thêm plugin, thả
`google-services.json`. Đúng họ công việc native mà M13 làm (icon, splash native,
flavor, ký AAB), nên hai module cạnh nhau thì không phải nạp lại kiến thức Gradle
hai lần.

### Hai nửa của module

**Lab `apps/12_firebase_lab`** — app rời, vứt đi được, **không nối vào `userhub`**:
`flutterfire configure`, Firebase Auth email/password, Firestore CRUD, bật offline
persistence. Mục đích là chạm đủ khái niệm một lần, rồi viết một
`docs/learning-records/` so sánh thẳng: *chỗ nào Firebase làm sẵn thứ M05 và M09
bắt mình tự làm.*

**Capstone trong `userhub`** — chỉ bốn thứ, tất cả là năng lực mới, không đụng vào
tầng dữ liệu đã có:

| Thứ | Làm gì | Nối vào đâu |
|---|---|---|
| **FCM** | xin quyền, handler foreground/background, bấm notification → deep link | route tree của M03, auth state của M07 |
| **Crashlytics** | bật, ném crash thử, đọc dashboard | chuẩn bị cho M13 |
| **Storage** | upload avatar | UI đã polish ở M10 |
| **Analytics** | log 2-3 event, không hơn | — |

Bỏ hẳn Remote Config và Firebase Hosting — YAGNI.

### Lab M12 làm được sớm, không cần chờ tới tuần 8

Nửa lab **độc lập hoàn toàn** với `userhub` — nó là một app riêng trong `apps/`.
Khi trên lớp dạy tới Firebase, cứ làm lab trước, kể cả đang ở M01. Chỉ **nửa
capstone** mới bị ràng buộc phải đứng sau M09.
