# Flutter Learning Workspace — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Dựng hạ tầng repo, docs khung, skill vận hành và module M00 để việc học Flutter bắt đầu được ngay trong buổi kế tiếp.

**Architecture:** Pub workspace ở root gom mọi app trong `apps/` vào một lần resolve dependency duy nhất. Hạ tầng (gitignore, hook, lint) được sửa trước khi có bất kỳ file Dart nào. Docs khung và skill `/flutter-module` được dựng trước M00 để vòng lặp học tồn tại qua nhiều phiên Claude. Các thư mục lab từ M01 trở đi **không** scaffold trước.

**Tech Stack:** Flutter 3.47.0 stable · Dart 3.13.0 · Pub workspaces (native, không Melos) · Husky 9 · flutter_lints

**Spec:** `docs/superpowers/specs/2026-09-10-flutter-learning-workspace-design.md`

## Mô hình kiểm chứng (thay cho TDD)

Spec đã chốt **hoãn testing tới M13**, và plan này chỉ tạo hạ tầng, docs, cấu hình — không có logic ứng dụng để viết unit test. Vì vậy mỗi task dùng chu kỳ:

**thay đổi → chạy lệnh kiểm chứng → so với output kỳ vọng đã ghi sẵn → commit.**

Mọi bước kiểm chứng đều ghi rõ lệnh và output mong đợi. Không được commit khi output lệch.

## Global Constraints

- Flutter **3.47.0** stable, Dart **3.13.0**. Không nâng/hạ version SDK.
- Commit message: `type(scope): subject` — **một dòng**, **≤ 70 ký tự**, **không body, không footer**. Hook `.husky/commit-msg` sẽ chặn. **Tuyệt đối không thêm trailer `Co-Authored-By`.**
- Types hợp lệ: `feat fix docs style refactor perf test chore revert ci`
- Scope: `userhub` (capstone) · tên thư mục app (lab) · `m00`–`m13` (docs) · `repo` (hạ tầng)
- Ngôn ngữ: docs/lessons/README **tiếng Việt**; code, identifier, comment, commit message, `CLAUDE.md` **tiếng Anh**.
- `flutter pub get` luôn chạy ở **root**, không chạy trong từng app.
- Không tạo thư mục lab cho module tương lai. Không tạo package rỗng.
- Không viết test trước M13.
- Không thêm package bên thứ ba khi Flutter SDK đã làm được.

---

## Task 0: Hoàn thiện toolchain Android + iOS

**Bối cảnh:** `flutter doctor` trên máy hiện tại báo hỏng **cả hai** nền tảng đích:

```
[!] Android toolchain — cmdline-tools component is missing
                      — Android license status unknown
[!] Xcode             — Xcode installation is incomplete
                      — CocoaPods not installed
```

`flutter devices` chỉ thấy macOS và Chrome. `flutter emulators` báo `No emulators available`.

**Task này chặn *tiêu chí Xong* của M00 (Task 6), nhưng KHÔNG chặn Task 1–5.** Nếu toolchain chưa xong, cứ làm Task 1–5 trước.

**Files:** không sửa file nào trong repo.

**Interfaces:**
- Produces: một Android emulator chạy được và một iOS simulator chạy được, để Task 6 xác nhận `userhub` khởi động trên cả hai.

**Phần lớn task này người học phải tự chạy** — có bước cần `sudo`, cần đăng nhập App Store, cần chấp nhận license tương tác. Claude không chạy thay. Trong Claude Code, gõ tiền tố `!` để chạy lệnh ngay trong phiên.

- [ ] **Step 1: Cài Xcode bản đầy đủ**

Hiện chỉ có Command Line Tools, không đủ để build iOS. Cài Xcode từ App Store (nhiều GB, nên làm khi mạng rảnh).

- [ ] **Step 2: Trỏ Flutter sang Xcode vừa cài**

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

- [ ] **Step 3: Cài CocoaPods**

```bash
sudo gem install cocoapods
```

Kỳ vọng: `pod --version` in ra số version.

- [ ] **Step 4: Cài Android cmdline-tools**

Mở Android Studio → Settings → Languages & Frameworks → Android SDK → tab **SDK Tools** → tick **Android SDK Command-line Tools (latest)** → Apply.

- [ ] **Step 5: Chấp nhận Android licenses**

```bash
flutter doctor --android-licenses
```

Lệnh tương tác — gõ `y` cho từng license.

- [ ] **Step 6: Tạo Android emulator**

```bash
flutter emulators --create --name pixel_dev
flutter emulators --launch pixel_dev
```

- [ ] **Step 7: Mở iOS simulator**

```bash
open -a Simulator
```

- [ ] **Step 8: Kiểm chứng**

Run: `flutter doctor`
Expected: dòng Android toolchain và Xcode đều là `[✓]`.

Run: `flutter devices`
Expected: danh sách có **cả** một thiết bị Android (`sdk gphone…` hoặc `android-arm64`) **và** một thiết bị iOS (`iPhone … • ios • …`).

Không commit gì ở task này — không có thay đổi trong repo.

---

## Task 1: Hạ tầng repo — gitignore, commit-msg, pre-commit

Phải xong **trước** khi có bất kỳ file Dart nào trong repo.

**Files:**
- Modify: `.gitignore` (thay toàn bộ nội dung)
- Modify: `.husky/commit-msg:24` (một ký tự trong regex)
- Modify: `.husky/pre-commit` (thay toàn bộ nội dung)

**Interfaces:**
- Produces: hook `pre-commit` tự format file `.dart` staged rồi restage, và chạy `flutter analyze --no-fatal-infos` ở root; bỏ qua sạch khi không có file `.dart` nào staged. Hook `commit-msg` chấp nhận scope có dấu gạch dưới.

- [x] **Step 1: Sửa regex scope trong `.husky/commit-msg`**

Regex hiện tại không cho dấu gạch dưới, trong khi tên package Dart bắt buộc `snake_case` — scope `01_layout_lab` sẽ bị từ chối.

