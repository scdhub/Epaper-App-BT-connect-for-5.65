import 'package:flutter/material.dart';

class TextInputForm2 extends StatelessWidget{
  final Function(String) onTodoListChanged2;
  TextInputForm2({required this.onTodoListChanged2});

  @override
  Widget build(BuildContext context){
    return Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Container(
                width: 150,

                child: Column(children: [
                  TextField(
                    autofocus: false,
                    // controller: _textController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 0),
                      hintText: "文字を入力2",
                      // isDense: true,
                    ),
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    onChanged: onTodoListChanged2,
                  ),
                ])))
    );
  }
}