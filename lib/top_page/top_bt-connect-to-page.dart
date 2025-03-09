import 'package:flutter/material.dart';
import '../bt_connect_page/connect_bt_page.dart';


class BlueToothConnectToPage extends StatefulWidget {
  const BlueToothConnectToPage({super.key});

  @override
  State<BlueToothConnectToPage> createState() => _BlueToothConnectToPageState();
}

class _BlueToothConnectToPageState extends State<BlueToothConnectToPage> {
  @override
  Widget build(BuildContext context) {
    const data ='E-paperに配信';
        '　BTスキャン &\nE-paper配信関連';

    // スマホ画面の幅を取得
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      //   decoration: BoxDecoration(
      //     shape: BoxShape.rectangle,
      //     color: Colors.white,
      //     border: Border.all(
      //       // color: Colors.black12,
      //       width: 2,
      //     ),
      //     borderRadius: BorderRadius.circular(20),
      //     boxShadow: const [
      //       BoxShadow(
      //         offset: Offset(2, 5),
      //         color: Colors.blue,
      //       ),
      //     ],
      //   ),

      width: screenWidth * 0.8, // 画面幅の80%に設定
      height: 70,
      //   width: 150,
      //   height: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF304FFE),
          // elevation: 10,
          // foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2,
          ),
          //ボタンの形状設定。角を丸めた長方形。
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),//20
          ),

          // backgroundColor: Colors.lightBlueAccent,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10.0)),
        ),
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10.0)),
        // ),

        //画面遷移の動き
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ConnectBTPage()), //BT接続画面に遷移
          );
        },

        // child: const Column(
        child: const Row(
          //位置
          //   crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,//下記、並び順に左右（テキスト：左、アイコン：右）
          children: [
            Text(data,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.bluetooth_outlined,
              size: 30.0, //45.0
              // color: Colors.white,
            ),
            // SizedBox(height: 7),
            // Text(data,
            //   style: TextStyle(
            //     fontSize: 12,
            //     fontWeight: FontWeight.bold,
            //     // color: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
