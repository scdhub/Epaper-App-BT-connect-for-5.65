import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'top_page/top_page.dart';

Future<void> main() async{
  await dotenv.load(fileName: '.env');//環境変数を使う為、設置。
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
        //アプリ全体に下記フォントを反映
        fontFamily:'NotoSansJP',
        //アプリ全体のappBarに下記フォント、背景を反映
        appBarTheme: AppBarTheme(
            // color: Color(0xFF87ff99),
            color: Colors.black87,
          iconTheme: IconThemeData(color: Colors.yellow[100]),
          actionsIconTheme: IconThemeData(color: Colors.yellow[100]),
          titleTextStyle: TextStyle(color: Colors.yellow[100],fontSize: 25,fontFamily:'NotoSansJP',),
        centerTitle: true,
        toolbarTextStyle: TextStyle(color:Colors.yellow[100],fontSize:20,fontFamily: 'NotoSansJP')
        ),
      ),
      home: TopPage(title: 'E ink E-paper'),
    );
  }
}
