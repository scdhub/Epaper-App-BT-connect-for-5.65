import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iphone_bt_epaper/devices_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import '../appserver.dart';
import 'e-paper-send-picture_page.dart';
import '../server_upload/photo-select_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../e-paper_info.dart';
import '../server_upload/select-photo-check_page.dart';
import 'package:http/http.dart' as http;


class ExportPage extends StatefulWidget {
  final String trustName;
  final String trustIpAddress;
  final VoidCallback onDelete;

  ExportPage({
    required this.trustName,
    required this.trustIpAddress,
    required this.onDelete,
  });

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  var _selectedIndex = 1;
  var processRate = 0.5;
  E_paperInfo e_paperInfo;
  List<TrustDevice> trustDevices = [];//信頼済みデバイスデータ格納List

  _ExportPageState(): e_paperInfo = E_paperInfo();

  AppServer? selectedPhoto;


  // //信頼済みデバイスからデータ削除
  // void _removeCounterValue(int index) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     var deviceToRemove = trustDevices[index];
  //     trustDevices.removeAt(index);
  //     _saveStringList(trustDevices);
  //     // SharedPreferencesから特定のデバイスを削除
  //     prefs.setStringList('item', trustDevices
  //         .map((device) => '${device.trustName}:${device.trustIpAddress}')
  //         .toList());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue,
        backgroundColor: Color(0xFF87ff99),
        centerTitle: true,
        title: Text(
          'E ink E-paper',
          style: GoogleFonts.sawarabiGothic(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1E9FF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Text('描画位置を選択',
              //     style: TextStyle(
              //       fontSize: 20,
              //     )),
              // SizedBox(height: 10),
              // Container(
              //   // color:Colors.white,
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       border: Border.all(
              //         color: Colors.black12,
              //         width: 2,
              //       )),
              //   child: ListView(shrinkWrap: true, children: [
              //     RadioListTile(
              //         value: 1,
              //         groupValue: _selectedIndex,
              //         title: Text('画面1'),
              //         onChanged: (int? value) {
              //           setState(() {
              //             _selectedIndex = value!;
              //           });
              //         }),
              //     RadioListTile(
              //         value: 2,
              //         groupValue: _selectedIndex,
              //         title: Text('画面2'),
              //         onChanged: (int? value) {
              //           setState(() {
              //             _selectedIndex = value!;
              //           });
              //         }),
              //   ]),
              // ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//               child:Text('デバイス内の写真を選んでE-paperにインポート',
//                   style: TextStyle(
//                     fontSize: 16,
//                   ))),
//               Container(
//                 // color:Colors.white,
//                 width: double.infinity,
//                 height: 80,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(
//                       color: Colors.black12,
//                       width: 2,
//                     )),
//                 child:
//                     // Column(children:[
//                     Padding(
//                   padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
//                   child: ElevatedButton(
//
//                     child: Container(
//                       width: double.infinity,
//                       child:
//                           // Row(children: [
//                           Center(
//                               child: Text('写真を選択',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                   ))),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>SendPictureSelect()),
//                       ).then((value){
//                         if(value != null){
// return showDialog(
//   barrierDismissible:false,//dialog以外の部分をタップしても消えないようにする。
// context:context,
//   builder: (context)=>
//     //   Container(
//     // width:double.infinity,
//     // height: 200,
//     // child:
//   Center( child:
//         Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//           children:[
//       AlertDialog(
//         title:Text('選択画像を転送しますか？',style:TextStyle(fontSize:20,)),
//         content: SingleChildScrollView(
//           child:ListBody(
//             children:<Widget>[
//               Container(
//                 width:200,
//                 height: 200,
//                 // color:Colors.white70,
//                 decoration: BoxDecoration(
//                     border:Border.all(color:Colors.black12,
//                         width:2
//                     )),
//                 child:
//           // Column(
//           //   mainAxisSize:  MainAxisSize.max,
//           //   children:<Widget>[
//                 FadeInImage.memoryNetwork(
//             placeholder: kTransparentImage,
//             image: value.url,
//           ),
//         ),
//         //   ]),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           // ボタン領域
//           TextButton(
//             child: Text("Cancel"),
//             onPressed: () => Navigator.pop(context),
//           ),
//           TextButton(
//             child: Text("OK"),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//
// ],),
//   // ),
//   ),
// );
//                         }
//                       });
//     // if (selectedPhoto != null && context.mounted) {
//     //   ScaffoldMessenger.of(context)
//     //     ..removeCurrentSnackBar()
//     //     ..showSnackBar(SnackBar(content: FadeInImage.memoryNetwork(
//     //       placeholder: kTransparentImage,
//     //       image: selectedPhoto!.detectIpAddress.toString(),
//     //     ),));
//     // }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       // backgroundColor: isScanning ? Colors.blue : Colors.grey,
//                       backgroundColor: Colors.blue,
//                       elevation: 10,
//                       side: BorderSide(
//                         color: Colors.transparent,
//                         width: 1,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 5),
//               Row(children: [
//                 SizedBox(width: 10),
//                 // Padding(
//                 // padding:EdgeInsets.all(5),
//                 // child:// LinearProgressIndicator(value: processRate),
//                 Expanded(
//                   child: LinearProgressIndicator(
//                     value: processRate,
//                     color: Colors.greenAccent,
//                     minHeight: 20,
//                   ),
//                 ),
//                 // ),
//                 SizedBox(width: 10),
// // Text('${(processRate * 100).toStringAsFixed(1)}%'),
//                 Text('${(processRate * 100).toStringAsFixed(1)}%',
//                     style: TextStyle(
//                       fontSize: 20,
//                     )),
//               ]),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          //     child:Text('デバイス内の文書を選んでE-paperにインポート',
          //         style: TextStyle(
          //           fontSize: 16,
          //         ))),
          //     Container(
          //       // color:Colors.white,
          //       width: double.infinity,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           border: Border.all(
          //             color: Colors.black12,
          //             width: 2,
          //           )),
          //       height: 80,
          //       child:
          //           // Column(children:[
          //           Padding(
          //         padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          //         child: ElevatedButton(
          //           child: Container(
          //             width: double.infinity,
          //             child:
          //                 // Row(children: [
          //                 Center(
          //                     child: Text('文書を選択',
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 16,
          //                         ))),
          //           ),
          //           onPressed: () {
          //             getImage();
          //           },
          //           style: ElevatedButton.styleFrom(
          //             // backgroundColor: isScanning ? Colors.blue : Colors.grey,
          //             backgroundColor: Colors.blue,
          //             elevation: 10,
          //             side: BorderSide(
          //               color: Colors.transparent,
          //               width: 1,
          //             ),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(15),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child:Text('接続 E-paper 情報',
                  style: TextStyle(
                    fontSize: 20,
                  ))),
              Container(
                // color:Colors.white,

                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    )),
                child: Column(
                    children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('名称',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(widget.trustName,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ]),
                  SizedBox(height:5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('IMEI',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text('46008000C003070',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ]),
                      SizedBox(height:5),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('MACアドレス',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(widget.trustIpAddress,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ]),
                ]),
              ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child:Text('E-paper規格情報',
                  style: TextStyle(
                    fontSize: 20,
                  ))),
              Container(
                // color:Colors.white,

                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    )),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('画面サイズ',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(e_paperInfo.screenSize,
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ]),
                  SizedBox(height:5),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('解像度',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(e_paperInfo.resolutions,
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ]),
                  SizedBox(height:5),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('色',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(e_paperInfo.colors,
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ]),
                ]),
              ),

              Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child:Text('登録画像を選んでE-paperに表示',
                      style: TextStyle(
                        fontSize: 16,
                      ))),
              Container(
                // color:Colors.white,
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    )),
                child:
                // Column(children:[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: ElevatedButton(

                    child: Container(
                      width: double.infinity,
                      child:
                      // Row(children: [
                      Center(
                          child: Text('画像選択',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ))),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>SendPictureSelect()),
                      // ).then((value){
                      //   if(value != null){
                      //     return showDialog(
                      //       barrierDismissible:false,//dialog以外の部分をタップしても消えないようにする。
                      //       context:context,
                      //       builder: (context)=>
                      //       //   Container(
                      //       // width:double.infinity,
                      //       // height: 200,
                      //       // child:
                      //       Center( child:
                      //       Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children:[
                      //           AlertDialog(
                      //             title:Text('選択画像を転送しますか？',style:TextStyle(fontSize:20,)),
                      //             content: SingleChildScrollView(
                      //               child:ListBody(
                      //                 children:<Widget>[
                      //                   Container(
                      //                     width:200,
                      //                     height: 200,
                      //                     // color:Colors.white70,
                      //                     decoration: BoxDecoration(
                      //                         border:Border.all(color:Colors.black12,
                      //                             width:2
                      //                         )),
                      //                     child:
                      //                     // Column(
                      //                     //   mainAxisSize:  MainAxisSize.max,
                      //                     //   children:<Widget>[
                      //                     FadeInImage.memoryNetwork(
                      //                       placeholder: kTransparentImage,
                      //                       image: value.url,
                      //                     ),
                      //                   ),
                      //                   //   ]),
                      //                 ],
                      //               ),
                      //             ),
                      //             actions: <Widget>[
                      //               // ボタン領域
                      //               TextButton(
                      //                 child: Text("Cancel"),
                      //                 onPressed: () => Navigator.pop(context),
                      //               ),
                      //               TextButton(
                      //                 child: Text("OK"),
                      //                 onPressed: () => Navigator.pop(context),
                      //               ),
                      //             ],
                      //           ),
                      //
                      //         ],),
                      //         // ),
                      //       ),
                      //     );
                      //   }
                      // }
                      );
                      // if (selectedPhoto != null && context.mounted) {
                      //   ScaffoldMessenger.of(context)
                      //     ..removeCurrentSnackBar()
                      //     ..showSnackBar(SnackBar(content: FadeInImage.memoryNetwork(
                      //       placeholder: kTransparentImage,
                      //       image: selectedPhoto!.detectIpAddress.toString(),
                      //     ),));
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: isScanning ? Colors.blue : Colors.grey,
                      backgroundColor: Colors.blue,
                      elevation: 10,
                      side: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
