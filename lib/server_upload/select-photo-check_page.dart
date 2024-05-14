import 'dart:async';
import 'dart:convert';
// import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../export-for-e-paper/e-paper-send-select_popup.dart';
import '../bt_connect_page/connect_bt_page.dart';
import '../export-for-e-paper/export_page.dart';
import 'photo-select_page.dart';
import '../import_type_select_page/import-type-select_popup.dart';
import 'package:transparent_image/transparent_image.dart';
import '../appserver.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

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
Uint8List? path ;
  bool _isWriting = false;
  int i = 5;
  final ScrollController _scrollController = ScrollController();
// String urlSignedName = 'https://scd-sample-bucket-240416-1755.s3.amazonaws.com/images/sample.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAU6GDZR4FBACJMDFQ%2F20240423%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20240423T053549Z&X-Amz-Expires=14400&X-Amz-SignedHeaders=host&X-Amz-Signature=5cdc28d257ce673b1bc2792d5df9b9cb04677b75eb638683cd9c8c0f7466e397%22';


  @override
  void initState(){
super.initState();
path = widget.imageData[0];
  }
  void changeImage(Uint8List pathN){
    setState(() {
      path = pathN;
    });
  }

  Future<void> _writeDataToServer() async {
    await Future.delayed(Duration(seconds:2));
    CircularProgressIndicator();
  }

  Future<void> postData(Uint8List filePath) async {
    // var request = http.MultipartRequest('PUT', Uri.parse('https://scd-sample-bucket-240416-1755.s3.amazonaws.com/images/sample.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAU6GDZR4FBACJMDFQ%2F20240424%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20240424T001651Z&X-Amz-Expires=34200&X-Amz-SignedHeaders=host&X-Amz-Signature=86390b2d8612d4a29293c8101158eeee25cc70813161247ee85e55916a334821'));
    // request.files.add(http.MultipartFile.fromBytes('media', filePath));
    //
    // var response = await request.send();
    // if (response.statusCode == 200) {
    //   print('ファイルアップロード成功！');
    // } else {
    //   print('ファイルアップロード失敗: ${response.statusCode}');
    // Uri uri = Uri.parse("https://v4krfnnah1.execute-api.ap-northeast-1.amazonaws.com/dev/signed_url");
    Uri uri = Uri.parse("https://127.0.0.1:8080/signed_url");
    // Uri uri = Uri.parse("https://127.0.0.1:8080");

    final headers = <String, String> {'Content-Type': 'application/json'};
    // 追加する画像ファイルパス名リスト
    final image_paths = [filePath];
    final response = await http.post(uri, headers: headers, body: jsonEncode(image_paths));
    // 署名付きURL取得APIが正常
    if (response.statusCode == 200) {
    // httpレスポンスをJSON変換
    final body = jsonDecode(response.body);
    // レスポンスデータ中の'signed_urls'部(署名付きURLリスト)を取得
    final signed_urls = body['https://scd-sample-bucket-240416-1755.s3.amazonaws.com/images/42118248-5af2-4b48-a163-1e1e28e90a35/sample.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAU6GDZR4FBACJMDFQ%2F20240425%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20240425T062417Z&X-Amz-Expires=10800&X-Amz-SignedHeaders=host&X-Amz-Signature=116ff79d6e44b4f098db464cc57290f5a2da3c5ef125279fea1090c28dbc829b%22'];
    signed_urls.forEach((map) {
      map.forEach((String image_path, String signed_url) {
        // signed_urlに画像をアップロード(PUT)する
        putImageImpl(image_path:image_path, signed_url:signed_url);
      });
    });
    print('ファイルアップロード成功！');
    } else {
      print('ファイルアップロード失敗2: ${response.statusCode}');
  }
    }

  Future<void> putImageImpl({required String image_path, required String signed_url}) async {
    final request = http.MultipartRequest('PUT', Uri.parse(signed_url));
    // // リクエストヘッダ設定(不要かも)
    // request.headers.addAll({'content-type': 'image/png'});
    // ファイルサーバにアップロードするデータ追加 ※「600x448」の解像度にリサイズして追加したい
    // request.files.add(await http.MultipartFile.fromPath('file', image_path));

    final response = await request.send();
    if (response.statusCode == 200 ){
    // 成功時の処理
        print('ファイルアップロード成功！');
      } else {
        print('ファイルアップロード失敗3: ${response.statusCode}');
    }
    // }
  }

