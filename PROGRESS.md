# Tiến độ

> Claude: đọc file này **trước** khi bắt đầu bất kỳ module nào,
> và cập nhật nó **sau** khi kết thúc mỗi vòng học.

## Đang ở đâu

- **Module hiện tại:** M03 — Navigation & Routing *(chưa bắt đầu)*
- **Vòng:** M02 đóng 2026-09-17, cả 2 vòng + capstone
- **Cập nhật lần cuối:** 2026-09-17

## Việc tiếp theo

**M02 xong ngày 2026-09-17**, đủ cả 2 vòng, tự dựng lại và capstone.

**`apps/userhub` đã có code thật đầu tiên**: `login_screen.dart` — layout chống
overflow, nút con mắt ẩn/hiện mật khẩu, validate rỗng bằng tay,
`TextEditingController` được `dispose`. Template counter của `flutter create` đã
xoá hẳn.

Sản phẩm M02: [bài 0005](docs/lessons/0005-vong-doi-cua-state.html) ·
[bài 0006](docs/lessons/0006-key-va-cach-ghep-state.html) ·
[cheat sheet](docs/reference/stateful-vong-doi-va-key.html) ·
[record 0002](docs/learning-records/0002-didupdatewidget-chay-moi-lan-cha-dung-lai.md)

**Tiếp theo — M03 Navigation & Routing, 3 ngày.**

- [ ] Đề bài `docs/modules/03-*.md` — chưa viết
- [ ] Lab `apps/03_navigation_lab` — chưa tạo
- [ ] Capstone: route tree Splash → Login → Home → User detail

> **Nợ mang sang M03:** màn **User list** (M01 hoãn, M02 hoãn). M03 có điều hướng
> rồi thì dựng nó luôn — lúc đó mới có đường đi tới.

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
| 03 | Navigation & Routing | ⬜ |
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
