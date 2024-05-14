import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


import 'text_bold.dart';
import 'text_color.dart';
import 'text_export_form.dart';
import 'text_fonts.dart';
import 'text_fonts_size.dart';
import 'text_input_form1.dart';
import 'text_input_form2.dart';
import 'text_input_form3.dart';
import 'text_input_form4.dart';
import 'text_italic.dart';
import 'text_underline.dart';
// import 'text_Fonts.dart';
// import 'text_FontsSize.dart';
// import 'text_Color.dart';
// import 'text_InputForm1.dart';
// import 'text_InputForm2.dart';
// import 'text_InputForm3.dart';
// import 'text_InputForm4.dart';
// import 'text_Bold.dart';
// import 'text_Italic.dart';
// import 'text_UnderLine.dart';
// import 'text_ExportForm.dart';

class TextInputPage extends StatefulWidget {
  @override
  _TextInputPageState createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  String _text1 = '';
  String _text2 = '';
  String _text3 = '';
  String _text4 = '';

  void _updateText1(String newText) {
    setState(() {
      _text1 = newText;
    });
  }

  void _updateText2(String newText) {
    setState(() {
      _text2 = newText;
    });
  }

  void _updateText3(String newText) {
    setState(() {
      _text3 = newText;
    });
  }

  void _updateText4(String newText) {
    setState(() {
      _text4 = newText;
    });
  }

  Offset position = Offset(0, 0); // 初期位置
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'テキストから画像を生成',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: () {
                // 入力した文字をインポート画面に渡せるようにコード修正必要。
              },
            ),
          ],
          // title: const Text('テキストから画像を生成'),
          backgroundColor: Color(0xFF0080FF),
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                color: Color(0xFFE0E0E0),
                width: 400,
                height: 210,
                child: Column(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextInputForm1(onTodoListChanged1: _updateText1),
                          TextInputForm2(onTodoListChanged2: _updateText2),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextInputForm3(onTodoListChanged3: _updateText3),
                          TextInputForm4(onTodoListChanged4: _updateText4),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextFonts(),//選んだフォントを文字に反映できるように修正する必要がある
                          TextBold(),//文字に太文字を反映できるように修正する必要がある
                          TextItalic(),//文字にイタリックな設定を反映できるように修正する必要がある
                          TextUnderLine(),//文字に下線引けるように反映できるように修正する必要がある
                        ]),
                    Transform.scale(
                        scale: 0.8,
                        child: Container(
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '文字色:',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.black),
                                  ),
                                  TextColor(),
                                  Text(
                                    '文字サイズ:',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.black),
                                  ),
                                  TextFontSize(),
                                ]))),

                    // 今のところ、押すと画像不一致エラーが出るように設定。
                    // 後で、画像選択画面に遷移して、画像を選択して、エラーが出るように設定。
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(300, 30),
                        backgroundColor: Color(0xFF0080FF),
                      ),
                      onPressed: () async {
                        _timer = Timer(
                          Duration(seconds: 2), //閉じる時間
                              () {
                            Navigator.pop(context);
                          },
                        );
                        await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                                backgroundColor: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                          size: 24,
                                        ),

                                        // 今のところ見本のアンドロイドのアプリを元に作成。
                                        // 一行で表示するには、サイズ調整必要。
                                        Text('画像情報とスクリーン情報が一致しま',
                                            style:
                                            TextStyle(color: Colors.white)),
                                        Text('せん',
                                            style:
                                            TextStyle(color: Colors.white)),
                                      ]),
                                )));
                      },
                      // child: Padding(
                      //   padding:EdgeInsets.zero,
                      child: Text(
                        '背景テンプレート画像をインポート',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                color: Colors.grey,
                width: 350,
                height: 300,

                child: GestureDetector(
                  // _text1～４の入力した文字がすべて同時に動くため、_text単体で動くように修正が必要。
                  dragStartBehavior: DragStartBehavior.down,
                  onPanUpdate: (details) {
                    position = details.localPosition; // ローカル座標を更新
                    setState(() {});
                  },

                  child: Stack(
                    children: <Widget>[
                      Positioned(//入力始めは、特定の座標にて表示するようにする
                          left: position.dx,
                          top: position.dy,
                          child: Column(children: [
                            TextExportForm(todoList: _text1),
                            TextExportForm(todoList: _text2),
                            TextExportForm(todoList: _text3),
                            TextExportForm(todoList: _text4),
                          ])),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
