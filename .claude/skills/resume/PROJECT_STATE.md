# PROJECT STATE — Flutter Learning Workspace

**Last synced commit:** `6908a60` — *commit ngay sau nó chỉ là chính lần sync này,
không phải việc mới; đừng đi tìm thay đổi nào khác.*
**Last synced:** 2026-09-22
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

**M00 ✅ · M01 ✅ · M02 ✅ · M03 ✅ 2026-09-21 · M04 ✅ 2026-09-22.**
**Đang ở M05 — Async & tầng dữ liệu, chưa bắt đầu** (chưa có đề bài, chưa có lab).

**M05 hết chặn** — spec API đã có: `docs/reference/backend-api.md` (2026-09-22,
backend commit `a873614`). Nhưng spec **bẻ lại hình dạng M05**: backend chưa có
endpoint auth nào. Xem `PROGRESS.md` mục *Việc tiếp theo*.

M03 chạy đủ 3 vòng + capstone + review: vòng 1 `Navigator` mệnh lệnh · vòng 2
`go_router` (route tree, `:id`, màn 404, `redirect` làm auth guard) · vòng 3 deep
link Android. Lab, `practice` và `userhub` đều đã kiểm chứng bằng `adb`, cold
start lẫn warm start.

**M01 đóng sớm theo yêu cầu người học:** vòng 1 làm đủ; vòng 2 (Flex, overflow)
bỏ bước tự dựng lại sau khi đã chạy và hiểu lab; vòng 3 (`Stack`) và capstone
**không làm** — capstone gộp sang M02.

**Nợ User list đã trả xong** ở capstone M03 (`user_list_screen.dart` +
`fake_users.dart`). Không còn nợ nào mang sang M04.

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
| `apps/04_forms_lab` — lab M04, 2 màn | xong. Ít màn hơn dự định vì người học gọi *"code dùm tui"* cho `practice` — xem quyết định *Bỏ bài giảng khi code đã dạy đủ* |
| `apps/practice` — sân tập, **một menu phẳng duy nhất** | `lib/m00/`→`lib/m04/` đều có bài; `MaterialApp.router`, scheme `practicelab`. M04 **không** dùng route — form không cần địa chỉ |
| `apps/userhub` — capstone | **11 file**: `MaterialApp.router` + `app_router.dart` (auth guard ở `redirect`, khái niệm *đường công khai*), Splash · Login · **Register** · User list · User detail · 404, `authState` trong RAM, `validators.dart`, deep link scheme `userhub`. Login và Register đều dùng `Form` |
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
| `docs/reference/backend-api.md` — **spec API Spring Boot** | người học viết, copy từ repo backend. Nguồn sự thật ở repo kia — API đổi thì sửa bên đó rồi copy sang |
| `docs/lessons/0010` Form/FormState/validator — **bài duy nhất của M04** | xong |
| `docs/reference/forms-va-input.md` — cheat sheet M04 | xong, **thay cho hai bài `0011`/`0012` đã bỏ** |
| `docs/learning-records/0001` thiếu Scaffold · `0002` didUpdateWidget | xong |

`docs/learning-records/` có **2 file**, `docs/reference/` có **5**.

