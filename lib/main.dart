import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'top_page/top_page.dart';

Future<void> main() async{
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E ink E-paper',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily:'NotoSansJP',
        appBarTheme: AppBarTheme(
        color: Color(0xFF87ff99),
          titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontFamily:'NotoSansJP',)),
      ),
      home: TopPage(title: 'E ink E-paper'),
    );
  }
}
