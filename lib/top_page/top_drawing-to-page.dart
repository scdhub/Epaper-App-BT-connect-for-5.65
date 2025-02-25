import 'package:flutter/material.dart';

import '../drawing_page/drawing_page.dart';

class DrawingToPage extends StatefulWidget {
  const DrawingToPage({super.key});

  @override
  State<DrawingToPage> createState() => _DrawingToPageState();
}

class _DrawingToPageState extends State<DrawingToPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // shape: BoxShape.rectangle,
        // color: Colors.white60,
        // border: Border.all(
        //   color: Colors.black12,
        //   width: 2,
        // ),
        // borderRadius: BorderRadius.circular(20),
        // boxShadow: const [
        //   BoxShadow(
        //     offset: Offset(2, 5),
        //     color: Colors.green,
        //   ),
        // ],
      ),
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            // foregroundColor: Colors.black,
            backgroundColor: Color(0xFF80DEEA),
            side: const BorderSide(
              color: Colors.white,
              width: 4,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DrawingPage()), //BT接続画面に遷移
            );
          },
          child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.brush,
                  size: 50.0,
                  // color: Colors.white,
                ),
                SizedBox(height: 7),
                Text('絵を描いて登録',
                    style: TextStyle(
                      // fontFamily: 'NotoSansJP',
                      // fontWeight: FontWeight.w400,//Regular
                      fontWeight: FontWeight.bold, //Midum
                      fontSize: 14,
                      // color: Colors.white,
                    )),
              ])),
    );
  }
}
