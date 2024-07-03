import 'package:flutter/material.dart';

String isSelectedValue = '15';

// StatelessWidgetをStatefulWidgetに変更する
class TextFontSize extends StatefulWidget {
  const TextFontSize({super.key});

  @override
  // createStateメソッドをオーバーライドして、Stateを継承したクラスのインスタンスを返す
  State<TextFontSize> createState() => _TextFontSizeState();
}

// Stateを継承したクラスを作成する
class _TextFontSizeState extends State<TextFontSize> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.fromLTRB(10, 0, 0, 0), //左にパディングを設けて文字色との間隔をあける
        width: 100,
        height: 50,
        child: Column(children: [
          DropdownButton(
            items: const [
              DropdownMenuItem(
                value: '15',
                child: Text('15'),
              ),
              DropdownMenuItem(
                value: '16',
                child: Text('16'),
              ),
              DropdownMenuItem(
                value: '17',
                child: Text('17'),
              ),
            ],
            value: isSelectedValue,
            onChanged: (String? value) {
              setState(() {
                isSelectedValue = value!;
              });
            },
            isExpanded: true,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ]));
  }
}
