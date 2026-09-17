# M01 — Widget & Layout

**Thời lượng:** 5 ngày · **Lab:** `apps/01_layout_lab` · **Capstone:** dựng tĩnh màn Login và màn User list trong `userhub`, data hardcode

> **Module dài nhất nửa đầu roadmap, và cố ý dài.** Đây là chỗ người học Flutter
> mắc kẹt lâu nhất. Biết Dart không giúp được gì ở đây — layout là một hệ thống
> hoàn toàn mới, không giống CSS, không giống Swing, không giống gì bạn đã dùng.

## Mục tiêu

Học xong module này bạn có thể:

- **Dự đoán** kích thước một widget sẽ ra sao **trước khi** chạy app
- Đọc lỗi `RenderFlex overflow` và sửa đúng chỗ, không thử mò từng widget
- Chọn đúng giữa `Row` / `Column` / `Stack` / `Expanded` / `Flexible` cho một
  layout cho trước, và nói được vì sao không chọn cái kia
- Giải thích vì sao `Container` rỗng thì chiếm hết màn hình, nhưng bọc nó trong
  `Center` thì lại biến mất
- Dựng hai màn hình tĩnh khớp thiết kế, không lỗi overflow ở mọi kích thước máy

## Khái niệm cốt lõi

- **Luật ba câu:** *Constraints đi xuống. Sizes đi lên. Parent đặt vị trí.*
  Toàn bộ module này là hệ quả của ba câu đó.
- `BoxConstraints` — `minWidth/maxWidth/minHeight/maxHeight`. Phân biệt
  **tight** (min = max, con không có quyền chọn) và **loose** (min = 0, con tự
  quyết trong giới hạn)
- `Row` và `Column` đều là `Flex` — `mainAxisAlignment` vs `crossAxisAlignment`,
  và `mainAxisSize` quyết định co hay giãn
- `Expanded` / `Flexible` / `Spacer` — chia phần không gian **còn lại**.
  `Expanded` là `Flexible(fit: FlexFit.tight)`, không phải thứ gì khác
- `Stack` + `Positioned` — chồng lớp, và cái bẫy `Positioned` ngoài `Stack`
- `SizedBox` vs `Padding` vs `Container` — khi nào cái nào, và vì sao
  `Container` là con dao Thuỵ Sĩ nên thường là lựa chọn tệ
- **Unbounded constraints** — vì sao `ListView` trong `Column` thì nổ, và vì sao
  thông báo lỗi lại nói về "viewport"

## Lab

`apps/01_layout_lab` — một app nhiều màn nhỏ, mỗi màn cô lập **đúng một** hiện
tượng. Claude viết, bạn chạy và phá.

Việc của bạn là phá, theo đúng thứ tự này:

1. Bỏ `Expanded` ra khỏi một `Row` đang vừa khít → **sọc vàng đen** và
   `RenderFlex overflowed by N pixels`. Đọc con số N, đối chiếu với chiều rộng máy
2. Đổi `mainAxisSize` từ `max` sang `min` trên một `Column` → xem nó co lại
3. Đặt một `ListView` thẳng vào `Column` → `Vertical viewport was given unbounded
   height`. Đây là lỗi bạn sẽ gặp lại cả trăm lần trong đời Flutter
4. Bọc một `Container` **không kích thước** trong `Center` → nó biến mất. Bỏ
   `Center` đi → nó chiếm hết màn hình. Cùng một `Container`
5. Bấm `p` trong `flutter run` để bật `debugPaintSizeEnabled`, làm lại bước 1
   và 4 → giờ nhìn thấy khung thật của từng widget

## Tự dựng lại — `apps/practice/lib/m01/`

*Từ 2026-09-15, bước "phá lab" được thay bằng bước này. Lý do: đọc code người
khác viết thì chán và trôi tuột; tự dựng thì va vào đúng những chỗ khó.*

**Luật:** đọc `apps/01_layout_lab/` **chỉ khi bí**, và chỉ mở đúng file đang bí.
Dựng xong rồi mới mở ra so — lúc đó so mới có nghĩa.

### Màn 1 — thước đo constraints

Dựng một widget nhận vào một `label`, và hiện ra **bốn con số constraints** mà
chính nó nhận được, kèm trạng thái `tight` / `loose` / `unbounded`.

- Gợi ý duy nhất: có một widget của Flutter đưa `BoxConstraints` vào tay bạn.
  Tìm nó trong bài 0003.
- Xong màn này thì hai màn sau dùng lại nó.

### Màn 2 — ô vuông lúc phủ kín lúc 100×100

Một `Container(width: 100, height: 100)` **duy nhất, không đổi**, và một công
tắc bật/tắt việc bọc nó trong `Center`.

- Tiêu chí: code của ô vuông không được đổi một chữ khi gạt công tắc
- Đặt thước đo của màn 1 ở dưới, bọc y hệt cách bọc ô vuông

### Màn 3 — cùng một `SizedBox` dưới hai loại constraints

Hai cột cạnh nhau, dùng **chung một** `SizedBox(width: 50, height: 50)`. Một bên
bọc bằng widget đưa xuống loose, bên kia bằng widget đưa xuống tight.

