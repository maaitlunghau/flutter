# Tiến độ

> Claude: đọc file này **trước** khi bắt đầu bất kỳ module nào,
> và cập nhật nó **sau** khi kết thúc mỗi vòng học.

## Đang ở đâu

- **Module hiện tại:** M01 — Widget & Layout
- **Vòng:** vòng 2/3 — bài giảng và lab đã xong, chờ người học **tự dựng lại**
- **Cập nhật lần cuối:** 2026-09-17

## Việc tiếp theo

**M00 xong ngày 2026-09-15**, cả hai vòng. Toolchain Android chạy thông, vòng lặp
sửa-code-thấy-kết-quả đã thông suốt trên `pixel_dev`. Năm cái bẫy gặp phải ghi ở
[bẫy thường gặp M00](docs/modules/00-khoi-dong.md#bẫy-thường-gặp).

Sản phẩm M00: [bài 0001](docs/lessons/0001-giai-phau-project-va-hot-reload.html) ·
[bài 0002](docs/lessons/0002-devtools-widget-inspector.html) ·
[cheat sheet](docs/reference/hot-reload-va-devtools.html) ·
[record 0001](docs/learning-records/0001-thieu-scaffold-khong-crash.md)

**Tiếp theo — M01 Widget & Layout, 5 ngày.** Module dài nhất phần đầu roadmap, và
cố ý dài: constraints là chỗ người học Flutter mắc kẹt lâu nhất, biết Dart không
giúp được gì.

- [ ] **Khởi động trước:** dựng lại bộ đếm M00 trong `apps/practice/lib/m00/` —
      đề bài ở [mục *Tự dựng lại* của M00](docs/modules/00-khoi-dong.md#tự-dựng-lại--appspracticelibm00).
      Không mở lại M00, module đó vẫn ✅; đây chỉ là bài quen nhịp.
- [x] Đề bài `docs/modules/01-widget-va-layout.md`
- [x] Bài giảng `docs/lessons/0003-constraints-luat-ba-cau.html`
- [x] Lab tham chiếu `apps/01_layout_lab` — 3 màn, đã verify bằng ảnh chụp
- [x] **Vòng 1** — người học đã tự dựng 3 màn constraints trong `apps/practice/lib/m01/`
- [x] Bài giảng `docs/lessons/0004-flex-va-loi-tran.html` + 3 màn lab vòng 2
- [ ] **Vòng 2** — người học tự dựng lại 3 màn Flex, đề bài ở
      [mục *Tự dựng lại*](docs/modules/01-widget-va-layout.md#vòng-2--thêm-ba-màn-nữa)
- [ ] Vòng 3 — `Stack`, rồi capstone 2 màn tĩnh trong `userhub`

Chạy bằng `/flutter-module 01`.

**Có thể làm lệch thứ tự:** lab `apps/12_firebase_lab` độc lập với `userhub`, nên
khi trên lớp dạy tới Firebase thì làm nửa lab của M12 luôn, không cần chờ tới M12.
Chỉ nửa capstone mới bắt buộc đứng sau M09. Xem
[roadmap, mục M12](docs/roadmap.md#m12--firebase-bổ-sung-không-thay-thế).

## Trạng thái các module

| # | Module | Trạng thái |
|---|---|---|
| 00 | Khởi động & công cụ | ✅ |
| 01 | Widget & Layout | 🚧 |
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