Đổi dòng 24 từ:

```sh
pattern='^(feat|fix|docs|style|refactor|perf|test|chore|revert|ci)(\([a-z0-9-]+\))?: .+$'
```

thành:

```sh
pattern='^(feat|fix|docs|style|refactor|perf|test|chore|revert|ci)(\([a-z0-9_-]+\))?: .+$'
```

- [x] **Step 2: Thay toàn bộ `.gitignore`**

Nội dung hiện tại ignore cả `.claude/` (làm mất CLAUDE.md và skills) và không có dòng nào cho Flutter. Ghi đè bằng:

```gitignore
# Claude — commit chỉ dẫn và skills, chỉ bỏ qua thiết lập máy cá nhân
.claude/settings.local.json

# OS & editor
.DS_Store
*.iml
*.swp
.idea/

# VS Code — commit thiết lập dùng chung, bỏ qua phần còn lại
.vscode/*
!.vscode/settings.json
!.vscode/extensions.json

# Node (chỉ dùng cho husky)
node_modules/

# Dart & Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
build/
**/build/
**/doc/api/
*.log

# Sinh tự động bởi code generation (drift, riverpod — từ M08 trở đi)
*.g.dart
*.freezed.dart

# Android
android/.gradle/
android/local.properties
android/key.properties
**/android/.gradle/
**/android/local.properties
**/android/key.properties
*.jks
*.keystore

# iOS / macOS
**/ios/Pods/
**/ios/.symlinks/
**/ios/Flutter/Flutter.framework
**/ios/Flutter/Flutter.podspec
**/ios/Flutter/ephemeral/
**/macos/Pods/

# Bí mật môi trường
.env
.env.local
```

- [x] **Step 3: Thay toàn bộ `.husky/pre-commit`**

Ba điều đã kiểm chứng bằng thực nghiệm và quyết định hình dạng hook này:

1. `dart format --set-exit-if-changed` **ghi đè file luôn** rồi mới exit 1 — nó không phải chế độ chỉ-kiểm-tra. Nên hook format xong phải `git add` lại, giống lint-staged.
2. `flutter analyze` mặc định coi issue mức **info** là fatal (exit 1). Trong repo học, lint nit như `avoid_print` xuất hiện hợp lệ ở lab. Dùng `--no-fatal-infos` để info không chặn commit, còn warning và error vẫn chặn.
3. **Husky v9 chạy hook bằng `sh -e`** (xem `.husky/_/h:17`). Nghĩa là bất kỳ lệnh nào trả về non-zero đều giết script ngay. `grep` không tìm thấy gì trả về 1 — nên dòng gán `staged_dart` **bắt buộc** phải có `|| true`, nếu không hook chết trước khi kịp kiểm tra biến rỗng. Phát hiện lúc chạy thật ở Task 1.

```sh
#!/usr/bin/env sh

# husky v9 runs this with `sh -e`, so a no-match grep would abort the script
# before the check below. The `|| true` keeps an empty result non-fatal.
staged_dart=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$' || true)

if [ -z "$staged_dart" ]; then
  echo "husky: pre-commit — no dart files staged, skipping"
  exit 0
fi

echo "husky: formatting staged dart files"
echo "$staged_dart" | xargs dart format || {
  echo "husky: commit blocked — dart format failed (syntax error?)"
  exit 1
}
echo "$staged_dart" | xargs git add

echo "husky: running flutter analyze"
flutter analyze --no-fatal-infos || {
  echo ""
  echo "husky: commit blocked — flutter analyze found warnings or errors"
  echo "  (info-level lints do not block; warnings and errors do)"
  exit 1
}

echo "husky: pre-commit ok"
```

- [x] **Step 4: Đảm bảo hook có quyền chạy**

```bash
chmod +x .husky/pre-commit .husky/commit-msg
```

- [x] **Step 5: Kiểm chứng — hook bỏ qua khi không có file Dart**

Run:
```bash
git add .gitignore .husky/commit-msg .husky/pre-commit
git commit -m "chore(repo): fix gitignore and upgrade git hooks"
```
Expected: in ra `husky: pre-commit — no dart files staged, skipping` rồi commit thành công.

- [x] **Step 6: Kiểm chứng — commit-msg chấp nhận scope có gạch dưới**

Run:
```bash
git commit --allow-empty -m "chore(01_layout_lab): verify underscore scope"
```
Expected: commit thành công (trước khi sửa sẽ bị từ chối).

Rồi gỡ commit thử này:
```bash
git reset --hard HEAD~1
```

- [x] **Step 7: Kiểm chứng — commit-msg vẫn chặn message sai**

Run:
```bash
git commit --allow-empty -m "added some stuff"
```
Expected: FAIL với `husky: commit message rejected — must match type(scope): subject`.

- [x] **Step 8: Kiểm chứng — `.claude/` giờ đã được track**

Run: `git status --short .claude/`
Expected: hiện `?? .claude/CLAUDE.md` và `?? .claude/skills/` (chưa track nhưng **không còn bị ignore**).

Chưa add `.claude/` ở bước này — CLAUDE.md sẽ được viết lại ở Task 4.

---

## Task 2: Pub workspace + lab app đầu tiên

Workspace và app đầu tiên đi cùng một task: root `pubspec.yaml` không kiểm chứng được nếu chưa có thành viên nào, và `analysis_options.yaml` ở Task 3 cần `flutter_lints` do app kéo về mới resolve được.

`00_hello_flutter` chính là lab của M00 nên không phải scaffold thừa.

**Files:**
- Create: `pubspec.yaml` (root workspace)
- Create: `apps/00_hello_flutter/` (qua `flutter create`)
- Modify: `apps/00_hello_flutter/pubspec.yaml` (thêm `resolution: workspace`)

**Interfaces:**
- Consumes: hook từ Task 1.
- Produces: root `pubspec.yaml` có khoá `workspace:` — mọi app sau này phải thêm tên mình vào danh sách đó **và** thêm dòng `resolution: workspace` vào pubspec của chính nó. Sau khi resolve, chỉ tồn tại một `pubspec.lock` và một `.dart_tool/` ở root.

