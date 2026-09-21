# `go_router` — tra nhanh

> Đọc từ trên xuống lần đầu để hiểu. Sau đó chỉ cần mục *Tra nhanh* ở cuối.
> Bài giảng đầy đủ: [0008](../lessons/0008-route-tree-khai-bao-voi-go-router.html) ·
> Code mẫu chạy được: `apps/03_navigation_lab/lib/`

---

## 1. Bức tranh toàn cục

### Vấn đề

Với `Navigator`, bạn **ra lệnh**: "đẩy màn này lên".

```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => UserDetail(id: 7)));
```

Chạy tốt cho app nhỏ. Lớn lên thì nứt ở ba chỗ:

| Chỗ nứt | Biểu hiện |
|---|---|
| Màn A phải `import` màn B | 10 màn mở lẫn nhau = 10 file import chéo |
| Cấu trúc app không đọc được | Cây đường đi nằm rải trong từng `onPressed` |
| Deep link | Android đưa vào `app://users/7` — ai biết dưới màn chi tiết phải có màn danh sách? |

### Lời giải

Khai báo **một lần** app có những địa chỉ nào, rồi chỉ nói mình muốn đứng ở đâu.

```dart
context.go('/users/7');
```

### Ý quan trọng nhất

**Bạn không dựng stack nữa. Bạn khai báo cây, stack là thứ rơi ra.**

```
BẠN VIẾT                          ROUTER SUY RA (khi ở /users/7)

GoRoute '/users'                  ┌─────────────┐
   └── GoRoute ':id'              │  /users/7   │ ← đỉnh, đang thấy
                                  ├─────────────┤
hai dòng, một quan hệ cha–con     │  /users     │ ← đáy, Back về đây
                                  └─────────────┘
```

Bạn **không hề** gọi `push` cho màn danh sách. Nó có mặt vì `:id` là **con** của `/users`.

Đây cũng là lý do deep link hoạt động: link thẳng vào `/users/7` sinh ra đúng stack hai tầng đó, nên bấm Back về danh sách chứ không văng ra khỏi app.

---

## 2. Bộ khung tối thiểu

Ba bước, không bước nào bỏ được.

**Bước 1 — cài**

```bash
flutter pub add go_router
```

**Bước 2 — khai báo cây** (một file riêng, ví dụ `app_router.dart`)

```dart
final GoRouter appRouter = GoRouter(
  initialLocation: '/users',
  routes: <RouteBase>[
    GoRoute(
      path: '/users',
      builder: (BuildContext context, GoRouterState state) =>
          const UserListScreen(),
      routes: <RouteBase>[
        GoRoute(
          // Route con KHÔNG có dấu / ở đầu. Đường đầy đủ là /users/:id
          path: ':id',
          builder: (BuildContext context, GoRouterState state) =>
              UserDetailScreen(id: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);
```

**Bước 3 — nối vào app**

```dart
MaterialApp.router(
  routerConfig: appRouter,
)
```

Không còn `home:`. Màn đầu tiên giờ là hệ quả của `initialLocation`.

---

## 3. Từng mảnh ghép

### 3.1 Path param — dữ liệu đi trong đường dẫn

```dart
GoRoute(
  path: ':id',
  builder: (context, state) => UserDetailScreen(id: state.pathParameters['id']!),
)
```

Màn chi tiết nhận `id` **từ đường dẫn**, không từ constructor của màn gọi nó. Đó là lý do nó mở được từ deep link — người gọi không cần tồn tại.

> **Router không validate giùm bạn.** `/users/999` vẫn khớp route và vẫn mở màn,
> dù không có user 999. Path param chỉ là một đoạn chữ. Kiểm tra là việc của màn.

Query param đi qua chỗ khác:

```dart
state.uri.queryParameters['from']   // /login?from=/users
```

### 3.2 `go` khác `push` — nhầm chỗ này là "bấm Back ra màn lạ"

| Lệnh | Làm gì với stack | Dùng khi |
|---|---|---|
| `context.go('/users/7')` | **Thay** cả stack bằng stack mà địa chỉ mới sinh ra | Đổi chỗ đứng: đăng nhập xong, đăng xuất, chuyển tab |
| `context.push('/users/7')` | **Chồng** thêm một tầng lên stack đang có | Đi sâu trong một luồng đang dở |

Thử nhanh: bấm vào 3 user liên tiếp.
`go` → Back **một lần** ra khỏi. `push` → Back **ba lần**.

### 3.3 Màn 404

```dart
GoRouter(
  errorBuilder: (context, state) => NotFoundScreen(location: state.uri.toString()),
  routes: ...,
)
```

Bỏ trống thì `go_router` vẫn đỡ, nhưng bằng màn lỗi mặc định tiếng Anh kèm stack trace — không phải thứ người dùng nên thấy.

### 3.4 `redirect` — auth guard đặt đúng một chỗ

`redirect` chạy **trước mọi lần điều hướng**, kể cả lần mở app đầu tiên và kể cả deep link.

- trả `null` → cứ đi tiếp
- trả một đường dẫn → đi chỗ khác

