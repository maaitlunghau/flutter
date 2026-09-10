# Thiết kế: Flutter Learning Workspace

- **Ngày:** 2026-09-10
- **Trạng thái:** Đã duyệt, chờ lập implementation plan
- **Repo:** `~/Documents/SelfStudy/flutter`

---

## 1. Bối cảnh & mục tiêu

Repo này là **không gian luyện Flutter**, không phải repo sản phẩm. Người học đã
nắm Dart ở mức tổng quát (xem repo `dart-roadmap`), nên toàn bộ phần cú pháp Dart
được bỏ qua có chủ đích.

**Mục tiêu cuối:** tự build và ship được một app cá nhân hoàn chỉnh — có tài khoản,
gọi API thật, dùng được offline, release lên máy thật.

**Không phải mục tiêu:** luyện thi phỏng vấn, làm portfolio, viết backend.

### Ràng buộc đã chốt

| Trục | Quyết định |
|---|---|
| Nhịp học | 3-4h/ngày, ưu tiên tốc độ |
| Backend | Spring Boot ở repo riêng, đã có API quản lý User hoàn chỉnh. Repo này chỉ làm frontend. |
| State management | Học nền tảng (setState → InheritedWidget → Provider) rồi chốt Riverpod |
| Platform | Android (emulator/máy thật) + iOS (simulator) |
| Ngôn ngữ | Docs & bài giảng: tiếng Việt · Code, comment, commit, CLAUDE.md: tiếng Anh |
| Testing & CI | Bỏ qua giai đoạn đầu; là module tuỳ chọn ở cuối, không đan xen |
| Môi trường | Flutter 3.47.0 stable · Dart 3.13.0 · macOS |

---

## 2. Hình dạng roadmap: hai làn song song

Đã cân nhắc ba hình dạng:

- **A — Tuyến tính:** học hết nền tảng rồi mới làm capstone ở cuối. Phủ kiến thức
  đầy đủ nhưng học architecture khi chưa từng đau vì thiếu nó, và 8 tuần đầu không
  ra sản phẩm gì.
- **B — Xoắn ốc:** dựng capstone thô từ tuần 1 rồi liên tục refactor. Bám sát mục
  tiêu ship, độ nhớ cao, nhưng bỏ trống những gì capstone không dùng tới.
- **C — Hai làn song song** ← **đã chọn**

### Vì sao C

Mỗi module có hai nửa:

- **Lab** — một app nhỏ độc lập trong `apps/`. Claude giảng và code mẫu đầy đủ.
  Học khái niệm trong môi trường sạch, không nhiễu.
- **Capstone increment** — người học tự tay áp dụng đúng khái niệm đó vào
  `apps/userhub/`, không nhìn lại code lab. Claude review sau.

C khớp chính xác với cơ chế học đã chọn: **lab chính là bản mẫu của Claude,
capstone increment chính là phần người học tự làm lại.** Không phải bịa ra bài tập
riêng — capstone tự nó là bài tập, và mỗi vòng lại thêm một mảnh của sản phẩm thật.

Đánh đổi: mỗi module tốn khoảng 1.5x thời gian so với hướng A. Với nhịp 3-4h/ngày
vẫn nằm trong ~9-10 tuần.

---

## 3. Cấu trúc repo

