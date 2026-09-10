# PROJECT STATE — Dart Self-Study

**Last synced commit:** `c903565`
**Last synced:** 2026-09-10
**Repo:** `/Users/maaitlunghau/Documents/SelfStudy/dart` · branch `main` · working tree sạch, đã push

> Cập nhật file này khi HEAD tiến lên đáng kể hoặc khi có quyết định mới.
> Quy tắc làm việc chi tiết nằm ở `.claude/CLAUDE.md` — **đọc file đó trước**.
> Không chép lại nội dung `README.md` / `docs/ROADMAP.md` — chỉ trỏ đường dẫn.

---

## Mục tiêu

Tự học Dart bài bản từ nền, đích đến là học Flutter đúng gốc rễ. Repo qua 2 giai đoạn (chi tiết ở
`README.vi.md`):

- **Giai đoạn 1** — luyện thi theo pattern, code chủ yếu AI sinh, kiến thức không đọng. Đóng băng
  trong `_archive/`.
- **Giai đoạn 2** — học theo `docs/ROADMAP.md`. **Đã hoàn thành.**

---

## Trạng thái: ROADMAP XONG 21/21

| Hạng mục | Số liệu |
|---|---|
| Mục hoàn thành | **21/21** (Tier 0→3) |
| File Dart | **27** |
| `dart analyze` toàn repo | **No issues found!** |
| Unit test (mục 18) | **9 test, all passed** |
| Commit trong session 2026-09-08→10 | 76 |

Ngày hoàn thành từng mục ghi trong bảng tổng quan `docs/ROADMAP.md`.

### 5 lỗ hổng từ bài chẩn đoán mục 00 — đã vá hết

Mục 00 (`00_gap_check/`) là 2 bài trắc nghiệm về code `_archive/`, làm không mở lại code.
Kết quả **42/51**. Năm lỗ hổng và nơi vá:

| Lỗ hổng | Vá ở mục |
|---|:---:|
| `extends` abstract → **bắt buộc** override | 05 |
| Named parameter phải gọi kèm tên | 02 |
| `late` ≠ nullable | 03 |
| Khoá `Map` · `Iterable` lazy | 06 |
| `on X` chỉ bắt đúng X | 09 |
| Logic dính I/O → không test được | 18 |

**Phát hiện quan trọng nhất:** hiệu chuẩn tự tin của người dùng bị **ngược** — 7 câu ghi "Chắc" thì
sai, 6 câu ghi "Đoán" thì đúng. Đây là lý do quy trình verify (đọc output, không tin cảm giác) phải
giữ nghiêm ở mọi session sau.

---

## Quyết định đã chốt trong session này

| Quyết định | Nội dung |
|---|---|
| Cấu trúc package | **Một `pubspec.yaml` ở root** (`dart_selfstudy`), không phải 21 package riêng. `_archive/*` giữ pubspec riêng |
| Lint | `package:lints/recommended` + `prefer_single_quotes`, `exclude: _archive/**` |
| Chính sách AI | Gỡ luật "không code hộ" → AI đưa code tham khảo, người dùng tự gõ (xem `.claude/CLAUDE.md`) |
| Mục 00 | Đổi từ ghi chú tự luận sang 2 bài trắc nghiệm; **phần tự luận cố ý bỏ** để rút ngắn |
| Mục 18 | Dựng thành **package độc lập** `student_manager` làm template phân tầng, không phải file demo |
| Test | Chỉ mục 18 có test thật (9 test). Các mục khác dùng `print` — người dùng đã cân nhắc và chọn vậy |

---

## Quy ước commit (tóm tắt — chi tiết ở `.claude/CLAUDE.md`)

`.husky/commit-msg` chặn cứng: **một dòng, ≤70 ký tự, `type(scope): subject`, không body, không
trailer**. `type` ∈ `feat fix docs style refactor perf test chore revert ci`.

Gọi skill `writing-commit-messages` trước khi commit. Người dùng tự push.

---

## Việc còn treo

1. **Đổi tên repo GitHub.** Hiện là `dart`, người dùng muốn tên chuyên nghiệp hơn. Đã đề xuất:
   `dart-roadmap` (khuyến nghị), `dart-before-flutter`, `dart-groundwork`. **Chưa chốt.**
   Nếu đổi: `git remote set-url origin https://github.com/maaitlunghau/<tên-mới>.git`
2. **Description + topics GitHub** — đã soạn sẵn, chưa rõ đã dán lên chưa:
   > `Hands-on Dart self-study: 21 topics from syntax to streams and isolates, each with runnable code — built as a solid foundation for Flutter.`
   
   Topics: `dart` `dart-lang` `flutter` `learning-dart` `self-study` `roadmap` `educational`
   `examples` `null-safety` `async-await` `streams` `isolates` `generics` `oop` `mixins`
   `sealed-classes` `unit-testing`
3. **`note.txt`** — file ghi chú cá nhân, thỉnh thoảng có thay đổi chưa commit. Không tự ý sửa.

---

## Hướng đi tiếp theo (chưa được yêu cầu)

Roadmap có phần *"Sau roadmap này"* ở cuối `docs/ROADMAP.md` — 5 cầu nối sang Flutter, mỗi cái trỏ
về mục đã học. Các khả năng:

- Bắt đầu học Flutter, dùng repo này làm tham chiếu
- Bổ sung test cho các mục 01–17 (hiện chỉ có `print`)
- Làm lại phần tự luận mục 00 đã bỏ (5 câu gốc trong `docs/ROADMAP.md`)

**Đừng tự quyết** — hỏi người dùng.

---

## Lưu ý về chính file này

`.claude/` nằm trong `.gitignore` → file này và `.claude/CLAUDE.md` **không được commit**, chỉ tồn
tại trên máy local. Clone repo ở máy khác sẽ không có chúng.
