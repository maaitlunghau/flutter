# Tiến độ

> Claude: đọc file này **trước** khi bắt đầu bất kỳ module nào,
> và cập nhật nó **sau** khi kết thúc mỗi vòng học.

## Đang ở đâu

- **Module hiện tại:** M02 — Stateful & vòng đời
- **Vòng:** M02 — cả 2 vòng bài giảng + lab đã xong, chờ người học tự dựng lại rồi làm capstone
- **Cập nhật lần cuối:** 2026-09-17

## Việc tiếp theo

**M01 đóng ngày 2026-09-17.** Vòng 1 người học tự dựng lại đủ 3 màn constraints
trong `apps/practice/lib/m01/`. Vòng 2 (Flex, overflow) người học **chọn bỏ bước
tự dựng lại** sau khi đã chạy và hiểu lab. Vòng 3 (`Stack`) và capstone **không
làm** — capstone được gộp sang M02, xem lý do trong brief M02.

Sản phẩm M01: [bài 0003](docs/lessons/0003-constraints-luat-ba-cau.html) ·
[bài 0004](docs/lessons/0004-flex-va-loi-tran.html) ·
lab `apps/01_layout_lab` 6 màn · `apps/practice/lib/m01/` 3 màn

**Tiếp theo — M02 Stateful & vòng đời, 3 ngày.**
Đề bài: [docs/modules/02-stateful-va-vong-doi.md](docs/modules/02-stateful-va-vong-doi.md)

M02 chia **2 vòng**: vòng 1 vòng đời + `dispose`, vòng 2 `Key` + capstone.

- [x] Đề bài M02
- [x] **Vòng 1** — bài `0005` + lab `apps/02_stateful_lab` (Lifecycle Logger, Dispose Leak)
- [ ] **Vòng 1** — người học tự dựng lại 2 màn trong `apps/practice/lib/m02/`
- [x] **Vòng 2** — bài `0006` + lab Key Trap
- [ ] **Vòng 2** — người học tự dựng lại màn Key Trap trong `apps/practice/lib/m02/`
- [ ] **Capstone: màn Login trong `userhub`** — gộp cả phần layout còn nợ của M01

> **Nợ từ M01:** `apps/userhub` vẫn **chưa có dòng code nào của người học**. Màn
> User list hoãn tới M03, khi đã có điều hướng để đi tới nó.

Chạy bằng `/flutter-module 02`.

**Có thể làm lệch thứ tự:** lab `apps/12_firebase_lab` độc lập với `userhub`, nên
khi trên lớp dạy tới Firebase thì làm nửa lab của M12 luôn, không cần chờ tới M12.
Chỉ nửa capstone mới bắt buộc đứng sau M09. Xem
[roadmap, mục M12](docs/roadmap.md#m12--firebase-bổ-sung-không-thay-thế).

## Trạng thái các module

| # | Module | Trạng thái |
|---|---|---|
| 00 | Khởi động & công cụ | ✅ |
| 01 | Widget & Layout | ✅ |
| 02 | Stateful & vòng đời | 🚧 |
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