```
flutter/
├── .claude/
│   ├── CLAUDE.md              # chỉ dẫn vận hành cho Claude (tiếng Anh)
│   ├── settings.json
│   ├── settings.local.json    # gitignored
│   └── skills/
│       └── flutter-module/    # skill mới, điều khiển vòng lặp học
├── .husky/
│   ├── commit-msg             # sửa regex scope
│   └── pre-commit             # nâng cấp: format + analyze
├── apps/
│   ├── 00_hello_flutter/
│   ├── 01_layout_lab/
│   ├── 02_stateful_lab/
│   ├── 03_navigation_lab/
│   ├── 04_forms_lab/
│   ├── 05_api_lab/
│   ├── 06_state_lab/
│   ├── 07_riverpod_lab/
│   ├── 09_storage_lab/
│   ├── 10_polish_lab/
│   ├── 11_perf_lab/
│   └── userhub/               # CAPSTONE
├── packages/                  # sinh ra khi có nhu cầu thật, không dựng trước
│   ├── app_core/              # Result, Failure, extensions  (từ M08)
│   ├── app_ui/                # design system dùng chung     (từ M10)
│   └── api_client/            # Dio wrapper + JWT interceptor (từ M08)
├── docs/
│   ├── roadmap.md
│   ├── modules/NN-*.md        # đề bài + tiêu chí Xong từng module
│   ├── lessons/*.html         # bài giảng do Claude sinh
│   ├── reference/*.html       # cheat sheet tra nhanh
│   ├── learning-records/*.md  # hiểu nhầm đáng nhớ
│   └── superpowers/specs/
├── MISSION.md                 # vì sao học Flutter — neo mọi bài giảng
├── PROGRESS.md                # đang ở đâu, làm gì tiếp
├── README.md                  # tiếng Việt
├── pubspec.yaml               # root pub workspace
├── analysis_options.yaml      # lint dùng chung
├── .env.example
├── package.json
└── .gitignore
```

### 3.1 Pub workspace, không dùng Melos

Dart 3.13 hỗ trợ `workspace:` sẵn. Một `flutter pub get` ở root xử lý toàn bộ apps,
một lockfile, một `.dart_tool` dùng chung — đáng kể khi có ~12 project.

Melos là công cụ cho repo publish nhiều package lên pub.dev; ở đây nó là tooling
thừa.

**Escape hatch:** nếu một lab cần version package xung đột, gỡ nó khỏi danh sách
`workspace:` là nó chạy standalone bình thường.

**Cần xác minh lúc triển khai:** tạo workspace tối thiểu (root + 1 app) và chạy
`flutter pub get` thành công trước khi scaffold toàn bộ.

### 3.2 `packages/` sinh theo nhu cầu

Không dựng sẵn ba package rỗng từ ngày đầu. `app_ui` chỉ ra đời ở M10, khi đã
copy-paste widget tới lần thứ ba. Kiến trúc dựng trước nhu cầu là kiến trúc hình
thức.

### 3.3 Sửa `.gitignore`

Hiện tại đang ignore toàn bộ `.claude/` → CLAUDE.md và các skill **không được
commit**, clone lại là mất. Sửa thành:

```diff
- .claude/
+ .claude/settings.local.json
```

Đồng thời bổ sung phần ignore của Flutter — hiện chưa có dòng nào:
`.dart_tool/`, `build/`, `.flutter-plugins*`, `*.iml`, `ios/Pods/`,
`ios/.symlinks/`, `android/.gradle/`, `android/local.properties`, `.env`,
`*.jks`, `*.keystore`, `**/generated_plugin_registrant.dart`.

---

## 4. Roadmap — M00 đến M13 (14 module, M13 tuỳ chọn)

Mỗi module gồm Lab (Claude làm mẫu) và Capstone (người học tự làm).
Ước lượng theo nhịp 3-4h/ngày.

