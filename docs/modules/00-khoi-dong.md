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
3. Xoá `Scaffold`, chỉ để lại `Text` trần → đoán trước xem app có crash không, rồi
   chạy. **Nó không crash** — vì sao thì xem
   [learning record 0001](../learning-records/0001-thieu-scaffold-khong-crash.md)
4. Mở DevTools, tìm chính widget `Text` đó trong cây

## Capstone task

`apps/userhub` đã được khởi tạo sẵn. Việc của bạn là làm nó **chạy được**, và
hiểu rõ đường đi từ lúc gõ `flutter run` tới lúc pixel hiện lên màn hình.

Chưa có tính năng gì cả. Mục tiêu duy nhất của module này là **vòng lặp phát
triển thông suốt** — sửa code là thấy kết quả trong vài giây.

## Tiêu chí Xong

**Toolchain — ĐÃ XONG (2026-09-10):**

- [x] Android SDK Command-line Tools (latest)
- [x] License đã accept — xác nhận bằng build thật, **không** bằng `flutter doctor`
- [x] Gỡ `adb` trùng của Homebrew
- [x] System image `system-images;android-36;google_apis;arm64-v8a` (4.3GB)
- [x] AVD `pixel_dev` — tạo bằng `avdmanager`, không phải `flutter emulators --create`
- [x] `flutter devices` thấy `emulator-5554 • android-arm64 • Android 16 (API 36)`

> `flutter doctor` **vẫn** báo `✗ Android license status unknown`. Đó là báo động
> giả, xem mục Bẫy bên dưới. Đừng đuổi theo nó.

**Capstone:**

- [x] `apps/userhub` chạy được trên Android emulator
- [x] Sửa text trong `userhub` rồi hot reload thấy đổi, không cần restart
- [x] Mở được DevTools và tìm thấy widget đó trong cây
- [x] `flutter analyze` ở root báo `No issues found!`
- [x] Giải thích được bằng lời: vì sao sửa `main()` thì hot reload không ăn

**M00 xong ngày 2026-09-15.** Sản phẩm của module:
[bài 0001](../lessons/0001-giai-phau-project-va-hot-reload.html) ·
[bài 0002](../lessons/0002-devtools-widget-inspector.html) ·
[cheat sheet](../reference/hot-reload-va-devtools.html) ·
[record 0001](../learning-records/0001-thieu-scaffold-khong-crash.md)

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

*Ghi lại từ lần setup thật ngày 2026-09-10.*

### 1. `flutter doctor` nói dối về license

**Triệu chứng:** `✗ Android license status unknown`, kể cả sau khi đã chạy
`flutter doctor --android-licenses` và accept hết.

**Nguyên nhân:** `cmdline-tools` bản mới thay `sdkmanager` bằng **Android CLI** và
**bỏ hẳn cờ `--licenses`** — chạy lệnh đó giờ chỉ in ra
`Warning: The --licenses option is no longer needed`. Flutter 3.47 vẫn gọi cờ cũ,
không đọc được câu trả lời nên ghi "unknown".

**Cách kiểm chứng thật** — build một APK, không tin doctor:

```bash
cd apps/userhub && flutter build apk --debug
```

Nếu thấy `License for package Android SDK Platform NN accepted` thì license ổn.
Cảnh báo trong `flutter doctor` sẽ **còn đó mãi**. Bỏ qua nó.

### 2. `flutter emulators --create` không dùng được

**Triệu chứng:** `No suitable Android AVD system images are available`, kèm gợi ý
cài image `android-27;google_apis_playstore;x86` từ đời nào — dù image đúng đã có
sẵn trong SDK.

**Nguyên nhân:** cùng gốc với bẫy 1 — Flutter hỏi `sdkmanager` kiểu cũ.

**Cách đi vòng** — gọi thẳng công cụ Android, bỏ qua Flutter:

