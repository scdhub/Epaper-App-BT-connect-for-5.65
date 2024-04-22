import 'package:flutter/material.dart';
import 'connect_bt_page.dart';
import 'import_page.dart';
import 'photo-select_page.dart';
import 'import-type-select_popup.dart';

class TopPage extends StatefulWidget {
  // const TopPage({super.key, required this.title});
  // final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue,
        centerTitle: true,
        title: Text('E Ink 電子ペーパー'),
      ),
      body:
    Container(
    // color:Colors.greenAccent,
      width:double.infinity,
    height:double.infinity,
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Color(0xFFE1E9FF), Colors.white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),child:Column(
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[
          SizedBox(height:100),
          Text('E ink 電子ペーパー',
              style: TextStyle(
                fontSize: 40,
              )),
          SizedBox(height:100),
          Text('最新インストールツール',
              style: TextStyle(
                fontSize: 20,
              )),
          Text('(Ver.20231201.001)',
              style: TextStyle(
                fontSize: 20,
              )),
          SizedBox(height:100),
Row(
    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
Container(
// padding:EdgeInsets.all(20),
//   margin:EdgeInsets.all(5),
  width:200,
  height:200,
  child:
          ElevatedButton(
            style:TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.lightBlueAccent,
                shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
            ),
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConnectBTPage()),//BT接続画面に遷移
              );
            },
            child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:[

              Icon(
                Icons.bluetooth_outlined,
                size: 100.0,),
                  Text('BlueTooth接続',),
                ]
            )
          ),
),
          SizedBox(width: 5,),
  Container(
    // padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
    // margin:EdgeInsets.fromLTRB(10, 0, 0, 0),
    width:200,
    height:200,
    child:
    ElevatedButton(
        style:TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.blueGrey,
            shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
        ),
        onPressed:(){
          showDialog(
            context: context,
            builder: (context) => ImageTypeSelection_popup(),
          );
        },
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,

            children:[

              Icon(
                Icons.install_mobile_rounded,
                size: 100.0,
              ),
              Text(
                'スマホから画像を\nインポート',
              ),
            ]
        )
    ),
  ),
      //     Text('スマホからアプリにインポート'),
      //   // Container(
      //   //   width:120,
      //   //   child:
      //     // ElevatedButton(
      //     // style:TextButton.styleFrom(foregroundColor: Colors.black,backgroundColor: Colors.blue),
      //
      // FloatingActionButton(
      //         // style:TextButton.styleFrom(foregroundColor: Colors.black,backgroundColor: Colors.blue),
      //         onPressed:(){
      //           // Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(builder: (context) => ImportPage()),
      //           // );
      //           showDialog(
      //             context: context,
      //             builder: (context) => ImageTypeSelection_popup(),//画像種類選択画面表示
      //           );
      //         },
      //
      //   shape: CircleBorder(),
      //
      //         child:
      //         // Row(
      //         //     children:[
      //
      //               Icon(Icons.photo_library),
      //             // ]
      //         // )
      //     ),
])
    // ),
        ],
      )
    )
    );
  }
}
