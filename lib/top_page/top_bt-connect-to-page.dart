import 'package:flutter/material.dart';
import '../bt_connect_page/connect_bt_page.dart';
import 'package:permission_handler/permission_handler.dart';


class BlueToothConnectToPage extends StatefulWidget {
  const BlueToothConnectToPage({super.key});

  @override
  State<BlueToothConnectToPage> createState() => _BlueToothConnectToPageState();
}

class _BlueToothConnectToPageState extends State<BlueToothConnectToPage> {

  Future<void> requestLocationPermission() async {
    // 位置情報の権限が許可されているか確認
    var status = await Permission.location.status;
    debugPrint("status.isGranted: ${status.isGranted}");
    if (!status.isGranted) {
      // 権限が許可されていない場合、リクエストする
      PermissionStatus permissionStatus = await Permission.locationWhenInUse.request();
      debugPrint("permissionStatus.isGranted: ${permissionStatus.isGranted}");
      debugPrint("permissionStatus.isDenied: ${permissionStatus.isDenied}");

      if (permissionStatus.isGranted) {
        // 権限が許可された場合
        print("Location permission granted");
      } else {
        // 権限が拒否された場合
        print("Location permission denied");

        if (permissionStatus.isDenied) {
          // 権限が拒否された場合
          print("Location permission is denied. Requesting again...");
        } else if (permissionStatus.isPermanentlyDenied) {
          // 権限が「永久に拒否された」場合、設定から手動で権限を変更してもらう必要があります
          print("Location permission is permanently denied. Open settings to grant permission.");
          openAppSettings(); // 設定画面を開く
        }
      }
    } else {
      // すでに許可されている場合
      print("Location permission already granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    const data = '　BTスキャン &\nE-paper配信関連';

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
      width: 150,
      height: 150,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // elevation: 10,
            // foregroundColor: Colors.white,
            // backgroundColor: Color(0xFF80DEEA),
            side: const BorderSide(
              color: Colors.white,
              width: 4,
            ),
            //ボタンの形状設定。角を丸めた長方形。
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            // backgroundColor: Colors.lightBlueAccent,
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10.0)),
          ),
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0)),
          // ),

          //画面遷移の動き
          onPressed: () async {
            await requestLocationPermission();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ConnectBTPage()), //BT接続画面に遷移
            );
          },

          child: const Column(
            //位置
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bluetooth_outlined,
                  size: 45.0,
                  // color: Colors.white,
                ),
                SizedBox(height: 7),
                Text(data,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      // color: Colors.white,
                    )),
              ])),
    );
  }
}
