# Tiến độ

> Claude: đọc file này **trước** khi bắt đầu bất kỳ module nào,
> và cập nhật nó **sau** khi kết thúc mỗi vòng học.

## Đang ở đâu

- **Module hiện tại:** M00 — Khởi động & công cụ
- **Vòng:** chưa bắt đầu
- **Cập nhật lần cuối:** 2026-09-10

## Việc tiếp theo

**Đang chặn — cần bạn làm, Claude không chạy thay được:**

- [ ] Android Studio → SDK Tools → cài **Android SDK Command-line Tools (latest)**
- [ ] `flutter doctor --android-licenses`
- [ ] `flutter emulators --create --name pixel_dev`

**Sau đó:**

- [ ] M00 vòng 1 — giải phẫu project, hot reload vs hot restart
- [ ] M00 vòng 2 — DevTools, đọc cây widget

Đề bài: [docs/modules/00-khoi-dong.md](docs/modules/00-khoi-dong.md)

## Trạng thái các module

| # | Module | Trạng thái |
|---|---|---|
| 00 | Khởi động & công cụ | 🚧 |
| 01 | Widget & Layout | ⬜ |
| 02 | Stateful & vòng đời | ⬜ |
| 03 | Navigation & Routing | ⬜ |
| 04 | Forms & Input | ⬜ |
| 05 | Async & tầng dữ liệu | ⬜ |
| 06 | State nền tảng | ⬜ |
| 07 | Riverpod | ⬜ |
| 08 | Kiến trúc ứng dụng | ⬜ |
| 09 | Lưu trữ & offline | ⬜ |
| 10 | Polish & UX | ⬜ |
| 11 | Hiệu năng & debug | ⬜ |
| 12 | Release | ⬜ |
| 13 | Testing & CI (tuỳ chọn) | ⬜ |

## Hạ tầng đã dựng

- [x] `.gitignore` + hook `commit-msg` + hook `pre-commit`
- [x] Pub workspace ở root + `apps/00_hello_flutter`
- [x] `analysis_options.yaml` dùng chung
- [x] Docs khung: README · CLAUDE.md · MISSION.md · roadmap.md
- [x] Skill `/flutter-module`
- [x] `apps/userhub` — đã khởi tạo, `applicationId com.maaitlunghau.userhub`
- [x] `.env.example` + đề bài M00

## Nợ kỹ thuật đang treo

- **Chưa có spec API Spring Boot.** Cần trước khi vào **M05**: danh sách endpoint,
  hình dạng request/response, JWT thuần hay có refresh token. Quyết định này ảnh
  hưởng kiến trúc `packages/api_client` ở M08.
- **Android chưa chạy được.** `flutter doctor` còn `[!]`: thiếu cmdline-tools,
  chưa accept license, chưa có emulator. Chặn tiêu chí Xong của M00.
- **iOS hoãn lại theo chủ ý.** `apps/userhub/ios/` đã sinh sẵn với đúng bundle id
  nhưng **chưa từng build** — placeholder chưa verify. Cần Xcode đầy đủ +
  CocoaPods. Không chặn việc học Android.
