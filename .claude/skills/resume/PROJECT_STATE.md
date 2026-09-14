# PROJECT STATE — Flutter Learning Workspace

**Last synced commit:** `913edf7`
**Last synced:** 2026-09-14
**Repo:** `/Users/maaitlunghau/Documents/SelfStudy/flutter` · branch `main` · working tree sạch
**Remote:** chưa có — repo mới chỉ nằm ở máy

> Cập nhật file này khi HEAD tiến lên đáng kể hoặc khi có quyết định mới.
> Quy tắc làm việc chi tiết nằm ở `.claude/CLAUDE.md` — **đọc file đó trước**.
> Không chép lại `PROGRESS.md`, `MISSION.md`, `docs/roadmap.md` hay đề bài module
> — chỉ trỏ đường dẫn. `PROGRESS.md` là nguồn sự thật về vị trí hiện tại.

---

## Mục tiêu

Đây là **workspace tự học**, không phải repo sản phẩm. Đích đến ghi ở
`MISSION.md`: tự build và ship được một app cá nhân hoàn chỉnh — có tài khoản,
gọi API thật, dùng được khi mất mạng, cài được lên máy thật.

Người học **đã nắm Dart** (repo riêng `dart-roadmap`) và **đã làm được backend
Java Spring Boot**. Cú pháp Dart cố ý nằm ngoài phạm vi repo này.

Neo cho mọi bài giảng: *thứ này giúp gì cho việc ship `userhub`?*

---

## Đang ở đâu

**M00 — Khởi động & công cụ.** Hạ tầng đã dựng xong, **chưa vào vòng học nào**.

Chi tiết và danh sách việc tiếp theo: `PROGRESS.md`. Đề bài: `docs/modules/00-khoi-dong.md`.

Bản đồ 14 module M00→M13: `docs/roadmap.md`.

### Vòng học — 4 bước, khoảng 4 tiếng

Chạy bằng `/flutter-module <NN>`. Skill ở `.claude/skills/flutter-module/`.

| Bước | Ai làm | Ra cái gì |
|---|---|---|
| Lesson (~45m) | Claude | `docs/lessons/NNNN-<slug>.html`, tiếng Việt |
| Lab (~1h) | Claude | `apps/NN_*_lab/` — người học chạy và phá |
| Capstone (~2h) | **người học** | `apps/userhub/` |
| Review (~30m) | Claude | đọc diff |

**Luật capstone:** `apps/userhub/` là của người học. Claude chỉ gợi hướng, chỉ
đúng dòng sai, viết pseudocode, hoặc viết ví dụ tương tự **trong bối cảnh khác**.

**Ngoại lệ:** khi người học nói thẳng *"code hộ tui"* / *"viết luôn đi"* →
viết **hoàn chỉnh**, không TODO, không stub, chạy được ngay. Rồi thêm mục
**"Chỗ đáng verify"** 3–5 gạch đầu dòng. **Tuyệt đối không cằn nhằn**, không hỏi
"bạn chắc chưa", không giảng đạo về việc học.

---

## Những gì đã có

| Thứ | Trạng thái |
|---|---|
| Pub workspace ở root (Dart 3.6+, không dùng Melos) | xong |
| `apps/00_hello_flutter` | xong, comment tiếng Việt |
| `apps/userhub` — capstone, `applicationId com.maaitlunghau.userhub` | đã khởi tạo, **chưa viết gì** |
| Hook `commit-msg` + `pre-commit` (husky) | xong, hoạt động thật |
| `analysis_options.yaml` dùng chung | xong |
| Skill `/flutter-module` | xong |
| Emulator `pixel_dev` (Android 16, API 36, arm64) | chạy được |
| `docs/lessons/0001-giai-phau-project-va-hot-reload.html` | xong |

`docs/learning-records/` và `docs/reference/` **đang rỗng** — sẽ đầy dần theo
từng module.

---

## Quyết định đã chốt — đừng lật lại

| Quyết định | Ngày | Lý do |
|---|---|---|
| **Android trước, iOS hoãn** | 2026-09-10 | Người học cần Android trước. `apps/userhub/ios/` đã sinh sẵn đúng bundle id nhưng **chưa từng build** — placeholder chưa verify. |
| **Comment tiếng Việt ở mọi nơi, kể cả `userhub`** | 2026-09-10 | Ban đầu định để `userhub` tiếng Anh; người học đổi ý. |
| **Không bao giờ dịch tên API Flutter/Dart** | | `build`, `setState`, `initState` phải giống hệt tài liệu chính thức, vì đó là chỗ người học tra cứu. |
| **Feature-first chỉ bắt đầu từ M08** | | Trước đó phẳng và hiển nhiên tốt hơn nhiều tầng và khôn lỏi. |
| **Làm thẳng trên `main`, không PR** | | Trừ **M08** — module refactor kiến trúc thì tách nhánh, để trạng thái "trước" còn lại mà so. Đọc diff đó **chính là bài học** của module. |
| **Không viết test trước M13** | | M13 là tuỳ chọn, mở khoá khi người học bắt đầu thấy sợ mỗi lần refactor. |

---

## Nợ kỹ thuật đang treo

Danh sách đầy đủ ở `PROGRESS.md`. Cái **chặn tiến độ** chỉ có một:

> **Chưa có spec API Spring Boot.** Cần trước khi vào **M05** (Async & tầng dữ
> liệu): danh sách endpoint, hình dạng request/response, JWT thuần hay có refresh
> token. Quyết định này ảnh hưởng kiến trúc `packages/api_client` ở M08.

Ba cái còn lại là nhiễu của toolchain, **không chặn gì**, đã ghi đầy đủ trong
`docs/modules/00-khoi-dong.md` mục *"Bẫy thường gặp"* (5 bẫy, kèm cách kiểm
chứng thật): `flutter doctor` báo giả về license · `flutter emulators --create`
hỏng · iOS chưa verify · bàn phím máy thật không gõ được vào emulator.

---

## Hai cái bẫy về cấu hình — dễ tái phát

**1. `flutter analyze` tự ghi đè `analysis_options.yaml`.** Nó tìm các chuỗi
*nguyên văn* `build/**`, `android/**`, `ios/**`, `web/**`, `windows/**`,
`macos/**`, `linux/**`; thiếu cái nào là nó viết lại file. Nhưng thứ thật sự với
được vào `apps/` lại là các mẫu `**/...`. **Phải giữ cả hai nhóm.** Đừng dọn
"cho gọn".

**2. Mỗi lần `flutter create` là sinh thêm rác cấu hình.** Bốn bước trong
`CLAUDE.md` mục *"Adding a new app"* **không bước nào bỏ được** — đặc biệt là
`rm` file `analysis_options.yaml` mà `flutter create` tự đẻ ra, vì analyzer dùng
file **gần nhất** nên nó âm thầm đè cấu hình chung ở root.

App mới **không** cần đụng gì tới Gradle: `.vscode/settings.json` đã tắt
`java.import.gradle.enabled`, mẫu loại trừ `**/android/**` bắt hết cả app chưa
tồn tại.

---

## Khi vào phiên mới nên làm gì

1. Đọc `PROGRESS.md` — nguồn sự thật về vị trí hiện tại
2. Đối chiếu với `git log --oneline -10` và `git status --short`
3. Báo lại cho người học: đang ở module nào, vòng mấy, việc tiếp theo là gì
4. **Chờ chỉ đạo.** Đừng tự đoán bước kế tiếp.

Vào học thì gọi `/flutter-module 00`.
