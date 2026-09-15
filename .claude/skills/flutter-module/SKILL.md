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
   first** using the template at the bottom of this file, and get the learner's
   agreement before teaching.

If the requested module is more than one ahead of the current position in
`PROGRESS.md`, say so and ask whether to skip ahead. Do not silently jump.

## The cycle

One cycle is about four hours. A module takes two to four cycles.

### 1. Lesson (~45 min) — you write

Write `docs/lessons/<NNNN>-<slug>.html`. Four digits, incrementing across the
whole repo rather than per module.

- Vietnamese prose, English technical terms
- **Short.** Working memory is small. One tangible win per lesson.
- Beautiful and printable — the learner comes back to these
- Include a diagram when the concept is structural (widget tree, constraint flow)
- End with one primary source: official Flutter docs or a Flutter team video.
  Never a random blog.
- Link to related lessons and to `docs/reference/*.html` via anchors

Open it for them: `open docs/lessons/<file>.html`

### 2. Lab (~1 hour) — you write the code

Write into `apps/<NN>_<topic>_lab/`. Creating the app:

```bash
mkdir -p apps
flutter create --template=app --platforms=android,ios \
  --project-name <topic>_lab apps/<NN>_<topic>_lab
rm apps/<NN>_<topic>_lab/analysis_options.yaml
```

Then add `resolution: workspace` to the new app's `pubspec.yaml`, append
`apps/<NN>_<topic>_lab` under `workspace:` in the root `pubspec.yaml`, and run
`flutter pub get` **at the repo root**.

The `rm` is required, not tidying: `flutter create` writes a per-app
`analysis_options.yaml`, and the analyzer uses the nearest one — leaving it there
silently disables the shared lint config for that app.

The lab is a worked example, so:

- Comments explain **why**, never **what**, and are written **in Vietnamese**
  (identifiers stay English — see the Language rule in `.claude/CLAUDE.md`)
- Keep it small enough to read in one sitting
- The lab is a **reference implementation**, not a toy to break. The learner
  rebuilds it themselves in step 3 and opens the lab only when stuck.

### 3. Rebuild (~1 hour) — the learner writes

Their work happens in `apps/practice/lib/m<NN>/`. **The capstone rule covers this
directory too** — you create the app shell and the module menu, nothing else.

What you write instead is the **task list**: a *"Tự dựng lại"* section in
`docs/modules/<NN>-*.md` describing each screen by its behaviour and its done
criteria, never by its code. One hint per screen, maximum.

Decide per module whether this step applies. Skip it where the lab exists to be
read rather than rebuilt — M11's deliberately-slow app is the clear case — and
write that decision into the brief.

### 4. Capstone (~2 hours) — the learner writes

Their work happens in `apps/userhub/`. **Follow the capstone rule in
`.claude/CLAUDE.md`.** Short version: by default you guide but do not write it;
when they ask outright, write it completely and add a "Chỗ đáng verify" section;
never nag.

### 5. Review (~30 min)

```bash
git diff HEAD -- apps/practice apps/userhub
```

Review for three things, in this order: does it work, is it idiomatic Flutter,
what will hurt later.

When a misconception is worth remembering, append a record to
`docs/learning-records/<NNNN>-<slug>.md`:

```markdown
# <NNNN> — <tiêu đề>

**Ngày:** YYYY-MM-DD · **Module:** M<NN>

## Đã tưởng là
## Thực tế là
## Vì sao dễ nhầm
## Dấu hiệu nhận ra lần sau
```

## Closing a module

1. Update `PROGRESS.md`: module status, current cycle, next actions, date
2. Create or refresh a cheat sheet in `docs/reference/`
3. Flip the module's status to ✅ in **both** `README.md` and `docs/roadmap.md`
4. Commit — one line, ≤70 chars, scope `m<NN>`

## Module brief template

Write to `docs/modules/<NN>-<slug>.md`:

```markdown
# M<NN> — <Tên module>

**Thời lượng:** N ngày · **Lab:** `apps/<NN>_<topic>_lab` · **Capstone:** <một dòng>

## Mục tiêu
(học xong làm được gì — viết bằng động từ hành động, không phải "hiểu về X")

## Khái niệm cốt lõi
(5-7 gạch đầu dòng)

## Lab
(Claude làm gì, người học quan sát và phá cái gì)

## Tự dựng lại
(đề bài từng màn cho apps/practice/lib/mNN/ — mô tả hành vi và tiêu chí Xong,
không bao giờ mô tả code. Tối đa một gợi ý mỗi màn. Bỏ mục này nếu module đó
không hợp để dựng lại, và ghi rõ vì sao.)

## Capstone task
(người học phải làm gì trong apps/userhub/)

## Tiêu chí Xong
- [ ] (checklist khách quan, tick được, không mơ hồ)

## Bẫy thường gặp
(để trống lúc đầu — điền dần khi thật sự vấp phải)

## Nguồn
(docs chính thống, không phải blog)
```