| # | Module | Ngày | Lab | Capstone |
|---|---|:--:|---|---|
| 00 | Khởi động & công cụ | 2 | `00_hello_flutter` — giải phẫu project, hot reload vs restart, DevTools | Khởi tạo `userhub`, chạy được trên Android + iOS |
| 01 | Widget & Layout | 5 | `01_layout_lab` — Row/Column/Flex, Stack, **constraints** | UI tĩnh: Login + User list, data hardcode |
| 02 | Stateful & vòng đời | 3 | `02_stateful_lab` — setState, initState/dispose, Key | Tương tác local: hiện/ẩn mật khẩu, validate rỗng |
| 03 | Navigation & Routing | 3 | `03_navigation_lab` — Navigator, go_router, deep link | Route tree: Splash → Login → Home → User detail |
| 04 | Forms & Input | 3 | `04_forms_lab` — Form, validator, FocusNode, bàn phím | Login + Register hoàn chỉnh có validate |
| 05 | Async & tầng dữ liệu | 5 | `05_api_lab` — Future/Stream, Dio, JSON, Repository | **Nối thật vào Spring API**: login → JWT → GET /users |
| 06 | State nền tảng | 4 | `06_state_lab` — cùng 1 app viết 3 cách | Tách auth state ra khỏi widget |
| 07 | Riverpod | 5 | `07_riverpod_lab` — Notifier, AsyncNotifier, family, autoDispose | Chuyển toàn bộ `userhub` sang Riverpod |
| 08 | Kiến trúc ứng dụng | 5 | *(không có lab — refactor thuần)* | Feature-first, `Result` thay `throw`, DI, refresh-token interceptor, env dev/prod |
| 09 | Lưu trữ & offline | 4 | `09_storage_lab` — 4 tầng lưu trữ, `sqflite` thô → `drift`, cache-then-network (xem 4.1) | Nhớ phiên đăng nhập, xem user offline |
| 10 | Polish & UX | 5 | `10_polish_lab` — Material 3, dark mode, animation, responsive | Theme hệ thống, skeleton loading, animation chuyển màn |
| 11 | Hiệu năng & debug | 3 | `11_perf_lab` — **app cố tình chậm, người học tối ưu** | Đo & tối ưu `userhub` bằng DevTools |
| 12 | Release | 3 | — | Icon, splash native, flavor, ký AAB, build iOS, chạy trên máy thật |
| 13 | *(tuỳ chọn)* Testing & CI | — | — | Mở khoá khi bắt đầu thấy sợ mỗi lần refactor |

**Tổng ~50 ngày làm việc → 7-10 tuần** tuỳ 5 hay 7 ngày/tuần.

### Những lựa chọn có chủ ý

- **M01 dành hẳn 5 ngày cho layout & constraints.** Đây là chỗ người học Flutter
  mắc kẹt lâu nhất. Biết Dart không giúp gì ở đây — nó là hệ thống hoàn toàn mới.
- **M06 bắt buộc đứng trước M07.** Viết một `InheritedWidget` bằng tay. Riverpod
  về bản chất là `InheritedWidget` được đóng gói; hiểu tầng dưới thì tầng trên
  thành hiển nhiên thay vì ma thuật.
- **M11 là lab duy nhất Claude cố tình viết code xấu.** Không thể học tối ưu hiệu
  năng trên một app vốn đã nhanh.
- **Chạm API Spring thật từ M05**, sớm hơn giáo trình thông thường, vì backend đã
  có sẵn — không cần luyện trên API giả.
- **Testing tách hẳn ra M13.** Đan test vào từ đầu sẽ làm chậm giai đoạn cần đà
  nhất. Đánh đổi được chấp nhận có ý thức: refactor ở M08 và M10 sẽ không có lưới
  an toàn.

### 4.1 M09 — bốn tầng lưu trữ và lộ trình SQLite

SQLite không phải khái niệm của Flutter: nó là database nhúng có sẵn trong cả
Android lẫn iOS — một file `.db` chạy SQL thật, không cần server. Flutter chỉ truy
cập nó qua package. Nên câu hỏi thật sự của M09 không phải "học SQLite" mà là
**"lưu xuống máy có mấy cách, chọn cách nào"**.

| Cách | Dùng cho | Trong `userhub` |
|---|---|---|
| `shared_preferences` | Key-value bé: dark mode, ngôn ngữ, đã xem onboarding chưa | Lưu setting |
| `flutter_secure_storage` | Bí mật, mã hoá qua Keychain (iOS) / Keystore (Android) | **Lưu JWT** |
| File thường (`path_provider`) | Ảnh cache, file tải về | Avatar cache |
| **SQLite** (`sqflite` → `drift`) | Dữ liệu có cấu trúc, nhiều bản ghi, cần query/lọc/sắp xếp | **Cache danh sách user để xem offline** |

