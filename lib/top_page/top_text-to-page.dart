import 'package:flutter/material.dart';

import '../text_input_page/text_input_page.dart';


class TextToPage extends StatefulWidget {

  @override
  State<TextToPage> createState() => _TextToPageState();
}

class _TextToPageState extends State<TextToPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // shape: BoxShape.rectangle,
        // color: Colors.white60,
        // border: Border.all(
        //   // color: Colors.black12,
        //   width: 2,
        // ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(4, 5),
            color: Colors.redAccent,
          ),
        ],
      ),
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            // backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TextInputPage()), //BT接続画面に遷移
            );
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_note_outlined,
                  size: 50.0,
                  color: Colors.redAccent,
                ),
                Text(
                  '文字を入力して\n画像として登録',
                    style: TextStyle(
                      fontFamily: 'NotoSansJP',
                      // fontWeight: FontWeight.w400,//Regular
                      fontWeight: FontWeight.w500,//Midum
                      fontSize: 14,
                    )
                ),
              ])),
    );
  }}