import 'package:flutter/material.dart';

class TextInputForm1 extends StatelessWidget{
  final Function(String) onTodoListChanged1;
  TextInputForm1({required this.onTodoListChanged1});

  @override
  Widget build(BuildContext context){
    return Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Container(
                width: 150,
                // height: 40,

                child: Column(children: [
                  TextField(
                    autofocus: false,
                    // controller: _textController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 0),
                      hintText: "文字を入力1",
                      isDense: true,//テキストフィールドの高さを小さくして、appBarとの間隔を少なくする。
                    ),
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    onChanged: onTodoListChanged1,
                  ),
                ])))
    );
  }
}