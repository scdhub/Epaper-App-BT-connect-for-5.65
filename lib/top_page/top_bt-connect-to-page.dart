
import 'package:flutter/material.dart';
import '../bt_connect_page/connect_bt_page.dart';

class BlueToothConnectToPage extends StatefulWidget {

  @override
  State<BlueToothConnectToPage> createState() => _BlueToothConnectToPageState();
}

class _BlueToothConnectToPageState extends State<BlueToothConnectToPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
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
                ),
                Text(
                  'BT接続して\ne-paper配信',

                    style: TextStyle(
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,//Medium
                    fontSize: 14,
                )
                ),
              ])),
    );
  }}