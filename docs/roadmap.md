# Roadmap — Flutter từ nền tảng tới sản phẩm ship được

14 module, M00 đến M13 (M13 tuỳ chọn). Ước lượng ~50 ngày làm việc với nhịp
3-4h/ngày → khoảng 7-10 tuần.

Mỗi module có hai nửa:

- **Lab** — app nhỏ độc lập trong `apps/`. Claude giảng và code mẫu.
- **Capstone** — người học tự áp dụng vào `apps/userhub/`, không nhìn lại code lab.

Thiết kế đầy đủ và lý do đằng sau từng lựa chọn:
[spec](superpowers/specs/2026-09-10-flutter-learning-workspace-design.md).

| # | Module | Ngày | Lab | Capstone |
|---|---|:--:|---|---|
| 00 | Khởi động & công cụ | 2 | `00_hello_flutter` — giải phẫu project, hot reload vs restart, DevTools | Khởi tạo `userhub`, chạy được trên Android + iOS |
| 01 | Widget & Layout | 5 | `01_layout_lab` — Row/Column/Flex, Stack, **constraints** | UI tĩnh: Login + User list, data hardcode |
| 02 | Stateful & vòng đời | 3 | `02_stateful_lab` — setState, initState/dispose, Key | Tương tác local: hiện/ẩn mật khẩu, validate rỗng |
| 03 | Navigation & Routing | 3 | `03_navigation_lab` — Navigator, go_router, deep link | Route tree: Splash → Login → Home → User detail |
| 04 | Forms & Input | 3 | `04_forms_lab` — Form, validator, FocusNode, bàn phím | Login + Register hoàn chỉnh có validate |
| 05 | Async & tầng dữ liệu | 5 | `05_api_lab` — Future/Stream, Dio, JSON, Repository | **Nối thật vào Spring API**: login → JWT → GET /users |
| 06 | State nền tảng | 4 | `06_state_lab` — cùng 1 app viết 3 cách | Tách auth state ra khỏi widget |
| 07 | Riverpod | 5 | `07_riverpod_lab` — Notifier, AsyncNotifier, family, autoDispose | Chuyển toàn bộ `userhub` sang Riverpod |
| 08 | Kiến trúc ứng dụng | 5 | *(không có lab — refactor thuần)* | Feature-first, `Result` thay `throw`, DI, refresh-token interceptor, env dev/prod |
| 09 | Lưu trữ & offline | 4 | `09_storage_lab` — 4 tầng lưu trữ, `sqflite` thô → `drift`, cache-then-network | Nhớ phiên đăng nhập, xem user offline |
| 10 | Polish & UX | 5 | `10_polish_lab` — Material 3, dark mode, animation, responsive | Theme hệ thống, skeleton loading, animation chuyển màn |
| 11 | Hiệu năng & debug | 3 | `11_perf_lab` — **app cố tình chậm, người học tối ưu** | Đo & tối ưu `userhub` bằng DevTools |
| 12 | Release | 3 | — | Icon, splash native, flavor, ký AAB, build iOS, chạy trên máy thật |
| 13 | *(tuỳ chọn)* Testing & CI | — | — | Mở khoá khi bắt đầu thấy sợ mỗi lần refactor |

Tiến độ hiện tại: [PROGRESS.md](../PROGRESS.md)

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
- **Testing tách hẳn ra M13.** Đan test vào từ đầu sẽ làm chậm giai đoạn cần đà
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
