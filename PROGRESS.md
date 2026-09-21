# Tiến độ

> Claude: đọc file này **trước** khi bắt đầu bất kỳ module nào,
> và cập nhật nó **sau** khi kết thúc mỗi vòng học.

## Đang ở đâu

- **Module hiện tại:** M03 — Navigation & Routing *(đang làm — xong vòng 1 và 2)*
- **Vòng:** vòng 1 (Navigator mệnh lệnh) và vòng 2 (`go_router`) xong
  2026-09-21. Vòng 3 (deep link) chưa bắt đầu. Capstone chưa.
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
- [ ] Bài 0009 + vòng 3 — deep link, chứng minh bằng `adb`
- [ ] Capstone `userhub`: route tree Splash → Login → Home → User detail
- [ ] Review cả `practice` lẫn `userhub`

> **Nợ mang sang M03:** màn **User list** (M01 hoãn, M02 hoãn). Vẫn chưa dựng.
> Nó là nơi User detail được mở ra từ, nên phải làm cùng capstone M03.

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
| 03 | Navigation & Routing | 🔄 vòng 1-2 xong |
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
