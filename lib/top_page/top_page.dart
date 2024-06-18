import 'package:flutter/material.dart';
import 'package:iphone_bt_epaper/top_page/top_text-to-page.dart';
import '../app_body_color.dart';
import 'top_bt-connect-to-page.dart';
import 'top_drawing-to-page.dart';
import 'top_import-type-select-to-popup.dart';

class TopPage extends StatefulWidget {
  final String title;
  TopPage({required this.title});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            // 'E ink E-paper',
            widget.title,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        body: CustomPaint(
    painter: HexagonPainter(),
    child: Container(
            width: MediaQuery.of(context).size.width, // 画面の幅に合わせる
            height: MediaQuery.of(context).size.height, // 画面の高さに合わせる
            // //Containerの色グラデーション
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white,Colors.black],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            // ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Text(widget.title,
                    style: TextStyle(
                      fontSize: 40,
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Text('最新インストールツール',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Text('(Ver.20231201.001)',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //bt接続画面に遷移するボタン
                  BlueToothConnectToPage(),
                  SizedBox(
                    width: 10,
                  ),
                  //スマホ画像種類選択画面に遷移するボタン
                  ImportTypeSelectToPopup(),
                ]),
                SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //ドローイング画面に遷移するボタン
                  DrawingToPage(),
                  SizedBox(
                    width: 10,
                  ),
                  //テキスト入力画面に遷移するボタン
                  TextToPage(),
                ]),
              ],
            ),
    ),
        ),
    );
  }
}
