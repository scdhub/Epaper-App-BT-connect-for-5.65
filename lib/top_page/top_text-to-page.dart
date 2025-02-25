import 'package:flutter/material.dart';

import '../text_input_page/text_input_page.dart';

class TextToPage extends StatefulWidget {
  const TextToPage({super.key});

  @override
  State<TextToPage> createState() => _TextToPageState();
}

class _TextToPageState extends State<TextToPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // shape: BoxShape.rectangle,
        // border: Border.all(
        //   color: Colors.white,
        //   width: 4,
        // ),
        borderRadius: BorderRadius.circular(20),
        // boxShadow: const [
        //   BoxShadow(
        //     offset: Offset(4, 5),
        //     color: Color(0xFFCEC5F0),  // ラベンダー
        //
        //   ),

      ),
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            // foregroundColor: Colors.white,
            backgroundColor: Color(0xFF8C9EFF),
            side: const BorderSide(
              color: Colors.white,
              width: 4,
            ),
            // backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TextInputPage()), //BT接続画面に遷移
            );
          },
          child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_note_outlined,
                  size: 50,
                  // color: Colors.white,
                ),
                SizedBox(height: 7),
                Text('入力して登録',
                    style: TextStyle(
                      // fontFamily: 'NotoSansJP',
                      // fontWeight: FontWeight.w400,//Regular
                      fontWeight: FontWeight.bold, //Midum
                      fontSize: 14,
                    )),
              ])),
    );
  }
}

