import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../bt_connect_page/connect_bt_page.dart';
import '../appserver.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SelectCheck extends StatefulWidget {
  final List<Uint8List?> imageData;
  SelectCheck({Key? key,
    required this.imageData
  });
  @override
  State<SelectCheck> createState() => _SelectCheckState();
}

class _SelectCheckState extends State<SelectCheck> {
  List<AppServer> savedPhoto =[];
List<Uint8List> installPhoto = [];
Uint8List? path ;
  bool _isWriting = false;
  String uploadStatus = '';
  int i = 5;
  final ScrollController _scrollController = ScrollController();
// String urlSignedName = 'https://scd-sample-bucket-240416-1755.s3.amazonaws.com/images/sample.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAU6GDZR4FBACJMDFQ%2F20240423%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20240423T053549Z&X-Amz-Expires=14400&X-Amz-SignedHeaders=host&X-Amz-Signature=5cdc28d257ce673b1bc2792d5df9b9cb04677b75eb638683cd9c8c0f7466e397%22';
  final List<File> files = [];

  @override
  void initState(){
super.initState();
path = widget.imageData[0];
saveImages();
  }

  void changeImage(Uint8List pathN){
    setState(() {
      path = pathN;
    });
  }

  void uploadMessage(){
    showDialog(
        context: context,
        builder: (BuildContext context)
    {
      return AlertDialog(
        title: Text(_isWriting ? '書き込み中...' : '書き込み完了'),
          content: Text(_isWriting ? '':'E-paper機能に移りますか？'),
        // content: Text('確認してください。'),
        actions: <Widget>[
          // TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     child:
          // if (!_isWriting)
          //  {
          _isWriting ?
          // return
          CircularProgressIndicator()
          //  },
          :  Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ConnectBTPage()));
                    },
                    child: Text('はい'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('いいえ'),
                  ),
                  // Text('書き込み中'),
                  // ),
                ])
        ],
      );
      // : AlertDialog(
      //   title: Text('書き込み完了'),
      //   content: Text('E-paperに配信しますか？'),
      //   actions: <Widget>[
      //     TextButton(
      //       onPressed: () {
      //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectBTPage()));
      //       },
      //       child: Text('はい'),
      //     ),
      //     TextButton(
      //       onPressed: () {
      //         Navigator.of(context).pop(); // Close the dialog
      //       },
      //       child: Text('いいえ'),
      //     ),
      //   ],
      // );
    });

  }

  Future<void> _writeDataToServer() async {
    await Future.delayed(Duration(seconds:2));
    CircularProgressIndicator();
  }

  Future<void> saveImages() async {
    final directory = await getApplicationDocumentsDirectory();
    // final List<File> files = [];

    for (int i = 0; i < widget.imageData.length; i++) {
      final Uint8List? data = widget.imageData[i];
      if (data != null) {
        final String fileName = 'image_$i.png'; // ファイル名を生成
        final path = '${directory.path}/$fileName';
        final file = File(path);
        await file.writeAsBytes(data);
        files.add(file); // 保存したファイルをリストに追加
        print(files);
      }
    }

    // 保存したファイルのリストを使用する処理をここに追加
  }

  // Future<void> postData(Uint8List filePath) async {
  //   // var request = http.MultipartRequest('PUT', Uri.parse('https://scd-sample-bucket-240416-1755.s3.amazonaws.com/images/sample.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAU6GDZR4FBACJMDFQ%2F20240424%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20240424T001651Z&X-Amz-Expires=34200&X-Amz-SignedHeaders=host&X-Amz-Signature=86390b2d8612d4a29293c8101158eeee25cc70813161247ee85e55916a334821'));
  //   // request.files.add(http.MultipartFile.fromBytes('media', filePath));
  //   //
  //   // var response = await request.send();
  //   // if (response.statusCode == 200) {
  //   //   print('ファイルアップロード成功！');
  //   // } else {
  //   //   print('ファイルアップロード失敗: ${response.statusCode}');
  //   // Uri uri = Uri.parse("https://v4krfnnah1.execute-api.ap-northeast-1.amazonaws.com/dev/signed_url");
  //   Uri uri = Uri.parse("https://127.0.0.1:8080/signed_url");//ローカルサーバーアップロード
  //   // Uri uri = Uri.parse("https://127.0.0.1:8080");
  //
  //   final headers = <String, String> {'Content-Type': 'application/json'};
  //   // 追加する画像ファイルパス名リスト
  //   final image_paths = [filePath];
  //   final response = await http.post(uri, headers: headers, body: jsonEncode(image_paths));
  //   // 署名付きURL取得APIが正常
  //   if (response.statusCode == 200) {
  //   // httpレスポンスをJSON変換
  //   final body = jsonDecode(response.body);
  //   // レスポンスデータ中の'signed_urls'部(署名付きURLリスト)を取得
  //   final signed_urls = body['https://scd-sample-bucket-240416-1755.s3.amazonaws.com/images/42118248-5af2-4b48-a163-1e1e28e90a35/sample.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAU6GDZR4FBACJMDFQ%2F20240425%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20240425T062417Z&X-Amz-Expires=10800&X-Amz-SignedHeaders=host&X-Amz-Signature=116ff79d6e44b4f098db464cc57290f5a2da3c5ef125279fea1090c28dbc829b%22'];
  //   signed_urls.forEach((map) {
  //     map.forEach((String image_path, String signed_url) {
  //       // signed_urlに画像をアップロード(PUT)する
  //       putImageImpl(image_path:image_path, signed_url:signed_url);
  //     });
  //   });
  //   print('ファイルアップロード成功！');
  //   } else {
  //     print('ファイルアップロード失敗2: ${response.statusCode}');
  // }
  //   }
  //
  // Future<void> putImageImpl({required String image_path, required String signed_url}) async {
  //   final request = http.MultipartRequest('PUT', Uri.parse(signed_url));
  //   // // リクエストヘッダ設定(不要かも)
  //   // request.headers.addAll({'content-type': 'image/png'});
  //   // ファイルサーバにアップロードするデータ追加 ※「600x448」の解像度にリサイズして追加したい
  //   // request.files.add(await http.MultipartFile.fromPath('file', image_path));
  //
  //   final response = await request.send();
  //   if (response.statusCode == 200 ){
  //   // 成功時の処理
  //       print('ファイルアップロード成功！');
  //     } else {
  //       print('ファイルアップロード失敗3: ${response.statusCode}');
  //   }
  //   // }
  // }

  List<String> convertUint8ListToStringList(List<Uint8List?> uint8List) {
    return uint8List.map((bytes) => base64Encode(bytes!)).toList();
  }
  List<Uint8List> convertStringListToUint8List(List<String> stringList) {
    return stringList.map((str) => base64Decode(str)).toList();
  }

  Future<File> saveImageAsPng(Uint8List imageData, String fileName) async {
    // アプリのドキュメントディレクトリを取得
    final directory = await getApplicationDocumentsDirectory();
    // ファイルのフルパスを生成
    final path = '${directory.path}/$fileName.png';
    // ファイルを作成
    final file = File(path);
    // ファイルにイメージデータを書き込む
    await file.writeAsBytes(imageData);
    return file;
  }

  //ファイルアップロード
  Future<void> postData(List<String?> uploadImages) async {
    // Future<void> postData(List<Uint8List?> uploadImages) async {
    Uri uri =  Uri.parse(
        // "https://m2g6hqov52dqjf3q5wfo67uf3y0vnmkf.lambda-url.ap-northeast-1.on.aws/signed_url"
            "https://uvky3v6bmi.execute-api.ap-northeast-1.amazonaws.com/dev/signed_url"
    );//awsS3
    // Uri uri = Uri.parse("https://127.0.0.1:8080/signed_url");//ローカルサーバーアップロード
    final headers =  {'Content-Type': 'application/json','x-api-key':dotenv.get('API_KEY')};
    final body ={'images': uploadImages};
    // final body = {
    //   'images': uploadImages.map((image) {
    //     return {
    //       'data': image, // 画像データ
    //       'filename': '$image.png' // ここでファイル名を指定
    //     };
    //   }).toList()
    // };
    final response = await http.post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final signed_urls = body['signed_urls'];

      // // for (int i = 0; i < signed_urls.length; i++) {
      //   for (int i = 0; i < widget.imageData.length; i++) {
      //   final String signed_url = signed_urls[i]['signed_url'];
      //
      //   final Uint8List imageData = widget.imageData[i]!; // ここで直接データを使用
      //   final String filename = 'image_$i.png'; // ファイル名を一意に決定
      //   await putImageImpl(signed_url: signed_url, imageData: imageData, filename: filename);
      // }


      for (var map in signed_urls) {
        for (var entry in map.entries) {
          // final List<String> image_path = entry.key;
          print(entry);
          // if (!entry.endsWith('.png')) {
          //   entry += '.png';

            final String image_path = entry.key;

//           String key = entry.key;
//           if (!key.endsWith('.png')) {
//             key += '.png';
//           }
//           final String image_path = key;
// print(image_path);

            final String signed_url = entry.value;
            // final String filename = image_path.split('/').last + '.png';
            // final String filename = '${image_path.split('/').last}.png';
            // final String filenameLast = image_path.endsWith('.png')
            //     ? image_path
            //     : image_path + '.png';
            // final String filename = image_path.split('/').last;
            // final String filename = filenameLast
            //     .split('/')
            //     .last;
            final String filename = image_path
                .split('/')
                .last;
            putImageImpl(image_path: image_path,
                signed_url: signed_url,
                filename: filename);
          }


      }
      print('ファイルアップロード成功1！');
    } else {
      print('ファイルアップロード失敗2: ${response.statusCode}');
    }
  }


  // Future<void> putImageImpl({required List<String> image_path, required String signed_url,required String filename}) async {
    Future<void> putImageImpl({required String image_path, required String signed_url,required String filename}) async {
      // Future<void> putImageImpl({required String signed_url, required Uint8List imageData, required String filename}) async {
      // アセットからバイトデータを取得
      // final byteData = await rootBundle.load(image_path);
      // final List<int> bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

      final file = File(image_path); // Fileオブジェクトを作成
      final byteData = await file.readAsBytes(); // Fileオブジェクトからバイトデータを読み込む
      final List<int> bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      // HTTP PUTリクエストを作成

      // List<Uint8List?> uploadImages = convertStringListToUint8List(
      //     [image_path]); // `List<String>` を渡す
      // // `Uint8List` を `body` に設定
      // final Uint8List? imageData = uploadImages.first;
      //
      // // final List<int> bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      //
      // if (imageData != null) {
      //   //追加
      //   // Uint8Listから画像データをデコード
      //   img.Image? image = img.decodeImage(imageData);
      //   //PNG形式にエンコード
      //   Uint8List pngBytes = Uint8List.fromList(img.encodePng(image!));
      //   final List<int> bytes = pngBytes;
      //   print(bytes);
      //   // // signedUrlにファイル名を含める
      //   // String fileName = 'your_image_name.png'; // ここでファイル名を指定
      //   // String uploadUrl = '$signedUrl/$fileName';

        final response = await http.put(
          Uri.parse(signed_url),
          headers: {
            'Content-Type': 'binary/octet-stream',
            // 'Content-Type': 'image/png', // MIMEタイプを 'image/png' に設定
            // 'Content-Disposition': 'attachment; filename="$filename.png"' // ファイル名に '.png' 拡張子を追加
          },
          // body: imageData, // `Uint8List` を渡す
          body: bytes ,
          // path:"***.png"
        );

        // List<Uint8List?> uploadImages = convertStringListToUint8List(image_path);
        // print(image_path);
        //
        //
        // //s
        // final response = await http.put(
        //   Uri.parse(signed_url),
        //   headers: {
        //     'Content-Type': 'binary/octet-stream',
        //   },
        //   // body: bytes,
        //   body: image_path
        // );

        // final response = await http.put(
        //   Uri.parse(signed_url),
        //   headers: {
        //     'Content-Type': 'binary/octet-stream',
        //   },
        //   body: imageData,
        // );
//s
        if (response.statusCode == 200) {
          print('ファイルアップロード成功2！');
          setState(() {
            _isWriting = false;
            Navigator.of(context).pop();
            uploadMessage();
          });
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


  Future<void> _showWriteDialog() async {//書き込みダイアログを表示するための非同期


    setState(() {
      _isWriting = true;
      uploadMessage();
    });
    // uploadMessage();
    // List<String> filePaths = files.map((file) => file.path).toList();
    // print(filePaths);
    // await postData(filePaths);
    // await _writeDataToServer();


    // await
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return
          //// _isWriting ?


    //       AlertDialog(
    //       title: Text(_isWriting ?'書き込み中...':'書き込み完了'),
    //       // content: Text('確認してください。'),
    //       actions: <Widget>[
    //         // TextButton(
    //         //     onPressed: () {
    //         //       Navigator.of(context).pop();
    //         //     },
    //         //     child:
    //         if (!_isWriting)
    //        //  {
    //        // return   CircularProgressIndicator(),
    //        //  },
    //         Row(
    //         children: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectBTPage()));
    //           },
    //           child: Text('はい'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(); // Close the dialog
    //           },
    //           child: Text('いいえ'),
    //         ),
    //           // Text('書き込み中'),
    //         // ),
    //     ])
    //       ],
    //     );
    //     // : AlertDialog(
    //     //   title: Text('書き込み完了'),
    //     //   content: Text('E-paperに配信しますか？'),
    //     //   actions: <Widget>[
    //     //     TextButton(
    //     //       onPressed: () {
    //     //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectBTPage()));
    //     //       },
    //     //       child: Text('はい'),
    //     //     ),
    //     //     TextButton(
    //     //       onPressed: () {
    //     //         Navigator.of(context).pop(); // Close the dialog
    //     //       },
    //     //       child: Text('いいえ'),
    //     //     ),
    //     //   ],
    //     // );
    //
    //   },
    // );

    // setState(() {
    //   _isWriting = false;
    // });
    List<String> filePaths = files.map((file) => file.path).toList();
    // print(filePaths);
    // await
   await postData(filePaths);
    // setState(() {
    //   _isWriting = false;
    // });
    // setState(() {
    //   _isWriting = false;
    // });
    // await showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('書き込み完了'),
    //       content: Text('E-paperに配信しますか？'),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectBTPage()));
    //           },
    //           child: Text('はい'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(); // Close the dialog
    //           },
    //           child: Text('いいえ'),
    //         ),
    //       ],
    //     );
    //   },
    // );

    // List<String> filePaths = files.map((file) => file.path).toList();
    // print(filePaths);
    // await postData(filePaths);
    // await showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('書き込みエラー'),
    //       // content: Text('確認してください。'),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(); // Close the dialog
    //           },
    //           child: Text('OK'),
    //         ),
    //       ],
    //     );
    //   },
    // );
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
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
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
//                 onPressed:() async{
//
//                   List<String> filePaths = files.map((file) => file.path).toList();
// print(filePaths);
//                   await postData(filePaths);
//
//                   // postData(path!);
//                   // List<Uint8List?> uploadImages = widget.imageData;
//
//                   // List<String?> uploadImages = convertUint8ListToStringList(widget.imageData);
//                   // await postData(uploadImages);
//
//                   // await postData(widget.imageData);
//                 },

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

