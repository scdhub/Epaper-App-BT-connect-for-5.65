import 'package:flutter/material.dart';


class TextToPage extends StatefulWidget {

  @override
  State<TextToPage> createState() => _TextToPageState();
}

class _TextToPageState extends State<TextToPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) =>
            //           ConnectBTPage()), //BT接続画面に遷移
            // );
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_note_outlined,
                  size: 50.0,
                ),
                Text(
                  'Text入力',
                ),
              ])),
    );
  }}