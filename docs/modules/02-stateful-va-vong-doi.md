# M02 — Stateful & vòng đời

**Thời lượng:** 3 ngày · **Lab:** `apps/02_stateful_lab` · **Capstone:** màn Login trong `userhub` — dựng layout và cho nó sống

> **Gộp capstone của M01.** M01 đóng ngày 2026-09-17 mà chưa làm phần capstone
> (Login + User list tĩnh). Thay vì dựng Login hai lần, M02 dựng **một lần**:
> layout là phần nợ của M01, hiện/ẩn mật khẩu và validate là phần của M02.
> Màn User list để dành tới M03, khi đã có điều hướng để đi tới nó.

## Mục tiêu

Học xong module này bạn có thể:

- Nói được vì sao một `StatefulWidget` phải tách làm **hai class**, và cái nào
  bị vứt đi mỗi lần vẽ lại
- Chọn đúng chỗ đặt code khởi tạo: `initState` hay `build` — và biết hậu quả khi
  chọn sai
- Giải phóng tài nguyên trong `dispose` và chỉ ra được rò rỉ khi quên
- Giải thích vì sao xoá một phần tử khỏi danh sách lại làm **state nhảy sang
  widget khác**, và chữa bằng `Key`
- Dựng một màn Login có ô mật khẩu ẩn/hiện được và báo lỗi khi bỏ trống

## Khái niệm cốt lõi

- **Widget là bản mô tả, `State` là object có vòng đời.** Widget bị vứt đi và
  dựng lại liên tục; `State` sống sót — đây là lý do phải có hai class
- `setState` **không vẽ lại gì cả** — nó đánh dấu `State` bẩn để Flutter xếp lịch
  gọi `build()` ở khung hình sau *(bạn đã thấy tận mắt ở bộ đếm M00)*
- Vòng đời: `createState` → `initState` → `didChangeDependencies` → `build` →
  `didUpdateWidget` → `dispose`
- `initState` chạy **đúng một lần**; `build` chạy **rất nhiều lần**. Đặt nhầm
  việc nặng vào `build` là nguồn gốc của app giật
- **`dispose` không tự động.** `TextEditingController`, `AnimationController`,
  `StreamSubscription`, `Timer` — quên `dispose` là rò rỉ thật
- **`Key`** — cách Flutter quyết định `State` cũ thuộc về widget mới nào. Không
  có `Key`, nó ghép theo **vị trí trong danh sách**, và đó là chỗ sinh bug
- `const` constructor giúp Flutter bỏ qua cả một nhánh khi dựng lại

## Lab

`apps/02_stateful_lab` — Claude viết làm **bản tham chiếu**, ba màn:

1. **Lifecycle Logger** — in ra màn hình mọi callback vòng đời kèm số thứ tự.
   Có nút ép rebuild, đổi tham số widget, và thoát màn. Nhìn một lần là thấy
   `initState` chạy một lần còn `build` chạy liên tục.
2. **Key Trap** — hai danh sách ô màu giống hệt nhau, một bên có `Key` một bên
   không. Xoá phần tử đầu và xem state nhảy sai chỗ ở danh sách không có `Key`.
3. **Dispose Leak** — một `Timer` chạy nền. Bật/tắt việc gọi `dispose` để thấy
   nó tiếp tục chạy sau khi đã thoát màn.

## Tự dựng lại — `apps/practice/lib/m02/`

Đề bài từng màn nằm ở cuối mỗi vòng bên dưới. Nguyên tắc giữ nguyên: mô tả
**hành vi và tiêu chí Xong**, không mô tả code; chỉ mở lab khi bí.

> Bước này là **mặc định**, làm đủ trừ khi người học nói bỏ. M01 vòng 2 đã bỏ một
> lần theo yêu cầu; quyết định đó không áp dụng tiếp cho M02.

### Vòng 1 — hai màn

*Bài giảng: [0005 — Vòng đời của State](../lessons/0005-vong-doi-cua-state.html).*

**Màn 1 — đếm callback**

Một widget con hiện **số lần** mỗi callback vòng đời đã chạy: `initState`,
`didChangeDependencies`, `didUpdateWidget`, `build`. Màn cha có hai nút: một nút
ép dựng lại, một nút đổi tham số truyền xuống con.

- Tiêu chí: bấm "ép rebuild" 5 lần → `build` tăng 5, `initState` **vẫn là 1**
- Tiêu chí: bấm "đổi tham số" → `didUpdateWidget` tăng, `initState` **không** tăng
- Tiêu chí: thoát màn rồi vào lại → mọi số về 1, và `dispose` in ra console
- Gợi ý duy nhất: biến đếm phải sống ở đâu để không bị reset mỗi lần vẽ?

**Màn 2 — để nó rò rỉ**

Một màn con chạy `Timer.periodic` mỗi giây, in ra console. Màn cha có công tắc
quyết định `dispose` **có** gọi `timer.cancel()` hay không.

- Tiêu chí: tắt công tắc, mở màn con, thoát ra → console **vẫn đếm tiếp**
- Tiêu chí: bật công tắc, làm lại → console im bặt ngay khi thoát
- Tiêu chí: chỉ ra được vì sao cần kiểm tra `mounted` trước khi gọi `setState`
  trong callback của `Timer`
- Bằng chứng nằm ở **console**, không phải trên màn hình. Đừng tìm trên UI

## Chia vòng

3 ngày, 2 vòng học:

| Vòng | Nội dung | Ra cái gì |
|---|---|---|
| 1 | Vòng đời, `setState`, `dispose` | bài `0005` + lab Lifecycle Logger, Dispose Leak |
| 2 | `Key` — vì sao state nhảy sang widget khác | bài `0006` + lab Key Trap + capstone Login |

## Capstone task

Trong `apps/userhub/`, dựng **màn Login** hoàn chỉnh về mặt giao diện và tương
tác cục bộ:

- Tiêu đề, ô email, ô mật khẩu, nút Đăng nhập, dòng "Quên mật khẩu"
- **Ô mật khẩu có nút con mắt** để ẩn/hiện ký tự
- Bấm Đăng nhập khi ô còn trống → hiện lỗi dưới ô đó

Chưa gọi API (M05). Chưa `Form`/`TextFormField` với `validator` (M04) — module
này validate bằng tay để bạn thấy rõ phần `Form` ở M04 tiết kiệm được cái gì.
Chưa điều hướng (M03).

## Tiêu chí Xong

- [ ] Màn Login dựng xong, không overflow khi xoay ngang và khi bật cỡ chữ lớn
- [ ] Nút con mắt đổi qua lại được giữa ẩn và hiện mật khẩu
- [ ] Bỏ trống rồi bấm Đăng nhập → hiện lỗi; gõ vào → lỗi biến mất
- [ ] `TextEditingController` được `dispose` — chỉ ra được dòng code làm việc đó
- [ ] Giải thích được bằng lời: vì sao `StatefulWidget` phải tách làm hai class
- [ ] Giải thích được bằng lời: `Key` chữa được chuyện gì
- [ ] `flutter analyze` ở root báo `No issues found!`

## Bẫy thường gặp

*(để trống — điền dần khi thật sự vấp phải)*

## Nguồn

- Flutter — `StatefulWidget`:
  https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
- Flutter — `State`: https://api.flutter.dev/flutter/widgets/State-class.html
- Flutter — Using keys: https://docs.flutter.dev/resources/architectural-overview
- Widget of the Week (kênh YouTube chính chủ đội Flutter) — tìm tập về `Key`.
  Không ghi link trực tiếp vì chưa kiểm chứng được ID video.
