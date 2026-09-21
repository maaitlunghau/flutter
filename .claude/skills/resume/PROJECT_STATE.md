# PROJECT STATE — Flutter Learning Workspace

**Last synced commit:** `f079367` — *commit ngay sau nó chỉ là chính lần sync này,
không phải việc mới; đừng đi tìm thay đổi nào khác.*
**Last synced:** 2026-09-21
**Repo:** `/Users/maaitlunghau/Documents/SelfStudy/flutter` · branch `main` · working tree sạch
**Remote:** `origin` → `https://github.com/maaitlunghau/flutter.git`, `main` đã
đồng bộ. **Chưa xác minh được public hay private** (máy không có `gh`) — chuyện
này ảnh hưởng quyết định `google-services.json` ở M12, xem mục Nợ kỹ thuật.

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

**M00 ✅ 2026-09-15 · M01 ✅ 2026-09-17 · M02 ✅ 2026-09-17.**
**Đang ở M03 — Navigation & Routing: xong cả 3 vòng ngày 2026-09-21.**
Còn đúng hai việc để đóng module: **capstone `userhub`** (người học viết) và
**review**.

Ba vòng của M03 đã chạy: vòng 1 `Navigator` mệnh lệnh · vòng 2 `go_router`
(route tree, `:id`, màn 404, `redirect` làm auth guard) · vòng 3 deep link
Android. Cả lab lẫn `practice` đều đã kiểm chứng bằng `adb`, cold start lẫn
warm start.

**M01 đóng sớm theo yêu cầu người học:** vòng 1 làm đủ; vòng 2 (Flex, overflow)
bỏ bước tự dựng lại sau khi đã chạy và hiểu lab; vòng 3 (`Stack`) và capstone
**không làm** — capstone gộp sang M02.

**Nợ vẫn treo:** màn **User list** trong `userhub` (M01 hoãn, M02 hoãn, M03 chưa
làm). Nó là chỗ User detail được mở ra từ, nên phải dựng cùng capstone M03.

Chi tiết và danh sách việc tiếp theo: `PROGRESS.md`.

Bản đồ 15 module M00→M14: `docs/roadmap.md`.

### Vòng học — 5 bước, khoảng 4 tiếng

Chạy bằng `/flutter-module <NN>`. Skill ở `.claude/skills/flutter-module/`.

| Bước | Ai làm | Ra cái gì |
|---|---|---|
| Lesson (~45m) | Claude | `docs/lessons/NNNN-<slug>.html`, tiếng Việt |
| Lab (~1h) | Claude | `apps/NN_*_lab/` — **bản tham chiếu**, không phải đồ chơi để phá |
| Rebuild (~1h) | **người học** | `apps/practice/lib/mNN/` — tự dựng lại theo đề bài ở module brief |
| Capstone (~2h) | **người học** | `apps/userhub/` |
| Review (~30m) | Claude | đọc diff cả `practice` lẫn `userhub` |

**Luật capstone — áp dụng cho CẢ `apps/practice/`:** hai thư mục này là của
người học. Với `practice`, Claude chỉ dựng vỏ app và menu từng module. Còn lại, Claude chỉ gợi hướng, chỉ
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
| `apps/01_layout_lab` — lab M01, **6 màn** | xong, đã verify bằng ảnh chụp |
| `apps/02_stateful_lab` — lab M02, 3 màn | xong |
| `apps/03_navigation_lab` — lab M03, 3 vòng | xong, `MaterialApp.router`, scheme deep link `navlab` |
| `apps/practice` — sân tập, **một menu phẳng duy nhất** | `lib/m00/`→`lib/m03/` đều có bài; đã chuyển sang `MaterialApp.router`, scheme `practicelab` |
| `apps/userhub` — capstone | **mới có** `main.dart` + `login_screen.dart`; chưa có `go_router`, `home:` vẫn trỏ thẳng Login |
| Hook `commit-msg` + `pre-commit` (husky) | xong, hoạt động thật |
| `analysis_options.yaml` dùng chung | xong |
| Skill `/flutter-module` | xong |
| Emulator `pixel_dev` (Android 16, API 36, arm64) | chạy được |
| `docs/lessons/0001-giai-phau-project-va-hot-reload.html` | xong |
| `docs/lessons/0002-devtools-widget-inspector.html` | xong |
| `docs/lessons/0003` constraints · `0004` Flex · `0005` vòng đời · `0006` Key | xong |
| `docs/lessons/0007` Navigator là stack · `0008` route tree `go_router` · `0009` deep link | xong |
| `docs/reference/hot-reload-va-devtools.html` — cheat sheet M00 | xong |
| `docs/reference/stateful-vong-doi-va-key.html` — cheat sheet M02 | xong, có mục *Giải phẫu một màn stateful* do người học tự vẽ |
| `docs/reference/go-router.md` — cheat sheet M03 | xong, viết theo hướng áp dụng vào project thật |
| `docs/learning-records/0001` thiếu Scaffold · `0002` didUpdateWidget | xong |

