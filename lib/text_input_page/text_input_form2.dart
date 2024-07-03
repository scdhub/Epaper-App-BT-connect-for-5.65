import 'package:flutter/material.dart';

class TextInputForm2 extends StatelessWidget {
  final Function(String) onTodoListChanged2;
  const TextInputForm2({super.key, required this.onTodoListChanged2});

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
                  hintText: "文字を入力2",
                  // isDense: true,
                ),
                style: const TextStyle(fontSize: 13, color: Colors.black),
                onChanged: onTodoListChanged2,
              ),
            ])));
  }
}
