import 'package:flutter/material.dart';

class TextInputForm1 extends StatelessWidget {
  final Function(String) onTodoListChanged1;
  const TextInputForm1({super.key, required this.onTodoListChanged1});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: SizedBox(
            width: 150,
            child: Column(children: [
              TextField(
                autofocus: false,
                // controller: _textController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 0),
                  hintText: "文字を入力1",
                  // isDense: true,//テキストフィールドの高さを小さくして、appBarとの間隔を少なくする。
                ),
                style: const TextStyle(fontSize: 13, color: Colors.black),
                onChanged: onTodoListChanged1,
              ),
            ])));
  }
}
