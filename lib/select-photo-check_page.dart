import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'e-paper-send-select_popup.dart';
import 'connect_bt_page.dart';
import 'import_page.dart';
import 'photo-select_page.dart';
import 'import-type-select_popup.dart';
import 'package:transparent_image/transparent_image.dart';
import 'appserver.dart';

import 'package:cached_network_image/cached_network_image.dart';

class SelectCheck extends StatefulWidget {
  // final Uint8List imageData;
  // final List<Media> imageData;
  final List<Uint8List?> imageData;
  SelectCheck({Key? key,
    required this.imageData
    // required this.imageData,
  });
  @override
  State<SelectCheck> createState() => _SelectCheckState();
}

class _SelectCheckState extends State<SelectCheck> {
  List<AppServer> savedPhoto =[];
List<Uint8List> installPhoto = [];

  bool _isWriting = false;
  int i = 5;

  Future<void> _writeDataToServer() async {
    await Future.delayed(Duration(seconds:2));
    CircularProgressIndicator();
  }
  // Future<void> _writeDataToServer(int index) async {//サーバーにデータを書き込むための非同期メソッド
  //   String base64Image = base64Encode(widget.imageData[index]!);
  //   // String base64Image = base64Encode(widget.imageData[index]);
  //
  //   await Future.delayed(Duration(seconds:2), () {
  //     setState(() {
  //       savedPhoto.add(AppServer(id: '$i', detectIpAddress: base64Image));
  //       i++; // 次のIDにインクリメント
  //       // print( savedPhoto);
  //     });
  //   });
  // }

  Future<void> _showWriteDialog() async { //書き込みダイアログを表示するための非同期
    setState(() {
      _isWriting = true;
    });
    await _writeDataToServer();

    setState(() {
      _isWriting = false;
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('書き込み完了'),
          content: Text('E-paperに配信しますか？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectBTPage()));
              },
              child: Text('はい'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('いいえ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text('E Ink 電子ペーパー'),
        ),
        body: Container(
          height:double.infinity,
            width:double.infinity,
            child: Column(
                children: [
            Container(
                // color:Colors.greenAccent,
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE1E9FF), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                 child: ListView.builder(
                    // Number of selected media items
                    itemCount: widget.imageData.length,
                    // Apply bouncing scroll physics
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          // Apply padding to each selected media item
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        // Display selected media widget
                        child: Image.memory(widget.imageData[index]!)
                      );
                    },
                  ),
            ),
          // child:Container(
          //     // color:Colors.greenAccent,
          //     width: 400,
          //     height: 400,
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [Color(0xFFE1E9FF), Colors.white],
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //       ),
          //     ),
          //     child:Image.memory(
          //       widget.imageData,
          //       fit:BoxFit.cover,
          //     ),
          // //     Row(
          // //       children: [
          // //       Container(
          // //         width: 100,
          // //         child:
          // //       Image.network(
          // //         // savedPhoto[0].detectIpAddress.toString(),
          // //         'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png'
          // //     ),
          // //       ),
          // //       Container(
          // //         width: 100,
          // //         child:
          // //       Stack(
          // //         children: <Widget>[
          // //           const Center(child: CircularProgressIndicator()),
          // //           Center(
          // //             child: FadeInImage.memoryNetwork(
          // //               placeholder: kTransparentImage,
          // //               image: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
          // //             ),
          // //           ),
          // //         ],
          // //       ),
          // //       ),
          // //       Container(
          // //         width: 100,
          // //         child:
          // //       CachedNetworkImage(
          // //         imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
          // //       ),
          // //       ),
          // //
          // // ],
          //     ),
          // ),

            Container(
            width: double.infinity,
            height: 300,
            color:Colors.greenAccent,

            child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text('アプリに保存する',style:TextStyle(
                    fontSize:40,
                  )),
                SizedBox(
                width: double.infinity, //横幅
                height: 60, //高さ
                child:
              ElevatedButton(

                child: Text('OK',style:TextStyle(
                  fontSize:40,
                )),

                onPressed:_isWriting ? null :_showWriteDialog,
// onPressed: (){
//
// },
                // onPressed: () {

                  // _timer = Timer(
                  // Duration(seconds: 2), //閉じる時間
                  // () {
                  //
                  //   showDialog(
                  //     context: context,
                  //     builder: (context) => EpaperSendSelect(),//画像種類選択画面表示
                  //   );
                  //
                  // }
                  // );
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) => Dialog(
                  //     backgroundColor: Colors.black,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: <Widget>[
                  //           // CircularProgressIndicator(
                  //           //   strokeWidth: 4.0,
                  //           //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  //           // ),
                  //           const Text(
                  //             '書き込み中...',
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // );

                // },
                style: ElevatedButton.styleFrom(
                    elevation:10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),),
              SizedBox(
                  width: double.infinity, //横幅
                  height: 60, //高さ
                  child:
              ElevatedButton(
                child: Text('キャンセル',style:TextStyle(
                  fontSize:40,
                )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation:10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),),
            ]),
            )
        ])));
  }
}
