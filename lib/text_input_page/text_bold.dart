import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';

var _isChecked = false;

class TextBold extends StatefulWidget {
  @override
  _TextBoldState createState() => _TextBoldState();
}

class _TextBoldState extends State<TextBold> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        height: 40,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Transform.scale(
          scale: 0.8,
          child:
          Row(children: [
            Checkbox(
              value: _isChecked,
              onChanged: (newValue) {
                setState(() {
                  _isChecked = newValue!;
                });
              },

            ),
            // ４つ並びにするためにサイズ調整
            // AutoSizeText('太字', // TextをAutoSizeTextに変更する
                Text('太字', // TextをAutoSizeTextに変更する
              // minFontSize: 6, // 最小のフォントサイズを指定する
              maxLines: 1, // 最大の行数を指定する

              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ]),
        ));
  }
}