```bash
SDK=~/Library/Android/sdk
# tải image (máy Apple Silicon → arm64-v8a)
"$SDK/cmdline-tools/latest/bin/android" sdk install \
  "system-images/android-36/google_apis/arm64-v8a"
# tạo AVD
echo "no" | "$SDK/cmdline-tools/latest/bin/avdmanager" create avd \
  -n pixel_dev -k "system-images;android-36;google_apis;arm64-v8a" -d pixel_7
```

Tạo xong thì `flutter emulators` **nhận ra bình thường** — Flutter chỉ hỏng ở khâu
tạo, không hỏng ở khâu dùng.

### 3. Tải system image bị đứt → im lặng hỏng

**Triệu chứng:** `avdmanager` báo
`Package ... contains no system images. Valid system image paths are: null`,
trong khi `android sdk list` vẫn liệt kê image đó là **đã cài**.

**Nguyên nhân:** tải bị ngắt giữa lúc giải nén. Thư mục còn `package.xml` và
`vendor.img` nhưng **thiếu `system.img`** — và `package.xml` chính là thứ khiến
`android sdk list` tưởng đã xong.

**Cách nhận ra:** image đầy đủ nặng **~4.3GB**. Kiểm nhanh:

```bash
du -sh ~/Library/Android/sdk/system-images
ls ~/Library/Android/sdk/system-images/android-36/google_apis/arm64-v8a/system.img
```

Dưới 1GB hoặc không có `system.img` là hỏng. Phải **gỡ hẳn rồi cài lại**, cài đè
không ăn thua:

```bash
"$SDK/cmdline-tools/latest/bin/android" sdk remove \
  "system-images/android-36/google_apis/arm64-v8a"
```

### 4. Hai bản `adb` cùng tồn tại

**Triệu chứng:** `flutter doctor` báo `Multiple adb binaries found` — một bản của
Android SDK, một bản cài qua Homebrew cask `android-platform-tools`.

**Vì sao phải sửa:** `adb` chạy một server nền. Hai bản khác version sẽ giết server
của nhau — biểu hiện là thiết bị lúc nhận lúc không, hoặc báo `device offline`.

```bash
brew uninstall --cask android-platform-tools
```

Bản trong `~/Library/Android/sdk/platform-tools/` vẫn còn nguyên, và đó là bản
Flutter dùng. Lưu ý sau khi gỡ thì `adb` không còn trên `PATH` — gõ `adb` trực
tiếp sẽ báo `command not found`. Flutter vẫn chạy bình thường vì nó gọi theo
đường dẫn SDK. Muốn gõ `adb` tay thì thêm vào `~/.zshrc`:

```bash
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
```

### 5. Bàn phím máy thật không gõ được vào emulator

*Ghi thêm ngày 2026-09-14.*

**Triệu chứng:** trong app chạy trên emulator, chạm vào ô nhập thì con trỏ hiện
ra nhưng gõ từ bàn phím Mac **không ăn**. Dán (`Cmd+V`) thì được, xoá bằng nút
trên khung emulator cũng được — chỉ riêng gõ là không.

**Nguyên nhân:** hệ quả trực tiếp của **bẫy 2**. AVD tạo bằng `avdmanager` mặc
định để `hw.keyboard=no`, khác với AVD tạo từ giao diện Android Studio. Không
liên quan gì tới Flutter hay code.

**Cách sửa — phải tắt emulator TRƯỚC:**

```bash
~/Library/Android/sdk/platform-tools/adb emu kill      # 1. tắt hẳn
# 2. sửa hw.keyboard=no thành hw.keyboard=yes
#    trong ~/.android/avd/pixel_dev.avd/config.ini
flutter emulators --launch pixel_dev                   # 3. bật lại
```

**Sửa lúc emulator đang chạy là mất công.** Emulator ghi đè `config.ini` khi
thoát, nên thay đổi của bạn bị nuốt mất.

## Nguồn

- Flutter — Get started: https://docs.flutter.dev/get-started/install/macos
- Hot reload: https://docs.flutter.dev/tools/hot-reload
- DevTools — Widget Inspector: https://docs.flutter.dev/tools/devtools/inspector
- Pub workspaces: https://dart.dev/tools/pub/workspaces