```dart
GoRouter(
  refreshListenable: authState,          // thiếu dòng này thì đổi cờ xong router không biết
  redirect: (BuildContext context, GoRouterState state) {
    final String location = state.matchedLocation;

    // Chỉ gác nhánh cần gác. Gác cả app thì không còn chỗ nào để đăng nhập.
    if (location.startsWith('/users') && !authState.isLoggedIn) {
      final String from = Uri.encodeComponent(state.uri.toString());
      return '/login?from=$from';        // nhớ chỗ họ định vào
    }

    if (location == '/login' && authState.isLoggedIn) {
      final String? from = state.uri.queryParameters['from'];
      if (from == null || from.startsWith('/login')) return '/users';
      return from;                       // trả họ về đúng chỗ cũ
    }

    return null;
  },
  routes: ...,
);
```

**Vì sao không đặt `if (!loggedIn) return LoginScreen();` trong `build` của từng màn?**
Vì bạn phải nhớ viết ở **mọi** màn, và cái màn bạn quên chính là lỗ hổng. `redirect` là **một cửa duy nhất** mà mọi lần điều hướng đều phải đi qua — kể cả lần bạn chưa nghĩ tới.

### 3.5 `refreshListenable` — nối state vào router

Router chỉ chạy lại `redirect` khi có gì đó **báo** cho nó. Cờ đăng nhập phải là một `Listenable`:

```dart
class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    if (_isLoggedIn == value) return;
    _isLoggedIn = value;
    notifyListeners();                   // ← router nghe ở đây
  }
}
```

Nhờ vậy nút Đăng nhập **không** gọi `context.go`. Nó chỉ đổi cờ, router tự đá đi.
**Điều hướng là hệ quả của state, không phải của cú bấm.**

---

## 4. Hai bẫy

### Bẫy 1 — vòng lặp vô hạn trong `redirect`

Chưa đăng nhập → đẩy về `/login` → `redirect` chạy lại cho `/login` → vẫn chưa đăng nhập → đẩy về `/login` → …

`go_router` đếm số lần chuyển hướng liên tiếp rồi ném lỗi, nên bạn thấy màn lỗi chứ app không treo. Điều kiện chặn luôn cùng một hình dạng:

> **Đích đến đã là nơi ta định đẩy tới rồi thì thôi.**

Trong code trên, nó là mệnh đề `location == '/login'`.

### Bẫy 2 — gác cả app

```dart
if (!authState.isLoggedIn) return '/login';   // ✗ gác luôn cả /login
```

Không còn đường nào vào được màn đăng nhập. Luôn giới hạn phạm vi gác bằng một prefix.

---

## 5. Áp dụng vào project thật

Thứ tự nên làm, mỗi bước chạy được rồi mới sang bước sau:

1. **Vẽ cây đường đi ra giấy trước.** Màn nào nằm trong màn nào? Quan hệ cha–con quyết định Back — sửa sau tốn hơn nhiều.
2. Dựng `GoRouter` với **routes phẳng trước**, chưa guard, chưa param. Chạy được đã.
3. Thêm `errorBuilder`. Năm dòng, và nó chặn nguyên một lớp crash.
4. Thêm path param cho các màn chi tiết. **Nhớ xử lý id không tồn tại.**
5. Tách state đăng nhập thành `ChangeNotifier`, nối `refreshListenable`, rồi mới viết `redirect`.
6. Cuối cùng mới tới deep link — nó chỉ là `intent-filter` trong `AndroidManifest.xml`, phần Flutter đã xong từ bước 2.

Ba quy ước đáng giữ:

- **Một file cho cả cây route.** Cấu trúc app phải đọc được ở một chỗ.
- **Đặt tên route** (`name:`) khi app lớn, rồi dùng `context.goNamed('userDetail', pathParameters: {'id': '7'})` — đổi path sau này không phải đi sửa chuỗi khắp nơi.
- **Không gọi điều hướng trong `build`.** Đó là việc của `redirect`.

---

## 6. Code mẫu trong repo này

`apps/03_navigation_lab/lib/` — chạy được, bấm thử được:

| File | Việc |
|---|---|
| `app_router.dart` | Cả cây route + `errorBuilder` + `redirect` |
| `auth_state.dart` | `ChangeNotifier` cho cờ đăng nhập |
| `user_list_screen.dart` | Danh sách + thanh địa chỉ gõ path tay |
| `user_detail_screen.dart` | Đọc `state.pathParameters`, xử lý id không tồn tại |
| `login_gate_screen.dart` | Màn khoá, nhớ `?from=` |
| `not_found_screen.dart` | Màn 404 |

---

## 7. Tra nhanh

| Cần gì | Viết gì |
|---|---|
| Đổi chỗ đứng | `context.go('/users')` |
| Chồng thêm một tầng | `context.push('/users/7')` |
| Lùi một tầng | `context.pop()` |
| Đọc path param | `state.pathParameters['id']` |
| Đọc query param | `state.uri.queryParameters['from']` |
| Địa chỉ đang khớp | `state.matchedLocation` |
| Địa chỉ đầy đủ (kèm query) | `state.uri.toString()` |
| Màn 404 | `GoRouter(errorBuilder: …)` |
| Chạy trước mọi lần điều hướng | `GoRouter(redirect: …)` |
| Nối state vào router | `GoRouter(refreshListenable: …)` |
| Gắn `NavigatorObserver` | `GoRouter(observers: […])` |

---

## Nguồn

- [pub.dev — `go_router`](https://pub.dev/packages/go_router) (do đội Flutter duy trì)
- [Flutter docs — Navigation and routing](https://docs.flutter.dev/ui/navigation)
- [Flutter docs — Deep linking](https://docs.flutter.dev/ui/navigation/deep-linking)