- [x] **Step 1: Tạo root `pubspec.yaml`**

Root là workspace root nên **không** có `resolution: workspace` — khoá đó chỉ dành cho thành viên.

```yaml
name: flutter_workspace
description: Learning workspace for Flutter — labs and the userhub capstone.
publish_to: none

environment:
  sdk: ^3.13.0

workspace:
  - apps/00_hello_flutter
```

- [x] **Step 2: Tạo lab app đầu tiên**

`flutter create` **không tự tạo thư mục cha** — thiếu `mkdir` nó sẽ báo `PathNotFoundException`. Phát hiện lúc chạy thật.

```bash
mkdir -p apps
flutter create --template=app --platforms=android,ios --project-name hello_flutter apps/00_hello_flutter
rm apps/00_hello_flutter/analysis_options.yaml
```

Tên package Dart không cho phép chữ số ở đầu, nên thư mục là `00_hello_flutter` còn tên package là `hello_flutter`. Quy ước này áp dụng cho mọi lab về sau.

**Dòng `rm` là bắt buộc, không phải dọn dẹp cho đẹp.** `flutter create` sinh ra một `analysis_options.yaml` riêng trong mỗi app. Dart analyzer dùng file **gần nhất** tính từ file đang phân tích, nên file của app sẽ **đè** file root ở Task 3 và làm cấu hình lint dùng chung trở nên vô nghĩa. Mọi lab app tạo về sau đều phải xoá file này.

Sửa `description:` trong pubspec của app cho khớp vai trò của nó, thay cho `"A new Flutter project."` mặc định.

- [x] **Step 3: Đăng ký app vào workspace**

Trong `apps/00_hello_flutter/pubspec.yaml`, thêm `resolution: workspace` ngay trước khối `environment:`:

```yaml
name: hello_flutter
description: "M00 lab — project anatomy, hot reload, DevTools."
publish_to: 'none'
version: 1.0.0+1

resolution: workspace

environment:
  sdk: ^3.13.0
```

- [x] **Step 4: Kiểm chứng — resolve ở root**

Run: `flutter pub get` (ở root repo)
Expected: kết thúc bằng `Changed N dependencies!` và có dòng
`Deleting old lock-file: ./apps/00_hello_flutter/pubspec.lock` — đó là dấu hiệu workspace đã tiếp quản.

- [x] **Step 5: Kiểm chứng — chỉ còn một lockfile**

Run: `ls pubspec.lock .dart_tool/ && ls apps/00_hello_flutter/pubspec.lock`
Expected: root có `pubspec.lock` và `.dart_tool/`; lệnh thứ hai FAIL với `No such file or directory`.

- [x] **Step 6: Thêm cấu hình VS Code dùng chung**

Tạo `.vscode/settings.json` (format on save cho Dart, `files.watcherExclude` và `search.exclude` cho `build/`, `.dart_tool/`, `ios/Pods/` — với hơn chục Flutter project thì file watcher sẽ quá tải nếu không loại trừ) và `.vscode/extensions.json` (gợi ý `Dart-Code.dart-code`, `Dart-Code.flutter`).

Format on save khiến `require_trailing_commas` luôn đúng tự động, nên hook `pre-commit` gần như không bao giờ phải sửa gì.

Kèm theo, `.gitignore` ở Task 1 đã đổi từ chặn sạch `.vscode/` sang:

```gitignore
.vscode/*
!.vscode/settings.json
!.vscode/extensions.json
```

Kiểm chứng bằng `git add -n .vscode/` — phải thấy đúng hai file. **Không** dùng `git check-ignore -v` để kiểm: khi rule khớp cuối cùng là một dòng phủ định `!`, nó vẫn in ra rule đó và dễ đọc nhầm thành "bị ignore".

- [x] **Step 7: Commit**

```bash
git add pubspec.yaml apps/00_hello_flutter .vscode/
git commit -m "chore(repo): add pub workspace, first lab app and vscode config"

git add pubspec.lock
git commit -m "chore(repo): commit workspace lockfile for reproducible builds"
```

`pubspec.lock` **phải được commit**. Quy ước Dart là chỉ package/plugin mới bỏ qua lockfile; **application thì commit** để build tái lập được. Repo này toàn app, và workspace chỉ sinh một lockfile duy nhất ở root.

---

## Task 3: Lint dùng chung

**Files:**
- Create: `analysis_options.yaml` (root)

**Interfaces:**
- Consumes: `flutter_lints` được `apps/00_hello_flutter` kéo về từ Task 2.
- Produces: một cấu hình lint duy nhất ở root áp cho mọi app trong workspace. `flutter analyze` chạy ở root quét toàn bộ (đã kiểm chứng: sửa lỗi trong `apps/*/lib/` thì analyze ở root báo đúng).

- [x] **Step 1: Tạo `analysis_options.yaml`**

Khối `exclude` là bắt buộc, và **phải chứa đúng các chuỗi literal** `build/**`, `android/**`, `ios/**`, `web/**`, `windows/**`, `macos/**`, `linux/**`. `flutter analyze` dò đúng những chuỗi đó; viết `**/build/**` thôi thì nó không nhận ra và sẽ tự chèn thêm khối của nó vào file, tạo diff bẩn. Nhưng các mẫu `**/...` mới là thứ thật sự có tác dụng, vì app nằm trong `apps/` chứ không ở root — nên cần **cả hai khối**. Phát hiện lúc chạy thật.

Kiểm chứng tính ổn định: chạy `flutter analyze` hai lần, checksum của `analysis_options.yaml` phải không đổi.

