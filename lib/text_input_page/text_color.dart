import 'package:flutter/material.dart';

String isSelectedValue = 'Black';

// StatelessWidgetをStatefulWidgetに変更する
class TextColor extends StatefulWidget {
  const TextColor({super.key});

  @override
  // createStateメソッドをオーバーライドして、Stateを継承したクラスのインスタンスを返す
  State<TextColor> createState() => _TextColorState();
}

// Stateを継承したクラスを作成する
class _TextColorState extends State<TextColor> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        width: 100,
        height: 50,
        child: Column(children: [
          DropdownButton(
            items: const [
              DropdownMenuItem(
                value: 'Black',
                child: Text('Black'),
              ),
              DropdownMenuItem(
                value: 'Red',
                child: Text('Red'),
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
          //   ],
          // ),
        ]));
  }
}