**Đánh số bài giảng:** bài cuối là `0010`. Số kế tiếp là `0011` — dành cho M05,
vì `0011`/`0012` của M04 đã bỏ chứ không phải đã dùng.

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
| **Danh sách user ở `/users`, không phải `/home`** | 2026-09-21 | Đề bài ban đầu để danh sách ở `/home` còn chi tiết ở `/users/:id` — hai đường không có quan hệ cha–con nên `go_router` không dựng được stack, và Back từ deep link sẽ thoát app. Đặt danh sách ở `/users` rồi cho chi tiết làm route con `:id` thì stack `[danh sách, chi tiết]` tự có. Đề bài và Tiêu chí Xong đã sửa theo. |
| **Capstone M03 do Claude viết theo yêu cầu, chia 8 step có duyệt** | 2026-09-21 | Người học nói thẳng *"thay vì tui code, bạn hãy triển khai dùm tôi từng step"* vì đã hiểu phần này. Quy trình: Claude làm một step → mô tả đã sửa file nào và vì sao → người học duyệt → commit → step kế. **Không phải tiền lệ** — mặc định `userhub` vẫn thuộc về người học. |
| **Chuỗi UI trong `userhub` dùng tiếng Anh** | 2026-09-22 | Người học chọn khi thống nhất lại 5 màn đang lệch nhau. Tên người và `role` trong `fake_users.dart` vẫn tiếng Việt — đó là **dữ liệu**, không phải nhãn giao diện. Chưa phải i18n thật; i18n là M10. |
| **Bỏ bài giảng khi code đã dạy đủ** | 2026-09-22 | Bài `0011` và `0012` của M04 bị bỏ hẳn: người học gọi *"code dùm tui"* nên cả 5 màn `practice/lib/m04/` được viết kèm doc comment dạy đúng nội dung hai bài đó. Phần tra cứu lại được dồn vào cheat sheet. **Số bài giảng kế tiếp là `0011`, dành cho M05.** Tiền lệ: khi người học đã đọc code và hiểu, bài giảng viết lại là thừa — hỏi trước khi viết. |
| **`redirect` dùng khái niệm "đường công khai"** | 2026-09-22 | M04 thêm `/register`, và nó phải vào được khi chưa đăng nhập. Thay vì thêm nhánh `if`, đặt `isPublic = location == '/login' \|\| location == '/register'`. **Cả hai vế của `redirect` phải đổi theo** — quên vế `loggedIn && isPublic` thì người đã đăng nhập vào `/register` vẫn thấy form đăng ký. |
| **M05 làm đủ, phần auth thì fake** | 2026-09-22 | Backend chưa có endpoint auth. Vẫn dựng `AuthRepository` + interceptor gắn `Authorization` đầy đủ, token do client tự sinh — khi backend có auth thật thì chỉ đổi một hàm. Nửa đọc dữ liệu (`GET /api/users`) là thật 100%. |
| **Register giữ fake, không nối `POST /api/users`** | 2026-09-22 | Spec tự cảnh báo endpoint đó bắt client gửi `role` nên **về nghiệp vụ là admin-only** — nối vào màn tự đăng ký công khai là lỗ hổng leo thang đặc quyền, và là dạy thói quen sai. Chờ `/api/auth/register` thật. |
| **`id` của user là UUID chuỗi, không phải `int`** | 2026-09-22 | Theo spec backend. `userhub` đang dùng `int` ở `fake_users.dart` và `int.tryParse` ở `user_detail_screen.dart` — phải sửa ở M05, kèm deep link `users/7` → `users/<uuid>` và Tiêu chí Xong của M03. |
| **`userhub` không mang comment** | 2026-09-22 | Người học gỡ hết comment, kể cả comment mới Claude thêm ở từng lần sửa. **Claude không tự thêm comment vào `userhub` nữa.** Lưu ý: `CLAUDE.md` vẫn ghi "comment tiếng Việt ở mọi nơi, kể cả `userhub`" — hai thứ đang lệch nhau, chưa quyết sửa bên nào. |

---

## Nợ kỹ thuật đang treo

Danh sách đầy đủ ở `PROGRESS.md`. Cái **chặn tiến độ** chỉ có một:

> **Backend chưa có module Auth.** Spec API đã có (hết chặn M05), nhưng
> `SecurityConfig` đang `permitAll()` và **không có endpoint login/register/refresh
> nào**. Hệ quả: `authState` của `userhub` vẫn fake sau M05, và **M08 cũng vướng**
> — "refresh-token interceptor" là một trong bốn việc chính của module đó.
> Chờ người học build module Auth bên Spring.

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

**4. `adb` không nằm trong `PATH`.** Gõ thẳng `adb` là `command not found` —
Flutter gọi nó bằng đường dẫn tuyệt đối nên chuyện này không bao giờ lộ ra cho
tới lúc cần `adb` thật (deep link, screenshot, `input text`). Máy đang để ở:

```bash
~/Library/Android/sdk/platform-tools/adb
```

**5. `NavigatorObserver` gắn vào `Navigator`, không gắn vào màn hình.** Người
học chép màn Stack Visualizer từ lab sang `practice` mà quên
`navigatorObservers` ở `MaterialApp` → bảng stack trống trơn trong khi code màn
hình đúng 100%. Kèm theo: không đặt `RouteSettings(name:)` thì mọi dòng trong
bảng đều vô danh. Dùng `go_router` thì observer chuyển vào `GoRouter.observers`.

