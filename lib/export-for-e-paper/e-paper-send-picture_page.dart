import 'dart:convert';

import 'package:flutter/material.dart';
import '../appserver.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

class SendPictureSelect extends StatefulWidget{
  @override
  _SendPictureSelectState createState() => _SendPictureSelectState();
}
//ローカルサーバーのデータバインド用
class ImageItem {
  // final int id;//ローカルサーバー
  final String id;//awsサーバー
  final String url;
  final Widget imageWidget;

  ImageItem({required this.id, required this.url})
      : imageWidget = Image.network(url);
}

class _SendPictureSelectState extends State<SendPictureSelect>{
  bool _isLoading = true; //imageが表示される

//   List<Widget> imageWidgets = [];
// List<Widget> imageID =[];
  List<ImageItem> imageItems = [];//データバインドインスタンス化
// //Amazon S3用
//   Future<void> getImage() async {
//    // Uri uri = Uri.parse("https://v4krfnnah1.execute-api.ap-northeast-1.amazonaws.com/dev/images");
//   Uri uri = Uri.parse("https://m2g6hqov52dqjf3q5wfo67uf3y0vnmkf.lambda-url.ap-northeast-1.on.aws/images");
//     final response = await http.get(uri);
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       // httpレスポンスをJSON変換
//       final body = jsonDecode(response.body);
//       // レスポンスデータ中の'data'部(画像IDと画像URLのリスト)を取得
//       final data = body['data'];
//       data.forEach((map) {
//         map.forEach((var id, var signedUrl) {
//           // signed_urlから画像を取得し表示する
//           imageWidgets.add(Image.network(signedUrl));
//           imageID.add(id);
//           // ※idは画像配信時に使用する(現在は未実装)ため、アプリ側で管理できるようにしておく
//         });
//       });
//       print(body);
//     }
//   }

// //サーバーからデータを読み取る
//   Future<void> getImage() async {
//     //awsサーバーからデータを読み取る
//     Uri uri = Uri.parse("https://m2g6hqov52dqjf3q5wfo67uf3y0vnmkf.lambda-url.ap-northeast-1.on.aws/images");
//     // //ローカルサーバーからデータを読み取る
//     // Uri uri =  Uri.parse("http://10.0.2.2:8080/images");
//     final response = await http.get(uri);
//     if (response.statusCode == 200) {
//       // httpレスポンスをJSON変換
//       final body = jsonDecode(response.body);
//       // レスポンスデータ中の'data'部(画像IDと画像URLのリスト)を取得
//       final data = body['data'];
//       print(data);
//       data.forEach((item) {
//         imageItems.add(ImageItem(id: item['id'], url: item['url']));
//       });
//     }
//   }

//サーバーからデータを読み取る
  Future<void> getImage() async {
    //awsサーバーからデータを読み取る
    Uri uri = Uri.parse("https://m2g6hqov52dqjf3q5wfo67uf3y0vnmkf.lambda-url.ap-northeast-1.on.aws/images");
    // //ローカルサーバーからデータを読み取る
    // Uri uri =  Uri.parse("http://10.0.2.2:8080/images");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // httpレスポンスをJSON変換
      final body = jsonDecode(response.body);
      // レスポンスデータ中の'data'部(画像IDと画像URLのリスト)を取得
      final data = body['data'];
      print(data);
      data.forEach((item) {
        imageItems.add(ImageItem(id: item['id'], url: item['url']));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      // MaterialApp(
      //   home:
        Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        title: Text('Image List',style:TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body:
    Container(
        width:double.infinity,
    height: double.infinity,
    color:Colors.black,
    child:
    FutureBuilder(
    future: getImage(),
    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
    // 非同期処理が完了したら画像を表示
    // print(imageWidgets.length);
    // print(imageWidgets);
    return
    GridView.builder(

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 1.0, // Spacing between columns
          mainAxisSpacing: 1.0, // Spacing between rows
        ),
        // itemCount: savedPhoto.length * 10, // Display 3 images per row
      itemCount: imageItems.length,
        // itemBuilder: (context, index) {
        //   final photoIndex = index % savedPhoto.length; // Get the correct photo index
      itemBuilder: (BuildContext context, int index) {
        final photoIndex = index % imageItems.length;
          return GestureDetector(
    onTap:(){
      // var value = savedPhoto[photoIndex];
      var value = imageItems[photoIndex];
      Navigator.pop(context, value);

            // onTap:() async{
            //   final byteData = await savedPhoto[photoIndex].detectIpAddress.toString();
            //   if(byteData != null){
            //     Navigator.of(context).pop();
            //   }
            },
              child:Container(

            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child:
            // Image.network(savedPhoto[photoIndex].detectIpAddress.toString()),

                    Center(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        // image: savedPhoto[photoIndex].detectIpAddress.toString(),
                        // image: imageItems[index].toString(),
                        image: imageItems[index].url,
                        // image: imageItems[index].url,
                      ),
                    ),
              ),
          );
        },
      );
    } else {
      // 非同期処理中はローディングインジケータを表示
      return Center(child:
      CircularProgressIndicator()
      // Container(color: Colors.white,width:30,height: 30,)
      );
    }
    },
    ),

        ),
        // ),
    );
  }
}

// class AppServer {
//   final String id;
//   final Uri detectIpAddress;
//
//   AppServer({required this.id,required String detectIpAddress}): detectIpAddress = Uri.parse(detectIpAddress);
// }
//
// List<AppServer> savedPhoto = [
//   AppServer(id: '1',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png'),
//   AppServer(id: '2',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/6e19fee6b47b36ca613f.png'),
//   AppServer(id: '3',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/a73a8b28b53d8d01cf76.png'),
//   AppServer(id: '4',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/683514c5660dbe52f5ba.png'),
// ];