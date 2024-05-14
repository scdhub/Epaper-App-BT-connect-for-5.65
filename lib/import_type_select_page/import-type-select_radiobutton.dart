import 'package:flutter/material.dart';

// _imageTypeSelection_popupStateの子ウィジェット
class TypeSelectedRadio extends StatefulWidget {
  final Function(int) onSelected; // コールバック関数を受け取る

  const TypeSelectedRadio({required this.onSelected, super.key});

  @override
  _TypeSelectedRadioState createState() => _TypeSelectedRadioState();
}

class _TypeSelectedRadioState extends State<TypeSelectedRadio> {
  var _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1300,
        height: 100,
        // color:Colors.cyanAccent,
        child: ListView(shrinkWrap: true, children: [
          RadioListTile(
              value: 1,
              groupValue: _selectedIndex,
              title: Text('撮影してインポート'),
              onChanged: (int? value) {
                setState(() {
                  _selectedIndex = value!;
                });
                widget.onSelected(value!); // コールバック関数を呼び出す
              }),
          RadioListTile(
              value: 2,
              groupValue: _selectedIndex,
              title: Text('アルバムからインポート'),
              onChanged: (int? value) {
                setState(() {
                  _selectedIndex = value!;
                });
                widget.onSelected(value!); // コールバック関数を呼び出す
              }),
        ]));
  }
}