```yaml
# Cấu hình lint dùng chung cho toàn workspace.
#
# QUAN TRỌNG 1: `flutter create` sinh ra một analysis_options.yaml riêng trong mỗi
# app. Dart analyzer dùng file GẦN NHẤT tính từ file đang phân tích, nên file của
# app sẽ đè file này. Mỗi lần tạo lab app mới, phải xoá file đó đi.
#
# QUAN TRỌNG 2: `flutter analyze` sẽ TỰ GHI THÊM vào file này nếu không thấy đúng
# các chuỗi literal `build/**`, `android/**`, `ios/**`, `web/**`, `windows/**`,
# `macos/**`, `linux/**`. Giữ nguyên khối đó. Các mẫu `**/...` bên dưới mới là
# thứ thật sự có tác dụng, vì app nằm trong apps/ chứ không nằm ở root.

include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    # Khối Flutter đòi hỏi phải có nguyên văn — đừng xoá.
    - build/**
    - android/**
    - ios/**
    - web/**
    - windows/**
    - macos/**
    - linux/**
    # Khối thật sự phủ được apps/*/ trong workspace.
    - "**/build/**"
    - "**/android/**"
    - "**/ios/**"
    - "**/macos/**"
    - "**/linux/**"
    - "**/windows/**"
    - "**/web/**"
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  language:
    strict-casts: true
    strict-raw-types: true

linter:
  rules:
    - avoid_print
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - require_trailing_commas
    - use_super_parameters
    - unawaited_futures
    - avoid_relative_lib_imports
```

- [x] **Step 2: Kiểm chứng — analyze ở root sạch**

Run: `flutter analyze` (ở root)
Expected: `No issues found!`

- [x] **Step 3: Kiểm chứng — analyze thật sự với tới app con**

Tạo file bẩn tạm thời:
```bash
printf 'void bad( ) { var x = 1; print(x); }\n' > apps/00_hello_flutter/lib/smell.dart
flutter analyze
```
Expected: báo đúng `avoid_print` tại `apps/00_hello_flutter/lib/smell.dart`.

Xoá đi:
```bash
rm apps/00_hello_flutter/lib/smell.dart
flutter analyze
```
Expected: `No issues found!`

- [x] **Step 4: Commit**

```bash
git add analysis_options.yaml
git commit -m "chore(repo): add shared analysis options"
```

---

## Task 4: Docs khung

Năm file này là bộ nhớ dài hạn của workspace. Mỗi phiên Claude là một phiên mới không nhớ gì — thiếu chúng thì mọi quyết định trong spec sẽ bốc hơi sau vài tuần.

**Files:**
- Modify: `.claude/CLAUDE.md` (thay toàn bộ — hiện chỉ có một dòng `# Flutter`)
- Create: `README.md`
- Create: `MISSION.md`
- Create: `PROGRESS.md`
- Create: `docs/roadmap.md`

**Interfaces:**
- Produces: `PROGRESS.md` là nguồn sự thật về vị trí hiện tại; Task 5 (skill) và mọi module sau đều đọc nó trước rồi cập nhật sau.

- [ ] **Step 1: Viết `.claude/CLAUDE.md`** (tiếng Anh, thay toàn bộ file)

````markdown
# Flutter Learning Workspace

## What this repo is

A **learning workspace**, not a product repo. Every directory under `apps/` is a
practice exercise. The owner already knows Dart (see the `dart-roadmap` repo), so
Dart syntax is deliberately out of scope here.

**Read `PROGRESS.md` before starting any module.** It is the source of truth for
where the learner currently is.

## Where things live

| Path | What |
|---|---|
| `apps/NN_*_lab/` | Lab apps — Claude writes these as worked examples |
| `apps/userhub/` | The capstone. The learner's app. See the rule below. |
| `packages/` | Shared code. Created only when a real need appears. |
| `docs/roadmap.md` | The 14-module map, M00 to M13 |
| `docs/modules/NN-*.md` | Per-module brief: goal, task, definition of done |
| `docs/lessons/*.html` | Generated lessons, in Vietnamese |
| `docs/reference/*.html` | Cheat sheets for quick lookup |
| `docs/learning-records/` | Misconceptions worth remembering |
| `PROGRESS.md` | Current position. Read first, update last. |

## The learning loop

Each module runs in cycles of roughly four hours:

1. **Lesson** (~45m) — Claude writes `docs/lessons/NNNN-<slug>.html` in Vietnamese
2. **Lab** (~1h) — Claude writes `apps/NN_*_lab/`; the learner runs it and breaks it
3. **Capstone** (~2h) — **the learner writes** `apps/userhub/`
4. **Review** (~30m) — Claude reviews the diff

### The capstone rule

**Default: `apps/userhub/` belongs to the learner.** When they are stuck you may
suggest a direction, point at the wrong line, write pseudocode, or write an
analogous example *in a different context*. Do not hand them the solution.

**When they ask outright** ("code hộ tui", "viết luôn đi", "write it for me"):
write it **completely**. No `// TODO`, no stubs, no "the rest is up to you". It
must run as-is and follow this repo's conventions. Then add a short section
titled **"Chỗ đáng verify"**: 3-5 bullets naming which decisions were trade-offs
and where bugs are most likely, so their review has something to grab onto.

**Never nag.** Do not ask "are you sure?", do not lecture about learning, do not
keep score of how often they ask. When asked, do it, do it well, stop.

## Language

- Docs, lessons, explanations, README: **Vietnamese**
- Code, identifiers, comments, commit messages, this file: **English**
- Technical terms stay English inside Vietnamese prose: widget, state, provider

## Code conventions

- Files `snake_case.dart`, classes `PascalCase`, members `lowerCamelCase`
- Lab directory `NN_topic_lab`, but the Dart package name drops the digits
  (`apps/03_navigation_lab` holds package `navigation_lab`) — Dart package names
  cannot start with a digit
- `const` wherever the analyzer allows it
- Trailing commas are mandatory. They are what keeps a deeply nested widget tree
  readable after `dart format`.
- Feature-first folder layout starts at **M08**, not before. Until then, flat and
  obvious beats layered and clever.
- Comments explain **why**, never **what**

## Commands

