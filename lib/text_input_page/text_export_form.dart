import 'package:flutter/material.dart';

class TextExportForm extends StatelessWidget{

  final String todoList;
  TextExportForm({super.key, required this.todoList});
  // textInputForm1 textForm1 = textInputForm1();

  @override
  Widget build(BuildContext context){
    return Text(todoList);

  }
}