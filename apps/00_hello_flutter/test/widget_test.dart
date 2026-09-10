// Đây là một widget test cơ bản.
//
// Widget test dựng widget lên trong bộ nhớ — KHÔNG cần emulator, không cần máy
// thật — rồi giả lập thao tác và kiểm tra kết quả. Nhờ vậy nó chạy trong vài
// giây thay vì vài chục giây như build APK.
//
// Chạy bằng: flutter test
//
// LƯU Ý: repo này hoãn phần testing tới tận M13. File này do `flutter create`
// sinh sẵn, giữ lại để tới M13 có sẵn điểm bắt đầu. Chưa cần hiểu nó lúc này.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hello_flutter/main.dart';

void main() {
  testWidgets('Bấm nút thì số đếm tăng', (WidgetTester tester) async {
    // Dựng app lên và vẽ một khung hình đầu tiên.
    await tester.pumpWidget(const HelloApp());

    // Kiểm tra số đếm bắt đầu từ 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Bấm vào icon '+' rồi vẽ lại một khung hình.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Kiểm tra số đếm đã tăng lên 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
