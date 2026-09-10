# M00 — Khởi động & công cụ

**Thời lượng:** 2 ngày · **Lab:** `apps/00_hello_flutter` · **Capstone:** khởi tạo `apps/userhub`

> **Phạm vi đã điều chỉnh:** module này chạy **Android trước**. Thư mục `ios/`
> đã được sinh sẵn với đúng bundle id, nhưng chưa verify — xem mục
> [iOS — hoãn lại](#ios--hoãn-lại) ở cuối.

## Mục tiêu

Học xong module này bạn có thể:

- Chỉ ra được mỗi thư mục trong một Flutter project dùng để làm gì
- Nói được khác biệt giữa hot reload và hot restart, và khi nào cái nào không đủ
- Chạy một app trên Android emulator
- Mở DevTools và đọc được cây widget của app đang chạy

## Khái niệm cốt lõi

- Giải phẫu project: `lib/`, `android/`, `ios/`, `pubspec.yaml`, `.dart_tool/`
- `main()` và `runApp()` — điểm bắt đầu
- `MaterialApp` và `Scaffold` — bộ khung tối thiểu của mọi app
- Hot reload giữ nguyên state; hot restart xoá sạch state. Thay đổi `main()`,
  biến `static`, hay khởi tạo global thì hot reload **không** ăn.
- Pub workspace: `flutter pub get` chạy ở root, apps không có lockfile riêng
- DevTools: Widget Inspector — sẽ còn quay lại ở M11

## Lab

Claude viết `apps/00_hello_flutter` và cùng đọc qua từng thư mục.

Việc của bạn là **phá nó**:

1. Sửa một chuỗi text → hot reload → thấy đổi ngay
2. Sửa `main()` → hot reload → **không** đổi. Hot restart → đổi. Hiểu vì sao.
3. Xoá `Scaffold`, chỉ để lại `Text` trần → xem lỗi hiện ra thế nào
4. Mở DevTools, tìm chính widget `Text` đó trong cây

## Capstone task

`apps/userhub` đã được khởi tạo sẵn. Việc của bạn là làm nó **chạy được**, và
hiểu rõ đường đi từ lúc gõ `flutter run` tới lúc pixel hiện lên màn hình.

Chưa có tính năng gì cả. Mục tiêu duy nhất của module này là **vòng lặp phát
triển thông suốt** — sửa code là thấy kết quả trong vài giây.

## Tiêu chí Xong

**Toolchain (việc của bạn, ngoài Flutter):**

- [ ] Android Studio → SDK Tools → cài **Android SDK Command-line Tools (latest)**
- [ ] `flutter doctor --android-licenses` — chấp nhận hết
- [ ] `flutter doctor` không còn `[!]` ở dòng Android toolchain
- [ ] Có emulator: `flutter emulators --create --name pixel_dev`
- [ ] `flutter devices` liệt kê ít nhất một thiết bị Android

**Capstone:**

- [ ] `apps/userhub` chạy được trên Android emulator
- [ ] Sửa text trong `userhub` rồi hot reload thấy đổi, không cần restart
- [ ] Mở được DevTools và tìm thấy widget đó trong cây
- [ ] `flutter analyze` ở root báo `No issues found!`
- [ ] Giải thích được bằng lời: vì sao sửa `main()` thì hot reload không ăn

## iOS — hoãn lại

Đã sinh sẵn `apps/userhub/ios/` với `PRODUCT_BUNDLE_IDENTIFIER =
com.maaitlunghau.userhub`. Sinh ngay từ đầu vì `--org` chỉ chốt được lúc
`flutter create`; thêm iOS sau mà quên `--org` thì bundle id thành
`com.example.userhub` và đổi lại rất phiền.

Thư mục đó hiện là **placeholder chưa verify** — chưa từng build lần nào.

Khi nào muốn mở khoá iOS, làm bốn việc rồi tick nốt:

- [ ] Cài Xcode bản đầy đủ từ App Store
- [ ] `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
      và `sudo xcodebuild -runFirstLaunch`
- [ ] `sudo gem install cocoapods`
- [ ] `cd apps/userhub && flutter run -d <ios-simulator>` — lần đầu sẽ chạy
      `pod install` nên khá lâu

## Bẫy thường gặp

*(Điền dần khi thật sự vấp phải.)*

## Nguồn

- Flutter — Get started: https://docs.flutter.dev/get-started/install/macos
- Hot reload: https://docs.flutter.dev/tools/hot-reload
- DevTools — Widget Inspector: https://docs.flutter.dev/tools/devtools/inspector
- Pub workspaces: https://dart.dev/tools/pub/workspaces