`docs/learning-records/` có **2 file**, `docs/reference/` có **3**.

---

## Quyết định đã chốt — đừng lật lại

| Quyết định | Ngày | Lý do |
|---|---|---|
| **Android trước, iOS hoãn** | 2026-09-10 | Người học cần Android trước. `apps/userhub/ios/` đã sinh sẵn đúng bundle id nhưng **chưa từng build** — placeholder chưa verify. |
| **Comment tiếng Việt ở mọi nơi, kể cả `userhub`** | 2026-09-10 | Ban đầu định để `userhub` tiếng Anh; người học đổi ý. |
| **Không bao giờ dịch tên API Flutter/Dart** | | `build`, `setState`, `initState` phải giống hệt tài liệu chính thức, vì đó là chỗ người học tra cứu. |
| **Feature-first chỉ bắt đầu từ M08** | | Trước đó phẳng và hiển nhiên tốt hơn nhiều tầng và khôn lỏi. |
| **Làm thẳng trên `main`, không PR** | | Trừ **M08** — module refactor kiến trúc thì tách nhánh, để trạng thái "trước" còn lại mà so. Đọc diff đó **chính là bài học** của module. |
| **Không viết test trước M14** | | M14 là tuỳ chọn, mở khoá khi người học bắt đầu thấy sợ mỗi lần refactor. |
| **Firebase là M12 — bổ sung, không thay backend** | 2026-09-15 | Roadmap 14 → 15 module; Release xuống M13, Testing xuống M14. Spring Boot vẫn là nguồn dữ liệu của `userhub`; Firebase chỉ lo FCM, Crashlytics, Storage, Analytics. Đặt sau M09 vì Firestore bật offline bằng một dòng, học sớm là M09 mất lý do tồn tại; đặt trước Release vì Crashlytics chỉ có nghĩa với release build trên máy thật. Lý do đầy đủ: `docs/roadmap.md` mục *M12 — Firebase*. |
| **Bước "phá lab" đổi thành "tự dựng lại"** | 2026-09-15 | Người học thấy đọc code người khác thì chán và khó vào. Lab giờ là bản tham chiếu; người học tự dựng lại trong `apps/practice/lib/mNN/` theo đề bài ở module brief, chỉ mở lab khi bí. Vòng học thành 5 bước. Quyết theo từng module — M11 (lab cố tình viết xấu) thì không dựng lại. |
| **`apps/practice/` thuộc về người học** | 2026-09-15 | Luật capstone áp dụng luôn cho thư mục này. Claude chỉ dựng vỏ app và menu từng module, không viết gì thêm trừ khi được bảo thẳng. |
| **`apps/practice` chỉ có MỘT menu phẳng** | 2026-09-15 | Người học bác bỏ tầng menu con: M00 có 1 màn mà bắt bấm 2 lần là thừa. Gom nhóm bằng `_SectionHeader` ngay trong danh sách gốc, **không bao giờ** bằng màn menu trung gian. Đã ghi vào `CLAUDE.md`. |
| **Tự dựng lại là mặc định** | 2026-09-17 | M01 vòng 2 bỏ một lần theo yêu cầu; quyết định đó **không** áp dụng tiếp. Chỉ bỏ khi người học ra lệnh từng lần. |
| **Capstone M01 gộp vào M02** | 2026-09-17 | M01 đóng mà chưa dựng Login. Dựng một lần ở M02: layout là nợ M01, hiện/ẩn mật khẩu + validate là phần M02. |
| **`userhub` validate bằng tay ở M02** | 2026-09-17 | Không dùng `Form`/`validator` — đó là M04. Tự làm một lần rồi mới thấy `Form` tiết kiệm gì. Cùng logic M06 → M07. |
| **Lab M12 làm được lệch thứ tự** | 2026-09-15 | `apps/12_firebase_lab` độc lập với `userhub`, nên làm được ngay khi lớp dạy tới Firebase. Chỉ nửa capstone mới buộc đứng sau M09. |
| **`go_router` là router chính thức của repo** | 2026-09-21 | Bản `18.0.1`. `Navigator` mệnh lệnh vẫn dùng cho các bài M00–M02 trong `practice` — chúng không cần địa chỉ. Chỉ thứ cần deep link mới sống trong cây route. |
| **Auth guard đặt ở `redirect`, không ở `build`** | 2026-09-21 | Một chỗ duy nhất chặn được cả điều hướng trong app lẫn deep link từ ngoài. Kèm `refreshListenable` — thiếu nó thì đổi cờ xong router không chạy lại `redirect`. |
| **Người học gọi "code hộ tui" cho cả vòng 2 và vòng 3 của `practice`** | 2026-09-21 | Đúng ngoại lệ của luật capstone. Đã viết hoàn chỉnh. Không phải tiền lệ — mặc định vẫn là người học tự viết. |