//   Future<void> postData(Uint8List args) async {
// try {
//   final response = await multipart(
//     method: 'POST',
//     // url: Uri.https('https://scd-sample-bucket-240416-1755.s3.amazonaws.com/images/sample.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAU6GDZR4FBACJMDFQ%2F20240423%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20240423T053549Z&X-Amz-Expires=14400&X-Amz-SignedHeaders=host&X-Amz-Signature=5cdc28d257ce673b1bc2792d5df9b9cb04677b75eb638683cd9c8c0f7466e397%22'),
//     url: Uri.parse('https://scd-sample-bucket-240416-1755.s3.amazonaws.com/images/sample.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAU6GDZR4FBACJMDFQ%2F20240424%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20240424T001651Z&X-Amz-Expires=34200&X-Amz-SignedHeaders=host&X-Amz-Signature=86390b2d8612d4a29293c8101158eeee25cc70813161247ee85e55916a334821%22'),
//     files: [
//       http.MultipartFile.fromBytes(
//         'media',
//         // File(path).readAsBytesSync(),
//         args,
//         // filename: 'sample.png',
//         // contentType: MediaType('image', 'png'),
//       ),
//     ],
//   );
//
//   print(response.statusCode);
//   print(response.body);
// }catch(e){
//   print('Error occurred2: $e');
// }
//   }
//
//   Future<http.Response> multipart({
//     required String method,
//     required Uri url,
//     required List<http.MultipartFile> files,
//   }) async {
//     final request = http.MultipartRequest(method, url);
//
//     request.files.addAll(files); // 送信するファイルのバイナリデータを追加
//     // request.headers.addAll({'Authorization': 'Bearer xxxxxx'}); // 認証情報などを追加
//     request.headers.addAll({'Content-Type': 'image/png'});
//
//     final stream = await request.send();
// final response = await http.Response.fromStream(stream);
//     // return http.Response.fromStream(stream).then((response) {
//     //   if (response.statusCode == 200) {
//     //     return response;
//     //   }
//     //
//     //   return Future.error(response);
//     // });
//     if (response.statusCode == 200) {
//       // 成功した場合の処理をここに記述
//       return response;
//     } else {
//       // エラーが発生した場合の処理をここに記述
//       throw Exception('Failed to upload image: ${response.statusCode}');
//     }
//   }


  Future<void> _showWriteDialog() async { //書き込みダイアログを表示するための非同期
    setState(() {
      _isWriting = true;
    });
    await _writeDataToServer();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('書き込み中...'),
          // content: Text('確認してください。'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: CircularProgressIndicator()
              // Text('書き込み中'),
            ),
          ],
        );
      },
    );

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
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('書き込みエラー'),
          // content: Text('確認してください。'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE1E9FF), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
                children: [
                Container(
                // color:Colors.greenAccent,
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE1E9FF), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                // child: AspectRatio(
                //   aspectRatio: 600 / 448,
                child:Image.memory(path!,
                  // fit: BoxFit.cover,
                ),
            // )
                ),
Divider(),
Row(children: [
  IconButton(
      onPressed:(){
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        );

      },
      icon:
  Icon(Icons.chevron_left,),),
  Expanded( child:
            Container(
                // color:Colors.greenAccent,
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE1E9FF), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                 child:

                 ListView.builder(
                   scrollDirection: Axis.horizontal,
                    // Number of selected media items
                    itemCount: widget.imageData.length,
                    // Apply bouncing scroll physics
                    physics: const BouncingScrollPhysics(),
                   controller: _scrollController,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          // Apply padding to each selected media item
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        // Display selected media widget
                        child:scrollImage(widget.imageData[index]!),
                        // GestureDetector(
                        //   onTap: (){
                        //     if(path! = pathN)
                        //       changeImage(pathN);
                        //   },
                        //     child:
                        // Image.memory(widget.imageData[index]!)
                        // ),
                      );
                    },
                  ),
            )),
  IconButton(
      onPressed:(){
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        );

      },
      icon:
  Icon(Icons.chevron_right),),
        ]),
                  Divider(),

            Container(
            width: double.infinity,
            height: 300,
            // color:Colors.greenAccent,
            // decoration: BoxDecoration(),
              decoration: BoxDecoration(
                color: Colors.blue, // コンテナの色を設定
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0), // 左上の角丸の大きさ
                  topRight: Radius.circular(30.0), // 右上の角丸の大きさ
                ),
              ),
            child:Padding(
              padding: EdgeInsets.all(10.0),
              child:
            Column(
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
                // onPressed:(){
                //   postData(path!);
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
            )),
        ])));
  }
  Widget scrollImage(Uint8List pathN){
    return Container(
      decoration: BoxDecoration(
          border:Border.all(
            color: path == pathN ? Colors.redAccent :Colors.white,
          )
      ),
      child: GestureDetector(
        child: Image.memory(
          pathN,
          width: 100,
          height: 100,
          fit:BoxFit.cover,
        ),
        onTap: (){
          if(path!= pathN)
            changeImage(pathN);
          // debugPrint('${pathN}');
        },
      ),
    );
  }
}

