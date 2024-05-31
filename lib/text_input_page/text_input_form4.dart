import 'package:flutter/material.dart';

class TextInputForm4 extends StatelessWidget{
  final Function(String) onTodoListChanged4;
  TextInputForm4({required this.onTodoListChanged4});

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
                      hintText: "文字を入力4",
                      // isDense: true,
                    ),
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    onChanged: onTodoListChanged4,
                  ),
                ])))
    );
  }
}