---

## Nợ kỹ thuật đang treo

Danh sách đầy đủ ở `PROGRESS.md`. Cái **chặn tiến độ** chỉ có một:

> **Chưa có spec API Spring Boot.** Cần trước khi vào **M05** (Async & tầng dữ
> liệu): danh sách endpoint, hình dạng request/response, JWT thuần hay có refresh
> token. Quyết định này ảnh hưởng kiến trúc `packages/api_client` ở M08.

Ngoài ra **chưa dựng Firebase project** — cần trước lab M12, và phải chốt xem
`google-services.json` có commit hay không. Mặc định hiện tại là `.gitignore`.
**Lý do của mặc định đó giờ đã thành hiện thực: repo đã lên GitHub.** Trước khi
vào M12, hỏi người học repo là public hay private rồi mới chốt. Chưa chặn gì.

Ba cái còn lại là nhiễu của toolchain, **không chặn gì**, đã ghi đầy đủ trong
`docs/modules/00-khoi-dong.md` mục *"Bẫy thường gặp"* (5 bẫy, kèm cách kiểm
chứng thật): `flutter doctor` báo giả về license · `flutter emulators --create`
hỏng · iOS chưa verify · bàn phím máy thật không gõ được vào emulator.

---

## Những cái bẫy dễ tái phát

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

**3. Deep link phải viết BA dấu gạch.** `scheme://users/3` thì `users` bị hiểu
là **host**, path chỉ còn `/3`, router không khớp và rơi vào màn 404. Phải là
`scheme:///users/3`. Phát hiện ở M03 vòng 3, đã sửa lại Tiêu chí Xong trong
`docs/modules/03-navigation-va-routing.md` (bẫy 6). Bẫy 7 cùng file: thiếu
meta-data `flutter_deeplinking_enabled` thì deep link **im lặng không chạy**,
không báo lỗi gì.

**4. `NavigatorObserver` gắn vào `Navigator`, không gắn vào màn hình.** Người
học chép màn Stack Visualizer từ lab sang `practice` mà quên
`navigatorObservers` ở `MaterialApp` → bảng stack trống trơn trong khi code màn
hình đúng 100%. Kèm theo: không đặt `RouteSettings(name:)` thì mọi dòng trong
bảng đều vô danh. Dùng `go_router` thì observer chuyển vào `GoRouter.observers`.

---

## Khi vào phiên mới nên làm gì

1. Đọc `PROGRESS.md` — nguồn sự thật về vị trí hiện tại
2. Đối chiếu với `git log --oneline -10` và `git status --short`
3. Báo lại cho người học: đang ở module nào, vòng mấy, việc tiếp theo là gì
4. **Chờ chỉ đạo.** Đừng tự đoán bước kế tiếp.

Vào học thì gọi `/flutter-module 03`.

**Việc còn lại để đóng M03**, theo thứ tự: capstone `userhub` (người học viết —
đề bài ở `docs/modules/03-navigation-va-routing.md` mục *Capstone task*) → review
diff cả `practice` lẫn `userhub` → lật M03 thành ✅ ở **cả** `README.md` lẫn
`docs/roadmap.md` (hiện `README.md` vẫn ghi ⬜) → commit scope `m03`.

Capstone cần `flutter pub add go_router` trong `apps/userhub` rồi `flutter pub
get` ở root, và một `intent-filter` scheme `userhub` trong `AndroidManifest.xml`.
