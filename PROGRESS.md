# Tiến độ

> Claude: đọc file này **trước** khi bắt đầu bất kỳ module nào,
> và cập nhật nó **sau** khi kết thúc mỗi vòng học.

## Đang ở đâu

- **Module hiện tại:** M04 — Forms & Input *(chưa bắt đầu)*
- **Vòng:** M03 đóng 2026-09-21, đủ 3 vòng + capstone + review
- **Cập nhật lần cuối:** 2026-09-21

## Việc tiếp theo

**M02 xong ngày 2026-09-17**, đủ cả 2 vòng, tự dựng lại và capstone.

**M03 đã chạy hết vòng 1** ngày 2026-09-21: Navigator dạng mệnh lệnh — `push`,
`pop`, `pushReplacement`, `pushAndRemoveUntil`, trả kết quả qua `Future`, và
`PopScope` chặn rời màn.

Đã xong:

- [x] Đề bài `docs/modules/03-navigation-va-routing.md`
- [x] [Bài 0007 — Navigator là một cái stack](docs/lessons/0007-navigator-la-mot-cai-stack.html)
- [x] Lab `apps/03_navigation_lab` — 3 màn vòng 1
- [x] Tự dựng lại `apps/practice/lib/m03/` — Stack Visualizer, trả kết quả,
      chặn rời màn

Còn lại của M03:

- [x] [Bài 0008 — route tree khai báo với `go_router`](docs/lessons/0008-route-tree-khai-bao-voi-go-router.html)
- [x] Lab màn 4 — `apps/03_navigation_lab` chuyển sang `MaterialApp.router`,
      có `/users/:id`, màn 404 và `redirect` làm auth guard
- [x] [Cheat sheet `go_router`](docs/reference/go-router.md)
- [x] Vòng 2 trong `practice` — `apps/practice` chuyển sang `MaterialApp.router`:
      `/m03/items`, `/m03/items/:id`, màn 404, `/m03/locked` + `redirect` làm
      auth guard
- [x] [Bài 0009 — deep link, hệ điều hành gõ cửa app](docs/lessons/0009-deep-link-he-dieu-hanh-go-cua-app.html)
- [x] Deep link ở lab — `AndroidManifest.xml` của `03_navigation_lab`, scheme
      `navlab`, đã kiểm chứng bằng `adb` cả cold start lẫn warm start
- [x] Vòng 3 trong `practice` — scheme `practicelab`, màn `/m03/deeplink` tra
      lệnh `adb`, đã kiểm chứng cold start lẫn warm start
- [x] Capstone `userhub`: route tree `/splash` → `/login` → `/users` → `/users/:id`,
      `redirect` làm auth guard, deep link scheme `userhub`
- [x] Review `userhub` — 2026-09-21

> **Nợ M01 đã trả xong.** Màn **User list** dựng ở `user_list_screen.dart`, data
> hardcode trong `fake_users.dart`. Hoãn từ M01, hoãn tiếp ở M02, xong ở M03.

**Capstone M03 — 9 commit, 9 file, 636 dòng.** Kiểm chứng bằng `adb`: cold start,
warm start, chưa-đăng-nhập-bị-chặn, hai-dấu-gạch ra 404, đường dẫn rác ra 404.

Điểm đáng nhớ nhất của capstone: **deep link lúc chưa đăng nhập vẫn tới đúng
đích.** `redirect` gắn địa chỉ đang định tới vào `/login?from=...`, đăng nhập
xong trả về đúng chỗ đó. Không có nó thì mọi link gửi cho người chưa đăng nhập
đều rơi về danh sách.

**Ba việc nợ lại từ review**, không chặn M04:

- `?from=` chưa lọc — hình dạng của lỗ hổng open redirect. Chỉ nên nhận giá trị
  bắt đầu bằng `/`
- `fake_users.dart` dùng `name[0]` — cắt theo UTF-16 code unit, sẽ ra ký tự rác
  khi API trả tên có emoji ở M05. Dùng `name.characters.first`
- Ngôn ngữ chuỗi UI đang lệch: `user_detail_screen` và `not_found_screen` tiếng
  Anh, ba màn còn lại tiếng Việt

**Bẫy phát hiện ở vòng 3:** deep link `scheme://users/3` **không** chạy — host
nuốt mất `users`, path còn `/3`, `go_router` không khớp và rơi vào màn 404. Phải
viết `scheme:///users/3`, **ba** dấu gạch. Tiêu chí Xong trong đề bài đã sửa lại
cho đúng. Bẫy 6 và 7 trong `docs/modules/03-navigation-va-routing.md`.

**Bẫy đã dẫm phải ở vòng 1:** chép màn hình từ lab sang `practice` mà quên
`navigatorObservers` ở `MaterialApp` → bảng stack trống trơn trong khi code màn
hình đúng 100%. `NavigatorObserver` gắn vào `Navigator`, không gắn vào màn hình.
Kèm theo: không đặt `RouteSettings(name:)` thì mọi dòng trong bảng đều vô danh.

Chạy bằng `/flutter-module 03`.

**Có thể làm lệch thứ tự:** lab `apps/12_firebase_lab` độc lập với `userhub`, nên
khi trên lớp dạy tới Firebase thì làm nửa lab của M12 luôn, không cần chờ tới M12.
Chỉ nửa capstone mới bắt buộc đứng sau M09. Xem
[roadmap, mục M12](docs/roadmap.md#m12--firebase-bổ-sung-không-thay-thế).

## Trạng thái các module

| # | Module | Trạng thái |
|---|---|---|
| 00 | Khởi động & công cụ | ✅ |
| 01 | Widget & Layout | ✅ |
| 02 | Stateful & vòng đời | ✅ |
| 03 | Navigation & Routing | ✅ |
| 04 | Forms & Input | ⬜ |
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
