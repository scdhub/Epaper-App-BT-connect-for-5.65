import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';

var _isChecked = false;

class TextUnderLine extends StatefulWidget {
  const TextUnderLine({super.key});

  @override
  State<TextUnderLine> createState() => _TextUnderLineState();
}

class _TextUnderLineState extends State<TextUnderLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color:Colors.yellow,
      height: 40,
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: Transform.scale(
        scale: 1.0,
        child: Row(children: [
          Checkbox(
            value: _isChecked,
            onChanged: (newValue) {
              setState(() {
                _isChecked = newValue!;
              });
            },
          ),
          // AutoSizeText('下線', // TextをAutoSizeTextに変更する
          const Text(
            '下線', // TextをAutoSizeTextに変更する
            // minFontSize: 6, // 最小のフォントサイズを指定する
            maxLines: 1, // 最大の行数を指定する
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ]),
      ),
    );
  }
}
