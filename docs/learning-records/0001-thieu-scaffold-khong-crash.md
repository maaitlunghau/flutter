# 0001 — Thiếu `Scaffold` không làm app crash

**Ngày:** 2026-09-15 · **Module:** M00

## Đã tưởng là

Bỏ `Scaffold` đi, chỉ trả về một `Text` trần, thì app sẽ **ném lỗi** — red screen
hoặc exception kiểu `No Material widget found`. Đề bài M00 cũng viết là *"xem lỗi
hiện ra thế nào"*, nên càng dễ tin.

## Thực tế là

App **chạy bình thường, không có exception nào**. Cái hiện ra là chữ đỏ, cỡ 48,
font monospace, đậm hết cỡ, **gạch chân đôi màu vàng**, nằm sát góc trên trái trên
nền đen.

Đó không phải lỗi. Đó là một `TextStyle` **được Flutter cố tình thiết kế cho xấu**
để bạn không thể không nhìn thấy. Nó có tên hẳn hoi trong SDK:

`packages/flutter/lib/src/material/app.dart:45`

```dart
const TextStyle _errorTextStyle = TextStyle(
  color: Color(0xD0FF0000),
  fontFamily: 'monospace',
  fontSize: 48.0,
  fontWeight: FontWeight.w900,
  decoration: TextDecoration.underline,
  decorationColor: Color(0xFFFFFF00),
  decorationStyle: TextDecorationStyle.double,
  debugLabel: 'fallback style; consider putting your text in a Material',
);
```

Ngay trên nó là comment của chính đội Flutter:

> *"[MaterialApp] uses this [TextStyle] as its [DefaultTextStyle] to encourage
> developers to be intentional about their [DefaultTextStyle]. […] If you're
> seeing text that uses this text style, consider putting your text in a
> [Material] widget."*

Chuỗi mắt xích đầy đủ, kiểm chứng được bằng cách mở đúng ba file:

| Bước | Ở đâu |
|---|---|
| `MaterialApp` truyền style xấu xuống làm mặc định | `material/app.dart:1091` — `textStyle: _errorTextStyle` |
| `Scaffold` chứa một `Material` | — |
| `Material` đè lại bằng `theme.textTheme.bodyMedium` | `material/material.dart:476` — `AnimatedDefaultTextStyle` |

Bỏ `Scaffold` là cắt mắt xích thứ ba. Không ai đè lên style xấu nữa, nên nó lộ ra.

Hai thứ khác cùng biến mất, cùng một nguyên nhân:

- **Nền đen** — `Scaffold` là thứ vẽ `colorScheme.surface`. Không có nó thì không
  ai vẽ nền cả.
- **Chữ dính góc trên trái** — căn giữa, `AppBar`, safe area đều là slot của
  `Scaffold`, không phải mặc định của Flutter.

## Vì sao dễ nhầm

Người quen backend đọc "thiếu dependency" ra "crash". Nhưng Flutter phân biệt rõ
hai loại hỏng:

- **Hỏng hợp đồng layout** → ném thật. `Scaffold` đứng ngoài `MaterialApp`, hay
  `Expanded` đứng ngoài `Flex`, là exception ngay.
- **Thiếu thứ có giá trị mặc định** → chạy tiếp, dùng mặc định. `DefaultTextStyle`
  và màu nền thuộc loại này.

`Text` không **cần** `Material` để tồn tại. Nó chỉ cần một `DefaultTextStyle`, mà
`MaterialApp` thì luôn cung cấp một cái — chỉ là cái nó cung cấp được làm cho xấu
có chủ đích.

## Dấu hiệu nhận ra lần sau

**Thấy chữ đỏ 48px gạch chân vàng đôi = quên bọc `Material`.** Không phải bug, không
phải font hỏng, không phải theme sai. Chỉ là chưa có widget nào đặt
`DefaultTextStyle`.

Hay gặp nhất ở ba chỗ: `Text` đặt thẳng vào `MaterialApp.home` không qua `Scaffold`
· `Text` bên trong một `Overlay` hoặc route tự dựng tay · `Text` nằm trong
`showDialog` mà builder quên `Material`.

Cách kiểm chứng chắc chắn trong 5 giây: mở DevTools → Widget Inspector → chọn
`Text` đó → xem `DefaultTextStyle` đang có hiệu lực. `debugLabel` sẽ ghi thẳng
`fallback style; consider putting your text in a Material`.
