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

Run a cycle with `/flutter-module <NN>`.

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

### Adding a new app

Four steps, and **none of them is optional**:

```bash
mkdir -p apps                                    # flutter create won't make parents
flutter create --template=app --platforms=android,ios \
  --project-name <topic>_lab apps/<NN>_<topic>_lab
rm apps/<NN>_<topic>_lab/analysis_options.yaml   # see below
```

then add `resolution: workspace` to the new app's `pubspec.yaml`, append
`apps/<NN>_<topic>_lab` under `workspace:` in the root `pubspec.yaml`, and run
`flutter pub get` at the repo root.

**The `rm` matters.** `flutter create` writes a per-app `analysis_options.yaml`,
and the Dart analyzer uses the *nearest* one — so it silently overrides the shared
config at the repo root and the workspace lint rules stop applying to that app.

Do not hand-edit the root `analysis_options.yaml` exclude list. `flutter analyze`
looks for the literal strings `build/**`, `android/**`, `ios/**`, `web/**`,
`windows/**`, `macos/**`, `linux/**` and rewrites the file if they are missing.
The `**/...` patterns beside them are the ones that actually reach into `apps/`.

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