---

## Cách làm việc đã thành nếp

Ba thói quen hình thành qua M03 và M04, người học không phản đối lần nào:

**1. Chia step → mô tả → người học duyệt → commit → step kế.** Mỗi step là một
commit. Phần mô tả phải nói rõ **sửa file nào** và **vì sao**, rồi kết bằng mục
*"Chỗ đáng verify"* 3–5 gạch đầu dòng. Người học đọc phần mô tả chứ ít khi mở
diff, nên mô tả sơ sài là họ duyệt mù.

**2. Kiểm chứng bằng `adb` trên emulator, không bằng suy luận.** `flutter analyze`
sạch **không** có nghĩa là chạy đúng — bài học đắt nhất của session này là bộ lọc
`?from=` làm hỏng deep link mà analyzer im lặng suốt. Cài APK, `input tap`,
`input text`, `screencap`, rồi đọc ảnh. Kèm `logcat -d | grep E/flutter`.

**3. Người học gỡ hết comment trong `userhub`.** Kể cả comment mới thêm ở từng
lần sửa. Đừng thêm lại, và đừng coi đó là lỗi — họ đọc phần mô tả của Claude thay
cho comment.

Hai lần người học gọi *"code hộ tui"* (vòng 2–3 của `practice` M03, toàn bộ
`practice/lib/m04` và capstone M04) đều **không phải tiền lệ**. Mặc định
`userhub` và `practice` vẫn thuộc về người học — chờ họ nói.

---

## Khi vào phiên mới nên làm gì

1. Đọc `PROGRESS.md` — nguồn sự thật về vị trí hiện tại
2. Đối chiếu với `git log --oneline -10` và `git status --short`
3. Báo lại cho người học: đang ở module nào, việc tiếp theo là gì
4. **Chờ chỉ đạo.** Đừng tự đoán bước kế tiếp.

**M03 và M04 đã đóng hoàn toàn** — PROGRESS, README, roadmap, đề bài đều đã lật ✅.

**Vào M05 thì gọi `/flutter-module 05`.** Chưa có đề bài, chưa có lab. Spec API
đã có nên **không còn chặn**, nhưng đọc `docs/reference/backend-api.md` trước khi
viết đề bài — nó bẻ lại hình dạng module (không có endpoint auth).

**M05 sẽ gồm:** `Future`/`async` trong UI · `http` · parse envelope dùng chung ·
`PageResponse` + phân trang (`page` đếm từ 0, `last` để dừng infinite scroll) ·
`Repository` · `ApiException` phân loại theo status · **map `data` của lỗi 400 vào
`errorText` từng ô** (nối thẳng vào M04) · trạng thái đang-tải / lỗi / rỗng.

**Bốn việc sửa bắt buộc khi vào M05**, do spec backend:

| Chỗ | Hiện tại | Phải thành |
|---|---|---|
| `fake_users.dart` | `final int id` · `findUserById(int)` | `String` (UUID) |
| `user_detail_screen.dart` | `int.tryParse(userId)` | bỏ hẳn |
| Deep link + Tiêu chí Xong M03 | `userhub:///users/7` | `userhub:///users/<uuid>` |
| Model | `name` | `fullName`, thêm `enabled`, `imageUrl`, `emailVerified`… |

Kèm hai thứ chặn ngay phút đầu: base URL phải là **`10.0.2.2:8081`** (emulator
không thấy `localhost` của máy host), và `AndroidManifest.xml` cần
`android:usesCleartextTraffic="true"` — không có thì Android 9+ chặn HTTP thường.

**Ba việc cố ý KHÔNG sửa** — sửa bây giờ là lấy mất bài học của module sau:
hai biến toàn cục (`authState`, `appRouter`) → M06/M07, và `appRouter` không test
được → M14 · Splash cứng 1 giây → M09 · nút Đăng nhập/Đăng ký không có trạng thái
đang xử lý → **M05 sẽ làm, vì lúc đó mới có `await` thật để khoá**.
