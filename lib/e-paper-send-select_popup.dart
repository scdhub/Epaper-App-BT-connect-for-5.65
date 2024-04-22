import 'package:flutter/material.dart';
import 'connect_bt_page.dart';

class EpaperSendSelect extends StatefulWidget{
  @override
  _EpaperSendSelectState createState() => _EpaperSendSelectState();
}

class _EpaperSendSelectState extends State<EpaperSendSelect>{

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Text('E-paperに送信しますか？'),

      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ConnectBTPage()),
              );
            },
          child: const Text('OK'),
        ),
      ],
    );
  }
}