Điểm hay bị nhầm và cần dạy tường minh trong lab: **`shared_preferences` không phải
database.** Nó là một file XML/plist đọc hết vào RAM. Nhét vài trăm bản ghi vào đó
là phình bộ nhớ và không query nổi.

**Lộ trình đã chốt: học `sqflite` thô trước (~nửa ngày), rồi dùng `drift` cho
capstone.**

- `sqflite` bọc SQLite ở mức thô — tự viết chuỗi SQL `CREATE TABLE`, `SELECT`.
- `drift` là tầng type-safe sinh code nằm trên chính SQLite — query trả về đúng
  class Dart, sai cột là lỗi lúc compile thay vì lúc chạy.

Đi qua `sqflite` trước dù cuối cùng không dùng nó, theo đúng logic M06 → M07:
`drift` chỉ là SQL được gói lại, thấy được SQL thô bên dưới thì khi `drift` báo lỗi
mới biết đường lần.

Chọn `drift` thay vì Hive/Isar vì người học đã có sẵn tư duy quan hệ và SQL từ
Spring Boot. Ép học mô hình NoSQL để lưu dữ liệu vốn dĩ quan hệ (user, role) là đi
đường vòng.

**Cần xác minh trước khi vào M09:** hệ sinh thái package lưu trữ của Flutter biến
động nhiều, có package từng phổ biến rồi rơi vào tình trạng ít bảo trì. Kiểm tra
sức khoẻ `sqflite`, `drift`, `flutter_secure_storage` trên pub.dev tại thời điểm
bắt đầu M09 thay vì tin vào lựa chọn chốt sẵn ở đây.

---

## 5. Vòng lặp học

Mỗi module gồm 2-4 **vòng**, mỗi vòng gọn trong một buổi ~4h.

```
1. Bài giảng    ~45'   Claude viết → docs/lessons/00XX-ten-bai.html
                       Tiếng Việt, có sơ đồ, ngắn, kèm 1 nguồn chính thống

2. Lab          ~1h    Claude code → apps/NN_xxx_lab/
                       Người học chạy, đổi số, cố tình làm hỏng, quan sát

3. Capstone     ~2h    Người học code → apps/userhub/
                       Đề bài + tiêu chí Xong ở docs/modules/NN-*.md

4. Review       ~30'   Claude đọc diff
                       Hiểu nhầm đáng nhớ → docs/learning-records/
```

### 5.1 Rule về capstone

Đây là rule giữ cho thiết kế không sụp về lại chế độ "đọc code Claude viết".

**Mặc định:** capstone là của người học. Khi bí, Claude được phép gợi ý hướng, chỉ
ra dòng sai, viết pseudo-code, viết ví dụ tương tự **nhưng khác ngữ cảnh** — không
viết lời giải trực tiếp.

**Khi người học yêu cầu rõ ràng** ("code hộ tui", "viết luôn đi"): Claude viết
**hoàn chỉnh** — không `// TODO`, không stub, không "phần còn lại bạn tự làm". Chạy
được ngay, đúng convention repo. Kèm mục **"Chỗ đáng verify"**: 3-5 gạch đầu dòng
chỉ ra quyết định nào là đánh đổi và chỗ nào dễ sai, để việc verify có điểm bám.

**Claude không được cằn nhằn.** Không hỏi lại "bạn chắc chưa?", không nhắc nhở về
việc học, không đếm số lần nhờ. Được nhờ thì làm, làm cho tử tế, hết.

### 5.2 Khung file module

`docs/modules/NN-ten-module.md` dùng khung cố định:

```markdown
# MNN — Tên module
## Mục tiêu           (học xong làm được gì)
## Khái niệm cốt lõi  (5-7 gạch đầu dòng)
## Lab                (Claude làm gì, người học quan sát gì)
## Capstone task      (phải làm gì)
## Tiêu chí Xong      (checklist tick được, khách quan)
## Bẫy thường gặp     (điền dần khi thật sự vấp phải)
## Nguồn              (docs chính thống, không phải blog)
```

### 5.3 Skill `/flutter-module`

