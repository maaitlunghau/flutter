# 0002 — `didUpdateWidget` chạy mỗi lần cha dựng lại, không phải khi giá trị đổi

**Ngày:** 2026-09-17 · **Module:** M02

## Đã tưởng là

`didUpdateWidget` chỉ chạy **khi tham số truyền xuống thật sự đổi**. Cái tên gợi
đúng như vậy: *"widget đã được cập nhật"*. Bài giảng 0005 bản đầu cũng viết theo
hướng đó, và lab M02 thiết kế hai nút riêng — một nút "ép rebuild", một nút "đổi
tham số" — với giả định chỉ nút thứ hai làm `didUpdateWidget` chạy.

## Thực tế là

Nó chạy **mỗi lần widget cha dựng lại**, bất kể có gì đổi hay không.

Đo bằng chính lab: bấm nút "Ép rebuild" 5 lần, không đụng gì tới `title`:

```
initState               1
didChangeDependencies   1
didUpdateWidget         5     ← chạy đủ 5 lần
build                   6
```

Lý do: cha dựng lại thì sinh ra một **instance widget mới**. Flutter thấy cùng
kiểu và cùng vị trí nên **giữ lại `State` cũ**, gắn widget mới vào, rồi gọi
`didUpdateWidget(oldWidget)` để báo cho `State` biết. Nó không hề so sánh giá trị
các field — việc đó là của bạn.

Ngoại lệ duy nhất: widget con là `const` và cha dựng lại ra **đúng cùng một
instance**. Lúc đó Flutter bỏ qua cả nhánh, và cả `build` lẫn `didUpdateWidget`
đều không chạy.

## Vì sao dễ nhầm

Cái tên đọc như một sự kiện *"có gì đó đã đổi"*, trong khi nó là một cái móc
*"cha vừa dựng lại, đây là widget mới của mày"*.

Hậu quả thật nếu tin nhầm: viết `didUpdateWidget` gọi API tải lại dữ liệu mà
không so `oldWidget`, thì **mỗi lần cha `setState` là gọi mạng một lần** — kể cả
khi cha `setState` vì một lý do chẳng liên quan gì. App sẽ gọi API hàng chục lần
mà không ai hiểu vì sao.

## Dấu hiệu nhận ra lần sau

**Trong `didUpdateWidget`, luôn so trước khi làm.** Mẫu chuẩn:

```dart
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.userId != widget.userId) {
    _reload();          // chỉ chạy khi đúng thứ mình quan tâm đã đổi
  }
}
```

Thấy `didUpdateWidget` mà **không** có câu `if (oldWidget.x != widget.x)` bên
trong thì gần như chắc chắn là bug đang chờ.

Triệu chứng ngoài đời: API bị gọi nhiều lần bất thường, hoặc animation tự khởi
động lại mỗi khi chạm vào một widget không liên quan trên cùng màn.
