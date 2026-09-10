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

Chi tiết từng module: [docs/roadmap.md](docs/roadmap.md) ·
Tiến độ: [PROGRESS.md](PROGRESS.md) ·
Vì sao học: [MISSION.md](MISSION.md)

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
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

Chép `.env.example` thành `.env` cho thiết lập local. `.env` không được commit.
Emulator Android không dùng được `localhost` — `10.0.2.2` mới là địa chỉ trỏ về
máy host.

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
- Thư mục lab đặt `NN_topic_lab`; tên package Dart bỏ phần số ở đầu, vì tên
  package Dart không được bắt đầu bằng chữ số.