Tạo `.claude/skills/flutter-module/SKILL.md`. Gõ `/flutter-module 03` thì Claude
tự đọc `PROGRESS.md`, mở đúng file module, chạy đúng vòng lặp trên.

Lý do cần: mỗi phiên Claude là một phiên mới không nhớ gì. Không có skill, quy
trình chỉ là chữ trong README và sẽ trôi mất sau vài tuần.

---

## 6. Convention & tooling

### 6.1 Sửa `commit-msg` hook (làm trước tiên)

Regex hiện tại cho scope là `[a-z0-9-]+` — **không cho phép dấu gạch dưới**. Nhưng
tên package Dart bắt buộc `snake_case`, nên scope `01_layout_lab` sẽ bị hook từ
chối.

Sửa: `[a-z0-9-]` → `[a-z0-9_-]`. Làm ngay, trước khi có commit nào của apps.

### 6.2 Nâng cấp `pre-commit`

Hiện chỉ `echo`. Nâng thành:

```sh
dart format --set-exit-if-changed <staged .dart files>
flutter analyze
```

Nhờ pub workspace, `flutter analyze` chạy một lần ở root quét hết mọi app.

### 6.3 `analysis_options.yaml` ở root

- `include: package:flutter_lints/flutter.yaml`
- `analyzer.language`: `strict-casts: true`, `strict-raw-types: true`
- Bật thêm: `prefer_const_constructors`, `avoid_print`, `use_super_parameters`,
  `require_trailing_commas`

`require_trailing_commas` là rule đáng giá nhất trong nhóm này với Flutter: nó giữ
cho widget tree lồng nhiều tầng còn đọc được sau khi format.

### 6.4 Quy ước scope commit

| Loại | Scope | Ví dụ |
|---|---|---|
| Capstone | `userhub` | `feat(userhub): add jwt interceptor` |
| Lab | tên thư mục app | `feat(03_navigation_lab): add nested route demo` |
| Bài giảng / docs | `m00`–`m13` | `docs(m03): add navigation lesson` |
| Hạ tầng repo | `repo` | `chore(repo): enable pub workspace` |

Ràng buộc từ hook: một dòng, ≤70 ký tự, không body, không footer.

### 6.5 Cấu hình môi trường

Base URL của Spring API truyền qua `--dart-define`, không hardcode, không commit.
`.env.example` làm mẫu, `.env` bị gitignore. Áp dụng từ M05.

### 6.6 Branch

Làm thẳng trên `main`, không PR. Ngoại lệ duy nhất là **M08** (refactor kiến trúc
lớn): tách branch để giữ bản "trước" mà so sánh — đọc lại diff đó chính là bài học
của module.

---

## 7. `.claude/CLAUDE.md`

**Viết bằng tiếng Anh** (file cấu hình công cụ, họ hàng với code hơn tài liệu; nằm
cùng thư mục với các skill vốn đã tiếng Anh).

**Nguyên tắc: ngắn và đậm đặc**, mục tiêu ~100 dòng. File này nạp vào mỗi phiên;
dài dòng thì rule quan trọng bị loãng. Chi tiết đẩy sang `docs/`.

| # | Mục | Nội dung |
|---|---|---|
| 1 | What this repo is | 2-3 câu. "Learning workspace, not a product repo." Ngăn Claude nhầm là codebase production. |
| 2 | Where things live | Bảng đường dẫn: `apps/` · `packages/` · `docs/` · `PROGRESS.md` |
| 3 | **The learning loop** | Vòng 4 bước + rule capstone (mục 5.1). Đặt ngay đầu, không chôn xuống dưới. |
| 4 | Language rule | Docs/bài giảng: tiếng Việt. Code, tên biến, comment, commit: tiếng Anh. |
| 5 | Code conventions | Dart style, file `snake_case`, feature-first từ M08, `const` khi được, trailing comma bắt buộc. |
| 6 | Commands | `flutter pub get` (ở **root**), `flutter run -d <device>`, `flutter analyze`, `dart format` |
| 7 | Commit rules | `type(scope): subject` · 1 dòng · ≤70 ký tự · không body. Bảng scope. Cảnh báo hook sẽ chặn. |
| 8 | **What Claude must NOT do** | Xem dưới |
| 9 | Current state | Trỏ `PROGRESS.md` + `docs/roadmap.md`. Bắt buộc đọc `PROGRESS.md` trước khi bắt đầu module. |