//               Row(children: [
//                 SizedBox(width: 10),
//                 // Padding(
//                 // padding:EdgeInsets.all(5),
//                 // child:// LinearProgressIndicator(value: processRate),
//                 Expanded(
//                   child: LinearProgressIndicator(
//                     value: processRate,
//                     color: Colors.greenAccent,
//                     minHeight: 20,
//                   ),
//                 ),
//                 // ),
//                 SizedBox(width: 10),
// // Text('${(processRate * 100).toStringAsFixed(1)}%'),
//                 Text('${(processRate * 100).toStringAsFixed(1)}%',
//                     style: TextStyle(
//                       fontSize: 20,
//                     )),
//               ]),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child:Text('このデバイスの登録を解除',
                      style: TextStyle(
                        fontSize: 16,
                      ))),
                  Container(
                    // color:Colors.white,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black12,
                          width: 2,
                        )),
                    height: 80,
                    child:
                        // Column(children:[
                        Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: ElevatedButton(
                        child: Container(
                          width: double.infinity,
                          child:
                              // Row(children: [
                              Center(
                                  child: Text('解除',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ))),
                        ),
                        onPressed: () {
                          // getImage();
                           showDialog(
                            barrierDismissible:false,//dialog以外の部分をタップしても消えないようにする。
                            context:context,
                            builder: (context)=>
                            //   Container(
                            // width:double.infinity,
                            // height: 200,
                            // child:
                            Center( child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                AlertDialog(
                                  title:Text('登録を解除しますか？',style:TextStyle(fontSize:20,)),
                                  // content: SingleChildScrollView(
                                  //   child:ListBody(
                                  //     children:<Widget>[
                                  //       Container(
                                  //         width:200,
                                  //         height: 200,
                                  //         // color:Colors.white70,
                                  //         decoration: BoxDecoration(
                                  //             border:Border.all(color:Colors.black12,
                                  //                 width:2
                                  //             )),
                                  //
                                  //         // Column(
                                  //         //   mainAxisSize:  MainAxisSize.max,
                                  //         //   children:<Widget>[
                                  //
                                  //       ),
                                  //       //   ]),
                                  //     ],
                                  //   ),
                                  // ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("キャンセル"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        widget.onDelete();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    ),
                                  ],
                                ),

                              ],),
                              // ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: isScanning ? Colors.blue : Colors.grey,
                          backgroundColor: Colors.deepOrange,
                          elevation: 10,
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),

            ],
          ),
        ),
      ),
    );
  }

  // Future<void> getImage() async {
  //   Uri uri = Uri.parse("https://v4krfnnah1.execute-api.ap-northeast-1.amazonaws.com/dev/images");
  //   final response = await http.get(uri);
  //   if (response.statusCode == 200) {
  //     // httpレスポンスをJSON変換
  //     final body = jsonDecode(response.body);
  //     // レスポンスデータ中の'data'部(画像IDと画像URLのリスト)を取得
  //     final data = body['data'];
  //     data.forEach((map) {
  //       map.forEach((var id, var signedUrl) {
  //         // signed_urlから画像を取得し表示する
  //         // ※idは画像配信時に使用する(現在は未実装)ため、アプリ側で管理できるようにしておく
  //       });
  //     });
  //     print(body);
  //   }
  //
  // }
  // Future<void> _navigateAndDisplaySelection(BuildContext context) async {
  //   // Navigator.push returns a Future that completes after calling
  //   // Navigator.pop on the Selection Screen.
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SendPictureSelect()),
  //   );
  //
  //   // When a BuildContext is used from a StatefulWidget, the mounted property
  //   // must be checked after an asynchronous gap.
  //   if (!context.mounted) return;
  //
  //   // After the Selection Screen returns a result, hide any previous snackbars
  //   // and show the new result.
  //   ScaffoldMessenger.of(context)
  //     ..removeCurrentSnackBar()
  //     ..showSnackBar(SnackBar(content: Text('$result')));
  // }

}

