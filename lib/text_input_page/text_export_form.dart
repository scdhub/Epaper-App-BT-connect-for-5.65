import 'package:flutter/material.dart';

class TextExportForm extends StatelessWidget{

  String todoList;
  TextExportForm({required this.todoList});
  // textInputForm1 textForm1 = textInputForm1();

  @override
  Widget build(BuildContext context){
    return Text(todoList);

  }
}