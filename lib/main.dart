import 'package:flutter/material.dart';
import 'top_page/top_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E Ink 電子ペーパー',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: TopPage(/*title: 'E Ink 電子ペーパー'*/),
    );
  }
}
