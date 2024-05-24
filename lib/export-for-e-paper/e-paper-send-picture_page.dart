import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

class SendPictureSelect extends StatefulWidget {
  @override
  _SendPictureSelectState createState() => _SendPictureSelectState();
}

//アプリサーバーのデータバインド用
class ImageItem {
  final String id;
  final String url;
  final String lastModified;
  final Widget imageWidget;

  ImageItem({required this.id, required this.url, required this.lastModified})
      : imageWidget = Image.network(url);
}

//アプリサーバー　取得データ逆順
class ReversedData {
  final String idR;
  final String url;
  final String lastModifiedR;
  final Widget imageWidgetR;

  ReversedData({required this.idR, required this.url,required this.lastModifiedR})
      : imageWidgetR = Image.network(url);
}

//取得データ日付順並び替え　用
class DateSort {
  final String idD;
  final String url;
  final String lastModifiedD;
  final Widget imageWidgetD;

  DateSort({required this.idD, required this.url,required this.lastModifiedD})
      : imageWidgetD = Image.network(url);
}

class _SendPictureSelectState extends State<SendPictureSelect> {
  bool gridReverse = false; //表示順序切り替え

  List<ImageItem> imageItems = []; //サーバーデータ
  List<ReversedData> reverseData = []; //サーバーデータ逆順
  List<DateSort> dateSort = []; //日付並び替え

//サーバーからデータを読み取る
  Future<void> getImage() async {
    //awsサーバーからデータを読み取る
    Uri uri = Uri.parse(
            "https://uvky3v6bmi.execute-api.ap-northeast-1.amazonaws.com/dev/images"
    );
    final headers =  {'x-api-key':dotenv.get('API_KEY')};
    // //ローカルサーバーからデータを読み取る
    final response = await http.get(uri, headers: headers).timeout(
    Duration(seconds: 30), // タイムアウトを30秒に設定;
    );
    if (response.statusCode == 200) {
      // httpレスポンスをJSON変換
      final body = jsonDecode(response.body);
      // レスポンスデータ中の'data'部(画像IDと画像URLのリスト)を取得
      final data = body['data'];
      imageItems.clear(); //リストをクリア
      reverseData.clear(); //リストをクリア
      dateSort.clear(); //リストをクリア
      // 日付順で並べる処理を入れる

      data.forEach((item) {
          dateSort.add(
              DateSort(idD: item['id'], url: item['url'],lastModifiedD: item['last_modified']));
      });
      // 古い順に並び変える
      dateSort.sort((a, b) {
          return a.lastModifiedD
              .compareTo(b.lastModifiedD); // nullでないことが確認されたので、安全にcompareToを呼び出す
      });
      //古い順を挿入
      for (var item in dateSort) {
        imageItems.add(ImageItem(
            id: item.idD, url: item.url, lastModified: item.lastModifiedD));
      }
      // 新しい順として挿入
      for (var item in imageItems.reversed) {
        reverseData
            .add(ReversedData(idR: item.id, url: item.url,lastModifiedR: item.lastModified));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Image List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          Text(
            gridReverse ? '古い順' : '新しい順',
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: Icon(
              Icons.swap_vertical_circle_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                gridReverse = !gridReverse;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.cloud_download_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              getImage();
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: FutureBuilder(
          future: getImage(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // 非同期処理が完了したら画像を表示

              return
                  // gridReverse ?
                  GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3マスずつ表示
                  crossAxisSpacing: 1.0, // 縦幅
                  mainAxisSpacing: 1.0, // 横幅
                ),
                itemCount: gridReverse ? imageItems.length : reverseData.length,
                itemBuilder: (BuildContext context, int index) {
                  final photoIndex = index % imageItems.length;
                  final photoIndexR = index % reverseData.length;
                  return GestureDetector(
                    onTap: gridReverse
                        ? () {
                            var value = imageItems[photoIndex];
                            // DialogHelper.
                            selectImageCheckDialog(
                              context: context,
                              imageUrl: value.url,
                            );
                            // showDialog(
                            //   barrierDismissible:false,//dialog以外の部分をタップしても消えないようにする。
                            //   context:context,
                            //   builder: (context)=>
                            //   //   Container(
                            //   // width:double.infinity,
                            //   // height: 200,
                            //   // child:
                            //   Center( child:
                            //   Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children:[
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
                            //                 // Column(
                            //                 //   mainAxisSize:  MainAxisSize.max,
                            //                 //   children:<Widget>[
                            //                 FadeInImage.memoryNetwork(
                            //                   placeholder: kTransparentImage,
                            //                   image: value.url,
                            //                 ),
                            //               ),
                            //               //   ]),
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
                            //     ],),
                            //     // ),
                            //   ),
                            // );
                            // Navigator.pop(context, value);

                          }
                        : () {
                            var value = reverseData[photoIndexR];
                            // Navigator.pop(context, value);
                            selectImageCheckDialog(
                              context: context,
                              imageUrl: value.url,
                            );
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Center(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: gridReverse
                              ? imageItems[index].url
                              : reverseData[index].url,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              // 非同期処理中はローディングインジケータを表示
              return Center(child: CircularProgressIndicator()
                  // Container(color: Colors.white,width:30,height: 30,)
                  );
            }
          },
        ),
      ),
    );
  }
}

// class DialogHelper{
  void selectImageCheckDialog({required BuildContext context, required String imageUrl}){
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
            title:Text('選択画像を転送しますか？',style:TextStyle(fontSize:20,)),
            content: SingleChildScrollView(
              child:ListBody(
                children:<Widget>[
                  Container(
                    width:200,
                    height: 200,
                    // color:Colors.white70,
                    decoration: BoxDecoration(
                        border:Border.all(color:Colors.black12,
                            width:2
                        )),
                    child:
                    // Column(
                    //   mainAxisSize:  MainAxisSize.max,
                    //   children:<Widget>[
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: imageUrl,
                    ),
                  ),
                  //   ]),
                ],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                child: Text("Cancel"),
                onPressed: () { Navigator.pop(context);}
              ),
              TextButton(
                child: Text("OK"),
                onPressed: (){ Navigator.pop(context);Navigator.pop(context);}
              ),
            ],
          ),

        ],),
        // ),
      ),
    );
  }
// }