Always run `pub get` from the **repo root** — this is a pub workspace and apps do
not carry their own lockfiles.

| Task | Command |
|---|---|
| Install deps | `flutter pub get` (repo root) |
| Run an app | `cd apps/<dir> && flutter run -d <device>` |
| List devices | `flutter devices` |
| Analyze everything | `flutter analyze` (repo root) |
| Format | `dart format <paths>` |

Adding a new app takes two edits: append its path under `workspace:` in the root
`pubspec.yaml`, and add `resolution: workspace` to the app's own `pubspec.yaml`.

## Commit messages

Enforced by `.husky/commit-msg`, which rejects anything else.

- `type(scope): subject` — **one line**, **70 characters or fewer**, **no body,
  no footer**
- Types: `feat fix docs style refactor perf test chore revert ci`
- **Never add a `Co-Authored-By` trailer** or any other trailer — the hook treats
  it as a body and rejects the commit

| Change | Scope | Example |
|---|---|---|
| Capstone | `userhub` | `feat(userhub): add jwt interceptor` |
| Lab app | app directory name | `feat(03_navigation_lab): add nested routes` |
| Docs, lessons | `m00`–`m13` | `docs(m03): add navigation lesson` |
| Repo infra | `repo` | `chore(repo): enable pub workspace` |

`.husky/pre-commit` formats staged Dart files and re-stages them, then runs
`flutter analyze --no-fatal-infos`. Info-level lints do not block a commit;
warnings and errors do.

## Branching

Work directly on `main`. No pull requests — this is a solo workspace and the
ceremony buys nothing. The one exception is **M08**, the architecture refactor:
branch there so the "before" state survives for comparison. Reading that diff
afterwards is the actual lesson of the module.

## What Claude must NOT do

- Do not bump dependency versions unprompted
- Do not create empty packages "for later" — YAGNI. A `packages/*` entry appears
  only when a third copy-paste has proved the need.
- Do not write tests before M13 unless explicitly asked
- Do not write code in `apps/userhub/` unless explicitly asked (capstone rule)
- Do not reach for a third-party package when the Flutter SDK already covers it
- Do not scaffold lab directories for modules that have not started

## Current state

Read `PROGRESS.md` first. `docs/roadmap.md` holds the full map.
````

- [ ] **Step 2: Viết `MISSION.md`** (tiếng Việt)

```markdown
# Mission

## Vì sao tôi học Flutter

Tôi muốn **tự build và ship được một app cá nhân hoàn chỉnh** — có tài khoản,
gọi API thật, dùng được khi mất mạng, cài được lên máy thật.

Không phải để luyện thi phỏng vấn. Không phải để làm portfolio.

## Tôi đã có gì

- Nắm Dart ở mức tổng quát — xem repo `dart-roadmap`
- Làm được backend với Java Spring Boot; **đã có sẵn API quản lý User hoàn chỉnh**
  ở repo riêng, đó là backend mà capstone sẽ gọi tới
- Quen tư duy quan hệ và SQL

## Tôi chưa có gì

- Chưa từng dựng UI bằng Flutter
- Chưa từng làm state management ở phía client
- Chưa từng release app lên thiết bị thật

## Neo cho mọi bài giảng

Mỗi bài giảng phải trả lời được: *thứ này giúp gì cho việc ship `userhub`?*
Nếu không trả lời được, nó chưa tới lúc cần học.
```

- [ ] **Step 3: Viết `PROGRESS.md`** (tiếng Việt)

```markdown
# Tiến độ

> Claude: đọc file này **trước** khi bắt đầu bất kỳ module nào,
> và cập nhật nó **sau** khi kết thúc mỗi vòng học.

## Đang ở đâu

- **Module hiện tại:** M00 — Khởi động & công cụ
- **Vòng:** chưa bắt đầu
- **Cập nhật lần cuối:** 2026-09-10

## Việc tiếp theo

- [ ] Hoàn thiện toolchain Android + iOS (xem Task 0 của plan scaffold)
- [ ] M00 vòng 1 — giải phẫu project, hot reload vs hot restart
- [ ] M00 vòng 2 — DevTools, khởi tạo `userhub`

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

## Nợ kỹ thuật đang treo

- Chưa có spec API Spring Boot — **cần trước khi vào M05**: danh sách endpoint,
  hình dạng request/response, JWT thuần hay có refresh token.
```

- [ ] **Step 4: Viết `docs/roadmap.md`** (tiếng Việt)

````markdown
# Roadmap — Flutter từ nền tảng tới sản phẩm ship được

14 module, M00 đến M13 (M13 tuỳ chọn). Ước lượng ~50 ngày làm việc với nhịp
3-4h/ngày → khoảng 7-10 tuần.

Mỗi module có hai nửa:

- **Lab** — app nhỏ độc lập trong `apps/`. Claude giảng và code mẫu.
- **Capstone** — người học tự áp dụng vào `apps/userhub/`, không nhìn lại code lab.

Thiết kế đầy đủ và lý do đằng sau từng lựa chọn:
[spec](superpowers/specs/2026-09-10-flutter-learning-workspace-design.md).

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
| 09 | Lưu trữ & offline | 4 | `09_storage_lab` — 4 tầng lưu trữ, `sqflite` thô → `drift`, cache-then-network | Nhớ phiên đăng nhập, xem user offline |
| 10 | Polish & UX | 5 | `10_polish_lab` — Material 3, dark mode, animation, responsive | Theme hệ thống, skeleton loading, animation chuyển màn |
| 11 | Hiệu năng & debug | 3 | `11_perf_lab` — **app cố tình chậm, người học tối ưu** | Đo & tối ưu `userhub` bằng DevTools |
| 12 | Release | 3 | — | Icon, splash native, flavor, ký AAB, build iOS, chạy trên máy thật |
| 13 | *(tuỳ chọn)* Testing & CI | — | — | Mở khoá khi bắt đầu thấy sợ mỗi lần refactor |

