# Tiến độ

> Claude: đọc file này **trước** khi bắt đầu bất kỳ module nào,
> và cập nhật nó **sau** khi kết thúc mỗi vòng học.

## Đang ở đâu

- **Module hiện tại:** M00 — Khởi động & công cụ
- **Vòng:** chưa bắt đầu
- **Cập nhật lần cuối:** 2026-09-10

## Việc tiếp theo

- [ ] Hoàn thiện toolchain Android + iOS — xem Task 0 của
      [plan scaffold](docs/superpowers/plans/2026-09-10-workspace-scaffold.md)
- [ ] Khởi tạo `apps/userhub` (Task 6, bị chặn bởi Task 0)
- [ ] M00 vòng 1 — giải phẫu project, hot reload vs hot restart
- [ ] M00 vòng 2 — DevTools, đọc cây widget

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
- [ ] `apps/userhub` — chờ toolchain

## Nợ kỹ thuật đang treo

- **Chưa có spec API Spring Boot.** Cần trước khi vào **M05**: danh sách endpoint,
  hình dạng request/response, JWT thuần hay có refresh token. Quyết định này ảnh
  hưởng kiến trúc `packages/api_client` ở M08.
- **Toolchain chưa xong.** `flutter doctor` còn báo `[!]` ở Android toolchain
  (thiếu cmdline-tools, chưa accept license) và Xcode (cài chưa đầy đủ, thiếu
  CocoaPods). Chặn tiêu chí Xong của M00.