- Tiêu chí: bên loose ra đúng 50×50, bên tight bị phình bằng khung cha
- **Không được hardcode chiều cao cho thước đo** — đó đúng là lỗi lab đã mắc
  phải và phải sửa ngày 2026-09-15

### Vòng 2 — thêm ba màn nữa

*Bài giảng: [0004 — Flex & lỗi tràn](../lessons/0004-flex-va-loi-tran.html).
Lab tham chiếu: ba màn mới trong `apps/01_layout_lab`.*

**Màn 4 — tự tay làm nó tràn**

Một `Row` chứa N ô cùng bề rộng cố định, có nút thêm/bớt ô. Đầu màn hiện sẵn
phép tính: *tổng bề rộng · chỗ có · thừa hay tràn bao nhiêu*.

- Tiêu chí: khi sọc vàng đen hiện ra, con số bạn tính phải **khớp đúng** với con
  số trong `RenderFlex overflowed by N pixels`
- Cạm bẫy đã biết: `margin` cũng chiếm chỗ trên trục chính. Dùng `margin` mà quên
  cộng vào thì phép tính lệch — đây là lỗi lab đã mắc phải và phải sửa
- Thêm một công tắc: bọc ô cuối bằng `Expanded` → hết tràn. Nói được vì sao

**Màn 5 — `Expanded` vs `Flexible` vs `Spacer`**

Cùng **một** ô xin 60px, đặt dưới bốn cách bọc: trần · `Flexible` · `Expanded` ·
`Spacer`.

- Tiêu chí: nhìn một lần là thấy `Expanded` bị kéo giãn còn `Flexible` giữ 60
- Gợi ý duy nhất: mở `basic.dart` trong SDK, tìm `class Expanded`. Khác biệt nằm
  gọn trong một dòng

**Màn 6 — `ListView` trong `Column`**

Dựng màn chạy được với `ListView` cuộn bên trong `Column`, và cho phép đổi qua
lại giữa hai cách chữa.

- Tiêu chí: hiểu được vì sao `Expanded` là cách dùng cho hầu hết trường hợp, còn
  `shrinkWrap: true` chỉ hợp với danh sách ngắn
- **Màn phải ship ở trạng thái chạy được.** Muốn xem nó nổ thì để một dòng
  comment sẵn kèm chú thích, bỏ comment khi cần rồi comment lại

### Xong khi nào

- [ ] Ba màn chạy được, vào từ `M01Menu`
- [ ] `flutter analyze` ở root báo `No issues found!`
- [ ] Không màn nào overflow khi xoay ngang
- [ ] Mở `01_layout_lab` ra so, và **nói được một chỗ mình làm khác** — khác
      không có nghĩa là sai

## Capstone task

Trong `apps/userhub/`, dựng **hai màn hình tĩnh**:

**Màn Login** — logo/tiêu đề, ô email, ô mật khẩu, nút Đăng nhập, dòng "Quên mật
khẩu". Chưa cần `TextField` hoạt động thật, chưa validate — đó là M04.

**Màn User list** — danh sách người dùng, mỗi dòng có avatar, tên, email. Data
**hardcode** trong một `List` ngay trong file. Chưa gọi API — đó là M05.

Chưa cần điều hướng giữa hai màn — đó là M03. Tạm thời đổi `home:` bằng tay để
xem từng màn.

**Phạm vi có chủ ý:** module này chỉ làm **hình**. Mọi thứ động đều thuộc module
sau. Làm lố sang phần động là tự làm khó mình.

## Tiêu chí Xong

- [ ] Hai màn dựng xong, **không lỗi overflow** khi xoay ngang và khi bật
      font lớn trong Settings của máy
- [ ] Trong màn User list, dòng dài không đẩy vỡ layout — tên và email dài bất
      thường thì cắt bằng `TextOverflow.ellipsis`, không tràn
- [ ] Không dùng kích thước cứng cho chiều rộng — không có `width: 320` nào
      trong code
- [ ] Giải thích được bằng lời: vì sao `Center` làm `Container` co lại
- [ ] Giải thích được bằng lời: `Expanded` khác `Flexible` chỗ nào
- [ ] `flutter analyze` ở root báo `No issues found!`

## Chia vòng

5 ngày, 3 vòng học:

| Vòng | Nội dung | Ra cái gì |
|---|---|---|
| 1 | Luật ba câu, `BoxConstraints`, tight vs loose | bài giảng + lab phần 1 |
| 2 | `Flex`: `Row`/`Column`/`Expanded`/`Flexible`, đọc lỗi overflow | bài giảng + lab phần 2 |
| 3 | `Stack`, `Positioned`, và dựng 2 màn capstone | bài giảng + capstone + review |

## Bẫy thường gặp

*(để trống — điền dần khi thật sự vấp phải)*

## Nguồn

- Flutter — Understanding constraints:
  https://docs.flutter.dev/ui/layout/constraints
- Flutter — Layout tutorial: https://docs.flutter.dev/ui/layout/tutorial
- Flutter — Dealing with box constraints:
  https://docs.flutter.dev/ui/layout/constraints#box-constraints
- Widget of the Week (kênh YouTube chính chủ đội Flutter) — tìm các tập
  `Expanded`, `Flexible`, `Stack`, `Spacer`. Không ghi link trực tiếp ở đây vì
  chưa kiểm chứng được từng ID video.