## Những lựa chọn có chủ ý

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
  nhất. Đánh đổi có ý thức: refactor ở M08 và M10 sẽ không có lưới an toàn.

## M09 — bốn tầng lưu trữ

SQLite không phải khái niệm của Flutter: nó là database nhúng có sẵn trong cả
Android lẫn iOS — một file `.db` chạy SQL thật, không cần server.

| Cách | Dùng cho | Trong `userhub` |
|---|---|---|
| `shared_preferences` | Key-value bé: dark mode, ngôn ngữ | Lưu setting |
| `flutter_secure_storage` | Bí mật, mã hoá qua Keychain / Keystore | **Lưu JWT** |
| File thường (`path_provider`) | Ảnh cache, file tải về | Avatar cache |
| **SQLite** (`sqflite` → `drift`) | Dữ liệu có cấu trúc, cần query/lọc/sắp xếp | **Cache user để xem offline** |

`shared_preferences` **không phải database** — nó là file XML/plist đọc hết vào
RAM. Nhét vài trăm bản ghi vào đó là phình bộ nhớ và không query nổi.

Lộ trình: học `sqflite` thô trước (~nửa ngày) rồi dùng `drift` cho capstone —
cùng logic với M06 → M07. Chọn `drift` thay Hive/Isar vì đã có sẵn tư duy quan hệ
và SQL từ Spring Boot.
````

- [ ] **Step 5: Viết `README.md`** (tiếng Việt)

````markdown
# Flutter — Không gian luyện tập

Luyện Flutter từ nền tảng tới một sản phẩm ship được, theo 14 module có cấu trúc.

## Repo này là gì

Đây là **workspace học**, không phải một sản phẩm. Mỗi thư mục trong `apps/` là
một bài luyện độc lập. Thứ duy nhất được nuôi lớn dần thành sản phẩm thật là
`apps/userhub/`.

## Tiền đề