### Mục 8 — danh sách "không được làm"

- Không tự nâng version dependency
- Không dựng package rỗng "để dành sau này" (YAGNI)
- Không viết test trước M13 trừ khi được yêu cầu
- Không code trong `apps/userhub/` khi chưa được nhờ rõ ràng
- Không thêm package ngoài khi Flutter SDK làm được việc đó

Danh sách "đừng làm" có giá trị cao hơn danh sách "hãy làm", vì hành vi mặc định
của Claude là chủ động thái quá — thấy repo học Flutter là muốn dựng sẵn clean
architecture 5 tầng, trong khi thứ cần ở tuần 1 là một `Column` chạy được.

---

## 8. `README.md`

Tiếng Việt.

| # | Mục | Nội dung |
|---|---|---|
| 1 | Tiêu đề + một câu | "Không gian luyện Flutter từ nền tảng tới sản phẩm ship được." |
| 2 | Là gì / không là gì | Nêu rõ: workspace học; mỗi thư mục trong `apps/` là một bài luyện, không phải sản phẩm. |
| 3 | Tiền đề | Đã học Dart trước → link repo `dart-roadmap`. Nói rõ repo này bỏ qua cú pháp Dart. |
| 4 | Roadmap | Bảng 14 module (M00–M13) có cột trạng thái ✅/🚧/⬜, link `docs/modules/*.md` |
| 5 | Cấu trúc thư mục | Cây thư mục + một dòng giải thích mỗi nhánh |
| 6 | Bắt đầu thế nào | Yêu cầu phiên bản, `flutter pub get` ở root, cách chạy một app, cách trỏ tới Spring API |
| 7 | Capstone: `userhub` | Mô tả app, tính năng, ảnh chụp màn hình (điền dần) |
| 8 | Tech stack | Flutter 3.47 · Dart 3.13 · Riverpod · Dio · go_router … |
| 9 | Quy ước | Commit format, đặt tên, ngôn ngữ |
| 10 | Tiến độ | Link `PROGRESS.md` |

Mục 3 quan trọng hơn vẻ ngoài: nó giải thích vì sao repo không có bài nào dạy
`List`, `Future`, `class` — thiếu nó thì roadmap trông như bị hụt.

---

## 9. Thứ tự triển khai

1. **Sửa hạ tầng trước** — `.gitignore`, `commit-msg` regex, `pre-commit`,
   `analysis_options.yaml`. Phải xong trước khi có commit nào của apps.
2. **Xác minh pub workspace** — root `pubspec.yaml` + một app, chạy
   `flutter pub get` thành công.
3. **Docs khung** — `README.md`, `.claude/CLAUDE.md`, `MISSION.md`,
   `PROGRESS.md`, `docs/roadmap.md`.
4. **Skill `/flutter-module`**.
5. **M00** — `apps/00_hello_flutter/` + `apps/userhub/` khởi tạo,
   `docs/modules/00-*.md`. Kết thúc bằng app chạy được trên cả Android và iOS.
6. Từ đó trở đi mỗi module là một chu kỳ độc lập, không scaffold trước.

Các thư mục lab từ M01 trở đi **không** được tạo sẵn ở bước scaffold — chúng ra đời
khi tới module tương ứng. Tạo 12 project rỗng từ đầu chỉ tạo ra nhiễu.

---

## 10. Câu hỏi còn mở

- **Spec API Spring Boot** — cần danh sách endpoint, hình dạng request/response,
  cơ chế auth (JWT thuần hay có refresh token?) trước khi bắt đầu **M05**. Không
  chặn các module trước đó.
- **Tên capstone** — `userhub` là tên tạm, đổi được bất cứ lúc nào trước M00.
