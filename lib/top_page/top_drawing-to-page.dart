import 'package:flutter/material.dart';

import 'drawing_page/drawing_page.dart';


class DrawingToPage extends StatefulWidget {

  @override
  State<DrawingToPage> createState() => _DrawingToPageState();
}

class _DrawingToPageState extends State<DrawingToPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.greenAccent,
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
                ),
                Text(
                  '絵を描いてインポート',
                ),
              ])),
    );
  }}