Repo này **bỏ qua toàn bộ cú pháp Dart** — không có bài nào dạy `List`, `Future`
hay `class`. Phần đó đã học ở repo trước:
[dart-roadmap](https://github.com/maaitlunghau/dart-roadmap).

Ở đây bắt đầu thẳng từ widget, layout và những thứ chỉ Flutter mới có.

## Roadmap

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

Chi tiết: [docs/roadmap.md](docs/roadmap.md) · Tiến độ: [PROGRESS.md](PROGRESS.md)

## Cấu trúc

```
apps/                 mỗi thư mục là một Flutter project độc lập
  NN_*_lab/           lab của từng module
  userhub/            capstone — app thật, gọi API Spring Boot
packages/             code dùng chung, chỉ sinh ra khi thật sự cần
docs/
  roadmap.md          bản đồ 14 module
  modules/            đề bài và tiêu chí Xong từng module
  lessons/            bài giảng dạng HTML
  reference/          cheat sheet tra nhanh
  learning-records/   những chỗ từng hiểu nhầm
MISSION.md            vì sao học Flutter
PROGRESS.md           đang ở đâu, làm gì tiếp
```

## Bắt đầu

Yêu cầu: Flutter 3.47.0 stable, Dart 3.13.0, macOS với Xcode và Android SDK đầy đủ.

```bash
flutter pub get                  # LUÔN chạy ở root — đây là pub workspace
flutter devices                  # xem thiết bị đang có

cd apps/00_hello_flutter
flutter run -d <device-id>
```

Từ M05 trở đi, capstone cần base URL của API:

```bash
cd apps/userhub
flutter run --dart-define=API_BASE_URL=http://localhost:8080
```

Chép `.env.example` thành `.env` cho thiết lập local. `.env` không được commit.

## Capstone — `userhub`

App quản lý người dùng, gọi tới API Spring Boot ở repo riêng. Đăng nhập bằng JWT,
danh sách và chi tiết user, xem được khi mất mạng, có dark mode, release lên máy
thật ở M12.

Ảnh chụp màn hình sẽ bổ sung dần.

## Tech stack

Flutter 3.47 · Dart 3.13 · Pub workspaces · Riverpod (từ M07) · Dio (M05) ·
go_router (M03) · drift + flutter_secure_storage (M09)

## Quy ước

- Commit: `type(scope): subject` — một dòng, ≤70 ký tự, không body. Hook sẽ chặn.
- Docs và bài giảng viết tiếng Việt; code, comment và commit viết tiếng Anh.
- Thư mục lab đặt `NN_topic_lab`; tên package Dart bỏ phần số ở đầu.
````

- [ ] **Step 6: Kiểm chứng — file tồn tại và link không gãy**

Run:
```bash
ls -1 README.md MISSION.md PROGRESS.md docs/roadmap.md .claude/CLAUDE.md
grep -c "userhub" .claude/CLAUDE.md
```
Expected: liệt kê đủ 5 file; `grep -c` trả về số ≥ 4.

Run:
```bash
grep -o "](.*\.md)" README.md docs/roadmap.md | sed 's/.*](//;s/)//' | while read -r f; do
  base=$(dirname "$(grep -rl "$f" README.md docs/roadmap.md | head -1)")
  [ -f "$base/$f" ] || echo "GÃY: $f"
done
```
Expected: không in ra dòng `GÃY:` nào.

- [ ] **Step 7: Commit**

```bash
git add README.md MISSION.md PROGRESS.md docs/roadmap.md .claude/CLAUDE.md .claude/settings.json .claude/skills
git commit -m "docs(repo): add workspace docs and claude instructions"
```

---

## Task 5: Skill `/flutter-module`

Không có skill này, vòng lặp học chỉ là chữ trong README. Mỗi phiên Claude bắt đầu từ con số không, nên quy trình phải nằm ở chỗ Claude bắt buộc đọc.

**Files:**
- Create: `.claude/skills/flutter-module/SKILL.md`

**Interfaces:**
- Consumes: `PROGRESS.md`, `docs/roadmap.md`, `docs/modules/NN-*.md` từ Task 4 và Task 6.
- Produces: lệnh `/flutter-module <NN>` chạy đúng vòng 4 bước và cập nhật `PROGRESS.md`.

- [ ] **Step 1: Viết `.claude/skills/flutter-module/SKILL.md`**

````markdown
---
name: flutter-module
description: Run one learning cycle of a Flutter module in this workspace. Use when the user says "bắt đầu M03", "/flutter-module 05", "học tiếp", or otherwise asks to start or continue a module.
argument-hint: "<module number, e.g. 03>"
---

# Running a Flutter learning module

## Before anything else

1. Read `PROGRESS.md` — where is the learner right now?
2. Read `docs/roadmap.md` — what does this module cover?
3. Read `docs/modules/<NN>-*.md` — the brief. **If it does not exist, write it
   first** using the template below, and get the learner's agreement before
   teaching.

If the requested module is more than one ahead of the current position in
`PROGRESS.md`, say so and ask whether to skip ahead. Do not silently jump.

## The cycle

One cycle is about four hours. A module takes two to four cycles.

### 1. Lesson (~45 min) — you write

Write `docs/lessons/<NNNN>-<slug>.html` (four digits, increment across the whole
repo, not per module).

- Vietnamese prose, English technical terms
- **Short.** Working memory is small. One tangible win per lesson.
- Beautiful and printable — the learner comes back to these
- Include a diagram when the concept is structural (widget tree, constraint flow)
- End with one primary source: official Flutter docs or Flutter team video.
  Never a random blog.
- Link to related lessons and to `docs/reference/*.html` via anchors

Open it for them: `open docs/lessons/<file>.html`

### 2. Lab (~1 hour) — you write the code

Write into `apps/<NN>_<topic>_lab/`.

Creating a new lab app takes three steps:

```bash
flutter create --template=app --platforms=android,ios \
  --project-name <topic>_lab apps/<NN>_<topic>_lab
```

then add `resolution: workspace` to the new app's `pubspec.yaml`, then append
`apps/<NN>_<topic>_lab` under `workspace:` in the root `pubspec.yaml`, then run
`flutter pub get` **at the repo root**.

The lab is a worked example, so:

- Comments explain **why**, never **what**
- Keep it small enough to read in one sitting
- Tell the learner explicitly what to go break, and what they should see when it
  breaks. "Remove `Expanded` and watch the RenderFlex overflow" teaches more than
  any paragraph.

### 3. Capstone (~2 hours) — the learner writes

Their work happens in `apps/userhub/`. **Follow the capstone rule in
`.claude/CLAUDE.md`.** Short version: by default you guide but do not write it;
when they ask outright, write it completely and add a "Chỗ đáng verify" section;
never nag.

### 4. Review (~30 min)

```bash
git -C . diff HEAD -- apps/userhub
```

Review for: does it work, is it idiomatic Flutter, what will hurt later.

When a misconception is worth remembering, append a record to
`docs/learning-records/<NNNN>-<slug>.md`:

```markdown
# <NNNN> — <title>

**Ngày:** YYYY-MM-DD · **Module:** M<NN>

## Đã tưởng là
## Thực tế là
## Vì sao dễ nhầm
## Dấu hiệu nhận ra lần sau
```

## Closing a module

1. Update `PROGRESS.md`: module status, current cycle, next actions, date
2. Create or refresh a cheat sheet in `docs/reference/`
3. Flip the module's status in `README.md` and `docs/roadmap.md` to ✅
4. Commit — one line, ≤70 chars, scope `m<NN>`

## Module brief template

`docs/modules/<NN>-<slug>.md`:

```markdown
# M<NN> — <Tên module>

## Mục tiêu
(học xong làm được gì — viết bằng động từ hành động)

## Khái niệm cốt lõi
(5-7 gạch đầu dòng)

## Lab
(Claude làm gì, người học quan sát và phá cái gì)

## Capstone task
(người học phải làm gì trong apps/userhub/)

## Tiêu chí Xong
- [ ] (checklist khách quan, tick được, không mơ hồ)

## Bẫy thường gặp
(để trống lúc đầu — điền dần khi thật sự vấp phải)

## Nguồn
(docs chính thống, không phải blog)
```
````

- [ ] **Step 2: Kiểm chứng — skill được nhận diện**

Run: `head -5 .claude/skills/flutter-module/SKILL.md`
Expected: frontmatter có `name: flutter-module` và dòng `description:`.

Trong Claude Code, gõ `/flutter-module` và xác nhận nó hiện trong danh sách skill (có thể phải khởi động lại phiên).

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/flutter-module
git commit -m "feat(repo): add flutter-module skill for learning loop"
```

---

## Task 6: M00 — khởi tạo capstone và đề bài

Task cuối của phần scaffold. Kết thúc task này là học được ngay.

**Blocked by Task 0** ở bước kiểm chứng cuối (cần chạy trên cả Android và iOS).

**Files:**
- Create: `apps/userhub/` (qua `flutter create`)
- Modify: `apps/userhub/pubspec.yaml` (thêm `resolution: workspace`)
- Modify: `pubspec.yaml` (thêm `apps/userhub` vào `workspace:`)
- Create: `docs/modules/00-khoi-dong.md`
- Create: `.env.example`

**Interfaces:**
- Consumes: workspace từ Task 2, lint từ Task 3, docs từ Task 4.
- Produces: `apps/userhub/` với application id `com.maaitlunghau.userhub`, chạy được trên Android và iOS.

- [ ] **Step 1: Tạo capstone**

Đặt `--org` **ngay bây giờ**. Application id đi vào Gradle, `Info.plist`, ký APK và định danh trên store — đổi nó sau M12 là việc rất phiền.

```bash
flutter create --template=app --platforms=android,ios \
  --org com.maaitlunghau --project-name userhub apps/userhub
```

- [ ] **Step 2: Đăng ký vào workspace**

Thêm `resolution: workspace` vào `apps/userhub/pubspec.yaml` ngay trước `environment:`, rồi sửa root `pubspec.yaml`:

```yaml
workspace:
  - apps/00_hello_flutter
  - apps/userhub
```

- [ ] **Step 3: Kiểm chứng resolve và application id**

Run: `flutter pub get` (ở root)
Expected: `Changed N dependencies!`, không có lỗi.

Run: `grep -r "com.maaitlunghau.userhub" apps/userhub/android/app/build.gradle.kts`
Expected: có dòng `applicationId = "com.maaitlunghau.userhub"`.
(Nếu Flutter version này sinh ra `build.gradle` thay vì `build.gradle.kts` thì grep file đó.)

- [ ] **Step 4: Tạo `.env.example`**

```dotenv
# Chép file này thành .env và điền giá trị máy bạn.
# .env không được commit.

# Base URL của API Spring Boot. Emulator Android không dùng được localhost —
# 10.0.2.2 là địa chỉ trỏ về máy host.
API_BASE_URL=http://10.0.2.2:8080
```

- [ ] **Step 5: Viết `docs/modules/00-khoi-dong.md`**

````markdown
# M00 — Khởi động & công cụ

**Thời lượng:** 2 ngày · **Lab:** `apps/00_hello_flutter` · **Capstone:** khởi tạo `apps/userhub`

## Mục tiêu

Học xong module này bạn có thể:

- Chỉ ra được mỗi thư mục trong một Flutter project dùng để làm gì
- Nói được khác biệt giữa hot reload và hot restart, và khi nào cái nào không đủ
- Chạy một app trên cả Android emulator lẫn iOS simulator
- Mở DevTools và đọc được cây widget của app đang chạy

## Khái niệm cốt lõi

- Giải phẫu project: `lib/`, `android/`, `ios/`, `pubspec.yaml`, `.dart_tool/`
- `main()` và `runApp()` — điểm bắt đầu
- `MaterialApp` và `Scaffold` — bộ khung tối thiểu của mọi app
- Hot reload giữ nguyên state; hot restart xoá sạch state. Thay đổi `main()`,
  biến `static`, hay khởi tạo global thì hot reload **không** ăn.
- Pub workspace: `flutter pub get` chạy ở root, apps không có lockfile riêng
- DevTools: Widget Inspector, và nó sẽ còn quay lại ở M11

## Lab

Claude viết `apps/00_hello_flutter` và cùng đọc qua từng thư mục.

Việc của bạn là **phá nó**:

1. Sửa một chuỗi text → hot reload → thấy đổi ngay
2. Sửa `main()` → hot reload → **không** đổi. Hot restart → đổi. Hiểu vì sao.
3. Xoá `Scaffold`, chỉ để lại `Text` trần → xem lỗi hiện ra thế nào
4. Mở DevTools, tìm chính widget `Text` đó trong cây

## Capstone task

Khởi tạo `apps/userhub` và làm nó chạy được trên cả hai nền tảng.

Chưa có tính năng gì cả. Mục tiêu duy nhất của module này là **vòng lặp phát
triển thông suốt** — sửa code là thấy kết quả trong vài giây, trên cả Android
lẫn iOS.

## Tiêu chí Xong

- [ ] `flutter doctor` không còn `[!]` ở Android toolchain và Xcode
- [ ] `flutter devices` liệt kê ít nhất một thiết bị Android và một thiết bị iOS
- [ ] `apps/userhub` chạy được trên Android emulator
- [ ] `apps/userhub` chạy được trên iOS simulator
- [ ] Sửa text trong `userhub` rồi hot reload thấy đổi, không cần restart
- [ ] Mở được DevTools và tìm thấy widget đó trong cây
- [ ] `flutter analyze` ở root báo `No issues found!`
- [ ] Giải thích được bằng lời: vì sao sửa `main()` thì hot reload không ăn

## Bẫy thường gặp

(Điền dần khi thật sự vấp phải.)

## Nguồn

- Flutter — Get started: https://docs.flutter.dev/get-started/install/macos
- Hot reload: https://docs.flutter.dev/tools/hot-reload
- DevTools — Widget Inspector: https://docs.flutter.dev/tools/devtools/inspector
- Pub workspaces: https://dart.dev/tools/pub/workspaces
````

- [ ] **Step 6: Kiểm chứng — chạy trên Android**

Run:
```bash
cd apps/userhub && flutter run -d <android-device-id>
```
Expected: app khởi động trên emulator; console in `Flutter run key commands`. Bấm `r` → `Reloaded ... in Nms`.

- [ ] **Step 7: Kiểm chứng — chạy trên iOS**

Run:
```bash
cd apps/userhub && flutter run -d <ios-device-id>
```
Expected: app khởi động trên simulator. Lần đầu chạy `pod install` nên sẽ lâu.

- [ ] **Step 8: Kiểm chứng — analyze sạch**

Run: `flutter analyze` (ở root)
Expected: `No issues found!`

- [ ] **Step 9: Cập nhật `PROGRESS.md`**

Chuyển "Việc tiếp theo" thành:

```markdown
## Việc tiếp theo

- [x] Hoàn thiện toolchain Android + iOS
- [x] M00 vòng 1 — giải phẫu project, hot reload vs hot restart
- [ ] M00 vòng 2 — DevTools, đọc cây widget
- [ ] Sang M01 — Widget & Layout
```

- [ ] **Step 10: Commit**

```bash
git add apps/userhub pubspec.yaml docs/modules/00-khoi-dong.md .env.example PROGRESS.md
git commit -m "feat(userhub): scaffold capstone app for android and ios"
```

---

## Sau khi xong plan này

Repo đã sẵn sàng. Từ đây mỗi module là một chu kỳ độc lập, chạy bằng
`/flutter-module <NN>`. Không scaffold trước bất cứ thứ gì.

**Nợ còn treo:** spec API Spring Boot cần có trước **M05** — danh sách endpoint,
hình dạng request/response, và JWT thuần hay có refresh token. Việc này quyết định
kiến trúc `packages/api_client` ở M08.
