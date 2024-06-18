import 'package:flutter/material.dart';

import '../drawing_page/drawing_page.dart';



class DrawingToPage extends StatefulWidget {

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
        //   // color: Colors.black12,
        //   width: 2,
        // ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(-4, 5),
            color: Colors.green,
          ),
        ],
      ),
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            // backgroundColor: Colors.greenAccent,
            side: BorderSide(
              color:  Colors.greenAccent,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DrawingPage()), //BT接続画面に遷移
            );
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.brush,
                  size: 50.0,
                  color: Colors.greenAccent,
                ),
                Text(
                  '　絵を描いて\n画像として登録',
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