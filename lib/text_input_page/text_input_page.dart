import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


import '../server_upload/select-photo-check_page.dart';
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

  GlobalKey _globalKey = GlobalKey();
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext?.findRenderObject()as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('画像データの取得に失敗しました。');
    }
    return byteData.buffer.asUint8List();
  }
  void _saveAndNavigate() async {
    Uint8List imageBytes = await _capturePng();
    var imagesBytes = [imageBytes];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectCheck(imageData: imagesBytes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, /*color: Colors.white*/),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'テキストから画像を生成',
            // style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.check_outlined, /*color: Colors.white*/),
              onPressed: () {
                // 入力した文字をインポート画面に渡せるようにコード修正必要。
                _saveAndNavigate();
              },
            ),
          ],
          // title: const Text('テキストから画像を生成'),
          // backgroundColor: Color(0xFF0080FF),
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                color: Color(0xFFE0E0E0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/3,
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
                        scale: 1.0,
                        child: Container(
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '文字色:',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                  TextColor(),
                                  Text(
                                    '文字サイズ:',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                  TextFontSize(),
                                ]))),

                    // 今のところ、押すと画像不一致エラーが出るように設定。
                    // 後で、画像選択画面に遷移して、画像を選択して、エラーが出るように設定。
                    // OutlinedButton(
                    //   style: OutlinedButton.styleFrom(
                    //     minimumSize: Size(300, 30),
                    //     backgroundColor: Color(0xFF0080FF),
                    //   ),
                    //   onPressed: () async {
                    //     _timer = Timer(
                    //       Duration(seconds: 2), //閉じる時間
                    //           () {
                    //         Navigator.pop(context);
                    //       },
                    //     );
                    //     await showDialog<String>(
                    //         context: context,
                    //         builder: (BuildContext context) => Dialog(
                    //             backgroundColor: Colors.black,
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Column(
                    //                   mainAxisSize: MainAxisSize.min,
                    //                   mainAxisAlignment:
                    //                   MainAxisAlignment.center,
                    //                   children: <Widget>[
                    //                     Icon(
                    //                       Icons.cancel,
                    //                       color: Colors.white,
                    //                       size: 24,
                    //                     ),
                    //
                    //                     // 今のところ見本のアンドロイドのアプリを元に作成。
                    //                     // 一行で表示するには、サイズ調整必要。
                    //                     Text('画像情報とスクリーン情報が一致しま',
                    //                         style:
                    //                         TextStyle(color: Colors.white)),
                    //                     Text('せん',
                    //                         style:
                    //                         TextStyle(color: Colors.white)),
                    //                   ]),
                    //             )));
                    //   },
                    //   // child: Padding(
                    //   //   padding:EdgeInsets.zero,
                    //   child: Text(
                    //     '背景テンプレート画像をインポート',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            RepaintBoundary(
            key: _globalKey,
            child:
            Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,

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
                )),
            ),
          ],
        ),

    );
  }
}
