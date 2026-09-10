import 'package:flutter/material.dart';

// Everything below is deliberately small. Read it top to bottom once, then go
// run the four experiments in docs/lessons/0001-*.html — the point of this lab
// is what happens when you break it, not what it does when it works.

void main() {
  // Hot reload never re-enters this function. Editing anything here needs a hot
  // restart (press R) before you will see it.
  runApp(const HelloApp());
}

class HelloApp extends StatelessWidget {
  const HelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp supplies theme, navigation and localization for everything
    // beneath it. Without it, widgets like Scaffold have no Material context to
    // read from and throw at runtime.
    return MaterialApp(
      title: 'Hello Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const CounterPage(title: 'M00 — Hot reload lab'),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.title});

  // Fields on the Widget are immutable — that is why this is `final` and why
  // the class is annotated @immutable upstream. Widgets get thrown away and
  // rebuilt constantly; they are descriptions, not objects with a lifetime.
  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // THIS is the object with a lifetime. It survives hot reload, which is why
  // changing the `0` below does nothing until you hot restart.
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // Runs exactly once, when this State is created. Hot reload will not run it
    // again — a very common source of "why didn't my change apply?".
  }

  void _increment() {
    // setState does not "update the UI". It marks this State dirty so Flutter
    // schedules build() again on the next frame. Mutating _counter outside of
    // setState would change the value but never repaint.
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    // Called on every frame that needs this subtree repainted — potentially 60
    // times a second. Keep it cheap: no network calls, no file IO, no parsing.
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Số lần bấm nút:'),
            Text('$_counter', style: theme.textTheme.displayMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        tooltip: 'Tăng',
        child: const Icon(Icons.add),
      ),
    );
  }
}
