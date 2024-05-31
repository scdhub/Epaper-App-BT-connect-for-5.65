import 'package:flutter/material.dart';

class TextInputForm3 extends StatelessWidget{
  final Function(String) onTodoListChanged3;
  TextInputForm3({required this.onTodoListChanged3});

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
                      hintText: "文字を入力3",
                      // isDense: true,
                    ),
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    onChanged: onTodoListChanged3,
                  ),
                ])))
    );
  }
}