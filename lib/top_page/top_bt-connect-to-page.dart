
import 'package:flutter/material.dart';
import '../bt_connect_page/connect_bt_page.dart';
import '../bt_connect_for_emulator/pre_connect_bt_page.dart';

class BlueToothConnectToPage extends StatefulWidget {

  @override
  State<BlueToothConnectToPage> createState() => _BlueToothConnectToPageState();
}

class _BlueToothConnectToPageState extends State<BlueToothConnectToPage> {
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
          offset: Offset(2, 5),
          color: Colors.blue,
        ),
      ],
      ),
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // elevation: 10,
            foregroundColor: Colors.black,
            // backgroundColor: Colors.white,
            side: BorderSide(
              color: Colors.blueAccent,
              width: 2,
            ),
            //ボタンの形状設定。角を丸めた長方形。
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),

            // backgroundColor: Colors.lightBlueAccent,
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10.0)),
          ),
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0)),
          // ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConnectBTPage()), //BT接続画面に遷移
            );
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bluetooth_outlined,
                  size: 50.0,
                   color: Colors.blueAccent,
                ),
                Text(
                  '　BTスキャン &\nE-paper配信関連',

                    style: TextStyle(
                    fontSize: 12,
                )
                ),
              ])),
    );
  }}