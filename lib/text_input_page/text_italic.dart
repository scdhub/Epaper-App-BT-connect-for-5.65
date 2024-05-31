import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';


var _isChecked = false;

class TextItalic extends StatefulWidget {
  @override
  _TextItalicState createState() => _TextItalicState();
}

class _TextItalicState extends State<TextItalic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color:Colors.blue,
        padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
        width: 110,
        height: 40,
        child: Transform.scale(
          scale: 1.0,
          child:  Row(children: [
            Checkbox(
              value: _isChecked,
              onChanged: (newValue) {
                setState(() {
                  _isChecked = newValue!;
                });
              },
            ),
            // AutoSizeText('イタリック',
                Text('イタリック',
                  // minFontSize: 5, // 最小のフォントサイズを指定する
              maxLines: 1, // 最大の行数を指定する
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),

          ]),
        ));
  }
}